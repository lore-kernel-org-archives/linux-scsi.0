From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 13:43:48 -0600
Message-ID: <1201031028.3210.61.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	 <1201022985.3210.24.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801221813540.8693@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35633 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599AbYAVTny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 14:43:54 -0500
In-Reply-To: <Pine.LNX.4.64.0801221813540.8693@blonde.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-01-22 at 18:36 +0000, Hugh Dickins wrote:
> On Tue, 22 Jan 2008, James Bottomley wrote:
> > > --- 2.6.24-rc8-mm1/drivers/ata/libata-scsi.c	2008-01-17 16:49:47.000000000 +0000
> > > +++ linux/drivers/ata/libata-scsi.c	2008-01-22 15:45:40.000000000 +0000
> > > @@ -826,7 +826,7 @@ static void ata_scsi_sdev_config(struct 
> > >  	sdev->max_device_blocked = 1;
> > >  
> > >  	/* set the min alignment */
> > > -	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
> > > +	blk_queue_update_dma_alignment(sdev->request_queue, ATA_SECT_SIZE - 1);
> > >  }
> > >  
> > >  static void ata_scsi_dev_config(struct scsi_device *sdev,
> > 
> > Unfortunately, that's likely not the entire hot fix ... the implication
> > is that we have some mapping error in the way we do direct SG_IO.
> 
> Quite possibly, I'm not sure.
> 
> > What the fix you propose does is make it far more likely that block will
> > copy, perform I/O then uncopy (almost certain, since most smartd data
> > transfers are well under ATA_SECT_SIZE, which is 512).  However,
> > implicating a generic path like this implies that we would get the same
> > problem for SCSI commands as well, so the correct hot fix is below.
> 
> I've not noticed any problems from the normal activity of the system,
> only from smartd's sg_ioctl.  My impression was that it's a libata
> issue, because it's going through ata_pio_sector, which does 
> 
> 	ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
> 
> referring to sect_size, without considering the possibility of any smaller
> I/O size.  (Me, I don't even know why it's going PIO rather than DMA:
> I'm assuming smartd does things that way, but there's no limit to my
> ignorance here.)

Actually, I don't think it's a smaller I/O issue.  The SMART protocol
specifically mandates that the transfers for SMART READ DATA and SMART
READ LOG shall be 512 bytes).  However, the pio transfer routine does
seem to be assuming sector alignment as well, which will be where your
problems are coming from.  I think we need to specify sector minimum
alignment for ata (but not atapi, which has its own non sector size pio
routine).  How about the attached?

We have to do this for all ATA devices, because they'll likely all
support SMART, and SMART is defined to be a PIO command.

James

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4bb268b..bc5cf6b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -824,9 +824,6 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	 * requests.
 	 */
 	sdev->max_device_blocked = 1;
-
-	/* set the min alignment */
-	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
 }
 
 static void ata_scsi_dev_config(struct scsi_device *sdev,
@@ -842,7 +839,14 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
-	}
+
+		/* set the min alignment */
+		blk_queue_update_dma_alignment(sdev->request_queue,
+					       ATA_DMA_PAD_SZ - 1);
+	} else
+		/* ATA devices must be sector aligned */
+		blk_queue_update_dma_alignment(sdev->request_queue,
+					       ATA_SECT_SIZE - 1);
 
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);


> > However, I'd like to see if we can track the problem through the SG_IO
> > direct path ... how many adjacent page bytes are corrupt?  Just a few or
> > a large number (I'm wondering if it's an off by one or off by alignment
> > type bug)?
> 
> I've assumed it's just the one next page: because ata_pio_sector is
> doing a data_xfer of sect_size ATA_SECT_SIZE 512 to an offset above
> 0xe00 in the smartd stack page.  The time I actually saw corruption
> rather than an oops at startup, it was in a tmpfs swap vector page
> running 64-bit kernel, and I didn't examine any further pages (just
> checked the page before and matched it up to smartd's stack, already
> suspecting that).
> 
> I don't believe it's an off-by-one at your SCSI end.
> 
> Hugh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

