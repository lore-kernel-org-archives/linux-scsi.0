From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Wed, 10 Dec 2008 01:03:33 +0100
Message-ID: <20081210000333.GC23556@one.firstfloor.org>
References: <20081209231005.17830.92133.stgit@fritz> <20081209231016.17830.87180.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYLIXwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 18:52:01 -0500
Content-Disposition: inline
In-Reply-To: <20081209231016.17830.87180.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, andi@firstfloor.org, jeffrey.t.kirsher@intel.com

On Tue, Dec 09, 2008 at 03:10:17PM -0800, Robert Love wrote:
> libFC is composed of 4 blocks supported by an exchange manager
> and a framing library. The upper 4 layers are fc_lport, fc_disc,
> fc_rport and fc_fcp. A LLD that uses libfc could choose to
> either use libfc's block, or using the transport template
> defined in libfc.h, override one or more blocks with its own
> implementation.

Just some more stuff I noticed while looking briefly at libfcoe.c
Not a complete review again.

 230 #ifdef CONFIG_SMP
 231         /*
 232          * The exchange ID are ANDed with num of online CPUs,
 233          * so that will have the least lock contention in
 234          * handling the exchange. if there is no thread
 235          * for a given idx then use first online cpu.
 236          */
 237         cpu_idx = oxid & (num_online_cpus() >> 1);
 238         if (fcoe_percpu[cpu_idx] == NULL)
 239                 cpu_idx = first_cpu(cpu_online_map);
 240 #endif

What is this supposed to do? It looks quite dubious.
Shouldn't this use the current CPU number?

include/scsi/libfc.h:   struct fcoe_dev_stats   *dev_stats[NR_CPUS];

NR_CPUS arrays are strongly discouraged because they lead to waste on
kernels compiled with large NR_CPUS, ideally use per CPU data or the 
per cpu allocator or at least a dynamic allocation with num_possible_cpus()
In general every use of NR_CPUS is dubious. e.g. you have some loops over that,
these should be all over possible cpus. fcoe_percpu[] should be also
per cpu data, not an array.

It would probably simplify the code a lot if you just went to global
per cpu counters instead of per cpu device counters. I don't know 
if that is feasible or not.

static int __init fcoe_init(void)

There are CPU hotplug races between the notifier and the for_each_online_cpu()
loop (probably not a serious problem, such races are common all over the 
code base, just wanted to mention it)

static int fcoe_device_notification(struct notifier_block *notifier,
                                    ulong event, void *ptr)

the link_status field seems to be only protected by the rtnl semaphore here
which is normally hold in this notifier chain. But if any other 
users in the fcoe stack change that too there might be races.
Also normally it's better to check "event" first before doing anything
expensive like walking lists. There are definitely more events you're
not handling, but right now you would slow them down.

fcoe_ethdrv_get/put

It's not quite clear to me why you go to the trouble to lock the underlying NIC module. 
Why would it be a problem if it goes away? Normally one would rather keep
a reference to the device, but even that might be not needed.

static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)

    get_page(page);
        skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
                           fps->crc_eof_offset, tlen);
        skb->len += tlen;
        skb->data_len += tlen;
        skb->truesize += tlen;
        fps->crc_eof_offset += sizeof(struct fcoe_crc_eof);

        if (fps->crc_eof_offset >= PAGE_SIZE) {
                fps->crc_eof_page = NULL;
                fps->crc_eof_offset = 0;
                put_page(page);
        }


Is the put_page() here really correct? The original reference in the skb
will be still around, won't it?

static void fcoe_insert_wait_queue(struct fc_lport *lp,
                                   struct sk_buff *skb)
{
        struct fcoe_softc *fc;

        fc = fcoe_softc(lp);
        spin_lock_bh(&fc->fcoe_pending_queue.lock);
        __skb_queue_tail(&fc->fcoe_pending_queue, skb);
        spin_unlock_bh(&fc->fcoe_pending_queue.lock);
}

That's just skb_queue_tail() (except that the lock is hardirq safe there, 
but that should be fine)

        /* adjust skb netowrk/transport offsets to match mac/fcoe/fc */
typo

> 
> The EM (Exchange Manager) manages exhcanges/sequences for all
> commands- ELS, CT and FCP.
> 
> The framing library frames ELS and CT commands.
> 
> The fc_lport block manages the library's representation of the
> host's FC enabled ports.
> 
> The fc_disc block manages discovery of targets as well as
> handling changes that occur in the FC fabric (via. RSCN events).
> 
> The fc_rport block manages the library's representation of other
> entities in the FC fabric. Currently the library uses this block
> for targets, its peer when in point-to-point mode and the
> directory server, but can be extended for other entities if
> needed.
> 
> The fc_fcp block interacts with the scsi-ml and handles all
> I/O.

A cheatsheet for all the acronyms would be nice.

-Andi

