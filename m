From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] scsi: use 64-bit value for 'max_luns'
Date: Wed, 25 Jun 2014 05:33:36 -0700
Message-ID: <20140625123336.GA10603@infradead.org>
References: <1401785937-43581-1-git-send-email-hare@suse.de>
 <1401785937-43581-6-git-send-email-hare@suse.de>
 <20140625122856.GA3221@infradead.org>
 <53AAC123.2060303@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53AAC123.2060303@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 25, 2014 at 02:31:31PM +0200, Hannes Reinecke wrote:
> Guess I need to redo the patchset yet again ...

If you plan to resend it please also include these fixes for the
mptfusion driver:


diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 02a3eef..bf2a2ce 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -204,7 +204,7 @@ mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
 	 || (loops > 0 && ioc->active == 0)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"mptfc_block_error_handler.%d: %d:%d, port status is "
+			"mptfc_block_error_handler.%d: %d:%llu, port status is "
 			"%x, active flag %d, deferring %s recovery.\n",
 			ioc->name, ioc->sh->host_no,
 			SCpnt->device->id, SCpnt->device->lun,
@@ -218,7 +218,7 @@ mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
 	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata
 	 || ioc->active == 0) {
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"%s.%d: %d:%d, failing recovery, "
+			"%s.%d: %d:%llu, failing recovery, "
 			"port state %x, active %d, vdevice %p.\n", caller,
 			ioc->name, ioc->sh->host_no,
 			SCpnt->device->id, SCpnt->device->lun, ready,
@@ -226,7 +226,7 @@ mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
 		return FAILED;
 	}
 	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-		"%s.%d: %d:%d, executing recovery.\n", caller,
+		"%s.%d: %d:%llu, executing recovery.\n", caller,
 		ioc->name, ioc->sh->host_no,
 		SCpnt->device->id, SCpnt->device->lun));
 	return (*func)(SCpnt);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 82d991d..5b06d68 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -536,7 +536,7 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, struct scsi_cmnd *sc, SCSIIOReply_t * pSc
 	}
 
 	scsi_print_command(sc);
-	printk(MYIOC_s_DEBUG_FMT "\tfw_channel = %d, fw_id = %d, lun = %d\n",
+	printk(MYIOC_s_DEBUG_FMT "\tfw_channel = %d, fw_id = %d, lun = %llu\n",
 	    ioc->name, pScsiReply->Bus, pScsiReply->TargetID, sc->device->lun);
 	printk(MYIOC_s_DEBUG_FMT "\trequest_len = %d, underflow = %d, "
 	    "resid = %d\n", ioc->name, scsi_bufflen(sc), sc->underflow,
@@ -1155,7 +1155,7 @@ mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSI
 		return;
 	ioc = hd->ioc;
 	if (time - hd->last_queue_full > 10 * HZ) {
-		dprintk(ioc, printk(MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported QUEUE_FULL!\n",
+		dprintk(ioc, printk(MYIOC_s_WARN_FMT "Device (%d:%d:%llu) reported QUEUE_FULL!\n",
 				ioc->name, 0, sc->device->id, sc->device->lun));
 		hd->last_queue_full = time;
 	}
@@ -2380,7 +2380,7 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 	vdevice = sdev->hostdata;
 
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-		"device @ %p, channel=%d, id=%d, lun=%d\n",
+		"device @ %p, channel=%d, id=%d, lun=%llu\n",
 		ioc->name, sdev, sdev->channel, sdev->id, sdev->lun));
 	if (ioc->bus_type == SPI)
 		dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
