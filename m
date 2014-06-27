From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Fri, 27 Jun 2014 00:55:53 -0700
Message-ID: <20140627075553.GB21799@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <20140626150208.GA14887@infradead.org>
 <1403808734.6440.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaF0Hzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 03:55:54 -0400
Content-Disposition: inline
In-Reply-To: <1403808734.6440.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org

On Thu, Jun 26, 2014 at 02:52:14PM -0400, James Bottomley wrote:
> > +	} else if (req->cmd_flags & REQ_FLUSH) {
> > +		/*
> > +		 * Flush request don't transfer data, so we can't try
> > +		 * to complete the good bytes first before checking
> > +		 * the error.
> > +		 */
> > +		if (result && !sense_deferred)
> > +			error = __scsi_error_from_host_byte(cmd, result);
> 
> Well, no, that's wrong.  To catch all of the corner cases that slip
> through here, the check is for a zero length command with and error
> otherwise we get the same problem for failed discards.

It's correct for the current code base where FLUSH is the only zero
length !BLOCK_PC case.  Your version is fine too, except for the
incorrect comment:

> +	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
> +		/*
> +		 * Certain non BLOCK_PC requests are commands that don't
> +		 * actually transfer anything (FLUSH, DISCARD), so cannot use
> +		 * good_bytes == 0 as the signal for an error.  This sets the
> +		 * error explicitly for the problem case
> +		 */

There aren't BLOCK_PC commands, otherwise they wouldn't end up here.

Note that REQ_DISCARD has been rewritten into either an WRITE_SAME or
UNMAP at this point, which always transfer data.

