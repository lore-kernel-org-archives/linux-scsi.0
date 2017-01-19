From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 19 Jan 2017 12:03:59 +0100
Message-ID: <65d46eca-33f7-adb3-ed86-7c7feec84130@suse.de>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <CACVXFVP=mdetwMds9W-YL22ghW3ra4R9=RAnWrKdb6G-jjuqFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751943AbdASLED (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 06:04:03 -0500
In-Reply-To: <CACVXFVP=mdetwMds9W-YL22ghW3ra4R9=RAnWrKdb6G-jjuqFA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <Linux-scsi@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>

On 01/19/2017 11:57 AM, Ming Lei wrote:
> On Wed, Jan 11, 2017 at 11:07 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 01/11/2017 06:43 AM, Johannes Thumshirn wrote:
>>> Hi all,
>>>
>>> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
>>>
>>> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
>>> networking field and accoring to Sagi's findings in [1] performance with
>>> polling is not on par with IRQ usage.
>>>
>>> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
>>> more block drivers and how to overcome the currently seen performance issues.
>>
>> It would be an interesting topic to discuss, as it is a shame that blk-iopoll
>> isn't used more widely.
> 
> I remembered that Keith and I discussed some issues of blk-iopoll:
> 
>     http://marc.info/?l=linux-block&m=147576999016407&w=2
> 
> seems which isn't addressed yet.
> 
That's a different poll.

For some obscure reasons you have a blk-mq-poll function (via
q->mq_ops->poll) and an irqpoll function.
The former is for polling completion of individual block-layer tags, the
latter for polling completions from the hardware instead of relying on
interrupts.

We're discussing the latter here, so that thread isn't really applicable
here. However, there have been requests to discuss the former at LSF/MM,
too. So there might be a chance of restarting that discussion.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
