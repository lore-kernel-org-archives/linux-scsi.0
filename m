From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
 V2
Date: Thu, 26 Jan 2017 23:47:33 +0000
Message-ID: <1485474426.2540.25.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
	<e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
	<1485472465.2540.19.camel@sandisk.com>
	<e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
Content-Language: en-US
Content-ID: <C63DC9E8AD387E47A9E5259B8DCD9EA7@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-01-26 at 16:26 -0700, Jens Axboe wrote:
> What device is stuck? Is it running with an mq scheduler attached, or
> with "none"?
> 
> Would also be great to see the output of /sys/block/*/mq/*/tags and
> sched_tags so we can see if they have anything pending.
> 
> From a quick look at the below, it looks like a request leak. Bisection
> would most likely be very helpful.

Hello Jens,

This happens with and without scheduler attached. The most recent test I ran
was with the deadline scheduler configured as default scheduler for all blk-mq
devices (CONFIG_DEFAULT_SQ_IOSCHED="mq-deadline" and
CONFIG_DEFAULT_MQ_IOSCHED="mq-deadline"). The block devices that hang are
/dev/dm-0 and /dev/dm-1. The tags and sched_tags data is as follows:

# (cd /sys/class/block && grep -aH '' dm*/mq/*/tags)
dm-0/mq/0/tags:nr_tags=2048, reserved_tags=0, bits_per_word=64
dm-0/mq/0/tags:nr_free=1795, nr_reserved=0
dm-0/mq/0/tags:active_queues=0
dm-1/mq/0/tags:nr_tags=2048, reserved_tags=0, bits_per_word=64
dm-1/mq/0/tags:nr_free=2047, nr_reserved=0
dm-1/mq/0/tags:active_queues=0
# (cd /sys/class/block && grep -aH '' dm*/mq/*/sched_tags)
dm-0/mq/0/sched_tags:nr_tags=256, reserved_tags=0, bits_per_word=64
dm-0/mq/0/sched_tags:nr_free=0, nr_reserved=0
dm-0/mq/0/sched_tags:active_queues=0
dm-1/mq/0/sched_tags:nr_tags=256, reserved_tags=0, bits_per_word=64
dm-1/mq/0/sched_tags:nr_free=254, nr_reserved=0
dm-1/mq/0/sched_tags:active_queues=0

Bart.
