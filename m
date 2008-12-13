From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Sat, 13 Dec 2008 05:14:46 -0800
Message-ID: <1229174086.4153.1003.camel@haakon2.linux-iscsi.org>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>
	 <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
	 <1229171597.4153.981.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130450y3288b32av7f435544823d9e97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:27428 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754680AbYLMNOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 08:14:48 -0500
In-Reply-To: <e2e108260812130450y3288b32av7f435544823d9e97@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2008-12-13 at 13:50 +0100, Bart Van Assche wrote:
> On Sat, Dec 13, 2008 at 1:33 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > The point is that neither you nor Vlad would acknowledge any of the
> > issues on that thread.
> 
> What that thread started with is whether or not higher-order
> allocations would help the performance of a storage target. I replied
> that the final argument in any discussion about performance are
> performance measurements. You failed to publish any performance
> numbers in that thread, which is why I stopped replying.
> 

This was just one of the items that I mentioned that is implemented in
Target_Core_Mod/ConfigFS v3.0 that is lacking in SCST Core.  The list
(which has not changed) is the following:

<SNIP>
        The fudemental limitiation I ran into wrt SCST core has to do with
        memory allocation (or rather, lack there of).  The problem is that for
        the upstream generic kernel target, the requirements are the following:
        
        A single codepath memory allocating *AND* mapping for:
        
        I) Every type of device_type
        II) Every combination of max_sectors and sector_size with per PAGE_SIZE
        segments and multiple contigious PAGE_SIZE memory segments
        III) Every combination of I and II while receiving a CDB with
        sector_count > $STORAGE_OBJECT->max_sectors
        IV) Allocating multiple contigious struct page from the memory allocator
        for I, II, III.
        
        So, if we are talking about these first two, both target_core_mod and
        SCST core have them (at least I think SCST has #2 with PAGE_SIZE memory
        segments).  I know that target_core_mod has #3 (because I explictly
        designed it this way), and you have some patch for SCST to do this,
        great!.  However, your algortims currently assume PAGE_SIZE by default,
        which is a problem for not just II, III, and IV above.  :-(
        
        V) Accept pre-registered memory segments being passed into
        target_core_mod that are then mapped (NOT MEMCPY!!) to struct
        scatterlist->page_link handling all cases (I, II, III, and IV) for
        zero-copy DMA with multiple contigious PAGE_SIZE memory segments (Very
        fast!!) using a *SINGLE* codepath down to every Linux Storage Subsystem
        past, present and future.  This is the target_core_mod design that has
        existed since 2006.

</SNIP>

So, you are talking about IV) above, which is just one of the items.  As
mentioned,the big item for me is V), which means you are going to have
to do some fundemental changes to SCST core to make this work.  As
previously mentioned, these five design requirements have been part of
LIO-Target v2.x and Target_Core_Mod/ConfigFS v3.0 from the start.

> > Lets not even get into how you claimed RDMA
> > meant only userspace ops on virtual memory addresses using a vendor
> > specific API, or that RDMA using virtual addresses would be
> > communicating with drivers/scsi or block/ (which obviously use
> struct
> > page).
> 
> I never claimed that RDMA is only possible from user space -- that was
> a misinterpretation of your side.
> 
> I never referred to any vendor specific RDMA API.
> 
> But I agree that the following paragraph I cited from Intel's VIA
> architecture document may be misleading:
> 
> The VI provider is directly responsible for a number of functions nor-
> mally supplied by the operating system. The VI provider manages the
> pro-
> tected sharing of the network controller, virtual to physical
> translation of
> buffer addresses, and the synchronization of completed work via
> interrupts.
> The VI provider also provides a reliable transport service, with the
> level of re-
> liability depending upon the capabilities of the underlying network.
> 
> I guess the above paragraph means that RDMA hardware must have
> scatter/gather support.

I have no idea why you keep mentioning Intel's VIA in the context of
RDMA and generic target mode.  This API has *NOTHING* to do with a
target mode engine using generic algorithms for zero-copy struct page
mapping from RDMA capable hardware into Linux/SCSI, Linux/BLOCK or
Linux/VFS subsystems.

--nab


> 
> Bart.
> 

