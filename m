From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] cxlflash: Base support for IBM CXL Flash Adapter
Date: Thu, 21 May 2015 23:16:16 -0500
Message-ID: <F4935A08-97EC-49D7-B8EB-48E746D84DDB@linux.vnet.ibm.com>
References: <1431724232-29321-1-git-send-email-mrochs@linux.vnet.ibm.com> <1432101117.20823.32.camel@neuling.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:40373 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbEVEQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 00:16:19 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 21 May 2015 22:16:19 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id D240C19D8041
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 22:07:18 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4M4GGWa39125226
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 21:16:16 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4M4GEml000689
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 22:16:15 -0600
In-Reply-To: <1432101117.20823.32.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Mikey,

Thanks for reviewing this patch. Responses are inline below.


-matt

On May 20, 2015, at 12:51 AM, Michael Neuling wrote:

> Does this driver work when compiled big endian?

We haven't tested on big endian but agree that the code should support both little
and big endian.

>> 
>> +#define CXLFLASH_MAX_CMDS               16
>> +#define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS
>> +
>> +#define NOT_POW2(_x) ((_x) & ((_x) & ((_x) - 1)))
> 
> include/linux/log2 has is_power_of_2()
> 

This is used for compile-time enforcement. The items in the log2 header are runtime
functions. Will add a comment for clarity.

>> +#if NOT_POW2(CXLFLASH_NUM_CMDS)
>> +#error "CXLFLASH_NUM_CMDS is not a power of 2!"
>> +#endif
>> +
>> +#define CMD_BUFSIZE     PAGE_SIZE_4K
> 
> Does this mean we can't compile with 64K pages?  How is this related to PAGES?
> 

No, 64K pages are fully supported. We are simply borrowing the 4K page #define as
the size of the AFU's command buffer is 4096 bytes. Will add a comment for clarity.

>> +#define CONFN(_s) "%s: "_s"\n"
>> +#define cxlflash_err(_s,   ...)	pr_err(CONFN(_s),   __func__, ##__VA_ARGS__)
>> +#define cxlflash_warn(_s,  ...)	pr_warn(CONFN(_s),  __func__, ##__VA_ARGS__)
>> +#define cxlflash_info(_s,  ...)	pr_info(CONFN(_s),  __func__, ##__VA_ARGS__)
>> +#define cxlflash_dbg(_s, ...)	pr_debug(CONFN(_s), __func__, ##__VA_ARGS__)
> 
> Please don't redefine these.  Just makes it less readable for others.
> 

Okay.

>> +#define cxlflash_dev_dbg(_d, _s, ...)	\
>> +	dev_dbg(_d, CONFN(_s), __func__, ##__VA_ARGS__)
>> +
> 
> Same here...

Okay.

>> 
>> +	u32 padding;
>> +	struct cxl_context *ctx;
>> +	struct list_head luns;	/* LUNs attached to this context */
>> +};
> 
> Might be nice to pack these to ensure there is no holes.  I'm not sure that's
> the case currently.

We'll look into this.

> 
>> +
>> +struct cxlflash {
> 
> I really don't like this name.  What does this struct actually represent?  Is
> it just some table, info, queue?  Calling it just "cxlflash" doesn't give the
> reader any idea what it is.  Plus it makes it really hard to search for since
> "cxlflash" is being used a lot in this driver for other stuff and you often do
>  struct cxlflash *cxlflash;
> 
> If you used something like
>  struct cxlflash_desc {....};
>  struct cxlflash_desc *desc;
> I could search for desc and find all the uses.
> 

Sounds reasonable. This is our per-device handle. How about the name
struct cxlflash_cfg and we locally call the variable 'cfg'?

>> 
>> +
>> +	struct pci_pool *cxlflash_cmd_pool;
>> +	struct pci_dev *parent_dev;
>> +
>> +	int num_user_contexts;
> 
> You init this to 0 but never use it.
> 
>> +	struct ctx_info *ctx_info[MAX_CONTEXT];
>> +	struct file_operations cxl_fops;
> 
> This is unused in this patch.
> 

These are used in other areas of the driver not included in this patch. Will look
at not including them in the next patch with updates based on feedback.

>> +	char *buf;		/* per command buffer */
>> +	struct afu *back;
> 
> Can we call this parent, rather than back?
> 

Sure.

>> +	int slot;
>> +	atomic_t free;
> 
> Looks like you're just doing ref counting with this so it should probably be a
> struct kref.
> 

We'll leave this as an atomic for now to support our round-robin allocation.

>> +	u8 special:1;
>> +	u8 internal:1;
>> +	u8 sync:1;
>> +
>> +} __aligned(cache_line_size());
> 
> Why is this cacheline aigned?

The IOASA and IOARCB sit at the top of this structure. We keep this aligned on
a cacheline so that these two sit in the same cacheline for better performance.

>> +	/* Housekeeping data */
>> +	struct mutex afu_mutex;	/* for anything that needs serialization
> 
> This is never used
> 
>> +				   e. g. to access afu */
>> +	struct mutex err_mutex;	/* for signalling error thread */
> 
> This is never used
> 

Will remove these with other unused fields.

>> +
>> +	struct cxlflash *back;	/* Pointer back to parent cxlflash */
> 
> Can we just call this parent?

Sure.

> 
>> +
>> +} __aligned(PAGE_SIZE_4K);
> 
> Why 4K aligned?  What has this got to do with page size?

We have removed this.

>> +	while (dec--) {
>> +		k = (afu->cmd_couts++ & (CXLFLASH_NUM_CMDS - 1));
>> +
>> +		cmd = &afu->cmd[k];
>> +
>> +		if (!atomic_dec_if_positive(&cmd->free)) {
> 
> I guess this is ok with only 32 commands but it's a linear search.  I would be
> nice to use a standard allocator here instead.  I think you could use ida for
> this and remove the need for cmd->free.  Probably not a bit issue though.

We're going to continue to use this simple round-robin search. The command pool
is larger than the hardware queue depth and therefore we should rarely hit a case
where we're looping more than a time or two here to find a free command.

>> +
>> +	spin_lock_irqsave(&cmd->slock, lock_flags);
>> +	cmd->sa.host_use_b[0] |= B_DONE;
>> +	spin_unlock_irqrestore(&cmd->slock, lock_flags);
> 
> Who else are you locking against here?  Just yourself?  In other places you
> just stick 0 here.  What happens if you race with that?
> 
> If you're just racing with yourself, does that mean this code can be called
> simultaneously?  If so, is the rest of this code save?  cmd->rcb.scp doesn't
> seem to be locked below.
> 

We have removed this locking. It was left over from when we used to have
other writer threads and more bits.

>> 
>> +
>> +	while (cxlflash->tmf_active)
>> +		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
> 
> This doesn't look right.  Why not just wait_event()?  
> 
> Same in other places.
> 

Fixed.

>> +
>> +	cxlflash_info("returning rc=%d", rc);
> 
> info print?

We'll change to a debug.

>> +			if (afu->cmd[i].timer.function)
>> +				del_timer_sync(&afu->cmd[i].timer);
> 
> Is this doing more that freeing memory (as the name of the function suggests)?

This has been removed. The routine only frees memory now.

>> 
>> +	if (!afu) {
>> +		cxlflash_info("returning because afu is NULl");
> 
> typo for "NULl"
> 

Fixed.

> Also, info print?  What is an sysadmin going to do with this info? This seems
> like a bug?
> 

Changed to debug.

> Also, this doesn't return an error code.  Can we propagate these error up?
> 

No error to propagate up. The early out supports calling in a partially setup state.

>> +	case UNDO_START:
>> +		cxl_stop_context(cxlflash->mcctx);
> 
> Please check the return code here.
> 
> 
>> +	case UNMAP_THREE:
>> +		cxlflash_dbg("before unmap 3");
>> +		cxl_unmap_afu_irq(cxlflash->mcctx, 3, afu);
>> +	case UNMAP_TWO:
>> +		cxlflash_dbg("before unmap 2");
>> +		cxl_unmap_afu_irq(cxlflash->mcctx, 2, afu);
>> +	case UNMAP_ONE:
>> +		cxlflash_dbg("before unmap 1");
>> +		cxl_unmap_afu_irq(cxlflash->mcctx, 1, afu);
>> +	case FREE_IRQ:
>> +		cxlflash_dbg("before cxl_free_afu_irqs");
>> +		cxl_free_afu_irqs(cxlflash->mcctx);
>> +		cxlflash_dbg("before cxl_release_context");
>> +	case RELEASE_CONTEXT:
>> +		cxl_release_context(cxlflash->mcctx);
> 
> Please check the return code here.
> 

We're now checking these return codes.

>> 
>> +	cxlflash->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
>> +						 get_order(sizeof(struct afu)));
> 
> Any reason not to use kmalloc here?  How big is struct afu?

The AFU is roughly 12K. We allocate on a page to satisfy alignment requirements
for substructures located at the top of the AFU. We have added a comment to
clarify the size and use.

>> +	struct afu *afu = (struct afu *)data;
>> +	struct afu_cmd *cmd;
>> +	u32 toggle = afu->toggle;
> 
> We seem to be doing a read modify write on this toggle.  Do we need to worry
> about locking it?  Can we come into thie interrupt twice at the same time for
> the same AFU?
> 
> Can this toggle just be a bool?

We've made the toggle a bool. Will look into if we need to lock the RRQ.

>> +
>> +out:
>> +	cxlflash_info("returning rc=%d, afu=%p", IRQ_HANDLED, afu);
> 
> _info print in an interupt handler?  Should this be removed to made _dbg?

Changed to debug.

>> 
>> +	if (unlikely(ro_start < 0)) {
>> +		cxlflash_err("VPD Read-only not found");
> 
> 
> 		cxlflash_err("VPD Read-only data not found");

Fixed.

>> +	if (unlikely((i + j) > vpd_size)) {
>> +		cxlflash_warn("Might need to read more VPD (%d > %ld)",
>> +			      (i + j), vpd_size);
> 
> This seems like an odd error message.

Clarified and made debug.

>> +			    ("Unable to convert port 0 WWPN to integer");
> 
>  Should this be "port %i", k?

Good catch, fixed.

>> 
>> +	if (afu->room == 0) {
>> +		do {
>> +			afu->room = readq_be(&afu->host_map->cmd_room);
>> +			udelay(nretry);
> 
> We retry the same number of times that we udelay().  That seems odd?  We
> waiting a little bit longer each time?

Correct, the idea here is to try at all costs to get the reset queued up. We delay a bit
longer on each retry in hopes that there will be some movement and a spot freed up.

>> 
>> +		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
> 
> Should this be have cpu_to_be16()? (along with everything else that touches
> sisl_ioarcb?)  sisl_ioarcb is shared in memory with the hardware AFU, right?

The AFU is bi-endian (except where noted). We'll likely leave these as host endian and
flip the AFU's endian control bit depending on the host endianness.

>> +
>> +	/* AFU configuration */
>> +	reg = readq_be(&afu->afu_map->global.regs.afu_config);
>> +	reg |= 0x7F20;		/* enable all auto retry options and LE */
> 
> LE??  Little Endian?
> 
> This needs to support BE also or you need to fail at compile/config time.

Correct, LE is for little endian. We added defines for these bits for clarity and
will set the endian control bit depending on what we're compiling against.

>> 
>> +
>> +	ctx = cxl_dev_context_init(cxlflash->dev);
>> +	if (!ctx)
>> +		return -ENOMEM;
> 
> You can pull a default context for this pci device using cxl_get_context() now.
> if you do this, you don't want to release it later though.  This was a recent
> update to the cxl kernel API

Noted. We'll look into this.

>> +	/* Allocate AFU generated interrupt handler */
> 
> These one line comments aren't needed.  It's obvious from the functions called.

Sure, we can pull these out (the ditto's too).

>> +
>> +	/* make memory updates visible to AFU before MMIO */
>> +	smp_wmb();
> 
> If this is for an MMIO, then you need wmb().  from powerpc barrier.h
> ---
> * For the smp_ barriers, ordering is for cacheable memory operations
> * only. We have to use the sync instruction for smp_mb(), since lwsync
> * doesn't order loads with respect to previous stores.  Lwsync can be
> * used for smp_rmb() and smp_wmb().
> ---
> 

This will be removed as it's not required here.

>> +
>> +	spin_lock_irqsave(&cmd->slock, lock_flags);
>> +	while (!(cmd->sa.host_use_b[0] & B_DONE)) {
> 
> I don't understand why you need this locking.  You are only reading it.  In
> other places you read it and don't lock.

This locking has been removed as it's unnecessary.

>> 
>> +
>> +	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
> 
> Again, are these endian safe?

Should be based on how we set the AFU endian control bit.

>> 
>> +	phys_dev = cxl_get_phys_dev(pdev);
>> +	if (!dev_is_pci(phys_dev)) {	/* make sure it's pci */
> 
> Drop this comment, it's obvious what it's doing.
> 

Okay.

>> +		cxlflash_err("not a pci dev");
>> +		rc = ENODEV;
>> +		goto out_remove;
>> +	}
>> +	cxlflash->parent_dev = to_pci_dev(phys_dev);
> 
> Is there much use in saving this?  You only use it in one place.

We're going to continue to save this off for now in case we need it in other places
in the future (ie: EEH).

> 
>> +
>> +	cxlflash->cxl_afu = cxl_pci_to_afu(pdev, NULL);
> 
> cxl_pci_to_afu() has changed now in my upstream post.  You don't need the
> second parameter anymore.

Got it.

>> +/*
>> + * IOARCB: 64 bytes, min 16 byte alignment required, host native endianness
>> + * except for SCSI CDB which remains big endian per SCSI standards.
> 
> Why not define these are be16/32/64, then?
> 
> sisl_ioarcb is shared in memory with the hardware AFU, right?  Souldn't
> everything that touches them be wrapped in cpu_to_be* and visa versa?

The AFU is bi-endian and therefore we can leave this as host endian defined.

>> +
>> +	union {
>> +		u64 host_use[4];
>> +		u8 host_use_b[32];
> 
> You only seem to use 0 and 1 of these 32.

This is defined by the SISlite spec. Added a comment for clarity.

>> +				 */
>> +	u8 nmask;
>> +} __aligned(16);
> 
> Why aligned?

The SISlite spec states that the RHT entries must be 16-byte aligned. We have
added a comment to clarify this.

