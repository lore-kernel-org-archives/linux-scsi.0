From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST
 sense to be retryable
Date: Fri, 2 Dec 2011 17:04:38 -0500
Message-ID: <20111202220438.GA13463@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
 <1322859891.6920.111.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab1LBWEp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2011 17:04:45 -0500
Content-Disposition: inline
In-Reply-To: <1322859891.6920.111.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Fri, Dec 02 2011 at  4:04pm -0500,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2011-12-02 at 15:31 -0500, Mike Snitzer wrote:
> > Thin provisioned LUNs from multiple array vendors have failed WRITE SAME
> > (16) w/ UNMAP bit set with ILLEGAL_REQUEST sense.  With additional sense
> > 0x24 and 0x26 respectively.
> > 
> > In both instances the target would always fail the CDB no matter how
> > many retries were performed (permanent target failure rather than
> > transient path failure).  This resulted in mkfs.ext4's discard of a
> > multipath device looping indefinitely while failing paths.
> 
> I don't quite understand this analysis.  ILLEGAL_REQUEST currently
> always returns SUCCESS from scsi_check_sense().  That return is
> propagated up to scsi_decide_disposition() which causes I/O completion.
> We do have another gate for ILLEGAL_REQUEST in scsi_io_completion()
> which can retry, but only if it's downshifting the command from _10 to
> _6 ... so I don't get where you think the looping is coming from ... the
> net effect of your patch is to change the error passed on to the block
> layer in blk_end_request() from -EIO to -EREMOTEIO.  So it sounds like
> if there is a retry problem it's above SCSI?

Exactly, the looping is in dm-multipath.  Because scsi_check_sense() is
returning SUCCESS for these ILLEGAL_REQUEST, multipath is retrying the
discard after failing the path that the request just failed on.
Previously failed paths are recovered in time for the next retry of the
discard that will _always_ fail... and so the cycle goes (and mkfs.ext4
appears hung).

commit 63583cca745f440 ([SCSI] Add detailed SCSI I/O errors) enabled
mpath to immediately return target errors (-EREMOTEIO) without retry
after path failure -- so the change to scsi_check_sense() is selectively
returning TARGET_ERROR for ILLEGAL REQUEST; which will result in
-EREMOTEIO.
