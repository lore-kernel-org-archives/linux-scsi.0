From: Jens Axboe <axboe@fb.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 16:50:03 -0700
Message-ID: <b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
 <1485455329.2540.7.camel@sandisk.com>
 <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
 <1485456745.2540.9.camel@sandisk.com>
 <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com> <20170126185924.GA25289@lst.de>
 <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
 <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
 <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
 <1485464486.2540.12.camel@sandisk.com>
 <6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
 <1485467235.2540.14.camel@sandisk.com>
 <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
 <1485472465.2540.19.camel@sandisk.com>
 <e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
 <1485474426.2540.25.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49259 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752456AbdAZXuj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 18:50:39 -0500
In-Reply-To: <1485474426.2540.25.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On 01/26/2017 04:47 PM, Bart Van Assche wrote:
> On Thu, 2017-01-26 at 16:26 -0700, Jens Axboe wrote:
>> What device is stuck? Is it running with an mq scheduler attached, or
>> with "none"?
>>
>> Would also be great to see the output of /sys/block/*/mq/*/tags and
>> sched_tags so we can see if they have anything pending.
>>
>> From a quick look at the below, it looks like a request leak. Bisection
>> would most likely be very helpful.
> 
> Hello Jens,
> 
> This happens with and without scheduler attached. The most recent test I ran
> was with the deadline scheduler configured as default scheduler for all blk-mq
> devices (CONFIG_DEFAULT_SQ_IOSCHED="mq-deadline" and
> CONFIG_DEFAULT_MQ_IOSCHED="mq-deadline"). The block devices that hang are
> /dev/dm-0 and /dev/dm-1. The tags and sched_tags data is as follows:
> 
> # (cd /sys/class/block && grep -aH '' dm*/mq/*/tags)
> dm-0/mq/0/tags:nr_tags=2048, reserved_tags=0, bits_per_word=64
> dm-0/mq/0/tags:nr_free=1795, nr_reserved=0
> dm-0/mq/0/tags:active_queues=0
> dm-1/mq/0/tags:nr_tags=2048, reserved_tags=0, bits_per_word=64
> dm-1/mq/0/tags:nr_free=2047, nr_reserved=0
> dm-1/mq/0/tags:active_queues=0
> # (cd /sys/class/block && grep -aH '' dm*/mq/*/sched_tags)
> dm-0/mq/0/sched_tags:nr_tags=256, reserved_tags=0, bits_per_word=64
> dm-0/mq/0/sched_tags:nr_free=0, nr_reserved=0
> dm-0/mq/0/sched_tags:active_queues=0
> dm-1/mq/0/sched_tags:nr_tags=256, reserved_tags=0, bits_per_word=64
> dm-1/mq/0/sched_tags:nr_free=254, nr_reserved=0
> dm-1/mq/0/sched_tags:active_queues=0

Clearly we are missing some requests. How do I setup dm similarly to
you?

Does it reproduce without Christoph's patchset?

-- 
Jens Axboe

