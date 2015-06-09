From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 0/2] target: Add TFO->complete_irq queue_work bypass
Date: Tue, 9 Jun 2015 09:19:21 +0200
Message-ID: <20150609071921.GA10590@lst.de>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com> <20150603125756.GA19696@lst.de> <1433401569.18125.112.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433401569.18125.112.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 04, 2015 at 12:06:09AM -0700, Nicholas A. Bellinger wrote:
> So I've been using tcm_loop + RAMDISK backends for prototyping, but this
> patch is intended for vhost-scsi so it can avoid the unnecessary
> queue_work() context switch within target_complete_cmd() for all backend
> driver types.
> 
> This is because vhost_work_queue() is just updating vhost_dev->work_list
> and immediately wake_up_process() into a different vhost_worker()
> process context.  For heavy small block workloads into fast IBLOCK
> backends, avoiding this extra context switch should be a nice efficiency
> win.

How about trying to merge the two workers instead?

> Perhaps tcm_loop LLD code should just be limited to RAMDISK here..?

I'd prefer to not do it especially for the loopback code, as that
should serve as a simple example.  But before making further judgement
I'd really like to see the numbers.

Note that something that might help much more is getting rid of
the remaining irq or bh disabling spinlocks in the target core,
as that tends to introduce a lot of additional latency.  Moving
additional code to hardirq context is fairly diametrical to that
design.
