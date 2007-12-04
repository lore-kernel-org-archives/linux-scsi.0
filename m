From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Linux-usb-users] Read errors on Flash Drive Transcend TS1GJF2A
Date: Tue, 04 Dec 2007 19:35:37 +0200
Message-ID: <47558FE9.4090400@panasas.com>
References: <Pine.LNX.4.44L0.0711261034090.4250-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56348 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXLDRf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 12:35:56 -0500
In-Reply-To: <Pine.LNX.4.44L0.0711261034090.4250-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <ltuikov@yahoo.com>, RTE <raszilki@yandex.ru>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 26 2007 at 17:35 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> Not all devices correctly report the error-causing LBA in the
> Information field of their sense data -- even when they set the Valid
> bit.  This patch (as1019) makes sd much more cautious about accepting
> the reported LBA.  If the value isn't within the range of blocks
> accessed during the I/O operation it is rejected, and instead the
> driver will try looking at the residue field (which currently it
> ignores completely).
> 
> This fixes a data-corruption bug reported here:
> 
> 	http://marc.info/?t=118745764700005&r=1&w=2
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Luben Tuikov <ltuikov@yahoo.com>
> 
> ---
> 
> This patch should be considered for inclusion in 2.6.24.  The bug in
> question has always existed, as far as I know, but before 2.6.18 it was
> masked by a different bug.
> 
> This doesn't use the new SCSI accessors.  In the development trees
> I've seen, those accessors haven't yet been imported into sd.c.  If
> the patch needs to be rebased, please let me know where to find the
> current sd source.
> 
> Presumably sr should use the same algorithm.  That's grist for another
> patch.
> 
> 
> Index: usb-2.6/drivers/scsi/sd.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/sd.c
> +++ usb-2.6/drivers/scsi/sd.c
> @@ -968,7 +968,17 @@ static int sd_done(struct scsi_cmnd *SCp
>  		/* This computation should always be done in terms of
>  		 * the resolution of the device's medium.
>  		 */
> -		good_bytes = (bad_lba - start_lba)*SCpnt->device->sector_size;
> +		if (start_lba <= bad_lba && bad_lba < start_lba +
> +				(xfer_size / SCpnt->device->sector_size))
> +			good_bytes = SCpnt->device->sector_size *
> +					(unsigned int) (bad_lba - start_lba);
> +
> +		/* If the bad_lba value is no good, maybe the residue value
> +		 * is better.
> +		 */
> +		else if (SCpnt->resid > 0 && SCpnt->resid < xfer_size)
> +			good_bytes = (xfer_size - SCpnt->resid) &
> +					(- SCpnt->device->sector_size);
>  		break;
>  	case RECOVERED_ERROR:
>  	case NO_SENSE:
> 
> -

perhaps below hunk should be added to your patch.

Was it decided when this data corruption bugfix is
merged.

Also in sr.c. It does the range check but it might
enjoy the resid handling as well.

---------
 drivers/scsi/scsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 796c0bd..1a576bc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -714,6 +714,8 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 	good_bytes = cmd->request_bufflen;
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		if ( cmd->resid > 0 && cmd->resid < good_bytes)
+				good_bytes -= cmd->resid;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
 			good_bytes = drv->done(cmd);

