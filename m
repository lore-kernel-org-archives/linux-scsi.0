From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Fri, 10 Jan 2003 14:23:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1F1DAC.6060207@splentec.com>
References: <200301101706.h0AH6rr03943@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> I got around to looking at the patch.
> 
> I think the idea of slab allocation for Scsi_Cmnds is generally worth the 
> effort.  There are several issues with the current patch, though:
> 
> 1) The command for the device has to be allocated in space that respects the 
> dma_mask for the device (on a non MMIO bus).  Pretty much for scsi, this 
> translates to using GFP_DMA as the allocation flag if unchecked_isa_dma is 
> set.  GFP_DMA has to be passed in at kmem_cache_create time.  We therefore 
> probably need the capacity to use a different kmem_cache on a per Scsi_Host 
> basis and the ability to set up a GFP_DMA kmem_cache if a host with 
> unchecked_isa_dma appears.

Some of our machines have 128 SCSI hosts.

I think that the slab cache can acknowledge a GFP_DMA flag even after
creation of the slab, but not 100% sure on this. I.e. in scsi_get_command()
a check of host->unchecked_isa_dma can be performed and the kmem_flags
OR-ed with GFP_DMA.

We can also have 2 slabs -- one for DMA capable hosts (current) and
another for non-DMA capable hosts.

Actually, I had this in the 2.5.52 version of this patch but decided that
the LLDD code will run as normal kernel code and that the actual PCI HOST
will never have to access the struct scsi_cmnd directly over the PCI bus;
but will only need to access the sg list. For this reason I decided to leave
it out. I.e. struct scsi_cmnd will alway be accessed in normal operation
of the kernel, and thus no need for GFP_DMA.
(I'd so much rather it be that way, so much... :-)

I've no problem changing the slab alloc. just let's decide if we
want a slab per host (kind of inefficient) or 2 slabs (DMA, and non-DMA)
or OR-ing the mask upon scsi_get_command().

> 2) scsi_get_command takes the host lock when obtaining a command from it's 
> free_list.  Unfortunately, scsi_get_command looks to be called from places 
> (like the prep_fn) where the lock is already held => deadlock.

Absolutely correct.

In this case I'll create a new spinlock which will be specifically for use
with the slab allocation. In fact, my preferred choice -- ``a lock for an object''.

In my version of mini-scsi-core I do not use spinlocks when accessing the slab
cache, but instead set the flag to GFP_ATOMIC or GFP_KERNEL as need be.
I can easily imagine a deadlock when we access it when our own spinlock
is obtained but the flag is GFP_KERNEL.

But the spinlock will be needed only to acess the backup store of command
structs (list), so I've no problem creating a scsi_cache_lock. Consider it done.

> 3) The free_list employs all the list machinery for potentially storing 
> multiple commands, but in practice it looks like it only ever stores one of 
> them.  Is there a plan to make this free_list size tuneable (probably tuneable 
> per device)?

Yes -- this was my intention (0:N commands in the backup store), and this was my
plan to make this tuneable in the (far) future.

Though I left it at one command when setting up the host, since I couldn't
assume much.

The problem is that the number of backup stored commands depends on quite a few
factors, and that will be one hell of a heuristic. So I'd imagine
it has to do with the available memory and the throughput (both in and out) of
commands between SCSI Core and LLDD. I.e. that number will be dynamically changing.
For this reason I left it at one.

-- 
Luben


