From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 16/24][RFC] Add .sense_buffsize to drivers that use scsi_eh_prep_cmnd
Date: Mon,  4 Feb 2008 19:21:39 +0200
Message-ID: <1202145699-5116-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:48936 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYBDR0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:26:49 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  With new sense handling drivers that use scsi_eh_prep_cmnd()
  should set .sense_buffsize to none-zero at host template.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/aha152x.c         |    1 +
 drivers/scsi/arm/cumana_1.c    |    1 +
 drivers/scsi/arm/oak.c         |    1 +
 drivers/scsi/atari_scsi.c      |    1 +
 drivers/scsi/dmx3191d.c        |    1 +
 drivers/scsi/dtc.c             |    1 +
 drivers/scsi/g_NCR5380.c       |    1 +
 drivers/scsi/mac_scsi.c        |    1 +
 drivers/scsi/pas16.c           |    1 +
 drivers/scsi/sun3_scsi.c       |    3 ++-
 drivers/scsi/sun3_scsi_vme.c   |    1 +
 drivers/scsi/t128.c            |    1 +
 drivers/usb/storage/scsiglue.c |    3 +++
 13 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 6ccdc96..2df7600 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3477,6 +3477,7 @@ static struct scsi_host_template aha152x_driver_template = {
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.slave_alloc			= aha152x_adjust_queue,
+	.sense_buffsize			= SCSI_SENSE_BUFFERSIZE,
 };
 
 #if !defined(PCMCIA)
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 49d838e..5866bb0 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -225,6 +225,7 @@ static struct scsi_host_template cumanascsi_template = {
 	.unchecked_isa_dma	= 0,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "CumanaSCSI-1",
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 static int __devinit
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 849cdf8..1646983 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -127,6 +127,7 @@ static struct scsi_host_template oakscsi_template = {
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "oakscsi",
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 static int __devinit
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index f5732d8..7324f49 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -1140,6 +1140,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= 0, /* initialized at run-time */
 	.cmd_per_lun		= 0, /* initialized at run-time */
 	.use_clustering		= DISABLE_CLUSTERING
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index fa738ec..1ee5264 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -66,6 +66,7 @@ static struct scsi_host_template dmx3191d_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 static int __devinit dmx3191d_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..7d84259 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -482,5 +482,6 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize   		= SG_ALL,
 	.cmd_per_lun    		= CMD_PER_LUN,
 	.use_clustering 		= DISABLE_CLUSTERING,
+	.sense_buffsize			= SCSI_SENSE_BUFFERSIZE,
 };
 #include "scsi_module.c"
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 75585a5..d47a62e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -925,6 +925,7 @@ static struct scsi_host_template driver_template = {
         .sg_tablesize   	= SG_ALL,
 	.cmd_per_lun    	= CMD_PER_LUN,
         .use_clustering		= DISABLE_CLUSTERING,
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 #include <linux/module.h>
 #include "scsi_module.c"
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 3b09ab2..abec17f 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -594,6 +594,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun			= CMD_PER_LUN,
 	.unchecked_isa_dma		= 0,
 	.use_clustering			= DISABLE_CLUSTERING
+	.sense_buffsize			= SCSI_SENSE_BUFFERSIZE,
 };
 
 
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index f2018b4..90ac61f 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -628,6 +628,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize   = SG_ALL,
 	.cmd_per_lun    = CMD_PER_LUN,
 	.use_clustering = DISABLE_CLUSTERING,
+	.sense_buffsize	= SCSI_SENSE_BUFFERSIZE,
 };
 #include "scsi_module.c"
 
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index e606cf0..dfc2383 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -633,7 +633,8 @@ static struct scsi_host_template driver_template = {
 	.this_id		= 7,
 	.sg_tablesize		= SG_TABLESIZE,
 	.cmd_per_lun		= CMD_PER_LUN,
-	.use_clustering		= DISABLE_CLUSTERING
+	.use_clustering		= DISABLE_CLUSTERING,
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 02d9727..a2efb4a 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -577,6 +577,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= SG_TABLESIZE,
 	.cmd_per_lun		= CMD_PER_LUN,
 	.use_clustering		= DISABLE_CLUSTERING
+	.sense_buffsize		= SCSI_SENSE_BUFFERSIZE,
 };
 
 
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 041eaaa..ad3365f 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -443,5 +443,6 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize   = SG_ALL,
 	.cmd_per_lun    = CMD_PER_LUN,
 	.use_clustering = DISABLE_CLUSTERING,
+	.sense_buffsize	= SCSI_SENSE_BUFFERSIZE,
 };
 #include "scsi_module.c"
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8c1e295..7acfc0b 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -499,6 +499,9 @@ struct scsi_host_template usb_stor_host_template = {
 	/* we do our own delay after a device or bus reset */
 	.skip_settle_delay =		1,
 
+	/* calling scsi_eh_prep_cmnd needs this set */
+	.sense_buffsize = 		US_SENSE_SIZE,
+
 	/* sysfs device attributes */
 	.sdev_attrs =			sysfs_device_attr_list,
 
-- 
1.5.3.3

