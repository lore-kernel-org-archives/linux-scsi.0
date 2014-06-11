From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Wed, 11 Jun 2014 06:37:36 -0700
Message-ID: <20140611133736.GA12240@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaFKNhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 09:37:38 -0400
Content-Disposition: inline
In-Reply-To: <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Mon, Jun 09, 2014 at 10:29:06AM -0700, James Bottomley wrote:
> I'll do it as a bug fix, but I do need Jens to make sure nothing else
> breaks first.  Best I can tell, the state model for compound commands
> like flush doesn't expect us to change the request type ... nothing puts
> it back to REQ_TYPE_FS.  In your case, the flush is the last command
> sent, so there's no problem ... I just worry we will get an obscure
> problem later on from something that does a BLOCK_PC prepared first
> command.

Yes, I don't think resetting cmd_type is a good idea.  I'd much rather
see a special case for rq->cmd_flags & REQ_FLUSH in the completion
handler - we already treat it special during setup anyway.
