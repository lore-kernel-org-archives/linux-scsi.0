From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_sas: fix physical disk handling
Date: Mon, 6 Feb 2006 15:05:19 +0100
Message-ID: <20060206140519.GA2515@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35804 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932118AbWBFOFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 09:05:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com, Sumant.Patro@lsil.com
Cc: Chandra_Nelogal@Dell.com, linux-scsi@vger.kernel.org

Chandra_Nelogal noticed that megaraid_sas currently exports all physical
disks normally to the disk layer, which is obviously quite bad.

The problems is that megaraid_sas is doing inquiry sniffing, and since
2.6.15 inquiry commands are sent down as one-element scatterlists on
which the code in the driver doesn't work anymore.  The right place to
keep the scsi midlayer from attaching to a device is the slave_alloc
method in the host template.  To completely prevent attaching the method
needs to return -ENXIO, but the patch below sets the no_uld_attach flag
instead which prevents upper level drivers from attaching while still
allowing scsi generic access to it, as in other raid HBA drivers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-02-04 13:35:00.000000000 +0100
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-02-06 14:59:13.000000000 +0100
@@ -707,6 +707,16 @@
 	return 0;
 }
 
+static int megasas_slave_configure(struct scsi_device *sdev)
+{
+	/*
+	 * Don't export physical disk devices to the disk driver.
+	 */
+	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
+		sdev->no_uld_attach = 1;
+	return 0;
+}
+
 /**
  * megasas_wait_for_outstanding -	Wait for all outstanding cmds
  * @instance:				Adapter soft state
@@ -857,6 +867,7 @@
 	.module = THIS_MODULE,
 	.name = "LSI Logic SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
+	.slave_configure = megasas_slave_configure,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -985,20 +996,6 @@
 			break;
 		}
 
-		/*
-		 * Don't export physical disk devices to mid-layer.
-		 */
-		if (!MEGASAS_IS_LOGICAL(cmd->scmd) &&
-		    (hdr->cmd_status == MFI_STAT_OK) &&
-		    (cmd->scmd->cmnd[0] == INQUIRY)) {
-
-			if (((*(u8 *) cmd->scmd->request_buffer) & 0x1F) ==
-			    TYPE_DISK) {
-				cmd->scmd->result = DID_BAD_TARGET << 16;
-				exception = 1;
-			}
-		}
-
 	case MFI_CMD_LD_READ:
 	case MFI_CMD_LD_WRITE:
 
