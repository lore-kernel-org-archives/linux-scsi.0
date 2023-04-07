Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCEAC77B79
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 20:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjDGUIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 16:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjDGUIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 16:08:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0E17ABF;
        Fri,  7 Apr 2023 13:08:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337Fx1p3019782;
        Fri, 7 Apr 2023 20:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=eNuUGDyV2sX0+7IoFekZ8HkfhlgZNIMnri/lsT0Pfm0=;
 b=Uegl0NVtzgKQKEeF2i5rUFs1ZHdy81dm00nfWtus+FN2qgcaa1B5+5RQP8SPOBvZ4lRt
 HMTD3Iz3OqO0xgqZahYRDDhkvUJqq0PWYfn0YZLCOwsEYrhEXr/3lAOhl8DzCwd785Nq
 6TVRxEg1P+y5dwF6//Ck94jJYWrKYL0o0mzTG2SMelpuBzFfLynbx0RFCA+VvZTrpN1i
 7iivNoDl6bQisRpwA0eoNQf90zXZM9FnTs+X76PLMBRI3S0NZdMS25me56FbV6B8rX5f
 xidmN2oc1YEbX5D4XpaglObxUXGx6hX0O3aDvyZysV9mLWWFN2SQockoYsFbVUQSD2j6 7Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd45w5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 337IdXZ1034243;
        Fri, 7 Apr 2023 20:06:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjxeevw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:19 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5trA010228;
        Fri, 7 Apr 2023 20:06:19 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com [10.154.128.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptjxeeam-10;
        Fri, 07 Apr 2023 20:06:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v6 09/18] nvme: Move pr code to it's own file
Date:   Fri,  7 Apr 2023 15:05:42 -0500
Message-Id: <20230407200551.12660-10-michael.christie@oracle.com>
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
X-Proofpoint-ORIG-GUID: _hrW1Mxgwj4D70kvjgMmIKlscfxxYlkd
X-Proofpoint-GUID: _hrW1Mxgwj4D70kvjgMmIKlscfxxYlkd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch moves the pr code to it's own file because I'm going to be
adding more functions and core.c is getting bigger.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/Makefile |   2 +-
 drivers/nvme/host/core.c   | 148 ----------------------------------
 drivers/nvme/host/nvme.h   |   2 +
 drivers/nvme/host/pr.c     | 158 +++++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+), 149 deletions(-)
 create mode 100644 drivers/nvme/host/pr.c

diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index e27202d22c7d..06c18a65da99 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
 obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
 obj-$(CONFIG_NVME_APPLE)		+= nvme-apple.o
 
-nvme-core-y				+= core.o ioctl.o
+nvme-core-y				+= core.o ioctl.o pr.o
 nvme-core-$(CONFIG_NVME_VERBOSE_ERRORS)	+= constants.o
 nvme-core-$(CONFIG_TRACING)		+= trace.o
 nvme-core-$(CONFIG_NVME_MULTIPATH)	+= multipath.o
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 02b39f0126af..cb3b97cd7f42 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2061,154 +2061,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 }
 
-static char nvme_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 1;
-	case PR_EXCLUSIVE_ACCESS:
-		return 2;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 3;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 4;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 5;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 6;
-	default:
-		return 0;
-	}
-}
-
-static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EWOULDBLOCK;
-
-	if (ns) {
-		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-	
-static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
-{
-	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-}
-
-static int nvme_sc_to_pr_err(int nvme_sc)
-{
-	if (nvme_is_path_error(nvme_sc))
-		return PR_STS_PATH_FAILED;
-
-	switch (nvme_sc) {
-	case NVME_SC_SUCCESS:
-		return PR_STS_SUCCESS;
-	case NVME_SC_RESERVATION_CONFLICT:
-		return PR_STS_RESERVATION_CONFLICT;
-	case NVME_SC_ONCS_NOT_SUPPORTED:
-		return -EOPNOTSUPP;
-	case NVME_SC_BAD_ATTRIBUTES:
-	case NVME_SC_INVALID_OPCODE:
-	case NVME_SC_INVALID_FIELD:
-	case NVME_SC_INVALID_NS:
-		return -EINVAL;
-	default:
-		return PR_STS_IOERR;
-	}
-}
-
-static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
-{
-	struct nvme_command c = { };
-	u8 data[16] = { 0, };
-	int ret;
-
-	put_unaligned_le64(key, &data[0]);
-	put_unaligned_le64(sa_key, &data[8]);
-
-	c.common.opcode = op;
-	c.common.cdw10 = cpu_to_le32(cdw10);
-
-	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
-	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
-						   sizeof(data));
-	else
-		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data, sizeof(data));
-	if (ret < 0)
-		return ret;
-
-	return nvme_sc_to_pr_err(ret);
-}
-
-static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
-{
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	cdw10 = old ? 2 : 0;
-	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
-	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
-}
-
-static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
-{
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	cdw10 = nvme_pr_type(type) << 8;
-	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
-}
-
-static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
-{
-	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
-
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
-}
-
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
-{
-	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
-
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
-}
-
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
-{
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
-
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
-}
-
-const struct pr_ops nvme_pr_ops = {
-	.pr_register	= nvme_pr_register,
-	.pr_reserve	= nvme_pr_reserve,
-	.pr_release	= nvme_pr_release,
-	.pr_preempt	= nvme_pr_preempt,
-	.pr_clear	= nvme_pr_clear,
-};
-
 #ifdef CONFIG_BLK_SED_OPAL
 static int nvme_sec_submit(void *data, u16 spsp, u8 secp, void *buffer, size_t len,
 		bool send)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bf46f122e9e1..c0762346b441 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -19,6 +19,8 @@
 
 #include <trace/events/block.h>
 
+extern const struct pr_ops nvme_pr_ops;
+
 extern unsigned int nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
 
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
new file mode 100644
index 000000000000..ca7a8d531a23
--- /dev/null
+++ b/drivers/nvme/host/pr.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2015 Intel Corporation
+ *	Keith Busch <kbusch@kernel.org>
+ */
+#include <linux/blkdev.h>
+#include <linux/pr.h>
+#include <asm/unaligned.h>
+
+#include "nvme.h"
+
+static char nvme_pr_type(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 1;
+	case PR_EXCLUSIVE_ACCESS:
+		return 2;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 3;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 4;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 5;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 6;
+	default:
+		return 0;
+	}
+}
+
+static int nvme_send_ns_head_pr_command(struct block_device *bdev,
+		struct nvme_command *c, u8 *data, unsigned int data_len)
+{
+	struct nvme_ns_head *head = bdev->bd_disk->private_data;
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EWOULDBLOCK;
+
+	if (ns) {
+		c->common.nsid = cpu_to_le32(ns->head->ns_id);
+		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
+
+static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
+		u8 *data, unsigned int data_len)
+{
+	c->common.nsid = cpu_to_le32(ns->head->ns_id);
+	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+}
+
+static int nvme_sc_to_pr_err(int nvme_sc)
+{
+	if (nvme_is_path_error(nvme_sc))
+		return PR_STS_PATH_FAILED;
+
+	switch (nvme_sc) {
+	case NVME_SC_SUCCESS:
+		return PR_STS_SUCCESS;
+	case NVME_SC_RESERVATION_CONFLICT:
+		return PR_STS_RESERVATION_CONFLICT;
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+		return -EINVAL;
+	default:
+		return PR_STS_IOERR;
+	}
+}
+
+static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
+				u64 key, u64 sa_key, u8 op)
+{
+	struct nvme_command c = { };
+	u8 data[16] = { 0, };
+	int ret;
+
+	put_unaligned_le64(key, &data[0]);
+	put_unaligned_le64(sa_key, &data[8]);
+
+	c.common.opcode = op;
+	c.common.cdw10 = cpu_to_le32(cdw10);
+
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
+						   sizeof(data));
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data, sizeof(data));
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_err(ret);
+}
+
+static int nvme_pr_register(struct block_device *bdev, u64 old,
+		u64 new, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = old ? 2 : 0;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
+	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+}
+
+static int nvme_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = nvme_pr_type(type) << 8;
+	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_clear(struct block_device *bdev, u64 key)
+{
+	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+const struct pr_ops nvme_pr_ops = {
+	.pr_register	= nvme_pr_register,
+	.pr_reserve	= nvme_pr_reserve,
+	.pr_release	= nvme_pr_release,
+	.pr_preempt	= nvme_pr_preempt,
+	.pr_clear	= nvme_pr_clear,
+};
-- 
2.25.1

