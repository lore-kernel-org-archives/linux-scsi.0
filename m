From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Mon, 05 Jan 2015 12:00:58 -0700
Message-ID: <54AADF6A.6090100@kernel.dk>
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150105091516.GA22226@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sasha Levin <sasha.levin@oracle.com>
Cc: bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/05/2015 02:15 AM, Christoph Hellwig wrote:
> On Wed, Dec 31, 2014 at 01:14:19PM -0500, Sasha Levin wrote:
>> Hi Christoph,
>>
>> I'm seeing an issue which was bisected down to 3c356bde1 ("scsi: stop passing
>> a gfp_mask argument down the command setup path"):
> 
> ->queue_rq in blk-mq context is designed to be able to sleep and be called
> from process context without any spinlocks held or irqs disabled, so we
> really should fix the
> caller instead.

That's not quite true, the only guarantee is that it WILL execute on the
CPU (or CPUs) that are set in the mask. So unless it ends up offloading
the run to a specific workqueue, we'll disable preempt in the current
path before ->queue_rq() is called.

-- 
Jens Axboe
