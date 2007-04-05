From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Perverting cciss
Date: Thu, 05 Apr 2007 11:58:06 +0200
Message-ID: <4614C82E.1020100@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080503000304070401030802"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:44775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbXDEJ6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2007 05:58:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080503000304070401030802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi All,

this patch adds the SG_IO ioctl to the cciss driver.
As the driver is capable of sending SCSI CDBs to the controller there is
no reason why we shouldn't exploit it.
This way we get to use all the nice sg_utils for the cciss driver.
And a persistent device name for free.

Makes one wonder why this one is not implemented as a SCSI driver in the
first place.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------080503000304070401030802
Content-Type: text/plain;
 name="cciss-add-SG_IO"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cciss-add-SG_IO"

Add SG_IO ioctl to cciss

The cciss driver is actually capable of sending SCSI CDB to the
controller. So it would only be logical to have it accepting 
SG_IO ioctl, too.
Now we can use all the nice sg_utils and get a persistent device name
for free, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0c716ee..33e7b83 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -45,6 +45,9 @@ #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/sg.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
@@ -1152,6 +1155,163 @@ #endif
 			kfree(ioc);
 			return status;
 		}
+	case SG_IO: {
+		struct sg_io_hdr hdr;
+		CommandList_struct *c;
+		char *buff = NULL;
+		u64bit temp64;
+		unsigned long flags;
+		DECLARE_COMPLETION_ONSTACK(wait);
+
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+
+		if (copy_from_user(&hdr, argp, sizeof(hdr)))
+			return -EFAULT;
+
+		if (hdr.interface_id != 'S')
+			return -EINVAL;
+
+		/* cciss only supports 16-byte commands */
+		if (hdr.cmd_len > 16)
+			return -EINVAL;
+
+		/* We don't support proper scatter-gather (yet) */
+		if (hdr.iovec_count)
+			return -EINVAL;
+
+		if ((hdr.dxfer_len < 1) &&
+		    (hdr.dxfer_direction != SG_DXFER_NONE))
+			return -EINVAL;
+
+		if (hdr.dxfer_len > 0) {
+			buff = kmalloc(hdr.dxfer_len, GFP_KERNEL);
+			if (buff == NULL)
+				return -EFAULT;
+		}
+		if ((hdr.dxfer_direction == SG_DXFER_TO_DEV) ||
+		    (hdr.dxfer_direction == SG_DXFER_TO_FROM_DEV)) {
+			/* Copy the data into the buffer we created */
+			if (copy_from_user (buff, hdr.dxferp,
+					    hdr.dxfer_len)) {
+				kfree(buff);
+				return -EFAULT;
+			}
+		} else
+			memset(buff, 0, hdr.dxfer_len);
+
+		if ((c = cmd_alloc(host, 0)) == NULL) {
+			kfree(buff);
+			return -ENOMEM;
+		}
+
+		/* Copy CDB */
+		if (copy_from_user(c->Request.CDB, hdr.cmdp, hdr.cmd_len))
+			return -EFAULT;
+
+		/* Fill in the command type */
+		c->cmd_type = CMD_IOCTL_PEND;
+		/* Fill in Command Header */
+		c->Header.ReplyQueue = 0;
+		if (hdr.dxfer_len > 0) {
+			c->Header.SGList = 1;
+			c->Header.SGTotal = 1;
+		} else {
+			c->Header.SGList = 0;
+			c->Header.SGTotal = 0;
+		}
+		/* Default to LUN the ioctl was directed to */
+		c->Header.LUN.LogDev.VolId = drv->LunID & 0x3FFFFFFF;
+		c->Header.LUN.LogDev.Mode = 0x01; /* Logical volume */
+		c->Header.Tag.lower = c->busaddr;
+
+		/* Fill in Request block */
+		c->Request.CDBLen = hdr.cmd_len;
+		c->Request.Type.Type = TYPE_CMD;
+		c->Request.Type.Attribute = ATTR_SIMPLE;
+		switch(hdr.dxfer_direction) {
+		    case SG_DXFER_NONE:
+			c->Request.Type.Direction = XFER_NONE;
+			break;
+		    case SG_DXFER_TO_DEV:
+			c->Request.Type.Direction = XFER_WRITE;
+			break;
+		    case SG_DXFER_FROM_DEV:
+			c->Request.Type.Direction = XFER_READ;
+			break;
+		    case SG_DXFER_TO_FROM_DEV:
+			c->Request.Type.Direction = XFER_RSVD;
+			break;
+		}
+		c->Request.Timeout = hdr.timeout;
+
+		/* Fill in the scatter gather information */
+		if (hdr.dxfer_len > 0) {
+			temp64.val = pci_map_single(host->pdev, buff,
+						    hdr.dxfer_len,
+						    PCI_DMA_BIDIRECTIONAL);
+			c->SG[0].Addr.lower = temp64.val32.lower;
+			c->SG[0].Addr.upper = temp64.val32.upper;
+			c->SG[0].Len = hdr.dxfer_len;
+			c->SG[0].Ext = 0;
+		}
+		c->waiting = &wait;
+
+		/* Put the request on the tail of the request queue */
+		spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+		addQ(&host->reqQ, c);
+		host->Qdepth++;
+		start_io(host);
+		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+
+		wait_for_completion(&wait);
+
+		/* unlock the buffers from DMA */
+		temp64.val32.lower = c->SG[0].Addr.lower;
+		temp64.val32.upper = c->SG[0].Addr.upper;
+		pci_unmap_single(host->pdev, (dma_addr_t) temp64.val,
+				 hdr.dxfer_len,
+				 PCI_DMA_BIDIRECTIONAL);
+
+		/* Copy the error information out */
+		hdr.status = c->err_info->ScsiStatus;
+		if (c->err_info->SenseLen && hdr.mx_sb_len > 0) {
+			int sense_len = c->err_info->SenseLen;
+
+			if (sense_len > hdr.mx_sb_len)
+				sense_len = hdr.mx_sb_len;
+
+			if (copy_to_user(hdr.sbp, c->err_info->SenseInfo,
+					 sense_len)) {
+				kfree(buff);
+				cmd_free(host, c, 0);
+				return -EFAULT;
+			}
+			hdr.sb_len_wr = sense_len;
+		}
+		hdr.resid = c->err_info->ResidualCnt;
+		/* Copy out the header */
+		if (copy_to_user(argp, &hdr, sizeof(hdr))) {
+			kfree(buff);
+			cmd_free(host, c, 0);
+			return -EFAULT;
+		}
+
+		if ((hdr.dxfer_direction == SG_DXFER_FROM_DEV) ||
+		    (hdr.dxfer_direction == SG_DXFER_TO_FROM_DEV)) {
+			/* Copy the data out to the buffer we created */
+			if (copy_to_user
+			    (hdr.dxferp, buff, hdr.dxfer_len)) {
+				kfree(buff);
+				cmd_free(host, c, 0);
+				return -EFAULT;
+			}
+		}
+
+		kfree(buff);
+		cmd_free(host, c, 0);
+		return 0;
+		}
 	default:
 		return -ENOTTY;
 	}

--------------080503000304070401030802--
