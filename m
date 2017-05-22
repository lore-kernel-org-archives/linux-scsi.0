From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
 queue pointer to blk_rq_init()
Date: Mon, 22 May 2017 10:46:10 +0200
Message-ID: <78097a2b-73c6-3206-803a-c108fe464c45@suse.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
 <20170519183016.12646-7-bart.vanassche@sandisk.com>
 <20170521065003.GE12891@lst.de> <1495384897.3192.3.camel@sandisk.com>
 <1a2b631a-8b12-f167-b3b8-3a74bd179daa@suse.com>
 <20170522075443.GC2081@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:55664 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757497AbdEVIqN (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 22 May 2017 04:46:13 -0400
In-Reply-To: <20170522075443.GC2081@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 05/22/2017 09:54 AM, hch@lst.de wrote:
> On Mon, May 22, 2017 at 08:06:46AM +0200, Hannes Reinecke wrote:
>> Problem is that quite some LLDDs require a hardware tag for sending
>> TMFs, and currently the re-use the tag from the passed in scmd for that.
>> So first we need to move those to a sane interface, and having them
>> requesting a new tag for TMFs.
> 
> Some do indeed.  But these seems to be the exception and not the rule.
> 
Still need to be handled, though ...

>> Should be made easier with Christophs rework, but we still don't have
>> any defined way how TMFs should request their tag; should they use
>> private tags? Should they use 'normal' tags? Should the driver implement
>> their own tag pool, seeing that these commands will never ever making
>> use of the associated request?
> 
> I think the right way to go is that every driver that needs tags for
> TMFs should use private tags internally without the core knowing
> about it.
> 
That was my idea, too.

>> Hence I'm looking into implementing a REQ_RESET block request operation,
>> which then could be used to facilitate all of this (the request would be
>> allocated from the private tag pool if present).
> 
> That seems to be overkill to me for the few drivers.  And I suspect
> most of them would be better off now even using blk-mq private tags
> (which we'd have to implement for the legacy path first or just
> kill it off) but just not expose a tag per host to the scsi and block
> layers and set that aside.
> 
IE not using blk-mq private tags for EH? Hmm.
But then we'd need a SCSI-internal mechanism to get one of them. I
really would want to avoid having each driver to implement it's own
mechanism on how to get a TMF tag; that sort of thing only leads to
copy-and-paste errors.
Ok; will be looking into it.

>> It would also neatly solve the scsi_ioctl_reset() problem, as we then
>> could just issue a REQ_RESET and would avoid having to call into the
>> eh_* function directly.
> 
> I don't think calling the eh_* methods is a problem per see.  It's just
> their stupid calling conventions..
> 
I know. I've been working on a patchset to move at least eh_host_reset()
to take the scsi_host as argument. But even that requires some
preliminary patches to some LLDDs :-(

Right. Dusting off those patches, then.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
