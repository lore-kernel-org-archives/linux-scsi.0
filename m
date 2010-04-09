From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/12] fcoe, fnic,
	libfc: increased CDB size to 16 bytes for fcoe.
Date: Fri, 09 Apr 2010 14:22:59 -0700
Message-ID: <20100409212259.1968.43502.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab0DIVXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:23:00 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

No reason to restrict CDB size to 12 bytes in fcoe, so
increased to 16 so that 16 bytes SCSI CDB doesn't fail.

Uses common define to set max_cmd_len for fcoe and fnic,
fnic is already setting max_cmd_len to 16.

sg_readcap -l fails without this fix.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |    2 ++
 drivers/scsi/fnic/fnic.h      |    2 +-
 drivers/scsi/fnic/fnic_main.c |    2 +-
 include/scsi/libfcoe.h        |    2 ++
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4d46b71..25a7ce5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -669,6 +669,8 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 	lport->host->max_lun = FCOE_MAX_LUN;
 	lport->host->max_id = FCOE_MAX_FCP_TARGET;
 	lport->host->max_channel = 0;
+	lport->host->max_cmd_len = FCOE_MAX_CMD_LEN;
+
 	if (lport->vport)
 		lport->host->transportt = fcoe_vport_transport_template;
 	else
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 585cc9c..19338e0 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -45,7 +45,7 @@
 #define	FNIC_IO_LOCKS		64 /* IO locks: power of 2 */
 #define FNIC_DFLT_QUEUE_DEPTH	32
 #define	FNIC_STATS_RATE_LIMIT	4 /* limit rate at which stats are pulled up */
-#define FNIC_MAX_CMD_LEN        16 /* Supported CDB length */
+
 /*
  * Tag bits used for special requests.
  */
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 97b2125..265e73d 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -556,7 +556,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	}
 	host->max_lun = fnic->config.luns_per_tgt;
 	host->max_id = FNIC_MAX_FCP_TARGET;
-	host->max_cmd_len = FNIC_MAX_CMD_LEN;
+	host->max_cmd_len = FCOE_MAX_CMD_LEN;
 
 	fnic_get_res_counts(fnic);
 
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 868ed26..ec13f51 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -29,6 +29,8 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
 
+#define FCOE_MAX_CMD_LEN	16	/* Supported CDB length */
+
 /*
  * FIP tunable parameters.
  */

