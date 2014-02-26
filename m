From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Proposal for a scalable SCSI midlayer
Date: Wed, 26 Feb 2014 11:59:56 +0100
Message-ID: <530DC92C.5070603@acm.org>
References: <20140205123918.GA15907@infradead.org> <1393186218.9743.3.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:57563 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaBZK77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 05:59:59 -0500
In-Reply-To: <1393186218.9743.3.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On 02/23/14 21:10, James Bottomley wrote:
> Right ... my ideal here if we can achieve it would be lockless threaded
> models, where we could make guarantees like single thread of execution
> per command, so all command state could be lockless.

This approach sounds interesting but could be challenging to implement.
With this approach it would no longer be safe to access the SCSI command
state from interrupt nor from tasklet context. That means that the I/O
completion path would have to be modified such that instead of using an
IPI to invoke a tasklet at the CPU that submitted the SCSI command a new
mechanism would have to be used that causes the I/O completion code to
run directly on the context of the thread that submitted the SCSI command.

Bart.

