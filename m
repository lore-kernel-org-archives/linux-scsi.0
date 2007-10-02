From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 08/16] gdth: Reorder scsi_host_template intitializers
Date: Tue, 02 Oct 2007 22:57:58 +0200
Message-ID: <4702B0D6.8020907@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3272 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754720AbXJBU6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 16:58:12 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kerne>

From: Jeff Garzik <jeff@garzik.org>

  * shuffle scsi_host_template members such that they appear in the
    order in which they are defined in the header.  this makes is easier
    to verify when initializers are missing members.

  Signed-off-by: Jeff Garzik <jeff@garzik.org>
  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 43b169f..24e6fd9 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4907,17 +4907,17 @@ static int gdth_slave_configure(struct scsi_device *sdev)
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


