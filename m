From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Wed, 12 Aug 2015 00:18:35 -0400
Message-ID: <20150812001835.Horde.5HNx0-z3d-8S7prwORBg_A1@ltc.linux.ibm.com>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38615 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbbHLESl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 00:18:41 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 22:18:40 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id BDE9219D804E
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 22:09:34 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7C4Ib8e51314774
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 21:18:37 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7C4IaYW005581
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 22:18:37 -0600
In-Reply-To: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


Quoting "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>:

> Add superpipe supporting infrastructure to device driver for the IBM CXL
> Flash adapter. This patch allows userspace applications to take advantage
> of the accelerated I/O features that this adapter provides and bypass the
> traditional filesystem stack.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
> Documentation/ioctl/ioctl-number.txt |    1 +
> Documentation/powerpc/cxlflash.txt   |  297 +++++
> drivers/scsi/cxlflash/Makefile       |    2 +-
> drivers/scsi/cxlflash/common.h       |   19 +
> drivers/scsi/cxlflash/main.c         |   21 +-
> drivers/scsi/cxlflash/superpipe.c    | 2206  
> ++++++++++++++++++++++++++++++++++
> drivers/scsi/cxlflash/superpipe.h    |  127 ++
> include/uapi/scsi/Kbuild             |    1 +
> include/uapi/scsi/cxlflash_ioctl.h   |  139 +++
> 9 files changed, 2810 insertions(+), 3 deletions(-)
> create mode 100644 Documentation/powerpc/cxlflash.txt
> create mode 100644 drivers/scsi/cxlflash/superpipe.c
> create mode 100644 drivers/scsi/cxlflash/superpipe.h
> create mode 100644 include/uapi/scsi/cxlflash_ioctl.h
>
>

>
>
> diff --git a/drivers/scsi/cxlflash/superpipe.c  
> b/drivers/scsi/cxlflash/superpipe.c
> new file mode 100644
> index 0000000..802f1f5
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/superpipe.c

> +struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxid,
> +			     void *arg, enum ctx_ctrl ctx_ctrl)
> +{
> +	struct ctx_info *ctxi = NULL;
> +	struct lun_access *lun_access = NULL;
> +	struct file *file = NULL;
> +	struct llun_info *lli = arg;
> +	u64 ctxid = DECODE_CTXID(rctxid);
> +	int rc;
> +	pid_t pid = current->tgid, ctxpid = 0;
> +
> +	if (ctx_ctrl & CTX_CTRL_FILE) {
> +		lli = NULL;
> +		file = (struct file *)arg;
> +	}
> +
> +	if (ctx_ctrl & CTX_CTRL_CLONE)
> +		pid = current->parent->tgid;
> +
> +	if (likely(ctxid < MAX_CONTEXT)) {
> +retry:
> +		rc = mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
> +		if (rc)
> +			goto out;
> +

if (mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex))
        goto out;
or  return ctxi;

> +		ctxi = cfg->ctx_tbl[ctxid];
> +		if (ctxi)
> +			if ((file && (ctxi->file != file)) ||
> +			    (!file && (ctxi->ctxid != rctxid)))
> +				ctxi = NULL;
> +

Should you combine two "if" to one "if"?

> +		if ((ctx_ctrl & CTX_CTRL_ERR) ||
> +		    (!ctxi && (ctx_ctrl & CTX_CTRL_ERR_FALLBACK)))
> +			ctxi = find_error_context(cfg, rctxid, file);
> +		if (!ctxi) {
> +			mutex_unlock(&cfg->ctx_tbl_list_mutex);
> +			goto out;
> +		}
> +
> +		/*
> +		 * Need to acquire ownership of the context while still under
> +		 * the table/list lock to serialize with a remove thread. Use
> +		 * the 'try' to avoid stalling the table/list lock for a single
> +		 * context.
> +		 */
> +		rc = mutex_trylock(&ctxi->mutex);
> +		mutex_unlock(&cfg->ctx_tbl_list_mutex);
> +		if (!rc)
> +			goto retry;
> +
> +		if (ctxi->unavail)
> +			goto denied;
> +
> +		ctxpid = ctxi->pid;
> +		if (likely(!(ctx_ctrl & CTX_CTRL_NOPID)))
> +			if (pid != ctxpid)
> +				goto denied;

Should you combine above two "if" to one "if"?

> +
> +		if (lli) {
> +			list_for_each_entry(lun_access, &ctxi->luns, list)
> +				if (lun_access->lli == lli)
> +					goto out;
> +			goto denied;
> +		}
> +	}
> +
> +out:
> +	pr_debug("%s: rctxid=%016llX ctxinfo=%p ctxpid=%u pid=%u ctx_ctrl=%u\n",
> +		 __func__, rctxid, ctxi, ctxpid, pid, ctx_ctrl);
> +
> +	return ctxi;
> +
> +denied:
> +	mutex_unlock(&ctxi->mutex);
> +	ctxi = NULL;
> +	goto out;
> +}

> +/**
> + * cxlflash_lun_attach() - attaches a user to a LUN and manages the  
> LUN's mode
> + * @gli:	LUN to attach.
> + * @mode:	Desired mode of the LUN.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_lun_attach(struct glun_info *gli, enum lun_mode mode)
> +{
> +	int rc = 0;
> +
> +	spin_lock(&gli->slock);
> +	if (gli->mode == MODE_NONE)
> +		gli->mode = mode;
> +	else if (gli->mode != mode) {
> +		pr_err("%s: LUN operating in mode %d, requested mode %d\n",
> +		       __func__, gli->mode, mode);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	gli->users++;
> +	WARN_ON(gli->users <= 0);

Does "gli->users" have upper limit?

> +out:
> +	pr_debug("%s: Returning rc=%d gli->mode=%u gli->users=%u\n",
> +		 __func__, rc, gli->mode, gli->users);
> +	spin_unlock(&gli->slock);
> +	return rc;
> +}
> +
> +/**
> + * cxlflash_lun_detach() - detaches a user from a LUN and resets  
> the LUN's mode
> + * @gli:	LUN to detach.
> + *
> + * When resetting the mode, terminate block allocation resources as they
> + * are no longer required (service is safe to call even when block  
> allocation
> + * resources were not present - such as when transitioning from  
> physical mode).
> + * These resources will be reallocated when needed (subsequent transition to
> + * virtual mode).
> + */
> +void cxlflash_lun_detach(struct glun_info *gli)
> +{
> +	spin_lock(&gli->slock);
> +	WARN_ON(gli->mode == MODE_NONE);
> +	if (--gli->users == 0)
> +		gli->mode = MODE_NONE;
> +	pr_debug("%s: gli->users=%u\n", __func__, gli->users);
> +	WARN_ON(gli->users < 0);

do you like to add a pr_debug(....) here?

> +	spin_unlock(&gli->slock);
> +}
> +
> +/**
> + * _cxlflash_disk_release() - releases the specified resource entry
> + * @sdev:	SCSI device associated with LUN.
> + * @ctxi:	Context owning resources.
> + * @release:	Release ioctl data structure.
> + *
> + * For LUN's in virtual mode, the virtual lun associated with the specified
> + * resource handle is resized to 0 prior to releasing the RHTE.  
> Note that the
> + * AFU sync should _not_ be performed when the context is sitting  
> on the error
> + * recovery list. A context on the error recovery list is not known  
> to the AFU
> + * due to reset. When the context is recovered, it will be  
> reattached and made
> + * known again to the AFU.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int _cxlflash_disk_release(struct scsi_device *sdev,
> +			   struct ctx_info *ctxi,
> +			   struct dk_cxlflash_release *release)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct afu *afu = cfg->afu;
> +	bool unlock_ctx = false;
> +
> +	res_hndl_t rhndl = release->rsrc_handle;
> +
> +	int rc = 0;
> +	u64 ctxid = DECODE_CTXID(release->context_id),
> +	    rctxid = release->context_id;
> +
> +	struct sisl_rht_entry *rhte;
> +	struct sisl_rht_entry_f1 *rhte_f1;
> +
> +	pr_debug("%s: ctxid=%llu rhndl=0x%llx gli->mode=%u gli->users=%u\n",
> +		 __func__, ctxid, release->rsrc_handle, gli->mode, gli->users);
> +
> +	if (!ctxi) {
> +		ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
> +		if (unlikely(!ctxi)) {
> +			pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		unlock_ctx = true;
> +	}
> +
> +	rhte = get_rhte(ctxi, rhndl, lli);
> +	if (unlikely(!rhte)) {
> +		pr_err("%s: Bad resource handle! (%d)\n", __func__, rhndl);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Resize to 0 for virtual LUNS by setting the size
> +	 * to 0. This will clear LXT_START and LXT_CNT fields
> +	 * in the RHT entry and properly sync with the AFU.
> +	 *
> +	 * Afterwards we clear the remaining fields.
> +	 */
> +	switch (gli->mode) {
> +	case MODE_PHYSICAL:
> +		/*
> +		 * Clear the Format 1 RHT entry for direct access
> +		 * (physical LUN) using the synchronization sequence
> +		 * defined in the SISLite specification.
> +		 */
> +		rhte_f1 = (struct sisl_rht_entry_f1 *)rhte;
> +
> +		rhte_f1->valid = 0;
> +		dma_wmb(); /* Make revocation of RHT entry visible */
> +
> +		rhte_f1->lun_id = 0;
> +		dma_wmb(); /* Make clearing of LUN id visible */
> +
> +		rhte_f1->dw = 0;
> +		dma_wmb(); /* Make RHT entry bottom-half clearing visible */
> +
> +		if (!ctxi->err_recovery_active)
> +			cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
> +		break;
> +	default:
> +		WARN(1, "Unsupported LUN mode!");
> +		goto out;
> +	}
> +
> +	rhte_checkin(ctxi, rhte);
> +	cxlflash_lun_detach(gli);
> +
> +out:
> +	if (unlock_ctx)
> +		mutex_unlock(&ctxi->mutex);

Should "mutex_lock(&ctxi->mutex);" in the same function?

> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +

> + * create_context() - allocates and initializes a context
> + * @cfg:	Internal structure associated with the host.
> + * @ctx:	Previously obtained CXL context reference.
> + * @ctxid:	Previously obtained process element associated with CXL context.
> + * @adap_fd:	Previously obtained adapter fd associated with CXL context.
> + * @file:	Previously obtained file associated with CXL context.
> + * @perms:	User-specified permissions.
> + *
> + * The context's mutex is locked when an allocated context is returned.
> + *
> + * Return: Allocated context on success, NULL on failure
> + */
> +static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
> +				       struct cxl_context *ctx, int ctxid,
> +				       int adap_fd, struct file *file,
> +				       u32 perms)
> +{
> +	char *tmp = NULL;
> +	size_t size;
> +	struct afu *afu = cfg->afu;
> +	struct ctx_info *ctxi = NULL;
> +	struct sisl_rht_entry *rhte;
> +
> +	size = (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
> +	size += sizeof(*ctxi);
> +

Combine above two lines code into one line code?

> +	tmp = kzalloc(size, GFP_KERNEL);
> +	if (unlikely(!tmp)) {
> +		pr_err("%s: Unable to allocate context! (%ld)\n",
> +		       __func__, size);
> +		goto out;
> +	}
> +
> +	rhte = (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
> +	if (unlikely(!rhte)) {
> +		pr_err("%s: Unable to allocate RHT!\n", __func__);
> +		goto err;
> +	}
> +
> +	ctxi = (struct ctx_info *)tmp;
> +	tmp += sizeof(*ctxi);
> +	ctxi->rht_lun = (struct llun_info **)tmp;

Combine above two lines code into one line code?

> +	ctxi->rht_start = rhte;
> +	ctxi->rht_perms = perms;
> +
> +	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
> +	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
> +	ctxi->lfd = adap_fd;
> +	ctxi->pid = current->tgid; /* tgid = pid */
> +	ctxi->ctx = ctx;
> +	ctxi->file = file;
> +	mutex_init(&ctxi->mutex);
> +	INIT_LIST_HEAD(&ctxi->luns);
> +	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
> +
> +	atomic_inc(&cfg->num_user_contexts);
> +	mutex_lock(&ctxi->mutex);
> +out:

Is it ok to call "mutex_lock(&ctxi->mutex);" in the function which  
calling create_context"?

> +	return ctxi;
> +
> +err:
> +	kfree(tmp);
> +	goto out;
> +}
> +
>
> +		mutex_unlock(&cfg->ctx_tbl_list_mutex);
> +		mutex_unlock(&ctxi->mutex);
> +
> +		lfd = ctxi->lfd;
> +		destroy_context(cfg, ctxi);
> +		ctxi = NULL;
> +		unlock_ctx = false;
> +
> +		/*
> +		 * As a last step, clean up external resources when not
> +		 * already on an external cleanup thread, ie: close(adap_fd).
> +		 *
> +		 * NOTE: this will free up the context from the CXL services,
> +		 * allowing it to dole out the same context_id on a future
> +		 * (or even currently in-flight) disk_attach operation.
> +		 */
> +		if (lfd != -1)
> +			sys_close(lfd);
> +	}
> +
> +out:
> +	if (unlock_ctx)
> +		mutex_unlock(&ctxi->mutex);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +

> +/**
> + * cxlflash_manage_lun() - handles lun management activities
> + * @sdev:	SCSI device associated with LUN.
> + * @manage:	Manage ioctl data structure.
> + *
> + * This routine is used to notify the driver about a LUN's WWID and  
> associate
> + * SCSI devices (sdev) with a global LUN instance. Additionally it serves to
> + * change a LUN's operating mode: legacy or superpipe.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_manage_lun(struct scsi_device *sdev,
> +			       struct dk_cxlflash_manage_lun *manage)
> +{
> +	int rc = 0;
> +	struct llun_info *lli = NULL;
> +	u64 flags = manage->hdr.flags;
> +	u32 chan = sdev->channel;
> +
> +	lli = lookup_lun(sdev, manage->wwid);
> +	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
> +		 __func__, get_unaligned_le64(&manage->wwid[0]),
> +		 get_unaligned_le64(&manage->wwid[8]),
> +		 manage->hdr.flags, lli);
> +	if (unlikely(!lli)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +

Move pr_debug(...) under if leg?

> +	if (flags & DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE) {
> +		if (lli->newly_created)
> +			lli->port_sel = CHAN2PORT(chan);
> +		else
> +			lli->port_sel = BOTH_PORTS;
> +		/* Store off lun in unpacked, AFU-friendly format */
> +		lli->lun_id[chan] = lun_to_lunid(sdev->lun);
> +		sdev->hostdata = lli;
> +	} else if (flags & DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE) {
> +		if (lli->parent->mode != MODE_NONE)
> +			rc = -EBUSY;
> +		else
> +			sdev->hostdata = NULL;
> +	}
> +
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +
>> +/**
> + * check_state() - checks and responds to the current adapter state
> + * @cfg:	Internal structure associated with the host.
> + *
> + * This routine can block and should only be used on process context.
> + * Note that when waking up from waiting in limbo, the state is unknown
> + * and must be checked again before proceeding.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int check_state(struct cxlflash_cfg *cfg)
> +{
> +	int rc = 0;
> +
> +retry:
> +	switch (cfg->state) {
> +	case STATE_LIMBO:
> +		pr_debug("%s: Limbo, going to wait...\n", __func__);
> +		rc = wait_event_interruptible(cfg->limbo_waitq,
> +					      cfg->state != STATE_LIMBO);
> +		if (unlikely(rc))
> +			goto out;
> +		goto retry;
> +	case STATE_FAILTERM:
> +		pr_debug("%s: Failed/Terminating!\n", __func__);
> +		rc = -ENODEV;
> +		goto out;

changed "goto out" to "break"?

> +	default:
> +		break;
> +	}
> +out:
> +	return rc;
> + * cxlflash_afu_recover() - initiates AFU recovery
> + * @sdev:	SCSI device associated with LUN.
> + * @recover:	Recover ioctl data structure.
> + *
> + * Only a single recovery is allowed at a time to avoid exhausting CXL
> + * resources (leading to recovery failure) in the event that we're up
> + * against the maximum number of contexts limit. For similar reasons,
> + * a context recovery is retried if there are multiple recoveries taking
> + * place at the same time and the failure was due to CXL services being
> + * unable to keep up.
> + *
> + * Because a user can detect an error condition before the kernel, it is
> + * quite possible for this routine to act as the kernel's EEH detection
> + * source (MMIO read of mbox_r). Because of this, there is a window of
> + * time where an EEH might have been detected but not yet 'serviced'
> + * (callback invoked, causing the device to enter limbo state). To avoid
> + * looping in this routine during that window, a 1 second sleep is in place
> + * between the time the MMIO failure is detected and the time a wait on the
> + * limbo wait queue is attempted via check_state().
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_afu_recover(struct scsi_device *sdev,
> +				struct dk_cxlflash_recover_afu *recover)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct afu *afu = cfg->afu;
> +	struct ctx_info *ctxi = NULL;
> +	struct mutex *mutex = &cfg->ctx_recovery_mutex;
> +	u64 ctxid = DECODE_CTXID(recover->context_id),
> +	    rctxid = recover->context_id;
> +	long reg;
> +	int lretry = 20; /* up to 2 seconds */
> +	int rc = 0;
> +
> +	atomic_inc(&cfg->recovery_threads);
> +	rc = mutex_lock_interruptible(mutex);
> +	if (rc)
> +		goto out;

change it to "if (mutex_lock_interruptible(mutex))":, If fails here,  
why need to unlock_mutex(mutex) in "out:"? How about just return error?

> +
> +	pr_debug("%s: reason 0x%016llX rctxid=%016llX\n", __func__,
> +		 recover->reason, rctxid);
> +
> +retry:
> +	/* Ensure that this process is attached to the context */
> +	ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
> +	if (unlikely(!ctxi)) {
> +		pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (ctxi->err_recovery_active) {
> +retry_recover:
> +		rc = recover_context(cfg, ctxi);
> +		if (unlikely(rc)) {
> +			pr_err("%s: Recovery failed for context %llu (rc=%d)\n",
> +			       __func__, ctxid, rc);
> +			if ((rc == -ENODEV) &&
> +			    ((atomic_read(&cfg->recovery_threads) > 1) ||
> +			     (lretry--))) {
> +				pr_debug("%s: Going to try again!\n", __func__);
> +				mutex_unlock(mutex);
> +				msleep(100);
> +				rc = mutex_lock_interruptible(mutex);
> +				if (rc)
> +					goto out;

Same here


> +				goto retry_recover;
> +			}
> +
> +			goto out;
> +		}
> +
> +		ctxi->err_recovery_active = false;
> +		recover->context_id = ctxi->ctxid;
> +		recover->adap_fd = ctxi->lfd;
> +		recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
> +		recover->hdr.return_flags |=
> +			DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET;
> +		goto out;
> +	}
> +
> +	/* Test if in error state */
> +	reg = readq_be(&afu->ctrl_map->mbox_r);
> +	if (reg == -1) {
> +		pr_info("%s: MMIO read fail! Wait for recovery...\n", __func__);
> +		mutex_unlock(&ctxi->mutex);
> +		ctxi = NULL;
> +		ssleep(1);
> +		rc = check_state(cfg);
> +		if (unlikely(rc))
> +			goto out;
> +		goto retry;
> +	}
> +

> +	pr_debug("%s: MMIO working, no recovery required!\n", __func__);
> +out:
> +	if (likely(ctxi))
> +		mutex_unlock(&ctxi->mutex);
> +	mutex_unlock(mutex);
> +	atomic_dec_if_positive(&cfg->recovery_threads);
> +	return rc;
> +}
> +

