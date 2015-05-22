From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 1/1] cxlflash: Base support for IBM CXL Flash Adapter
Date: Fri, 22 May 2015 14:34:28 +1000
Message-ID: <1432269268.29160.22.camel@neuling.org>
References: <1431724232-29321-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1432101117.20823.32.camel@neuling.org>
	 <F4935A08-97EC-49D7-B8EB-48E746D84DDB@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:58074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbbEVEe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 00:34:29 -0400
In-Reply-To: <F4935A08-97EC-49D7-B8EB-48E746D84DDB@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> >> +#define CXLFLASH_MAX_CMDS               16
> >> +#define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS
> >> +
> >> +#define NOT_POW2(_x) ((_x) & ((_x) & ((_x) - 1)))
> > 
> > include/linux/log2 has is_power_of_2()
> > 
> 
> This is used for compile-time enforcement. The items in the log2 header are runtime
> functions. Will add a comment for clarity.

OK.

> >> +#if NOT_POW2(CXLFLASH_NUM_CMDS)
> >> +#error "CXLFLASH_NUM_CMDS is not a power of 2!"
> >> +#endif
> >> +
> >> +#define CMD_BUFSIZE     PAGE_SIZE_4K
> > 
> > Does this mean we can't compile with 64K pages?  How is this related to PAGES?
> > 
> 
> No, 64K pages are fully supported. We are simply borrowing the 4K page #define as
> the size of the AFU's command buffer is 4096 bytes. Will add a comment for clarity.

OK, I'd just put 4096 there.

> >> +
> >> +struct cxlflash {
> > 
> > I really don't like this name.  What does this struct actually represent?  Is
> > it just some table, info, queue?  Calling it just "cxlflash" doesn't give the
> > reader any idea what it is.  Plus it makes it really hard to search for since
> > "cxlflash" is being used a lot in this driver for other stuff and you often do
> >  struct cxlflash *cxlflash;
> > 
> > If you used something like
> >  struct cxlflash_desc {....};
> >  struct cxlflash_desc *desc;
> > I could search for desc and find all the uses.
> > 
> 
> Sounds reasonable. This is our per-device handle. How about the name
> struct cxlflash_cfg and we locally call the variable 'cfg'?

Sounds good!

> 
> >> 
> >> +
> >> +	struct pci_pool *cxlflash_cmd_pool;
> >> +	struct pci_dev *parent_dev;
> >> +
> >> +	int num_user_contexts;
> > 
> > You init this to 0 but never use it.
> > 
> >> +	struct ctx_info *ctx_info[MAX_CONTEXT];
> >> +	struct file_operations cxl_fops;
> > 
> > This is unused in this patch.
> > 
> 
> These are used in other areas of the driver not included in this patch. Will look
> at not including them in the next patch with updates based on feedback.

Ideally this next patch would add these.

> >> +	char *buf;		/* per command buffer */
> >> +	struct afu *back;
> > 
> > Can we call this parent, rather than back?
> > 
> 
> Sure.
> 
> >> +	int slot;
> >> +	atomic_t free;
> > 
> > Looks like you're just doing ref counting with this so it should probably be a
> > struct kref.
> > 
> 
> We'll leave this as an atomic for now to support our round-robin allocation.
> 
> >> +	u8 special:1;
> >> +	u8 internal:1;
> >> +	u8 sync:1;
> >> +
> >> +} __aligned(cache_line_size());
> > 
> > Why is this cacheline aigned?
> 
> The IOASA and IOARCB sit at the top of this structure. We keep this aligned on
> a cacheline so that these two sit in the same cacheline for better performance.

Great... document this here.

> >> +	while (dec--) {
> >> +		k = (afu->cmd_couts++ & (CXLFLASH_NUM_CMDS - 1));
> >> +
> >> +		cmd = &afu->cmd[k];
> >> +
> >> +		if (!atomic_dec_if_positive(&cmd->free)) {
> > 
> > I guess this is ok with only 32 commands but it's a linear search.  I would be
> > nice to use a standard allocator here instead.  I think you could use ida for
> > this and remove the need for cmd->free.  Probably not a bit issue though.
> 
> We're going to continue to use this simple round-robin search. The command pool
> is larger than the hardware queue depth and therefore we should rarely hit a case
> where we're looping more than a time or two here to find a free command.

OK. Just looked like you were reinventing something that should already
be available.

> 
> >> +
> >> +	spin_lock_irqsave(&cmd->slock, lock_flags);
> >> +	cmd->sa.host_use_b[0] |= B_DONE;
> >> +	spin_unlock_irqrestore(&cmd->slock, lock_flags);
> > 
> > Who else are you locking against here?  Just yourself?  In other places you
> > just stick 0 here.  What happens if you race with that?
> > 
> > If you're just racing with yourself, does that mean this code can be called
> > simultaneously?  If so, is the rest of this code save?  cmd->rcb.scp doesn't
> > seem to be locked below.
> > 
> 
> We have removed this locking. It was left over from when we used to have
> other writer threads and more bits.

Great

> 
> >> 
> >> +
> >> +	while (cxlflash->tmf_active)
> >> +		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
> > 
> > This doesn't look right.  Why not just wait_event()?  
> > 
> > Same in other places.
> > 
> 
> Fixed.

Great

> >> 
> >> +	cxlflash->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
> >> +						 get_order(sizeof(struct afu)));
> > 
> > Any reason not to use kmalloc here?  How big is struct afu?
> 
> The AFU is roughly 12K. We allocate on a page to satisfy alignment requirements
> for substructures located at the top of the AFU. We have added a comment to
> clarify the size and use.

Thanks.

> >> 
> >> +	if (afu->room == 0) {
> >> +		do {
> >> +			afu->room = readq_be(&afu->host_map->cmd_room);
> >> +			udelay(nretry);
> > 
> > We retry the same number of times that we udelay().  That seems odd?  We
> > waiting a little bit longer each time?
> 
> Correct, the idea here is to try at all costs to get the reset queued up. We delay a bit
> longer on each retry in hopes that there will be some movement and a spot freed up.

OK.  A comment to clarify this would be good.

> >> 
> >> +		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
> > 
> > Should this be have cpu_to_be16()? (along with everything else that touches
> > sisl_ioarcb?)  sisl_ioarcb is shared in memory with the hardware AFU, right?
> 
> The AFU is bi-endian (except where noted). We'll likely leave these as host endian and
> flip the AFU's endian control bit depending on the host endianness.

Good.  Some documentation on this bi-endianess would be good.  Devices
normally just pick an endian and software has to deal with it.  So
flipping device endian is something you should note.

> 
> >> +
> >> +	/* AFU configuration */
> >> +	reg = readq_be(&afu->afu_map->global.regs.afu_config);
> >> +	reg |= 0x7F20;		/* enable all auto retry options and LE */
> > 
> > LE??  Little Endian?
> > 
> > This needs to support BE also or you need to fail at compile/config time.
> 
> Correct, LE is for little endian. We added defines for these bits for clarity and
> will set the endian control bit depending on what we're compiling against.

Thanks.  

On POWERPC transition to little endian is happening fast but not
everyone is there yet so we need to support both.

> >> 
> >> +
> >> +	ctx = cxl_dev_context_init(cxlflash->dev);
> >> +	if (!ctx)
> >> +		return -ENOMEM;
> > 
> > You can pull a default context for this pci device using cxl_get_context() now.
> > if you do this, you don't want to release it later though.  This was a recent
> > update to the cxl kernel API
> 
> Noted. We'll look into this.

Great.

> >> 
> >> +
> >> +	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
> > 
> > Again, are these endian safe?
> 
> Should be based on how we set the AFU endian control bit.

OK.

> >> 
> >> +	phys_dev = cxl_get_phys_dev(pdev);
> >> +	if (!dev_is_pci(phys_dev)) {	/* make sure it's pci */
> > 
> > Drop this comment, it's obvious what it's doing.
> > 
> 
> Okay.
> 
> >> +		cxlflash_err("not a pci dev");
> >> +		rc = ENODEV;
> >> +		goto out_remove;
> >> +	}
> >> +	cxlflash->parent_dev = to_pci_dev(phys_dev);
> > 
> > Is there much use in saving this?  You only use it in one place.
> 
> We're going to continue to save this off for now in case we need it in other places
> in the future (ie: EEH).

OK

> >> +/*
> >> + * IOARCB: 64 bytes, min 16 byte alignment required, host native endianness
> >> + * except for SCSI CDB which remains big endian per SCSI standards.
> > 
> > Why not define these are be16/32/64, then?
> > 
> > sisl_ioarcb is shared in memory with the hardware AFU, right?  Souldn't
> > everything that touches them be wrapped in cpu_to_be* and visa versa?
> 
> The AFU is bi-endian and therefore we can leave this as host endian defined.

OK.  More info on the bi-endian nature would be useful then.

> >> +
> >> +	union {
> >> +		u64 host_use[4];
> >> +		u8 host_use_b[32];
> > 
> > You only seem to use 0 and 1 of these 32.
> 
> This is defined by the SISlite spec. Added a comment for clarity.

Ok.

> 
> >> +				 */
> >> +	u8 nmask;
> >> +} __aligned(16);
> > 
> > Why aligned?
> 
> The SISlite spec states that the RHT entries must be 16-byte aligned. We have
> added a comment to clarify this.

OK, should be documented here as such.

Mikey

