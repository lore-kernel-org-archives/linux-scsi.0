From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove superflous scsi_delete_timer()
Date: Sat, 23 Nov 2002 04:02:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021123040216.A11428@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

the first action performed by scsi_mlqueue_insert() is exactly that
scsi_delete_timer()


--- 1.73/drivers/scsi/scsi.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/scsi.c	Sat Nov 23 02:58:22 2002
@@ -793,7 +776,6 @@
 			rtn = host->hostt->queuecommand(SCpnt, scsi_done);
 			spin_unlock_irqrestore(host->host_lock, flags);
 			if (rtn != 0) {
-				scsi_delete_timer(SCpnt);
 				scsi_mlqueue_insert(SCpnt, rtn == SCSI_MLQUEUE_DEVICE_BUSY ? rtn : SCSI_MLQUEUE_HOST_BUSY);
 				SCSI_LOG_MLQUEUE(3,
 				   printk("queuecommand : request rejected\n"));                                
