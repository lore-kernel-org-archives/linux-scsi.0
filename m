From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't dereference sdev->access_count in dpt_i2o
Date: Mon, 9 Jun 2003 17:18:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609151830.GC1325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:16270 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263837AbTFIPEx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 11:04:53 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is nothing a LLDD should ever look at and might go away
completly soon.  The uses are for a printk and a racy ioctl.


diff -Nru a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c	Sun Jun  8 19:06:49 2003
+++ b/drivers/scsi/dpt_i2o.c	Sun Jun  8 19:06:49 2003
@@ -1949,25 +1949,5 @@
 	case I2ORESCANCMD:
 		adpt_rescan(pHba);
 		break;
-	case DPT_TARGET_BUSY & 0xFFFF:
-	case DPT_TARGET_BUSY:
-	{
-		TARGET_BUSY_T busy;
-		struct adpt_device* d;
-
-		if (copy_from_user((void*)&busy, (void*)arg, sizeof(TARGET_BUSY_T))) {
-			return -EFAULT;
-		}
-
-		d = adpt_find_device(pHba, busy.channel, busy.id, busy.lun);
-		if(d == NULL){
-			return -ENODEV;
-		}
-		busy.isBusy = ((d->pScsi_dev) && (0 != d->pScsi_dev->access_count)) ? 1 : 0;
-		if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
-			return -EFAULT;
-		}
-		break;
-	}
 	default:
 		return -EINVAL;
@@ -2492,10 +2473,6 @@
 			printk(KERN_WARNING"%s: Device (%d,%d,%d) offline\n",pHba->name,pDev->scsi_channel,pDev->scsi_id,pDev->scsi_lun);
 			if (pDev->pScsi_dev) {
 				pDev->pScsi_dev->online = FALSE;
-				if (pDev->pScsi_dev->access_count) {
-					// A drive that was mounted is no longer there... bad!
-					printk(KERN_WARNING"%s:Mounted drive taken offline\n",pHba->name);
-				}
 			}
 		}
 	}
