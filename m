From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Mon, 08 Sep 2014 11:11:23 +0200
Message-ID: <540D72BB.2020100@acm.org>
References: <5403AB47.3040706@interlog.com> <20140905052402.GA27094@infradead.org> <5409C116.5060702@interlog.com> <5409D5D0.8060801@acm.org> <540B1CC6.8010800@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:54448 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaIHJLe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 05:11:34 -0400
In-Reply-To: <540B1CC6.8010800@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>

On 09/06/14 16:40, Douglas Gilbert wrote:
> On 14-09-05 11:25 AM, Bart Van Assche wrote:
>> An LLD must call scsi_remove_host() directly or indirectly from the
>> module
>> cleanup path. scsi_remove_host() triggers a call to
>> blk_cleanup_queue(). That
>> last function sets the flag QUEUE_FLAG_DYING which prevents that new
>> I/O is
>> queued and waits until previously queued requests have finished before
>> returning.
>
> And they do call scsi_remove_host(). But they do that toward
> the end of their clean-up. The problem that I observed has
> already happened before that.
>
> IOW I think the QUEUE_FLAG_DYING state needs to be set and
> acknowledged as the first order of business by the code
> that implements 'rmmod LLD'.

Hello Doug,

In the scsi_debug driver scsi_remove_host() is called from inside the 
sdebug_driver_remove() callback function. Unless I have missed something 
it is not guaranteed that that callback function is invoked before 
unloading of the scsi_debug driver has finished. I think most of the 
code in sdebug_driver_remove() should be moved to sdebug_remove_adapter().

Bart.

