From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Sat, 06 Sep 2014 10:40:06 -0400
Message-ID: <540B1CC6.8010800@interlog.com>
References: <5403AB47.3040706@interlog.com> <20140905052402.GA27094@infradead.org> <5409C116.5060702@interlog.com> <5409D5D0.8060801@acm.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48004 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaIFOkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 10:40:18 -0400
In-Reply-To: <5409D5D0.8060801@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>

On 14-09-05 11:25 AM, Bart Van Assche wrote:
> On 09/05/14 15:56, Douglas Gilbert wrote:
>> With scsi-mq I think many LLDs probably have a new
>> race possibility between a surprise rmmod of the LLD
>> and another thread presenting a new command at about
>> the same time (or another thread's command completing
>> around that time). Does anything above the LLD stop
>> this happening?
>>
>> Looking at mpt3sas and hpsa module exit calls, they don't
>> seem to guard against this possibility.
>>
>> The test is pretty easy: build the LLD as a module, load
>> it and fire up a multi-thread, libaio fio test on one or
>> more devices (SSDs would probably be good) on that LLD.
>> While the test is running, do 'rmmod LLD'.
>
> An LLD must call scsi_remove_host() directly or indirectly from the module
> cleanup path. scsi_remove_host() triggers a call to blk_cleanup_queue(). That
> last function sets the flag QUEUE_FLAG_DYING which prevents that new I/O is
> queued and waits until previously queued requests have finished before returning.

And they do call scsi_remove_host(). But they do that toward
the end of their clean-up. The problem that I observed has
already happened before that.

IOW I think the QUEUE_FLAG_DYING state needs to be set and
acknowledged as the first order of business by the code
that implements 'rmmod LLD'.

Doug Gilbert
