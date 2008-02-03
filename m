From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Sun, 03 Feb 2008 08:38:31 -0600
Message-ID: <1202049511.3318.13.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <1200698057.3111.68.camel@localhost.localdomain>
	 <1201894847.3134.59.camel@localhost.localdomain>
	 <47A37AF3.3030503@garzik.org>
	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>
	 <1202013174.3187.69.camel@localhost.localdomain>
	 <47A56F2B.4040904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47A56F2B.4040904@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-02-03 at 16:37 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> >> I think the best solution is to update block layer draining such that it
> >> can be included together before the merge window closes.  I'll dig into it.
> > 
> > Like I said, the block layer pieces are already upstream.  All we need
> > is the ATA bits and I think it should all work ... unless there's some
> > part I haven't though of?
> 
> Yeah, I think we'll probably need to add rq->raw_data_len and I'd really
> like to map longer drain area but I think the basics are there.

I'm reluctant to add another parameter to the request, but this one you
can calculate:  you just do it wherever you work out the size of the
request.  If data_len is the true data length and total_data_len is the
data length plus the drain length, the calculation fragment is

if (blk_pc_request(req))
	data_len = req->data_len;
else
	data_len = req->nr_sectors << 9;
total_data_len = data_len + req->q->dma_drain_size;

If the request has already been mapped by scsi, then data_len is
actually scsi_cmnd->sdb.length

> What's needed is updating libata accordingly and testing it.

Actually, I sent the patch to do this a few days ago:

http://marc.info/?l=linux-ide&m=120189565418258

But I've attached it again.

> I'm currently away from all my toys.  I'll implement the ATA part,
> test it and submit the patch on Monday.

Great, will look forward to the results.  Like I said, I think the turn
on draining in slave configure should be narrowed from all ATAPI devices
to all AHCI ATAPI devices if there's no evidence that any other
implementation that uses DMA to transfer PIO isn't similarly broken (I
know the aic94xx works fine, for instance ...

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 10 Jan 2008 11:42:50 -0600
Subject: libata: implement drain buffers

This just updates the libata slave configure routine to take advantage
of the block layer drain buffers.

I suspect I should also be checking for AHCI as well as ATA_DEV_ATAPI,
but I couldn't see how to do that easily.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/ata/libata-scsi.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ffff44..a28351c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -826,8 +826,8 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	sdev->max_device_blocked = 1;
 }
 
-static void ata_scsi_dev_config(struct scsi_device *sdev,
-				struct ata_device *dev)
+static int ata_scsi_dev_config(struct scsi_device *sdev,
+			       struct ata_device *dev)
 {
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
@@ -839,6 +839,16 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		sdev->manage_start_stop = 1;
 	}
 
+	if (dev->class == ATA_DEV_ATAPI) {
+		struct request_queue *q = sdev->request_queue;
+		void *buf = kmalloc(ATAPI_MAX_DRAIN, GFP_KERNEL);
+		if (!buf) {
+			sdev_printk(KERN_ERR, sdev, "drain buffer allocation failed\n");
+			return -ENOMEM;
+		}
+		blk_queue_dma_drain(q, buf, ATAPI_MAX_DRAIN);
+	}
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -849,6 +859,8 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		depth = min(ATA_MAX_QUEUE - 1, depth);
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
+
+	return 0;
 }
 
 /**
@@ -867,13 +879,14 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
+	int rc = 0;
 
 	ata_scsi_sdev_config(sdev);
 
 	if (dev)
-		ata_scsi_dev_config(sdev, dev);
+		rc = ata_scsi_dev_config(sdev, dev);
 
-	return 0;
+	return rc;
 }
 
 /**
@@ -895,6 +908,7 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	unsigned long flags;
 	struct ata_device *dev;
+	struct request_queue *q = sdev->request_queue;
 
 	if (!ap->ops->error_handler)
 		return;
@@ -908,6 +922,10 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 		ata_port_schedule_eh(ap);
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
+
+	kfree(q->dma_drain_buffer);
+	q->dma_drain_buffer = NULL;
+	q->dma_drain_size = 0;
 }
 
 /**
-- 
1.5.3.8



