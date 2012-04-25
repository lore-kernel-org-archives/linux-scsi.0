From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: Block flash access from application when device is initialized for ISP82xx.
Date: Wed, 25 Apr 2012 07:26:14 -0700
Message-ID: <1335363977-6816-3-git-send-email-chad.dupuis@qlogic.com>
References: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:50950
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab2DYOl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 10:41:59 -0400
Received: from mail102-db3 (localhost [127.0.0.1])	by
 mail102-db3-R.bigfish.com (Postfix) with ESMTP id 44AC54C0184	for
 <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2012 14:41:52 +0000 (UTC)
In-Reply-To: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    3 +++
 drivers/scsi/qla2xxx/qla_sup.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f74cc06..bc3cc6d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1367,6 +1367,9 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (ha->flags.isp82xx_reset_hdlr_active)
+		return -EBUSY;
+
 	rval = qla2x00_optrom_setup(bsg_job, vha, 0);
 	if (rval)
 		return rval;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 3c13c0a..a683e76 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1017,6 +1017,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	    !IS_CNA_CAPABLE(ha) && !IS_QLA2031(ha))
 		return;
 
+	if (ha->flags.isp82xx_reset_hdlr_active)
+		return;
+
 	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
 	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
 	if (hdr.version == __constant_cpu_to_le16(0xffff))
-- 
1.6.0.2


