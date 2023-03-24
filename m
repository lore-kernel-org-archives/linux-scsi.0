Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F80C6FD20
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCXSUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCXSUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:20:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58532206BD;
        Fri, 24 Mar 2023 11:20:28 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OIE9b7012167;
        Fri, 24 Mar 2023 18:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=RC2Q2K+DcL3OKVj2tSewPSDAMwmiLHJjK1Hph1DIUDI=;
 b=cNRyW3doswqe4QA8MMJWWcQKEWNAMY6w5bok86RJZVv7reFoedQHXI6ScO/Jov79gvVN
 ip2DR498Lf7RpfsSqOAP1+xrhgcI8bAztrUAJa2MFrdHnw12SqBfA8rj3K9cMCOBu1LS
 4r6Yi1B6g6q0vjtl/cAO/H8m0XTn3KlLxgY5ZOJ8quKVVTNdiYm74pTtFKq/VGcLK5/h
 A0NxeCxgbatb2CJ40X+T7oyIyq9FGtVex4bYj8in7XTD5uFRIVGL4aYskWMYe+0KV/7j
 xcEcftjz10iklVt58ZlVa11Dt0J1S2tLVg3IowUWWQLQKQusU3eV9Zt1lN7imQ1HXDlt WQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgy9g0a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OHkCmA001276;
        Fri, 24 Mar 2023 18:18:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4bxh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:11 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEf021017;
        Fri, 24 Mar 2023 18:18:11 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com [10.154.153.54])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4bx19-12;
        Fri, 24 Mar 2023 18:18:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 11/18] nvme: Add pr_ops read_keys support
Date:   Fri, 24 Mar 2023 13:17:34 -0500
Message-Id: <20230324181741.13908-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-GUID: Unq8BHoCIuN03LkRd0O--aElRipvrgbo
X-Proofpoint-ORIG-GUID: Unq8BHoCIuN03LkRd0O--aElRipvrgbo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support for the pr_ops read_keys callout by calling the
NVMe Reservation Report helper, then parsing that info to get the
controller's registered keys. Because the callout is only used in the
kernel where the callers, like LIO, do not know about controller/host IDs,
the callout just returns the registered keys which is required by the SCSI
PR in READ KEYS command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/nvme.h   |  4 +++
 2 files changed, 73 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index cd93d2e5b340..6aadcc25f3e2 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -154,10 +154,79 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
+static int nvme_pr_resv_report(struct block_device *bdev, void *data,
+		u32 data_len, bool *eds)
+{
+	struct nvme_command c = { };
+	int ret;
+
+	c.common.opcode = nvme_cmd_resv_report;
+	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
+	c.common.cdw11 = NVME_EXTENDED_DATA_STRUCT;
+	*eds = true;
+
+retry:
+	ret = nvme_send_pr_command(bdev, &c, data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST &&
+	    c.common.cdw11 == NVME_EXTENDED_DATA_STRUCT) {
+		c.common.cdw11 = 0;
+		*eds = false;
+		goto retry;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_err(ret);
+}
+
+static int nvme_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info)
+{
+	u32 rse_len, num_keys = keys_info->num_keys;
+	struct nvme_reservation_status_ext *rse;
+	int ret, i;
+	bool eds;
+
+	/*
+	 * Assume we are using 128-bit host IDs and allocate a buffer large
+	 * enough to get enough keys to fill the return keys buffer.
+	 */
+	rse_len = struct_size(rse, regctl_eds, num_keys);
+	rse = kzalloc(rse_len, GFP_KERNEL);
+	if (!rse)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, rse, rse_len, &eds);
+	if (ret)
+		goto free_rse;
+
+	keys_info->generation = le32_to_cpu(rse->gen);
+	keys_info->num_keys = get_unaligned_le16(&rse->regctl);
+
+	num_keys = min(num_keys, keys_info->num_keys);
+	for (i = 0; i < num_keys; i++) {
+		if (eds) {
+			keys_info->keys[i] =
+					le64_to_cpu(rse->regctl_eds[i].rkey);
+		} else {
+			struct nvme_reservation_status *rs;
+
+			rs = (struct nvme_reservation_status *)rse;
+			keys_info->keys[i] = le64_to_cpu(rs->regctl_ds[i].rkey);
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
 	.pr_release	= nvme_pr_release,
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
+	.pr_read_keys	= nvme_pr_read_keys,
 };
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 83704fc04a94..c18bd55a4ead 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -759,6 +759,10 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+enum nvme_eds {
+	NVME_EXTENDED_DATA_STRUCT	= 0x1,
+};
+
 struct nvme_registered_ctrl {
 	__le16	cntlid;
 	__u8	rcsts;
-- 
2.25.1

