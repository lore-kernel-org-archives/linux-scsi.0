From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 6/16] Reorder scsi_host_template intitializers
Date: Sun, 30 Sep 2007 21:59:22 +0200
Message-ID: <4700001A.3010802@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa12.bezeqint.net ([192.115.104.27]:51642 "EHLO
	sa12.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbXI3T7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 15:59:30 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  * shuffle scsi_host_template members such that they appear in the
    order in which they are defined in the header.  this makes is easier
    to verify when initializers are missing members.

  Signed-off-by: Jeff Garzik <jeff@garzik.org>
  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c911ebc..4fa6609 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4898,17 +4898,17 @@ static int gdth_slave_configure(struct scsi_device *sdev)
 }
 
 static struct scsi_host_template driver_template = {
-        .proc_name              = "gdth", 
-        .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
         .detect                 = gdth_detect, 
         .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
+        .slave_configure        = gdth_slave_configure,
         .bios_param             = gdth_bios_param,
+        .proc_info              = gdth_proc_info,
+        .proc_name              = "gdth",
         .can_queue              = GDTH_MAXCMDS,
-        .slave_configure        = gdth_slave_configure,
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
-- 
1.5.3.1


