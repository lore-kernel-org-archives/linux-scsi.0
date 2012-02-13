From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST
 sense to be retryable
Date: Mon, 13 Feb 2012 14:36:15 -0500
Message-ID: <20120213193615.GA10349@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
 <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
 <20111206212704.GB30719@redhat.com>
 <yq1vcptpdch.fsf@sermon.lab.mkp.net>
 <20111206224218.GA31543@redhat.com>
 <20120213162923.GA29578@redhat.com>
 <yq1d39iipra.fsf@sermon.lab.mkp.net>
 <20120213181359.GA5803@redhat.com>
 <yq14nuuilxd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq14nuuilxd.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 13 2012 at  2:16pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> I don't have a fundamental problem with your patch. But since we
> >> explicitly handle ILLEGAL REQUEST with 0x20 and 0x24 in sd.c I wonder
> >> what's broken? We should disable discard support if the WRITE SAME w/
> >> UNMAP fails.
> 
> Mike> Yeah, I thought the disabling would be sufficient too.  But
> Mike> unfortunately multipath doesn't inspect the request it is retrying
> Mike> (after it fails the path the request just failed on).
> 
> Well, we shouldn't be returning something that multipath should ever act
> on.
> 
> I think I understand what's going on. Can you try the following patch?

Looks good to me (small nit below), it'll solve the immediate problem,
I'll pass it on.  Please add my:

Acked-by: Mike Snitzer <snitzer@redhat.com>

But I also think establishing a baseline of TARGET_ERROR for certain
ILLEGAL REQUEST is still sane and should go in too...

Thanks,
Mike

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b2c95db..4e8d0b6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -879,6 +879,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  				    cmd->cmnd[0] == WRITE_SAME_16 ||
>  				    cmd->cmnd[0] == WRITE_SAME)) {
>  				description = "Discard failure";
> +				error = -EREMOTEIO;
>  				action = ACTION_FAIL;

Previous DIX -EILSEQ code block sets error after action.  Should follow
that order here?  Purely an aesthetics thing.
