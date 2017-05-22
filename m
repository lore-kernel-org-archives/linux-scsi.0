From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
        queue pointer to blk_rq_init()
Date: Mon, 22 May 2017 09:54:43 +0200
Message-ID: <20170522075443.GC2081@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-7-bart.vanassche@sandisk.com> <20170521065003.GE12891@lst.de> <1495384897.3192.3.camel@sandisk.com> <1a2b631a-8b12-f167-b3b8-3a74bd179daa@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46735 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752975AbdEVHyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 03:54:45 -0400
Content-Disposition: inline
In-Reply-To: <1a2b631a-8b12-f167-b3b8-3a74bd179daa@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Mon, May 22, 2017 at 08:06:46AM +0200, Hannes Reinecke wrote:
> Problem is that quite some LLDDs require a hardware tag for sending
> TMFs, and currently the re-use the tag from the passed in scmd for that.
> So first we need to move those to a sane interface, and having them
> requesting a new tag for TMFs.

Some do indeed.  But these seems to be the exception and not the rule.

> Should be made easier with Christophs rework, but we still don't have
> any defined way how TMFs should request their tag; should they use
> private tags? Should they use 'normal' tags? Should the driver implement
> their own tag pool, seeing that these commands will never ever making
> use of the associated request?

I think the right way to go is that every driver that needs tags for
TMFs should use private tags internally without the core knowing
about it.

> Hence I'm looking into implementing a REQ_RESET block request operation,
> which then could be used to facilitate all of this (the request would be
> allocated from the private tag pool if present).

That seems to be overkill to me for the few drivers.  And I suspect
most of them would be better off now even using blk-mq private tags
(which we'd have to implement for the legacy path first or just
kill it off) but just not expose a tag per host to the scsi and block
layers and set that aside.

> It would also neatly solve the scsi_ioctl_reset() problem, as we then
> could just issue a REQ_RESET and would avoid having to call into the
> eh_* function directly.

I don't think calling the eh_* methods is a problem per see.  It's just
their stupid calling conventions..
