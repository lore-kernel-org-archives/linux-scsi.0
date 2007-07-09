From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] libsas: add SAS management protocol handler
Date: Mon, 09 Jul 2007 12:52:08 +0900
Message-ID: <20070709125208I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60536 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833AbXGIDwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 23:52:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, Eric.Moore@lsi.com, jens.axboe@oracle.com

This patch adds support for SAS Management Protocol (SMP) passthrough
support via bsg. aic94xx can use this.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsas/sas_expander.c |   48 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_init.c     |    1 +
 include/scsi/libsas.h              |    2 +
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index e34442e..49d8952 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/scatterlist.h>
+#include <linux/blkdev.h>
 
 #include "sas_internal.h"
 
@@ -1914,3 +1915,50 @@ out:
 	return res;
 }
 #endif
+
+int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
+		    struct request *req)
+{
+	struct domain_device *dev;
+	int ret, type = rphy->identify.device_type;
+	struct request *rsp = req->next_rq;
+
+	if (!rsp) {
+		printk("%s: space for a smp response is missing\n",
+		       __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* seems aic94xx doesn't support */
+	if (!rphy) {
+		printk("%s: can we send a smp request to a host?\n",
+		       __FUNCTION__);
+		return -EINVAL;
+	}
+
+	if (type != SAS_EDGE_EXPANDER_DEVICE &&
+	    type != SAS_FANOUT_EXPANDER_DEVICE) {
+		printk("%s: can we send a smp request to a device?\n",
+		       __FUNCTION__);
+		return -EINVAL;
+	}
+
+	dev = sas_find_dev_by_rphy(rphy);
+	if (!dev) {
+		printk("%s: fail to find a domain_device?\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* do we need to support multiple segments? */
+	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+		printk("%s: multiple segments req %u %u, rsp %u %u\n",
+		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		       rsp->bio->bi_vcnt, rsp->data_len);
+		return -EINVAL;
+	}
+
+	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
+			       bio_data(rsp->bio), rsp->data_len);
+
+	return ret;
+}
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 965698c..9836027 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -259,6 +259,7 @@ static struct sas_function_template sft = {
 	.phy_reset = sas_phy_reset,
 	.set_phy_speed = sas_set_phy_speed,
 	.get_linkerrors = sas_get_linkerrors,
+	.smp_handler = sas_smp_handler,
 };
 
 struct scsi_transport_template *
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 2e6bdc4..e981ac3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -661,4 +661,6 @@ int __sas_task_abort(struct sas_task *);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
 
+extern int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
+			   struct request *req);
 #endif /* _SASLIB_H_ */
-- 
1.4.4.4

