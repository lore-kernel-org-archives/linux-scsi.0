From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: EH action after scsi_remove_host, was: Re: [PATCH v2 12/12] IB/srp:
 Add multichannel support
Date: Mon, 20 Oct 2014 15:53:38 +0200
Message-ID: <544513E2.6050406@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <20141017110102.GC7819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:35837 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaJTNxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Oct 2014 09:53:43 -0400
In-Reply-To: <20141017110102.GC7819@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/17/14 13:01, Christoph Hellwig wrote:
> On Tue, Oct 07, 2014 at 03:07:17PM +0200, Bart Van Assche wrote:
>> +	/*
>> +	 * Avoid that the SCSI error handler tries to use this channel after
>> +	 * it has been freed. The SCSI error handler can namely continue
>> +	 * trying to perform recovery actions after scsi_remove_host()
>> +	 * returned.
>> +	 */
>> +	ch->target = NULL;
>
> Do you have a reproducer for that?  I think we should fix the root
> cause.

Hello Christoph,

The above assignment statement has been reported to fix a kernel oops 
that could be triggered by cable pulling. Regarding fixing the root 
cause: some time ago I had posted a patch series that makes 
scsi_remove_host() wait until all error handler callback functions have 
finished and also that prevents that any new error handler function 
calls are initiated after scsi_remove_host() has finished 
(http://thread.gmane.org/gmane.linux.scsi/82572/focus=87985). Should I 
repost that patch series ?

Bart.

