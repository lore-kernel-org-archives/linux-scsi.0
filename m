Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAF8C77B70
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 20:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjDGUIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 16:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDGUIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 16:08:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EF27ABF;
        Fri,  7 Apr 2023 13:08:36 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337FwobW017328;
        Fri, 7 Apr 2023 20:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=GQNtxFeOu9dapPk11J+Pydze/7EYKsAe+RMGieB8gbA=;
 b=haEQ42KqZ7H0npHTVv1f6EHlZyzYcPxCYyuO1WsDnC1cdrIYgL45AyuZuIuv58qMrUr+
 9GplvSs6zIFRonntvf6ZVD52hOJG+WBy0QBgRWm8I7J+Y68LZPmTPywf8NbLV90Ew9RS
 r0z9hiHRRwMDxSoKJRUOr5nu84Nek/kSOkRUub0qNMQwbd10XvvwBjhleieKcU/VQL2X
 Kn1wtR7L5lqUiTyw7xeNWC6ZyHq+5D3yRTuP7ec61zF12VabtwWgrW/FjD59bX+xxcFK
 teevs/03yBAR5Iq1WzBXK6xI2vJsyqY2JF/SGPP31PICwUHAv1chcZNhCBFf5tsDahs6 rA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcnd5wv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 337IefFc034269;
        Fri, 7 Apr 2023 20:06:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjxef1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:25 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5trE010228;
        Fri, 7 Apr 2023 20:06:24 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com [10.154.128.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptjxeeam-12;
        Fri, 07 Apr 2023 20:06:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 11/18] nvme: Add pr_ops read_keys support
Date:   Fri,  7 Apr 2023 15:05:44 -0500
Message-Id: <20230407200551.12660-12-michael.christie@oracle.com>
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
X-Proofpoint-GUID: PD3MqFhRtTA-sjcaKB0fLsKhkgjizzyt
X-Proofpoint-ORIG-GUID: PD3MqFhRtTA-sjcaKB0fLsKhkgjizzyt
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
index cd93d2e5b340..0ee656404437 100644
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
+	c.common.cdw11 = cpu_to_le32(NVME_EXTENDED_DATA_STRUCT);
+	*eds = true;
+
+retry:
+	ret = nvme_send_pr_command(bdev, &c, data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST &&
+	    c.common.cdw11 == cpu_to_le32(NVME_EXTENDED_DATA_STRUCT)) {
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

