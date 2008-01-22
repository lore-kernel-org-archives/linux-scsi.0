From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 11:29:45 -0600
Message-ID: <1201022985.3210.24.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34904 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbYAVR3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 12:29:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Added linux-scsi to the cc.

On Tue, 2008-01-22 at 17:11 +0000, Hugh Dickins wrote:
> 2.6.24-rc8-mm1 is corrupting.  smartd does some sg_ioctl into its stack,
> and depending on how its stack randomization worked out, this is liable
> to end up writing into the adjacent physical page too.  If you're lucky
> you have highmem, and ioread16_rep oopses on the virtual address beyond
> what ata_pio_sector's kmap_atomic set up; when you're unlucky, it'll go
> ahead and corrupt the next page more obscurely.
> 
> Bisect led to scsi-misc-2.6.git's 465ff3185e0cb76d46137335a4d21d0d9d3ac8a2
> [SCSI] relax scsi dma alignment, and the patch below is good for a hot-fix.
> Though I doubt it'll be the final fix, since it appears to undo the whole
> point of blk_queue_update_dma_alignment: perhaps libata is at fault to be
> going through sectory code for unsectory I/O - I wouldn't know.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  drivers/ata/libata-scsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.24-rc8-mm1/drivers/ata/libata-scsi.c	2008-01-17 16:49:47.000000000 +0000
> +++ linux/drivers/ata/libata-scsi.c	2008-01-22 15:45:40.000000000 +0000
> @@ -826,7 +826,7 @@ static void ata_scsi_sdev_config(struct 
>  	sdev->max_device_blocked = 1;
>  
>  	/* set the min alignment */
> -	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
> +	blk_queue_update_dma_alignment(sdev->request_queue, ATA_SECT_SIZE - 1);
>  }
>  
>  static void ata_scsi_dev_config(struct scsi_device *sdev,

Unfortunately, that's likely not the entire hot fix ... the implication
is that we have some mapping error in the way we do direct SG_IO.

What the fix you propose does is make it far more likely that block will
copy, perform I/O then uncopy (almost certain, since most smartd data
transfers are well under ATA_SECT_SIZE, which is 512).  However,
implicating a generic path like this implies that we would get the same
problem for SCSI commands as well, so the correct hot fix is below.

However, I'd like to see if we can track the problem through the SG_IO
direct path ... how many adjacent page bytes are corrupt?  Just a few or
a large number (I'm wondering if it's an off by one or off by alignment
type bug)?

James

---
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4cf902e..13376e9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1673,8 +1673,11 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 * set a reasonable default alignment on word boundaries: the
 	 * host and device may alter it using
 	 * blk_queue_update_dma_alignment() later.
+	 *
+	 * FIXME: Corruption showing up in SG_IO leads this to be
+	 * raised to 511 again.
 	 */
-	blk_queue_dma_alignment(q, 0x03);
+	blk_queue_dma_alignment(q, 511);
 
 	return q;
 }


