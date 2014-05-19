From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Mon, 19 May 2014 08:25:30 -0700
Message-ID: <20140519152530.GA15433@infradead.org>
References: <537A105B.4080504@redhat.com>
 <537A1E88.9080803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaESPZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 11:25:33 -0400
Content-Disposition: inline
In-Reply-To: <537A1E88.9080803@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>

On Mon, May 19, 2014 at 05:08:56PM +0200, Bart Van Assche wrote:
> On 05/19/14 16:08, Paolo Bonzini wrote:
> > 2) reentrancy: the softirq handler and scmd_eh_abort_handler can run
> > concurrently, and call scsi_finish_command without any lock protecting
> > the calls.  You can then get memory corruption.
> 
> I'm not sure what the recommended approach is to address this race. But
> it is possible to address this in the LLD. See e.g. the srp_claim_req()
> function in the SRP LLD and how it is invoked from the reply handler,
> the abort handler and the reset handlers in that LLD.

blk-mq triest to solve this a test_and_set_bit for a completion flag
at the block layer for completions vs timeouts.  I think doing this in
the SCSI layer as well would be very useful as we can't expect Joe
Random Driver Developer to get it right in every driver.
