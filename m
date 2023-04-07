Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCFBC6FD1D
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 20:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjDGUIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 16:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDGUIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 16:08:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B4DBBB7;
        Fri,  7 Apr 2023 13:08:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337Fx4YF014224;
        Fri, 7 Apr 2023 20:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=Fc7/liukLED5zb5XMUVILOJyd5gp8kDpSQkqqd83g9k=;
 b=drRR7bDUSrN0gBtVBN3dEkLrXp7MwyFd8JqnQyzr59M6A/vithylDrl/ge8E580UDYZP
 a9v2DQ9ftdpJ6ApmNp82LkDq1I5jwRHyqzy9to3KslMTqv+up69RYonSm5UrzKGuygjD
 RrzTq4St4J6LV0BNnQuVeOB9RCp84+uC1PLae9HqT4q6WEulrcFnnjnmt6NmSvCuMz5t
 0/D953x/i+Mtkd9SXSeIH2+Jojy8TKRWm9VE3A+UcokOZNms3hiXs2dO6aslQCmYqpj7
 gdMFp22ziqYJAJQNTYXg4B1g8Yazhp5HWhC6vNafmCqtC4/itcT/NSXMQDH42cd1Jluq Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7u5ss9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 337ImALe034194;
        Fri, 7 Apr 2023 20:06:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjxef5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5trI010228;
        Fri, 7 Apr 2023 20:06:29 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com [10.154.128.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptjxeeam-14;
        Fri, 07 Apr 2023 20:06:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v6 13/18] nvme: Add pr_ops read_reservation support
Date:   Fri,  7 Apr 2023 15:05:46 -0500
Message-Id: <20230407200551.12660-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407200551.12660-1-michael.christie@oracle.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304070180
X-Proofpoint-ORIG-GUID: 5si_IelyY2lT6tl4GjteLpEP1MBqzeZd
X-Proofpoint-GUID: 5si_IelyY2lT6tl4GjteLpEP1MBqzeZd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/pr.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 732c56b417c2..391b1465ebfd 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -29,6 +29,26 @@ static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 	return 0;
 }
 
+static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
+{
+	switch (type) {
+	case NVME_PR_WRITE_EXCLUSIVE:
+		return PR_WRITE_EXCLUSIVE;
+	case NVME_PR_EXCLUSIVE_ACCESS:
+		return PR_EXCLUSIVE_ACCESS;
+	case NVME_PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case NVME_PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	}
+
+	return 0;
+}
+
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 		struct nvme_command *c, void *data, unsigned int data_len)
 {
@@ -222,6 +242,68 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status_ext tmp_rse, *rse;
+	int ret, i, num_regs;
+	u32 rse_len;
+	bool eds;
+
+get_num_regs:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_pr_resv_report(bdev, &tmp_rse, sizeof(tmp_rse), &eds);
+	if (ret)
+		return ret;
+
+	num_regs = get_unaligned_le16(&tmp_rse.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_rse.gen);
+		return 0;
+	}
+
+	rse_len = struct_size(rse, regctl_eds, num_regs);
+	rse = kzalloc(rse_len, GFP_KERNEL);
+	if (!rse)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, rse, rse_len, &eds);
+	if (ret)
+		goto free_rse;
+
+	if (num_regs != get_unaligned_le16(&rse->regctl)) {
+		kfree(rse);
+		goto get_num_regs;
+	}
+
+	resv->generation = le32_to_cpu(rse->gen);
+	resv->type = block_pr_type_from_nvme(rse->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (rse->regctl_eds[i].rcsts) {
+				resv->key = le64_to_cpu(rse->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			struct nvme_reservation_status *rs;
+
+			rs = (struct nvme_reservation_status *)rse;
+			if (rs->regctl_ds[i].rcsts) {
+				resv->key = le64_to_cpu(rs->regctl_ds[i].rkey);
+				break;
+			}
+		}
+	}
+
+free_rse:
+	kfree(rse);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
@@ -229,4 +311,5 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
-- 
2.25.1

