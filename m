From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Crash on WRITE SAME
Date: Wed, 2 Jul 2014 14:29:05 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407021423240.20183@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com> <20140702181333.GA15792@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140702181333.GA15792@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 2 Jul 2014, Christoph Hellwig wrote:

> On Wed, Jul 02, 2014 at 02:05:14PM -0400, Mikulas Patocka wrote:
> > Hi Sagi
> > 
> > Your commit d77e65350f2d82dfa0557707d505711f5a43c8fd causes crash on SCSI 
> > WRITE SAME command (it can be triggered by issuing the BLKZEROOUT ioctl). 
> > The crash happens in iscsi_tcp_segment_done because sg_next returns NULL.
> 
> Martin already fixes this over a week ago, we're just waiting for James
> to send a pull request to Linus.
> 
> Get this fix from the core-for-3.16 branch of
> git.infradead.org/users/hch/scsi-queue.git for now.

I see.

And what about protection information for commands that transfer partial 
sectors? (for example, UMAP transfers 24 bytes). Should 
scsi_transfer_length return 24 or 32 in this case?

Mikulas
