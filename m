From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scsi: sr.c use unaligned access helpers
Date: Tue, 7 Oct 2008 12:25:31 -0700
Message-ID: <20081007122531.fbe3c6b8.akpm@linux-foundation.org>
References: <1223081173.6778.4.camel@brick>
	<20081007121025.GY19428@kernel.dk>
	<48EB53C2.6050101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbYJGT0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 15:26:24 -0400
In-Reply-To: <48EB53C2.6050101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: jens.axboe@oracle.com, harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, 07 Oct 2008 14:19:14 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Jens Axboe wrote:
> > On Fri, Oct 03 2008, Harvey Harrison wrote:
> >> Preserve the cd->capacity indentation near the #if 0'd if() statement.
> >>
> >> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >> ---
> >>  drivers/scsi/sr.c |   26 ++++++++------------------
> >>  1 files changed, 8 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> >> index 27f5bfd..f1b650e 100644
> >> --- a/drivers/scsi/sr.c
> >> +++ b/drivers/scsi/sr.c
> >> @@ -45,6 +45,7 @@
> >>  #include <linux/blkdev.h>
> >>  #include <linux/mutex.h>
> >>  #include <asm/uaccess.h>
> >> +#include <asm/unaligned.h>
> >>  
> >>  #include <scsi/scsi.h>
> >>  #include <scsi/scsi_dbg.h>
> >> @@ -280,10 +281,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
> >>  		case ILLEGAL_REQUEST:
> >>  			if (!(SCpnt->sense_buffer[0] & 0x90))
> >>  				break;
> >> -			error_sector = (SCpnt->sense_buffer[3] << 24) |
> >> -				(SCpnt->sense_buffer[4] << 16) |
> >> -				(SCpnt->sense_buffer[5] << 8) |
> >> -				SCpnt->sense_buffer[6];
> >> +			error_sector = get_unaligned_be32(SCpnt->sense_buffer + 3);
> >>  			if (SCpnt->request->bio != NULL)
> >>  				block_sectors =
> >>  					bio_sectors(SCpnt->request->bio);
> >> @@ -445,13 +443,9 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
> >>  		SCpnt->sdb.length = this_count * s_size;
> >>  	}
> >>  
> >> -	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
> >> -	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
> >> -	SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
> >> -	SCpnt->cmnd[5] = (unsigned char) block & 0xff;
> >> +	put_unaligned_be32(block, SCpnt->cmnd + 2);
> >>  	SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
> >> -	SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
> >> -	SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
> >> +	put_unaligned_be16(this_count, SCpnt->cmnd + 7);
> >>  
> >>  	/*
> >>  	 * We shouldn't disconnect in the middle of a sector, so with a dumb
> > 
> > Lets not please, it reduces readability a lot when you are used to SCSI
> > cdb filling.
> > 
> > 
> 
> I feel the opposite. That is: put_unaligned_be32(block, SCpnt->cmnd + 2);
> is much more readable for me. Coming from the spec, I'm looking for a __b32
> at offset CDB+2 and not: "SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;"
> At offset CDB+4 the 2nd-or-3rd? order byte of "block".
> 
> And for BE systems it's a gain. So please DO

Yeah.  For neophytes it's a good change.  This:

	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
	SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
	SCpnt->cmnd[5] = (unsigned char) block & 0xff;

is "wtf is that doing?", whereas this:

	put_unaligned_be32(block, SCpnt->cmnd + 2);

is "ah, I know what that's doing".
