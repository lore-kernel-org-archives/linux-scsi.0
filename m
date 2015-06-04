From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 0/2] target: Add TFO->complete_irq queue_work bypass
Date: Thu, 04 Jun 2015 00:06:09 -0700
Message-ID: <1433401569.18125.112.camel@haakon3.risingtidesystems.com>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>
	 <20150603125756.GA19696@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150603125756.GA19696@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-06-03 at 14:57 +0200, Christoph Hellwig wrote:
> This makes lockdep very unhappy, rightly so.  If you execute
> one end_io function inside another you bas=D1=96cally nest every poss=
ible
> lock taken in the I/O completion path.  Also adding more work
> to the hardirq path generally isn't a smart idea.  Can you explain
> what issues you were seeing and how much this helps?  Note that
> the workqueue usage in the target core so far is fairly basic, so
> there should some low hanging fruit.

So I've been using tcm_loop + RAMDISK backends for prototyping, but thi=
s
patch is intended for vhost-scsi so it can avoid the unnecessary
queue_work() context switch within target_complete_cmd() for all backen=
d
driver types.

This is because vhost_work_queue() is just updating vhost_dev->work_lis=
t
and immediately wake_up_process() into a different vhost_worker()
process context.  For heavy small block workloads into fast IBLOCK
backends, avoiding this extra context switch should be a nice efficienc=
y
win.

Also, AFAIK RDMA fabrics are allowed to do ib_post_send() response
callbacks directly from IRQ context as well.

Perhaps tcm_loop LLD code should just be limited to RAMDISK here..?
