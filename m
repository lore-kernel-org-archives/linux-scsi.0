From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v1 0/2] genirq: support multiple IRQ notifier.
Date: Fri, 25 Mar 2016 21:49:51 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1603252149120.3978@nanos>
References: <cover.1458920770.git.weongyo.linux@gmail.com> <20160325193243.GA30485@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160325193243.GA30485@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Weongyo Jeong <weongyo.linux@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 25 Mar 2016, Christoph Hellwig wrote:
> On Fri, Mar 25, 2016 at 08:51:51AM -0700, Weongyo Jeong wrote:
> > Each irq_desc only supports one IRQ affinity notifier at current
> > implementation so when we try to register another notifier, it silently
> > unregister previous entry and register new one.
> > 
> > However the problem is that if CONFIG_RFS_ACCEL is set, at current
> > implementation no way to set additional IRQ affinity notifier for
> > some NIC cards RFS enabled because it already used for RFS.
> > With this patch we can register multiple IRQ affinity notifiers.
> 
> The whole concept of these irq affinity notifiers seems wrong to me.
> 
> If a device supports MSI-X it should simply request per-cpu or per-node
> vectors and we should prevent affinity changes for them.

You beat me to it. I'm having a half baken prototype to implement this at the
core level. Will post next week.

Thanks,

	tglx
