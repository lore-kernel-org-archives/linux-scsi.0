From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 26 Jun 2014 10:02:47 -0400
Message-ID: <1403791367.3572.1.camel@dabdike>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
	 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
	 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
	 <20140611133736.GA12240@infradead.org>
	 <1403201159.17294.13.camel@dabdike.int.hansenpartnership.com>
	 <20140625131344.GA13094@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49701 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbaFZOCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 10:02:50 -0400
In-Reply-To: <20140625131344.GA13094@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>


On Wed, 2014-06-25 at 06:13 -0700, Christoph Hellwig wrote:
> On Thu, Jun 19, 2014 at 11:05:59AM -0700, James Bottomley wrote:
> > That's not really a good idea either ... I did think of it.  We'll end
> > up with a cmd_type of REQ_TYPE_FS which because of REQ_FLUSH (or REQ_FUA
> > or REQ_DISCARD or any number of other things) we have to treat as though
> > it were REQ_TYPE_BLOCK_PC.  It's much better to tune handling
> > expectations according to req->cmd_type because that's what we already
> > do.  These commands are actually set up by our handlers, so it's up to
> > us to mark the request type correctly.
> 
> Looking at the places where the SCSI midlayer cares about the request
> type:
> 
>  - scsi_finish_command to call ->done for non-PC requests.  Given that
>    we called into the driver to setup flush/discard/etc we should also
>    call into the driver on request completion
>  - scsi_eh_action: ditto for error handling
>  - scsi_noretry_cmd: I don't see why we'd want to treat flush request
> 	as having an implicit failfast flag
>  - scsi_io_completion: this mostly opts out of all kinds of error
> 	handling and retries, not really what we'd want either
>  - scsi_unprep_fn: calls ->uninit_command only for !PC request,
>    	so your patch introduces a leak for discard requests

Yes, but think what you're proposing.  Every block command with a
special setup goes via scsi_setup_blk_pc_cmnd() because they usually
have to translate to something special.  If we did what you propose,
every time we add one, we'd have to modify these five places in the code
plus the setup ... it's a bit insane plus a maintenance nightmare.

Since block gave us the command to set up as we please, we're entitled
to change the fields including cmd_type.

James


