From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cxlflash: Base superpipe support
Date: Sat, 11 Jul 2015 18:36:48 -0500
Message-ID: <DDB93CA4-2396-4CBD-8490-CB3E470642E3@linux.vnet.ibm.com>
References: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com> <55A021BD.5090501@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:46039 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbbGKXgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2015 19:36:54 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Sat, 11 Jul 2015 19:36:53 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 161866E8045
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2015 19:28:38 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6BNapqo63308016
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2015 23:36:51 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6BNaonv012828
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2015 19:36:51 -0400
In-Reply-To: <55A021BD.5090501@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, nab@linux-iscsi.org, Christoph Hellwig <hch@infradead.org>, Michael Neuling <mikey@neuling.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Brian,

Thanks for reviewing. Comments inline below.


-matt

On Jul 10, 2015, at 2:49 PM, Brian King wrote:
> On 06/19/2015 05:37 PM, Matthew R. Ochs wrote:
>> 
>> 	cfg->init_state = INIT_STATE_NONE;
>> 	cfg->dev = pdev;
>> +	cfg->last_lun_index[0] = 0;
>> +	cfg->last_lun_index[1] = 0;
>> 	cfg->dev_id = (struct pci_device_id *)dev_id;
>> 	cfg->mcctx = NULL;
>> 	cfg->err_recovery_active = 0;
>> +	cfg->num_user_contexts = 0;
> 
> No need to set these to zero, since they get allocated via scsi_host_alloc,
> which zeroes the memory for you.

Agreed. We've actually already fixed this, you'll see it in v2.

>> +/**
>> + * marshall_det_to_rele() - translate detach to release structure
>> + * @detach:	Destination structure for the translate/copy.
>> + * @rele:	Source structure from which to translate/copy.
>> + */
>> +static void marshall_det_to_rele(struct dk_cxlflash_detach *detach,
>> +				 struct dk_cxlflash_release *release)
>> +{
>> +	release->hdr = detach->hdr;
>> +	release->context_id = detach->context_id;
> 
> Function name could be better. Marshal should have only one 'l' in this usage...

Sure, will fix.

>> +	if (wwid)
>> +		list_for_each_entry_safe(lun_info, temp, &global.luns, list) {
>> +			if (!memcmp(lun_info->wwid, wwid,
>> +				    DK_CXLFLASH_MANAGE_LUN_WWID_LEN))
>> +				return lun_info;
>> +		}
> 
> You probably want to be grabbing global.slock hre, right? list_for_each_entry_safe doesn't protect
> you from other threads deleting things off the list, it only allows you to delete
> entries off the list in your loop and continue to iterate.

Yes, will correct.

>> +
>> +	/* Store off lun in unpacked, AFU-friendly format */
>> +	lun_info->lun_id = lun_to_lunid(sdev->lun);
>> +	lun_info->lun_index = cfg->last_lun_index[sdev->channel];
>> +
>> +	writeq_be(lun_info->lun_id,
>> +		  &afu->afu_map->global.fc_port[sdev->channel]
>> +		  [cfg->last_lun_index[sdev->channel]++]);
> 
> Do you need a slave_destroy that undoes this and makes the AFU forget
> about this LUN? I'm thinking you probably want to also destroy any
> user contexts to this device in slave_destroy as well. Otherwise
> if you have a superpipe open to a scsi_device and someone deletes that
> scsi_device through sysfs, you will have an open superpipe to that
> device still and no way to tear it down since you don't have a
> way to issue the detach ioctl any longer.

In v2, you'll see that we have remove any need for the slave_* routines.

>> +	pid_t pid = current->tgid, ctxpid = 0;
>> +	ulong flags = 0;
>> +
>> +	if (unlikely(ctx_ctrl & CTX_CTRL_CLONE))
> 
> I'm seeing what is a bit of an overuse of likely / unlikely. Basically, IMHO,
> the only place where you should be using these compiler hints is in the performance
> path and even then, only when the odds are pretty high that you will go down
> the likely path.

We've actually revised the likely/unlikely since this patch. You'll see it toned down in v2.

>> 
>> +		if (likely(lun_info)) {
>> +			list_for_each_entry(lun_access, &ctx_info->luns, list)
>> +				if (lun_access->lun_info == lun_info) {
>> +					found = true;
>> +					break;
>> +				}
> 
> Do we need some locking here?

Yes, will investigate adding a per-context lock.

>> +static int read_cap16(struct afu *afu, struct lun_info *lun_info, u32 port_sel)
>> +{
>> +	struct afu_cmd *cmd = NULL;
>> +	int rc = 0;
>> +
> 
> Suggest using scsi_execute instead. That way it goes up through the block layer
> via the normal execution path, should result in less code, and then you also get
> error recovery for free. You can then get rid of the nasty looping on cxlflash_check_status.

Done.

>> +	cmd = cxlflash_cmd_checkout(afu);
>> +	if (unlikely(!cmd)) {
>> +		pr_err("%s: could not get a free command\n", __func__);
>> +		return -1;
>> +	}
>> +
>> +	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
>> +			      SISL_REQ_FLAGS_SUP_UNDERRUN |
>> +			      SISL_REQ_FLAGS_HOST_READ);
>> +
>> +	cmd->rcb.port_sel = port_sel;
>> +	cmd->rcb.lun_id = lun_info->lun_id;
>> +	cmd->rcb.data_len = CMD_BUFSIZE;
>> +	cmd->rcb.data_ea = (u64) cmd->buf;
>> +	cmd->rcb.timeout = MC_DISCOVERY_TIMEOUT;
>> +
>> +	cmd->rcb.cdb[0] = 0x9E;	/* read cap(16) */
> 
> Use SERVICE_ACTION_IN_16 here

Okay.

>> +	cmd->rcb.cdb[1] = 0x10;	/* service action */
> 
> Use SAI_READ_CAPACITY_16 here

You got it.

>> + * rhte_checkin() - releases a resource handle table entry
>> + * @ctx_info:	Context owning the resource handle.
>> + * @rht_entry:	RHTE to release.
>> + */
>> +void rhte_checkin(struct ctx_info *ctx_info,
>> +		  struct sisl_rht_entry *rht_entry)
>> +{
>> +	rht_entry->nmask = 0;
>> +	rht_entry->fp = 0;
>> +	ctx_info->rht_out--;
>> +	ctx_info->rht_lun[rht_entry - ctx_info->rht_start] = NULL;
> 
> Do you need some locking in both the checkout and checkin path?

Likely, will investigate this.

>> 
>> +		/*
>> +		 * Clear the Format 1 RHT entry for direct access
>> +		 * (physical LUN) using the synchronization sequence
>> +		 * defined in the SISLite specification.
>> +		 */
>> +		rht_entry_f1 = (struct sisl_rht_entry_f1 *)rht_entry;
>> +
>> +		rht_entry_f1->valid = 0;
>> +		smp_wmb(); /* Make revocation of RHT entry visible */
> 
> I think what you actually want to use here is dma_wmb() rather than smp_wmb(),
> assuming you are trying to ensure these writes occur in order with respect
> to the AFU. If you were to build the kernel as a UP kernel, rather than an SMP
> kernel, all these smp_wmb calls would turn into mere compiler barriers, which is
> not what you want, I think... Suggest auditing the entire patch as there are
> likely other barriers you may want to change as well.

What we're looking for here is a lightweight sync. Looking at the PPC barrier.h, I see
that you are correct, we need to specify dma_wmb() instead to ensure we use the
LWSYNC instead of a compiler barrier() when smp_wmb is not defined.. Agree with
the audit idea.

>> +	/* Free the context; note that rht_lun was allocated at same time */
>> +	kfree(ctx_info);
>> +	cfg->num_user_contexts--;
> 
> What guarantees atomicity of this increment? I don't see any locking around the callers...

Per Mikey Neuling's comments, we have already made this atomic.

>> +	/* Take our LUN out of context, free the node */
>> +	list_for_each_entry_safe(lun_access, t, &ctx_info->luns, list)
>> +		if (lun_access->lun_info == lun_info) {
>> +			list_del(&lun_access->list);
>> +			kfree(lun_access);
>> +			lun_access = NULL;
>> +			break;
>> +		}
> 
> Do you need to do some locking around this? Can others be reading / writing
> to / from this list concurrently?

Reading/writing would be via any of the ioctl threads when determining access
to a context. We'll likely cover this via a per-context lock.

>> +
>> +	/* Tear down context following last LUN cleanup */
>> +	if (list_empty(&ctx_info->luns)) {
>> +		spin_lock_irqsave(&cfg->ctx_tbl_slock, flags);
>> +		cfg->ctx_tbl[ctxid] = NULL;
>> +		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
>> +
>> +		while (atomic_read(&ctx_info->nrefs) > 1) {
>> +			pr_debug("%s: waiting on threads... (%d)\n",
>> +				 __func__, atomic_read(&ctx_info->nrefs));
>> +			cpu_relax();
> 
> Hmm. Would an msleep with an overall timeout be more appropriate here? It might
> actually be cleaner just to use a kref in the ctx_info struct to manage your
> reference count and then use the release function to do that cleanup,
> then you could simplify all this and eliminate the wait.

In v2, you'll see that we've already move to a sleep instead of a busy-wait here. Will
need to investigate what moving to a kref would look like.

>> +int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg)
>> +{
>> +	int i, rc = 0;
>> +	ulong lock_flags;
>> +	struct ctx_info *ctx_info = NULL;
>> +
>> +	spin_lock_irqsave(&cfg->ctx_tbl_slock, lock_flags);
>> +
>> +	for (i = 0; i < MAX_CONTEXT; i++) {
>> +		ctx_info = cfg->ctx_tbl[i];
>> +
>> +		if (ctx_info) {
>> +			cfg->ctx_tbl[i] = NULL;
>> +			list_add(&ctx_info->list, &cfg->ctx_err_recovery);
>> +			ctx_info->err_recovery_active = true;
>> +			unmap_context(ctx_info);
>> +		}
>> +	}
>> +
>> +	spin_unlock_irqrestore(&cfg->ctx_tbl_slock, lock_flags);
>> +
>> +	return rc;
>> +}
> 
> This function doesn't appear to be called anywhere. Not even in the follow on patch...

You're correct, this might not have been called in the first patch, but is used in v2.

>> +
>> +	/* On first attach set fileops */
>> +	if (cfg->num_user_contexts == 0)
>> +		cfg->cxl_fops = cxlflash_cxl_fops;
> 
> I'm not seeing any synchronization or locking here. How are you managing a hundred different users
> hitting your ioctl path at the same time? You are iterating through lists below with no locks
> held, but it seems to me like that list could be changing on you. Am I missing something here?

This line in particular is now an atomic. We've also added a state check to block ioctls when needed.

>> +	ctxid = cxl_process_element(ctx);
>> +	if ((ctxid > MAX_CONTEXT) || (ctxid < 0)) {
> 
> Too many parentheses

Fixed.

>> +	reg = readq_be(&afu->ctrl_map->mbox_r);	/* Try MMIO */
>> +	/* MMIO returning 0xff, need to reset */
>> +	if (reg == -1) {
>> +		pr_info("%s: afu=%p reason 0x%llx\n",
>> +			__func__, afu, recover->reason);
>> +		cxlflash_afu_reset(cfg);
>> +	} else {
>> +		pr_debug("%s: reason 0x%llx MMIO working, no reset performed\n",
>> +			 __func__, recover->reason);
>> +		rc = -EINVAL;
> 
> This seems a little strange to me. The user asked you to recover the AFU, the AFU looks
> fine to you, so you do nothing, yet you fail the request to recover the AFU. What about
> multiple users issuing this IOCTL at the same time? Seems like we might want to just
> return success rather than make the user second guess what they did wrong in building
> the ioctl.

Correct, we've reworked this routine for v2. You'll see behavior similar to as you've described.

>> +	case MODE_VIRTUAL:
>> +		last_lba = (((rht_entry->lxt_cnt * MC_CHUNK_SIZE *
>> +			      lun_info->blk_len) / CXLFLASH_BLOCK_SIZE) - 1);
>> +		break;
> 
> Should this go in the second patch?

Yes, this should have been in the second patch.

>> +struct dk_cxlflash_uvirtual {
>> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
>> +	__u64 context_id;		/* Context to own virtual resources */
>> +	__u64 lun_size;			/* Requested size, in 4K blocks */
>> +	__u64 rsrc_handle;		/* Returned resource handle */
>> +	__u64 last_lba;			/* Returned last LBA of LUN */
>> +};
> 
> This isn't used in this patch, so should really be in the second patch.

Yes, this technically should be in the second patch.

>> +
>> +struct dk_cxlflash_release {
>> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
>> +	__u64 context_id;		/* Context owning resources */
>> +	__u64 rsrc_handle;		/* Resource handle to release */
>> +};
>> +
>> +struct dk_cxlflash_resize {
>> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
>> +	__u64 context_id;		/* Context owning resources */
>> +	__u64 rsrc_handle;		/* Resource handle of LUN to resize */
>> +	__u64 req_size;			/* New requested size, in 4K blocks */
>> +	__u64 last_lba;			/* Returned last LBA of LUN */
>> +};
> 
> Looks like the same is true here. Ideally all the virtual LUN definitions, function
> prototypes, etc, would be in the second patch.

Agreed.

>> +#define DK_CXLFLASH_ATTACH		CXL_IOW(0x80, dk_cxlflash_attach)
> 
> It would probably be good to add a comment to include/uapi/misc/cxl.h to indicate
> that cxlflash is reserving this ioctl range so you don't conflict with other
> cxl users.

Sounds reasonable. Will work with the maintainers of that file to do this.

>> +#define DK_CXLFLASH_USER_DIRECT		CXL_IOW(0x81, dk_cxlflash_udirect)
>> +#define DK_CXLFLASH_USER_VIRTUAL	CXL_IOW(0x82, dk_cxlflash_uvirtual)
>> +#define DK_CXLFLASH_VLUN_RESIZE		CXL_IOW(0x83, dk_cxlflash_resize)
>> +#define DK_CXLFLASH_RELEASE		CXL_IOW(0x84, dk_cxlflash_release)
>> +#define DK_CXLFLASH_DETACH		CXL_IOW(0x85, dk_cxlflash_detach)
>> +#define DK_CXLFLASH_VERIFY		CXL_IOW(0x86, dk_cxlflash_verify)
>> +#define DK_CXLFLASH_CLONE		CXL_IOW(0x87, dk_cxlflash_clone)
>> +#define DK_CXLFLASH_RECOVER_AFU		CXL_IOW(0x88, dk_cxlflash_recover_afu)
>> +#define DK_CXLFLASH_MANAGE_LUN		CXL_IOW(0x89, dk_cxlflash_manage_lun)
>> +
>> +#endif /* ifndef _CXLFLASH_IOCTL_H */

