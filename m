From: scameron@beardog.cce.hp.com
Subject: Re: [RFC] hpsa: work in progress "lockless monster" patches
Date: Thu, 31 Jul 2014 10:16:00 -0500
Message-ID: <20140731151600.GA14599@beardog.cce.hp.com>
References: <20140725192859.GU14599@beardog.cce.hp.com> <53D9077D.8000406@redhat.com> <53D95686.6040403@hp.com> <53DA4AFD.7030105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58664 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaGaPRQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 11:17:16 -0400
Content-Disposition: inline
In-Reply-To: <53DA4AFD.7030105@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, jbottomley@parallels.com, martin.petersen@oracle.com, hare@suse.de, hch@infradead.org, bvanassche@acm.org, axboe@kernel.dk, elliott@hp.com, scott.teel@hp.com, joseph.t.handzik@hp.com, justin.lindley@hp.com, scameron@beardog.cce.hp.comscameron@beardog.cce.hp.com

On Thu, Jul 31, 2014 at 03:56:13PM +0200, Tomas Henzl wrote:
> Hi Steve, Webb,
> 
> let me start with the part most important for me - from my previous mail
> "And please have a look at "[PATCH] hpsa: refine the pci enble/disable handling"
> I posted in June and add it to your series or review in the list. Thanks."

Ok.  I will try to get to this.  
(some customer issues have been eating a lot of my time this week).

When I first saw that patch I knew that Rob Elliott had a lot of patches in the
works that did a lot of cleanup to the initialization code, so I expect some
conflicts.

> 
> other comments see below
> 
> > Hi Tomas,
> >
> > Thanks for taking a look and for the feedback.  I'm actually the one 
> > responsible for the changes you refer to, so I'll try to address your 
> > comments.
> >
> >
> > On 7/30/14 10:55 AM, Tomas Henzl wrote:
> >> I'm not sure if I got it right,
> >> it seems it uses the same cmd_pool for both alloc function,
> >> from (0 - reserved_cmds) it's cmd_alloc and above that it's handled
> >> by cmd_tagged_alloc.
> >> The logic in both functions seems to be valid for me.
> > Good.  With Christoph's proposed changes, the block layer will select a 
> > tag for I/O requests, and it provides for the driver to reserve part of 
> > the tag space for its own use.  Thus, HPSA uses a common pool for both 
> > I/O requests and internally-driven requests (IOCTLs, aborts, etc.), and 
> > we index the pool using the tag.  The code is this way mostly to 
> > minimize change from the previous version, but it's also handy in terms 
> > of managing the pool (i.e., there is a single pool to administer, 
> > instead of two, and all the items are initialized the same way, etc.).  
> > The portion of the pool which is reserved to the driver (the 
> > low-numbered tags) continues to be managed through a bitmap, just as it 
> > was prior to this change; the bitmap does cover the whole pool (which is 
> > a historical artifact), but the higher bits are never set, since 
> > allocation of those entries is determined by the tag from the block 
> > layer -- nevertheless, it is convenient to have the map extend over the 
> > whole pool in certain corner cases (such as resets).
> >
> >
> >> In cmd_tagged_alloc "Thus, there should never be a collision here between
> >> two requests" if this is true you don't need the refcount and just a simple
> >> flag were sufficient for your other needs. (And maybe you get to ~971k IOPS..)
> > :-)  The code previously had the reference count in there to close 
> > certain race conditions' asynchronous accesses to the command block 
> > (e.g., between an abort and a completing command).  We hope that, using 
> > the block layer tags, those races no longer occur, but there didn't seem 
> > to be any point in removing the reference count until we'd had more 
> > experience with the code...and, in a fit of healthy paranoia I added the 
> > check to which you refer.  Unfortunately, in some of Rob Elliott's 
> > recent tests, he managed to drive a case where the check triggers.  So, 
> > until we reconcile that, I'm inclined to leave the check in place 
> > (hopefully it's not costing a full 1k IOPS :-) ).
> 
> Let us assume that the block layer never sends duplicate tags to the driver,
> I think there are some weaknesses in the way how it's implemented,
> for example here - from fail_all_outstanding_cmds:
>                 refcount = atomic_inc_return(&c->refcount);
>                 if (refcount > 1) {
>                 ...
>                         finish_cmd(c); - this finishes the command
> 			and the tag might be now reused,
> 			when that happens you'll see a race
>                         atomic_dec(&h->commands_outstanding);
>                         failcount++;
>                 }
>                 else {what happens when right now comes a call from block layer?}                
>                 cmd_free(h, c);
>                 
> When references are used it usually means, that when refcount==0 that
> a release function frees the resources, in this case it is the tag number.
> In your implementation you should ensure that when you signal
> to the upper layer that the tag is free, that nothing else holds the reference.
> If this is true the conclusion is that you don't need this kind of references
> and a simple flag just to debug not yet fixed races is enough.

Part of the motivation is we want to have this code be workable for distros
that may not have the necessary kernel changes for us to be able to use the
block layer tagging (e.g. tags reserved for driver use).  So I am floating
the block layer tag patches, keeping them at the top of my stack of patches
so that all this lockless stuff can still work even without using the block
layer tags.  So one reason the reference counting needs to go in is to
accomodate backporting the LLD without touching an older kernel's mid layer
or block layer code, which is important to me for distros, because I can
easily change out the LLD as a module, but scsi mid layer or block layer of
a distro cannot be touched.  I expect, eg. RHEL6u5 will never have such block
layer changes present in the install media, yet a lockless version of the driver 
will need to work with that install media.  Now maybe on linux-scsi, we care
not for distros but I do try to care about the foreseeable maintenance pain I
inflict (or avoid inflicting) upon myself and upon the distro maintainers. So
I would like not to depend on block or scsi mid layer changes if at all
possible.

That being said, iirc, we do see the block layer tags getting reused for
aborts without having been freed by the LLD, and we can have the abort code
racing completion code using the same tag twice concurrently.  So it is not
clear to me whether the reference counting can really come out even after
switching to using block layer tags.  That is an area we're still working on
and is part of what I meant by, "Be warned though, there are still some
problems, esp.  around error recovery."

-- steve


> I'm maybe wrong because I don't understand what you want to protect
> in the above example, so that makes me to have some doubts if I understand 
> the code properly.
> 
> >> cmd_alloc some minor changes are possible
> >> - try to find free entries only to reserved_cmds
> >>    (the bitmap might be shorter too)
> > Excellent catch!  I'll make that change.  (As I said, we currently rely 
> > on the over-sized bit map, but there is no reason for this code to 
> > search the whole thing...although, with the block layer doing the heavy 
> > lifting, this allocation path is lightly used, and it will be rare that 
> > it runs off the end of the reserved range.)
> >
> >
> >> - next thread should start + 1 from the last result
> > That's a fair point, but the suggestion is somewhat more complicated 
> > than it seems:  if "start + 1" is greater than reserved_cmds, then we 
> > want to start at zero, instead.  I think it ends up being more code than 
> > it's worth.
> >
> > In fact, with the partitioned pool, the reserved-to-driver section is 
> > now so small that it's probably not worth the effort to try to resume 
> > the search where the last search left off -- we might as well start at 
> > zero each time.  (Thanks for bringing that up!  ;-) )
> >
> >
> >> - when nr_cmds is read from hw it should be tested (nr_cmds > reserved_cmds)
> > That's a fair point.
> >
> >
> >> - what is the correct pronunciation of benignhly?
> > You would have to ask in certain parts of Boston or perhaps out on the 
> > South Fork of Long Island.  :-D  (I thought I fixed those typos -- I'm 
> > _sure_ I did! -- and yet....)
> >
> >
> >> @@ -5634,7 +5634,8 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
> >>   
> >>   	offset = h->last_allocation; /* benighly racy */
> >>   	for (;;) {
> >> -		i = find_next_zero_bit(h->cmd_pool_bits, h->nr_cmds, offset);
> >> +		offset %=  h->reserved_cmds;
> >> +		i = find_next_zero_bit(h->cmd_pool_bits, h->reserved_cmds, offset);
> > Aside from changing the limit from nr_cmds to reserved_cmds, I don't 
> > think this change is helpful, because it inserts a modulo operation on 
> > every iteration, which is probably unnecessary.  (It would be better to 
> > ensure that offset is a reasonable value to begin with, and, even it is 
> > not, the call to find_next_zero_bit() will handle it properly and then 
> > the code will retry.)
> >
> >> @@ -5642,15 +5643,16 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
> >>   		c = h->cmd_pool + i;
> >>   		refcount = atomic_inc_return(&c->refcount);
> >>   		if (unlikely(refcount > 1)) {
> >> -			cmd_free(h, c); /* already in use */
> >> -			offset = (i + 1) % h->nr_cmds;
> >> +			atomic_dec(&c->refcount); /* already in use, since we
> >> +			 don't own the command just decrease the refcount */
> >> +			offset = i + 1;
> >>   			continue;
> >>   		}
> > The call to cmd_free() is necessary, since the original owner of the 
> > command might have tried to free it in the brief window while this code 
> > held its reference, and so the command might actually need to be freed 
> > at this point.
> Yes, you are right, I've read the code before not long enough.
> > And, moving the modulo from this rare path to the 
> > common, possibly repeated path above is not an improvement.
> I moved the the modulo operator because of the 'i + 1;' on the next
> line.
> In general I agree with you that when given this is not a critical path,
> all the optimisations are only potential a source of problems, so starting
> every loop from 0 is fine.
> >
> >> -	h->last_allocation = i; /* benignly racy */
> >> +	h->last_allocation = i + 1; /* benignly racy */
> > While this would be nice, I don't think it's worth the added 
> > complication, especially since I'm inclined to remove the 
> > "last_allocation" optimization altogether.
> >
> >> @@ -5670,6 +5672,7 @@ static void cmd_free(struct ctlr_info *h, struct CommandList *c)
> >>   		clear_bit(i & (BITS_PER_LONG - 1),
> >>   			  h->cmd_pool_bits + (i / BITS_PER_LONG));
> >>   	}
> >> +	else ; /*BUG ? or just atomic_dec and no if */
> > If the decrement causes the reference count to reach zero, then we need 
> > to mark the command as free in the bitmask.  If the result of the 
> > decrement is not zero, then there is no further work to do, here.  (So, 
> > yes, the conditional is required, and, no, there's no bug here that I 
> > see -- what would you consider doing in the else clause?)
> The same as before you are right .
> Thanks,
> Tomas
> >
> >
> >              Thanks,
> >
> >                  Webb
> >
> >
> >
> >> On 07/25/2014 09:28 PM, scameron@beardog.cce.hp.com wrote:
> >>> hpsa: Work In Progress: "lockless monster" patches
> >>>
> >>> To be clear, I am not suggesting that these patches be merged at this time.
> >>>
> >>> This patchset is vs. Christoph Hellwig's scsi-mq.4 branch which
> >>> may be found here: git://git.infradead.org/users/hch/scsi.git
> >>>
> >>> We've been working for a long time on a patchset for hpsa to remove
> >>> all the locks from the main i/o path in pursuit of high IOPS.  Some
> >>> of that work is already upstream, but a lot more of it is not quite
> >>> yet ready to be merged.  However, I think we've "gone dark" for a bit
> >>> too long on this, and even though the patches aren't really ready to
> >>> be merged just yet, I thought I should let other people who might be
> >>> interested have a look anyway, as things are starting to be at least
> >>> more stable than unstable.  Be warned though, there are still some
> >>> problems, esp. around error recovery.
> >>>
> >>> That being said, with the right hardware (fast SAS SSDs, recent Smart
> >>> Arrays e.g. P430, with up-to-date firmware, attached to recent disk enclosures)
> >>> with these patches and the scsi-mq patches, it is possible to get around
> >>> ~970k IOPS from a single logical drive on a single controller.
> >>>
> >>> There are about 150 patches in this set.  Rather than bomb the list
> >>> with that, here is a link to a tarball of the patches in the form of
> >>> an stgit patch series:
> >>> https://github.com/smcameron/hpsa-lockless-patches-work-in-progress/blob/master/hpsa-lockless-vs-hch-scsi-mq.4-2014-07-25-1415CDT.tar.bz2?raw=true
> >>>
> >>> In some cases, I have probably erred on the side of having too many too
> >>> small patches, on the theory that it is easier to bake a cake than to
> >>> unbake a cake.  Before these are submitted "for reals", there will be
> >>> some squashing of patches, along with other cleaning up.
> >>>
> >>> There are some patches in this set which are already upstream in
> >>> James's tree which do not happen to be in Christoph's tree
> >>> (most of which are named "*_sent_to_james").  There are also
> >>> quite a few patches which are strictly for debugging and are not
> >>> ever intended to be merged.
> >>>
> >>>
> >>> Here is a list of all the patches sorted by author:
> >>>
> >>> Arnd Bergmann (1):
> >>>    [SCSI] hpsa: fix non-x86 builds
> >>>
> >>> Christoph Hellwig (1):
> >>>    reserve block tags in scsi host
> >>>
> >>> Joe Handzik (9):
> >>>    hpsa: add masked physical devices into h->dev[] array
> >>>    hpsa: add hpsa_bmic_id_physical_device function
> >>>    hpsa: get queue depth for physical devices
> >>>    hpsa: use ioaccel2 path to submit IOs to physical drives in HBA mode.
> >>>    hpsa: Get queue depth from identify physical bmic for physical disks.
> >>>    hpsa: add ioaccel sg chaining for the ioaccel2 path
> >>>    Set the phys_disk value for a CommandList structure that is
> >>>      submitted. Squash
> >>>    hpsa: unmap ioaccel2 commands before, not after adding to resubmit
> >>>      workqueue
> >>>    hpsa: add more ioaccel2 error handling, including underrun statuses.
> >>>
> >>> Nicholas Bellinger (1):
> >>>    hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
> >>>
> >>> Robert Elliott (44):
> >>>    Change scsi.c scsi_log_completion() to print strings for QUEUED,
> >>>    Set scsi_logging_level to be more verbose to get better messages
> >>>    hpsa: do not unconditionally copy sense data
> >>>    hpsa: optimize cmd_alloc function by remembering last allocation
> >>>    From a154642aeed291c7cfe4b9ea9da932156030f7d1 Mon Sep 17 00:00:00
> >>>      2001
> >>>    hpsa: Clean up host, channel, target, lun prints
> >>>    hpsa: do not check cmd_alloc return value - it cannnot return NULL
> >>>    hpsa: return -1 rather than -ENOMEM in hpsa_get_raid_map if fill_cmd
> >>>      fails
> >>>    hpsa: return -ENOMEM not 1 from ioaccel2_alloc_cmds_and_bft on
> >>>      allocation failure
> >>>    hpsa: return -ENOMEM not 1 from hpsa_alloc_ioaccel_cmd_and_bft on
> >>>      allocation failure
> >>>    hpsa: return -ENOMEM not -EFAULT from hpsa_passthru_ioctl on kmalloc
> >>>      failure
> >>>    hpsa: pass error from pci_set_consistent_dma_mask intact from
> >>>      hpsa_message
> >>>    hpsa: detect and report failures changing controller transport modes
> >>>    hpsa: add hpsa_disable_interrupt_mode
> >>>    hpsa: rename free_irqs to hpsa_free_irqs and move before
> >>>      hpsa_request_irq
> >>>    hpsa: rename hpsa_request_irq to hpsa_request_irqs
> >>>    hpsa: on failure of request_irq, free the irqs that we did get
> >>>    hpsa: make hpsa_pci_init disable interrupts and pci_disable_device on
> >>>      critical failures
> >>>    hpsa: fix a string constant broken into two lines
> >>>    hpsa: avoid unneccesary calls to resource freeing functions in
> >>>      hpsa_init_one
> >>>    hpsa: add hpsa_free_cfgtables function to undo what
> >>>      hpsa_find_cfgtables does
> >>>    hpsa: report failure to ioremap config table
> >>>    hpsa: add hpsa_free_pci_init function
> >>>    hpsa: clean up error handling in hpsa_pci_init
> >>>    hpsa: make hpsa_remove_one use hpsa_pci_free_init
> >>>    hpsa: rename hpsa_alloc_ioaccel_cmd_and_bft to
> >>>      hpsa_alloc_ioaccel1_cmd_and_bft
> >>>    hpsa: rename hpsa_allocate_cmd_pool to hpsa_alloc_cmd_pool
> >>>    hpsa: rename ioaccel2_alloc_cmds_and_bft to
> >>>      hpsa_alloc_ioaccel2_cmd_and_bft
> >>>    hpsa: fix memory leak in hpsa_alloc_cmd_pool
> >>>    hpsa: return status not void from hpsa_put_ctlr_into_performant_mode
> >>>    hpsa: clean up error handling in hpsa_init_one
> >>>    hpsa: report allocation failures while allocating SG chain blocks
> >>>    hpsa: rename hpsa_allocate_sg_chain_blocks to
> >>>      hpsa_alloc_sg_chain_blocks
> >>>    hpsa: improve allocation failure messages from hpsa_init_one
> >>>    hpsa: fix minor if-statement style issue in hpsa_init_one
> >>>    hpsa: fix wrong indent level in hpsa_init_one
> >>>    Add hpsa_free_performant_mode and call it from hpsa_init_one
> >>>    hpsa: shorten the wait for the CISS doorbell mode change
> >>>      acknowledgement
> >>>    hpsa: clean up some error reporting output in abort handler
> >>>    hpsa: try to detect controller lockup in abort handler
> >>>    hpsa: Return DID_NO_CONNECT rather than DID_ERR on lockup
> >>>    hpsa: check for lockup on all simple_cmd submissions
> >>>    hpsa: Support 64-bit lun values in printks
> >>>    hpsa: do not print ioaccel2 warning messages about unusual
> >>>      completions.
> >>>
> >>> Stephen M. Cameron (95):
> >>>    scsi: break from queue depth adjusting loops when device found
> >>>    hpsa: remove online devices from offline device list
> >>>    hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
> >>>    hpsa: make hpsa_init_one return -ENOMEM if allocation of
> >>>      h->lockup_detected fails
> >>>    hpsa: fix 6-byte READ/WRITE with 0 length data xfer
> >>>    hpsa: remove spin lock around command allocation
> >>>    hpsa: use atomics for commands_outstanding instead of spin locks
> >>>    hpsa: reserve some commands for use by driver
> >>>    hpsa: get rid of cmd_special_alloc and cmd_special_free
> >>>    hpsa: do not queue commands internally in driver
> >>>    hpsa: remove unused interrupt handler code
> >>>    hpsa: remove direct lookup bit from command tags
> >>>    hpsa: fix race between abort handler and main i/o path
> >>>    hpsa: allow lockup detector to be turned off
> >>>    hpsa: do not request device rescan on every ioaccel path error
> >>>    hpsa: factor out hpsa_ciss_submit function
> >>>    hpsa: use workqueue to resubmit failed ioaccel commands
> >>>    hpsa: use driver instead of system work queue for command
> >>>      resubmission
> >>>    hpsa: remove 'action required' phrasing
> >>>    hpsa: Count passthru cmds with atomics, not a spin locked int
> >>>    hpsa: remove unused fifo_full function
> >>>    hpsa: slightly optimize SA5_performant_completed
> >>>    hpsa: do not check for msi(x) in interrupt_pending
> >>>    hpsa: fix fail_all_outstanding_cmds to use reference counting
> >>>    hpsa: fix endianness issue with scatter gather elements
> >>>    hpsa: get rid of type/attribute/direction bit field where possible
> >>>    hpsa: do not use function pointers in fast path command submission
> >>>    hpsa: do not wait for aborted commands to complete after abort
> >>>    hpsa: fix hpsa_drain_accel_commands to use reference counting instead
> >>>      of bitmap
> >>>    hpsa: fix race when updating raid map data.
> >>>    hpsa: allow commands to be completed on specified reply queue
> >>>    hpsa: fix completion race in abort handler
> >>>    hpsa: fix aborting of reused commands
> >>>    hpsa: lay groundwork for handling driver initiated command timeouts
> >>>    hpsa: do not free command twice in hpsa_get_raid_map
> >>>    hpsa: do not send aborts to logical devices that do not support
> >>>      aborts
> >>>    hpsa: remember whether devices support aborts across rescans
> >>>    hpsa: do not send two aborts with swizzled tags.
> >>>    hpsa: decrement h->commands_outstanding in fail_all_outstanding_cmds
> >>>    hpsa: flush work queue hpsa_wq in fail_all_outstanding_cmds
> >>>    hpsa: use per controller not per driver work queue for command
> >>>      resubmission
> >>>    hpsa: fix allocation sizes for CISS_REPORT_LUNs commands
> >>>    hpsa: always use extended report physical LUNs for physical devices
> >>>    hpsa: prevent manually adding masked physical devices
> >>>    hpsa: fix values for expose status
> >>>    hpsa: avoid unnecessary io in hpsa_get_pdisk_of_ioaccel2()
> >>>    hpsa: do not be so noisy about check conditions
> >>>    hpsa: handle descriptor format sense data where needed
> >>>    hpsa: print CDBs instead of kernel virtual addresses for uncommon
> >>>      errors
> >>>    hpsa: handle Command Status TMF function status
> >>>    hpsa: do not use a void pointer for scsi_cmd field of struct
> >>>      CommandList
> >>>    hpsa: return FAILED from abort handler if controller locked up.
> >>>    hpsa: if controller locked up return failed from device reset handler
> >>>    hpsa: check for ctlr lockup after command allocation in main io path
> >>>    hpsa: mark masked devices as masked in output
> >>>    hpsa: limit number of concurrent abort requests
> >>>    hpsa: separate lockup detection and device rescanning
> >>>    hpsa: factor out hpsa_init_cmd function
> >>>    hpsa: reinitialize commands on resubmitting failed ioaccel commands
> >>>    hpsa: fully initialize commands once at driver load not every time
> >>>    hpsa: change driver version to 3.4.6
> >>>    hpsa: allow lockup detected to be viewed via sysfs
> >>>    hpsa: do not ignore return value of hpsa_register_scsi
> >>>    hpsa: DEBUG ONLY - allow triggering command resubmitting via sysfs
> >>>    hpsa: try resubmitting down raid path on task set full
> >>>    hpsa: factor out hpsa_ioaccel_submit function
> >>>    hpsa: try resubmitting down ioaccelerated path on task set full
> >>>    hpsa: honor queue depth of physical devices
> >>>    hpsa: use cancel_delayed_work_sync where needed
> >>>    hpsa: clean up queue depth getting code
> >>>    hpsa: try to fix ioaccel command accounting code
> >>>    hpsa: fix hpsa_figure_phys_disk_ptrs to handle layout_map_count other
> >>>      than 1
> >>>    hpsa: close race in ioaccel_cmds_out accounting
> >>>    hpsa: guard against overflowing raid map array
> >>>    hpsa: test ioaccel_cmds_out vs. queue depth earlier to avoid wasting
> >>>      time
> >>>    hpsa: DEBUG ONLY - fix missing atomic-dec of ioaccel_cmds_out in
> >>>      debug command resubmission code
> >>>    hpsa: fix missing atomic_dec of dev->ioaccel_cmds_out
> >>>    hpsa: do not ack controller events on controllers that do not support
> >>>      it
> >>>    hpsa: fix code that updates h->dev[]->phys_disk[]
> >>>    hpsa: remove bug-on that triggers in hba mode by mistake
> >>>    hpsa: remove unused temp64 variable from hpsa_cmd_init
> >>>    hpsa bump driver version again
> >>>    hpsa break hpsa_free_irqs_and_disable_msix into two functions
> >>>    separate hpsa_free_cmd_pool into three separate function
> >>>    hpsa: fix missing return in hpsa_command_resubmit_worker
> >>>    hpsa: fix command leaks in hpsa_resubmit_command_worker
> >>>    hpsa: fix bad interpretations of hpsa_ioaccel_submit return value
> >>>    hpsa: do not touch phys_disk[] for ioaccel enabled logical drives
> >>>      during rescan
> >>>    hpsa: add change_queue_type function
> >>>    hpsa: make hpsa_change_queue_depth handle reason SCSI_QDEPTH_QFULL
> >>>    hpsa: initialize queue depth of logical drives reasonably
> >>>    hpsa: attempt to fix queue depth calculations for logical drives
> >>>    hpsa: add support sending aborts to physical devices via the ioaccel2
> >>>      path
> >>>    hpsa: fix problem with abort support checking happening too early
> >>>    hpsa: remove incorrect bug on in hpsa_scsi_ioaccel_raid_map
> >>>
> >>> Webb Scales (3):
> >>>    Initialize reference counts to zero on initial command entry
> >>>      allocation
> >>>    hpsa: make hpsa_send_reset_as_abort_ioaccel2() use the specified
> >>>      reply queue.
> >>>    hpsa:  use block layer tag for command allocation
> >>>
> >>>   drivers/scsi/hpsa.c       | 3642 ++++++++++++++++++++++++++++-----------------
> >>>   drivers/scsi/hpsa.h       |  103 +-
> >>>   drivers/scsi/hpsa_cmd.h   |  222 +++-
> >>>   drivers/scsi/scsi.c       |   64 +-
> >>>   drivers/scsi/scsi_error.c |    2 +
> >>>   drivers/scsi/scsi_lib.c   |    1 +
> >>>   include/scsi/scsi_host.h  |    9 +
> >>>   7 files changed, 2561 insertions(+), 1482 deletions(-)
> >>>
> >>> -- steve
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
