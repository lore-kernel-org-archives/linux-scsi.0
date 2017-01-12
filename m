From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 12 Jan 2017 11:02:51 +0100
Message-ID: <20170112100251.GB3598@linux-x5ow.site>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdALKDw (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 05:03:52 -0500
Content-Disposition: inline
In-Reply-To: <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org, Linux-scsi@vger.kernel.org

On Thu, Jan 12, 2017 at 10:23:47AM +0200, Sagi Grimberg wrote:
> 
> >>>Hi all,
> >>>
> >>>I'd like to attend LSF/MM and would like to discuss polling for block drivers.
> >>>
> >>>Currently there is blk-iopoll but it is neither as widely used as NAPI in the
> >>>networking field and accoring to Sagi's findings in [1] performance with
> >>>polling is not on par with IRQ usage.
> >>>
> >>>On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
> >>>more block drivers and how to overcome the currently seen performance issues.
> >>
> >>It would be an interesting topic to discuss, as it is a shame that blk-iopoll
> >>isn't used more widely.
> >
> >Forgot to mention - it should only be a topic, if experimentation has
> >been done and results gathered to pin point what the issues are, so we
> >have something concrete to discus. I'm not at all interested in a hand
> >wavy discussion on the topic.
> >
> 
> Hey all,
> 
> Indeed I attempted to convert nvme to use irq-poll (let's use its
> new name) but experienced some unexplained performance degradations.
> 
> Keith reported a 700ns degradation for QD=1 with his Xpoint devices,
> this sort of degradation are acceptable I guess because we do schedule
> a soft-irq before consuming the completion, but I noticed ~10% IOPs
> degradation fr QD=32 which is not acceptable.
> 
> I agree with Jens that we'll need some analysis if we want the
> discussion to be affective, and I can spend some time this if I
> can find volunteers with high-end nvme devices (I only have access
> to client nvme devices.

I have a P3700 but somehow burned the FW. Let me see if I can bring it back to
live. 

I also have converted AHCI to the irq_poll interface and will run some tests.
I do also have some hpsa devices on which I could run tests once the driver is
adopted.

But can we come to a common testing methology not to compare apples with
oranges? Sagi do you still have the fio job file from your last tests laying
somewhere and if yes could you share it?

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
