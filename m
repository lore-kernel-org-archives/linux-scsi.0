From: "John Stoffel" <john@stoffel.org>
Subject: Re: [dm-devel] [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Thu, 1 Feb 2018 19:26:34 -0500
Message-ID: <23155.45114.317289.396546@quad.stoffel.home>
References: <20180129203300.50595-1-snitzer@redhat.com>
        <1517260932.2687.42.camel@wdc.com>
        <20180129214446.GD5744@redhat.com>
        <1517262713.2687.56.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.stoffel.org ([104.236.43.127]:40980 "EHLO mail.stoffel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751604AbeBBAek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Feb 2018 19:34:40 -0500
In-Reply-To: <1517262713.2687.56.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <Bart.VanAssche@wdc.com> writes:

Bart> On Mon, 2018-01-29 at 16:44 -0500, Mike Snitzer wrote:
>> But regardless of which wins the race, the queue will have been run.
>> Which is all we care about right?

Bart> Running the queue is not sufficient. With this patch applied it can happen
Bart> that the block driver returns BLK_STS_DEV_RESOURCE, that the two or more
Bart> concurrent queue runs finish before sufficient device resources are available
Bart> to execute the request and that blk_mq_delay_run_hw_queue() does not get
Bart> called at all. If no other activity triggers a queue run, e.g. request
Bart> completion, this will result in a queue stall.

Doesn't this argue that you really want some sort of completions to be
run in this case instead?  Instead of busy looping or waiting for a
set amount of time, just fire off a callback to run once you have the
resources available, no?

I can't provide any code examples, I don't know the code base nearly
well enough.

John
