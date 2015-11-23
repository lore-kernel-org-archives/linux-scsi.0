From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Mon, 23 Nov 2015 08:18:13 -0800
Message-ID: <56533C45.4040505@sandisk.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
 <20151120104710.GA24871@lst.de> <564EFB65.6050603@suse.de>
 <564FA58A.8040006@sandisk.com> <56533A86.2090109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:64799
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841AbbKWQSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Nov 2015 11:18:18 -0500
In-Reply-To: <56533A86.2090109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>



On 11/23/2015 08:10 AM, Hannes Reinecke wrote:
> On 11/20/2015 11:58 PM, Bart Van Assche wrote:
>> On 11/20/2015 02:52 AM, Hannes Reinecke wrote:
>>> One thing, though: I don't really agree with Barts objection that
>>> moving to a workqueue would tie in too many resources.
>>> Thing is, I'm not convinces that using a work queue is allocating
>>> too many resources (we're speaking of 460 vs 240 bytes here).
>>> Also we have to retry commands for quite some time (cite the
>>> infamous NetApp takeover/giveback, which can take minutes).
>>> If we were to handle that without workqueue we'd have to initiate
>>> the retry from the end_io callback, causing a quite deep stack
>>> recursion. Which I'm not really fond of.
>>
>> Hello Hannes,
>>
>> Sorry if I wasn't clear enough in my previous e-mail about this
>> topic but I'm more concerned about the additional memory needed for
>> thread stacks and thread control data structures than about the
>> additional memory needed for the workqueue. I'd like to see the ALUA
>> device handler implementation scale to thousands of LUNs and target
>> port groups. In case all connections between an initiator and a
>> target port group fail, with a synchronous implementation of STPG we
>> will either need a large number of threads (in case of one thread
>> per STPG command) or the STPG commands will be serialized (if there
>> are fewer threads than portal groups). Neither alternative looks
>> attractive to me.
>>
>> BTW, not all storage arrays need STPG retries. Some arrays are able
>> to process an STPG command quickly (this means within a few seconds).
>>
>> A previous discussion about this topic is available e.g. at
>> http://thread.gmane.org/gmane.linux.scsi/105340/focus=105601.
>>
> Well, one could argue that the whole point of this patchset is to
> allow you to serialize STPGs :-)
>
> We definitely need to serialize STPGs for the same target port
> group; the current implementation is far too limited to take that
> into account.
>
> But the main problem I'm facing with the current implementation is
> that we cannot handle retries. An RTPG or an STPG might fail, at
> which point we need to re-run RTPG to figure out the current status.
> (We also need to send RTPGs when we receive an "ALUA state changed"
>   UA, but that's slightly beside the point).
> The retry cannot be send directly, as we're evaluating the status
> from end_io context. So to instantiate a retry we need to move it
> over to a workqueue.
>
> Or, at least, that's the solution I'm able to come up with.
> If you have other ideas it'd be most welcome.

Hello Hannes,

I agree that retries have to be handled from workqueue context instead 
of end_io context. But in workqueue context we can choose whether to 
submit the retry synchronously or asynchronously. Unless I overlooked 
something I don't see why the retry should be submitted synchronously.

Bart.
