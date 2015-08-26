From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 2/3] cxlflash: Superpipe support
Date: Wed, 26 Aug 2015 17:26:56 -0500
Message-ID: <55DE3D30.6000505@linux.vnet.ibm.com>
References: <1439520463-56798-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44144 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbbHZW1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2015 18:27:04 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 26 Aug 2015 16:27:04 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 955F738C8054
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 18:27:01 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7QMR1FN49479838
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 22:27:01 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7QMQwvH004472
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 18:27:00 -0400
In-Reply-To: <1439520463-56798-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org
Cc: hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Matt,

Some comments below. I'm happy to see this one get merged as-is, as long as
these issues can get addressed in a follow on patch.

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

On 08/13/2015 09:47 PM, Matthew R. Ochs wrote:
> +/**
> + * cxlflash_term_global_luns() - frees resources associated with global LUN list
> + */
> +void cxlflash_term_global_luns(void)
> +{
> +	struct glun_info *gli, *temp;
> +
> +	mutex_lock(&global.mutex);
> +	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
> +		list_del(&gli->list);
> +		kfree(gli);

Comments below regarding refcounting this.

> +	}
> +	mutex_unlock(&global.mutex);
> +}
> +
> +/**
> + * cxlflash_manage_lun() - handles LUN management activities
> + * @sdev:	SCSI device associated with LUN.
> + * @manage:	Manage ioctl data structure.
> + *
> + * This routine is used to notify the driver about a LUN's WWID and associate
> + * SCSI devices (sdev) with a global LUN instance. Additionally it serves to
> + * change a LUN's operating mode: legacy or superpipe.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_manage_lun(struct scsi_device *sdev,
> +			struct dk_cxlflash_manage_lun *manage)
> +{
> +	int rc = 0;
> +	struct llun_info *lli = NULL;
> +	u64 flags = manage->hdr.flags;
> +	u32 chan = sdev->channel;
> +
> +	lli = find_and_create_lun(sdev, manage->wwid);
> +	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
> +		 __func__, get_unaligned_le64(&manage->wwid[0]),
> +		 get_unaligned_le64(&manage->wwid[8]),
> +		 manage->hdr.flags, lli);
> +	if (unlikely(!lli)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
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

I don't see any locking in this function. What if you had two processes calling
this ioctl at the same time with different parameters? Could we get into a strange
state?

> +	}
> +
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}

> @@ -2439,6 +2470,9 @@ static int __init init_cxlflash(void)
>   */
>  static void __exit exit_cxlflash(void)
>  {
> +	cxlflash_term_global_luns();
> +	cxlflash_free_errpage();

Both these functions free up memory. I'm concerned that memory could still be in use.
You probably need to add some refcounting to your global objects so you know when you
can free them up. kref is your friend.

> +
>  	pci_unregister_driver(&cxlflash_driver);
>  }
> 
> diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
> index bf5d399..66b8891 100644
> --- a/drivers/scsi/cxlflash/sislite.h
> +++ b/drivers/scsi/cxlflash/sislite.h
> @@ -409,7 +409,10 @@ struct sisl_lxt_entry {
> 
>  };
> 
> -/* Per the SISlite spec, RHT entries are to be 16-byte aligned */
> +/*
> + * RHT - Resource Handle Table
> + * Per the SISlite spec, RHT entries are to be 16-byte aligned
> + */
>  struct sisl_rht_entry {
>  	struct sisl_lxt_entry *lxt_start;
>  	u32 lxt_cnt;

> +/**
> + * cxlflash_stop_term_user_contexts() - stops/terminates known user contexts
> + * @cfg:	Internal structure associated with the host.
> + *
> + * When the host needs to go down, all users must be quiesced and their
> + * memory freed. This is accomplished by putting the contexts in error
> + * state which will notify the user and let them 'drive' the tear-down.
> + * Meanwhile, this routine camps until all user contexts have been removed.

Can you clarify this a bit more? What if the user ignores this notification?
Perhaps the process has been sent a SIGSTOP or the process is misbehaved.
Will we ever exit this loop? Are we actually dependent on the user process to
do something to exit this loop?

> + */
> +void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
> +{
> +	struct device *dev = &cfg->dev->dev;
> +	int i, found;
> +
> +	cxlflash_mark_contexts_error(cfg);
> +
> +	while (true) {
> +		found = false;
> +
> +		for (i = 0; i < MAX_CONTEXT; i++)
> +			if (cfg->ctx_tbl[i]) {
> +				found = true;
> +				break;
> +			}
> +
> +		if (!found && list_empty(&cfg->ctx_err_recovery))
> +			return;
> +
> +		dev_dbg(dev, "%s: Wait for user contexts to quiesce...\n",
> +			__func__);
> +		wake_up_all(&cfg->limbo_waitq);
> +		ssleep(1);
> +	}
> +}
> +

> +/**
> + * read_cap16() - issues a SCSI READ_CAP16 command
> + * @sdev:	SCSI device associated with LUN.
> + * @lli:	LUN destined for capacity request.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct device *dev = &cfg->dev->dev;
> +	struct glun_info *gli = lli->parent;
> +	u8 *cmd_buf = NULL;
> +	u8 *scsi_cmd = NULL;
> +	u8 *sense_buf = NULL;
> +	int rc = 0;
> +	int result = 0;
> +	int retry_cnt = 0;
> +	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);

Looks like you are using only a 5 second timeout for this. sd.c uses 30 seconds. 
5 might be a bit on the short side.

> +
> +retry:
> +	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
> +	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
> +	sense_buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> +	if (unlikely(!cmd_buf || !scsi_cmd || !sense_buf)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	scsi_cmd[0] = SERVICE_ACTION_IN_16;	/* read cap(16) */
> +	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
> +	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
> +
> +	dev_dbg(dev, "%s: %ssending cmd(0x%x)\n", __func__,
> +		retry_cnt ? "re" : "", scsi_cmd[0]);
> +
> +	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
> +			      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
> +
> +	if (driver_byte(result) == DRIVER_SENSE) {
> +		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
> +		if (result & SAM_STAT_CHECK_CONDITION) {
> +			struct scsi_sense_hdr sshdr;
> +
> +			scsi_normalize_sense(sense_buf, SCSI_SENSE_BUFFERSIZE,
> +					    &sshdr);
> +			switch (sshdr.sense_key) {
> +			case NO_SENSE:
> +			case RECOVERED_ERROR:
> +				/* fall through */
> +			case NOT_READY:
> +				result &= ~SAM_STAT_CHECK_CONDITION;
> +				break;
> +			case UNIT_ATTENTION:
> +				switch (sshdr.asc) {
> +				case 0x29: /* Power on Reset or Device Reset */
> +					/* fall through */
> +				case 0x2A: /* Device capacity changed */
> +				case 0x3F: /* Report LUNs changed */
> +					/* Retry the command once more */
> +					if (retry_cnt++ < 1) {
> +						kfree(cmd_buf);
> +						kfree(scsi_cmd);
> +						kfree(sense_buf);
> +						goto retry;
> +					}
> +				}
> +				break;
> +			default:
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (result) {
> +		dev_err(dev, "%s: command failed, result=0x%x\n",
> +			__func__, result);
> +		rc = -EIO;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Read cap was successful, grab values from the buffer;
> +	 * note that we don't need to worry about unaligned access
> +	 * as the buffer is allocated on an aligned boundary.
> +	 */
> +	mutex_lock(&gli->mutex);
> +	gli->max_lba = be64_to_cpu(*((u64 *)&cmd_buf[0]));
> +	gli->blk_len = be32_to_cpu(*((u32 *)&cmd_buf[8]));
> +	mutex_unlock(&gli->mutex);
> +
> +out:
> +	kfree(cmd_buf);
> +	kfree(scsi_cmd);
> +	kfree(sense_buf);
> +
> +	dev_dbg(dev, "%s: maxlba=%lld blklen=%d rc=%d\n",
> +		__func__, gli->max_lba, gli->blk_len, rc);
> +	return rc;
> +}
> +

> +
> +/**
> + * cxlflash_lun_detach() - detaches a user from a LUN and resets the LUN's mode
> + * @gli:	LUN to detach.
> + */
> +void cxlflash_lun_detach(struct glun_info *gli)
> +{
> +	mutex_lock(&gli->mutex);
> +	WARN_ON(gli->mode == MODE_NONE);
> +	if (--gli->users == 0)
> +		gli->mode = MODE_NONE;

It looks like the only place you free this struct glun_info object is when your
module gets unloaded. Would be nice if it got freed up when it was no longer in
use, but to do this will require some re-work on how you manage reference counting
in this object. You probably also want to use a kref to manage the object lifetime
rather than inventing your own.


> +	pr_debug("%s: gli->users=%u\n", __func__, gli->users);
> +	WARN_ON(gli->users < 0);
> +	mutex_unlock(&gli->mutex);
> +}
> +

> +/**
> + * cxlflash_cxl_release() - release handler for adapter file descriptor
> + * @inode:	File-system inode associated with fd.
> + * @file:	File installed with adapter file descriptor.
> + *
> + * This routine is the release handler for the fops registered with
> + * the CXL services on an initial attach for a context. It is called
> + * when a close is performed on the adapter file descriptor returned
> + * to the user. Programmatically, the user is not required to perform
> + * the close, as it is handled internally via the detach ioctl when
> + * a context is being removed. Note that nothing prevents the user
> + * from performing a close, but the user should be aware that doing
> + * so is considered catastrophic and subsequent usage of the superpipe
> + * API with previously saved off tokens will fail.
> + *
> + * When initiated from an external close (either by the user or via
> + * a process tear down), the routine derives the context reference
> + * and calls detach for each LUN associated with the context. The
> + * final detach operation will cause the context itself to be freed.
> + * Note that the saved off lfd is reset prior to calling detach to
> + * signify that the final detach should not perform a close.
> + *
> + * When initiated from a detach operation as part of the tear down
> + * of a context, the context is first completely freed and then the
> + * close is performed. This routine will fail to derive the context
> + * reference (due to the context having already been freed) and then
> + * call into the CXL release entry point.
> + *
> + * Thus, with exception to when the CXL process element (context id)
> + * lookup fails (a case that should theoretically never occur), every
> + * call into this routine results in a complete freeing of a context.
> + *
> + * As part of the detach, all per-context resources associated with the LUN
> + * are cleaned up. When detaching the last LUN for a context, the context
> + * itself is cleaned up and released.
> + *
> + * Return: 0 on success
> + */
> +static int cxlflash_cxl_release(struct inode *inode, struct file *file)
> +{
> +	struct cxl_context *ctx = cxl_fops_get_context(file);
> +	struct cxlflash_cfg *cfg = container_of(file->f_op, struct cxlflash_cfg,
> +						cxl_fops);
> +	struct device *dev = &cfg->dev->dev;
> +	struct ctx_info *ctxi = NULL;
> +	struct dk_cxlflash_detach detach = { { 0 }, 0 };
> +	struct lun_access *lun_access, *t;
> +	enum ctx_ctrl ctrl = CTX_CTRL_ERR_FALLBACK | CTX_CTRL_FILE;
> +	int ctxid;
> +
> +	ctxid = cxl_process_element(ctx);
> +	if (unlikely(ctxid < 0)) {
> +		dev_err(dev, "%s: Context %p was closed! (%d)\n",
> +			__func__, ctx, ctxid);
> +		goto out;
> +	}
> +
> +	ctxi = get_context(cfg, ctxid, file, ctrl);
> +	if (unlikely(!ctxi)) {
> +		ctxi = get_context(cfg, ctxid, file, ctrl | CTX_CTRL_CLONE);
> +		if (!ctxi) {
> +			dev_dbg(dev, "%s: Context %d already free!\n",
> +				__func__, ctxid);
> +			goto out_release;
> +		}
> +
> +		dev_dbg(dev, "%s: Another process owns context %d!\n",
> +			__func__, ctxid);
> +		put_context(ctxi);
> +		goto out;
> +	}
> +
> +	dev_dbg(dev, "%s: close(%d) for context %d\n",
> +		__func__, ctxi->lfd, ctxid);
> +
> +	/* Reset the file descriptor to indicate we're on a close() thread */
> +	ctxi->lfd = -1;
> +	detach.context_id = ctxi->ctxid;
> +	list_for_each_entry_safe(lun_access, t, &ctxi->luns, list)
> +		_cxlflash_disk_detach(lun_access->sdev, ctxi, &detach);

I think you have a potential oops here. If you have a user context created for
an scsi device, you then delete the scsi device via sysfs, then, if there is any
way to go down this path, which I would hope there is, otherwise you have a
different issue, then you may pass an sdev pointer that now points to freed memory.

There are a couple possible ways you could solve this.

1. It might work to use scsi_get_device / scsi_put_device to get / put a reference to the scsi device
   for each user context associated with it.
2. The other option would be to implement a slave_destroy function and have it kill off
   any open user contexts.


> +out_release:
> +	cxl_fd_release(inode, file);
> +out:
> +	dev_dbg(dev, "%s: returning\n", __func__);
> +	return 0;
> +}
> +

> +
> +/**
> + * cxlflash_disk_attach() - attach a LUN to a context
> + * @sdev:	SCSI device associated with LUN.
> + * @attach:	Attach ioctl data structure.
> + *
> + * Creates a context and attaches LUN to it. A LUN can only be attached
> + * one time to a context (subsequent attaches for the same context/LUN pair
> + * are not supported). Additional LUNs can be attached to a context by
> + * specifying the 'reuse' flag defined in the cxlflash_ioctl.h header.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_disk_attach(struct scsi_device *sdev,
> +				struct dk_cxlflash_attach *attach)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct device *dev = &cfg->dev->dev;
> +	struct afu *afu = cfg->afu;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct cxl_ioctl_start_work *work;
> +	struct ctx_info *ctxi = NULL;
> +	struct lun_access *lun_access = NULL;
> +	int rc = 0;
> +	u32 perms;
> +	int ctxid = -1;
> +	u64 rctxid = 0UL;
> +	struct file *file;
> +
> +	struct cxl_context *ctx;
> +
> +	int fd = -1;
> +
> +	/* On first attach set fileops */
> +	if (atomic_read(&cfg->num_user_contexts) == 0)
> +		cfg->cxl_fops = cxlflash_cxl_fops;
> +
> +	if (attach->num_interrupts > 4) {
> +		dev_dbg(dev, "%s: Cannot support this many interrupts %llu\n",
> +			__func__, attach->num_interrupts);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (gli->max_lba == 0) {
> +		dev_dbg(dev, "%s: No capacity info for this LUN (%016llX)\n",
> +			__func__, lli->lun_id[sdev->channel]);
> +		rc = read_cap16(sdev, lli);
> +		if (rc) {
> +			dev_err(dev, "%s: Invalid device! (%d)\n",
> +				__func__, rc);
> +			rc = -ENODEV;
> +			goto out;
> +		}
> +		dev_dbg(dev, "%s: LBA = %016llX\n", __func__, gli->max_lba);
> +		dev_dbg(dev, "%s: BLK_LEN = %08X\n", __func__, gli->blk_len);
> +	}
> +
> +	if (attach->hdr.flags & DK_CXLFLASH_ATTACH_REUSE_CONTEXT) {
> +		rctxid = attach->context_id;
> +		ctxi = get_context(cfg, rctxid, NULL, 0);
> +		if (!ctxi) {
> +			dev_dbg(dev, "%s: Bad context! (%016llX)\n",
> +				__func__, rctxid);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		list_for_each_entry(lun_access, &ctxi->luns, list)
> +			if (lun_access->lli == lli) {
> +				dev_dbg(dev, "%s: Already attached!\n",
> +					__func__);
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +	}
> +
> +	lun_access = kzalloc(sizeof(*lun_access), GFP_KERNEL);
> +	if (unlikely(!lun_access)) {

You can ditch the unlikely throughout all your ioctls. ioctls are not a performance path.

> +		dev_err(dev, "%s: Unable to allocate lun_access!\n", __func__);
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	lun_access->lli = lli;
> +	lun_access->sdev = sdev;
> +
> +	/* Non-NULL context indicates reuse */
> +	if (ctxi) {
> +		dev_dbg(dev, "%s: Reusing context for LUN! (%016llX)\n",
> +			__func__, rctxid);
> +		list_add(&lun_access->list, &ctxi->luns);
> +		fd = ctxi->lfd;
> +		goto out_attach;
> +	}
> +
> +	ctx = cxl_dev_context_init(cfg->dev);
> +	if (unlikely(IS_ERR_OR_NULL(ctx))) {
> +		dev_err(dev, "%s: Could not initialize context %p\n",
> +			__func__, ctx);
> +		rc = -ENODEV;
> +		goto err0;
> +	}
> +
> +	ctxid = cxl_process_element(ctx);
> +	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
> +		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
> +		rc = -EPERM;
> +		goto err1;
> +	}
> +
> +	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
> +	if (unlikely(fd < 0)) {
> +		rc = -ENODEV;
> +		dev_err(dev, "%s: Could not get file descriptor\n", __func__);
> +		goto err1;
> +	}
> +
> +	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
> +	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
> +
> +	ctxi = create_context(cfg, ctx, ctxid, fd, file, perms);
> +	if (unlikely(!ctxi)) {
> +		dev_err(dev, "%s: Failed to create context! (%d)\n",
> +			__func__, ctxid);
> +		goto err2;
> +	}
> +
> +	work = &ctxi->work;
> +	work->num_interrupts = attach->num_interrupts;
> +	work->flags = CXL_START_WORK_NUM_IRQS;
> +
> +	rc = cxl_start_work(ctx, work);
> +	if (unlikely(rc)) {
> +		dev_dbg(dev, "%s: Could not start context rc=%d\n",
> +			__func__, rc);
> +		goto err3;
> +	}
> +
> +	rc = afu_attach(cfg, ctxi);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: Could not attach AFU rc %d\n", __func__, rc);
> +		goto err4;
> +	}
> +
> +	/*
> +	 * No error paths after this point. Once the fd is installed it's
> +	 * visible to user space and can't be undone safely on this thread.
> +	 * There is no need to worry about a deadlock here because no one
> +	 * knows about us yet; we can be the only one holding our mutex.
> +	 */
> +	list_add(&lun_access->list, &ctxi->luns);
> +	mutex_unlock(&ctxi->mutex);
> +	mutex_lock(&cfg->ctx_tbl_list_mutex);
> +	mutex_lock(&ctxi->mutex);
> +	cfg->ctx_tbl[ctxid] = ctxi;
> +	mutex_unlock(&cfg->ctx_tbl_list_mutex);
> +	fd_install(fd, file);
> +
> +out_attach:
> +	attach->hdr.return_flags = 0;
> +	attach->context_id = ctxi->ctxid;
> +	attach->block_size = gli->blk_len;
> +	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
> +	attach->last_lba = gli->max_lba;
> +	attach->max_xfer = (sdev->host->max_sectors * 512) / gli->blk_len;

Would be better to use a literal instead of a magic number here.


> +
> +out:
> +	attach->adap_fd = fd;
> +
> +	if (ctxi)
> +		put_context(ctxi);
> +
> +	dev_dbg(dev, "%s: returning ctxid=%d fd=%d bs=%lld rc=%d llba=%lld\n",
> +		__func__, ctxid, fd, attach->block_size, rc, attach->last_lba);
> +	return rc;
> +
> +err4:
> +	cxl_stop_context(ctx);
> +err3:
> +	put_context(ctxi);
> +	destroy_context(cfg, ctxi);
> +	ctxi = NULL;
> +err2:
> +	/*
> +	 * Here, we're overriding the fops with a dummy all-NULL fops because
> +	 * fput() calls the release fop, which will cause us to mistakenly
> +	 * call into the CXL code. Rather than try to add yet more complexity
> +	 * to that routine (cxlflash_cxl_release) we should try to fix the
> +	 * issue here.
> +	 */
> +	file->f_op = &null_fops;
> +	fput(file);
> +	put_unused_fd(fd);
> +	fd = -1;
> +err1:
> +	cxl_release_context(ctx);
> +err0:
> +	kfree(lun_access);
> +	goto out;
> +}
> +

> +/**
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
> +	struct device *dev = &cfg->dev->dev;
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
> +
> +	dev_dbg(dev, "%s: reason 0x%016llX rctxid=%016llX\n",
> +		__func__, recover->reason, rctxid);
> +
> +retry:
> +	/* Ensure that this process is attached to the context */
> +	ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
> +	if (unlikely(!ctxi)) {
> +		dev_dbg(dev, "%s: Bad context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (ctxi->err_recovery_active) {
> +retry_recover:
> +		rc = recover_context(cfg, ctxi);
> +		if (unlikely(rc)) {
> +			dev_err(dev, "%s: Recovery failed for context %llu (rc=%d)\n",
> +				__func__, ctxid, rc);
> +			if ((rc == -ENODEV) &&
> +			    ((atomic_read(&cfg->recovery_threads) > 1) ||
> +			     (lretry--))) {
> +				dev_dbg(dev, "%s: Going to try again!\n",
> +					__func__);
> +				mutex_unlock(mutex);
> +				msleep(100);
> +				rc = mutex_lock_interruptible(mutex);
> +				if (rc)
> +					goto out;
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

By the time this read completes, pdev->error_state is already set to pci_channel_io_frozen. If that
is not the case here, we need to fix that. You should be able to just use pci_channel_offline(pdev) here
and not need any delay.

> +	if (reg == -1) {
> +		dev_dbg(dev, "%s: MMIO read fail! Wait for recovery...\n",
> +			__func__);
> +		mutex_unlock(&ctxi->mutex);
> +		ctxi = NULL;
> +		ssleep(1);
> +		rc = check_state(cfg);
> +		if (unlikely(rc))
> +			goto out;
> +		goto retry;
> +	}
> +
> +	dev_dbg(dev, "%s: MMIO working, no recovery required!\n", __func__);
> +out:
> +	if (likely(ctxi))
> +		put_context(ctxi);
> +	mutex_unlock(mutex);
> +	atomic_dec_if_positive(&cfg->recovery_threads);
> +	return rc;
> +}
> +

> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> new file mode 100644
> index 0000000..ae39b96
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -0,0 +1,132 @@
> +/*
> + * CXL Flash Device Driver
> + *
> + * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
> + *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
> + *
> + * Copyright (C) 2015 IBM Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _CXLFLASH_SUPERPIPE_H
> +#define _CXLFLASH_SUPERPIPE_H
> +
> +extern struct cxlflash_global global;
> +
> +/*
> + * Terminology: use afu (and not adapter) to refer to the HW.
> + * Adapter is the entire slot and includes PSL out of which
> + * only the AFU is visible to user space.
> + */
> +
> +/* Chunk size parms: note sislite minimum chunk size is
> +   0x10000 LBAs corresponding to a NMASK or 16.
> +*/
> +#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs */
> +
> +#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */

Seems like the only place you use this is for the read capacity you issue,
so MC_READ_CAP timeout might be more accurate.


> +
> +#define CHAN2PORT(_x)	((_x) + 1)
> +
> +enum lun_mode {
> +	MODE_NONE = 0,
> +	MODE_PHYSICAL
> +};
> +



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


