From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_error: do not allow IO errors with certain
 ILLEGAL_REQUEST sense to be retryable
Date: Fri, 02 Dec 2011 15:04:51 -0600
Message-ID: <1322859891.6920.111.camel@dabdike>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46745 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584Ab1LBVFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 16:05:07 -0500
In-Reply-To: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Fri, 2011-12-02 at 15:31 -0500, Mike Snitzer wrote:
> Thin provisioned LUNs from multiple array vendors have failed WRITE SAME
> (16) w/ UNMAP bit set with ILLEGAL_REQUEST sense.  With additional sense
> 0x24 and 0x26 respectively.
> 
> In both instances the target would always fail the CDB no matter how
> many retries were performed (permanent target failure rather than
> transient path failure).  This resulted in mkfs.ext4's discard of a
> multipath device looping indefinitely while failing paths.

I don't quite understand this analysis.  ILLEGAL_REQUEST currently
always returns SUCCESS from scsi_check_sense().  That return is
propagated up to scsi_decide_disposition() which causes I/O completion.
We do have another gate for ILLEGAL_REQUEST in scsi_io_completion()
which can retry, but only if it's downshifting the command from _10 to
_6 ... so I don't get where you think the looping is coming from ... the
net effect of your patch is to change the error passed on to the block
layer in blk_end_request() from -EIO to -EREMOTEIO.  So it sounds like
if there is a retry problem it's above SCSI?

James


