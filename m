From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 3/3] cxlflash: Virtual LUN support
Date: Wed, 29 Jul 2015 18:13:09 -0400
Message-ID: <20150729181309.Horde.6ofK41kNBwHDWXDMz0bHhw1@ltc.linux.ibm.com>
References: <1437089217-52200-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <55B13B1D.60804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:33300 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbbG2WNP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2015 18:13:15 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 29 Jul 2015 16:13:14 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CCDBA19D8026
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 16:04:09 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6TMCbes44957796
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 15:12:37 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6TMDAYU010584
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 16:13:11 -0600
In-Reply-To: <55B13B1D.60804@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mrochs@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, wenxiong@linux.vnet.ibm.com


>
> -------- Forwarded Message --------
> Subject: [PATCH v2 3/3] cxlflash: Virtual LUN support
> Date: Thu, 16 Jul 2015 18:26:57 -0500
> From: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> To: linux-scsi@vger.kernel.org,  
> James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org,  
> brking@linux.vnet.ibm.com
> CC: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com,  
> dja@ozlabs.au.ibm.com, Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>
> Add support for physical LUN segmentation (virtual LUNs) to device
> driver supporting the IBM CXL Flash adapter. This patch allows user
> space applications to virtually segment a physical LUN into N virtual
> LUNs, taking advantage of the translation features provided by this
> adapter.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/Makefile     |    2 +-
>  drivers/scsi/cxlflash/common.h     |    3 +
>  drivers/scsi/cxlflash/main.c       |   12 +
>  drivers/scsi/cxlflash/sislite.h    |    3 +
>  drivers/scsi/cxlflash/superpipe.c  |   56 ++
>  drivers/scsi/cxlflash/superpipe.h  |   50 +-
>  drivers/scsi/cxlflash/vlun.c       | 1187  
> ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxlflash/vlun.h       |   68 +++
>  include/uapi/scsi/cxlflash_ioctl.h |   29 +
>  9 files changed, 1408 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/scsi/cxlflash/vlun.c
>  create mode 100644 drivers/scsi/cxlflash/vlun.h
>
> + * ba_alloc() - allocates a block from the block allocator
> + * @ba_lun:	Block allocator from which to allocate a block.
> + *
> + * Return: The allocated block, -1 on failure
> + */
> +static u64 ba_alloc(struct ba_lun *ba_lun)
> +{
> +	u64 bit_pos = -1;
> +	int bit_word = 0;
> +	struct ba_lun_info *lun_info = NULL;
> +
> +	lun_info = (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	pr_debug("%s: Received block allocation request: "
> +		 "lun_id = %llX, free_aun_cnt = %llX\n",
> +		 __func__, ba_lun->lun_id, lun_info->free_aun_cnt);
> +
> +	if (lun_info->free_aun_cnt == 0) {
> +		pr_err("%s: No space left on LUN: lun_id = %llX\n",
> +		       __func__, ba_lun->lun_id);
> +		return -1ULL;
> +	}
> +
> +	/* Search to find a free entry, curr->high then low->curr */
> +	bit_pos = find_free_range(lun_info->free_curr_idx,
> +				  lun_info->free_high_idx, lun_info, &bit_word);
> +	if (bit_pos == -1) {
> +		bit_pos = find_free_range(lun_info->free_low_idx,
> +					  lun_info->free_curr_idx,
> +					  lun_info, &bit_word);
> +		if (bit_pos == -1) {
> +			pr_err("%s: Could not find an allocation unit on LUN: "
> +			       "lun_id = %llX\n", __func__, ba_lun->lun_id);
> +			return -1ULL;
> +		}
> +	}
> +
> +	/* Update the free_curr_idx */
> +	if (bit_pos == 63)
> +		lun_info->free_curr_idx = bit_word + 1;

Predefined Macros for 63 and 64?

> +	else
> +		lun_info->free_curr_idx = bit_word;
> +
> +	pr_debug("%s: Allocating AU number %llX, on lun_id %llX, "
> +		 "free_aun_cnt = %llX\n", __func__,
> +		 ((bit_word * 64) + bit_pos), ba_lun->lun_id,
> +		 lun_info->free_aun_cnt);
> +
> +	return (u64) ((bit_word * 64) + bit_pos);
> +}

> +/**
> + * ba_free() - frees a block from the block allocator
> + * @ba_lun:	Block allocator from which to allocate a block.
> + * @to_free:	Block to free.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int ba_free(struct ba_lun *ba_lun, u64 to_free)
> +{
> +	int idx = 0, bit_pos = 0;
> +	struct ba_lun_info *lun_info = NULL;
> +
> +	lun_info = (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +

struct ba_lun_info *lun_info =(struct ba_lun_info *)ba_lun->ba_lun_handle;

> +	if (validate_alloc(lun_info, to_free)) {
> +		pr_err("%s: The AUN %llX is not allocated on lun_id %llX\n",
> +		       __func__, to_free, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	pr_debug("%s: Received a request to free AU %llX on lun_id %llX, "
> +		 "free_aun_cnt = %llX\n", __func__, to_free, ba_lun->lun_id,
> +		 lun_info->free_aun_cnt);
> +
> +	if (lun_info->aun_clone_map[to_free] > 0) {
> +		pr_debug("%s: AUN %llX on lun_id %llX has been cloned. Clone "
> +			 "count = %X\n", __func__, to_free, ba_lun->lun_id,
> +			 lun_info->aun_clone_map[to_free]);
> +		lun_info->aun_clone_map[to_free]--;
> +		return 0;
> +	}
> +
> +	idx = to_free / 64;
> +	bit_pos = to_free % 64;
> +
> +	set_bit(bit_pos, (ulong *)&lun_info->lun_alloc_map[idx]);
> +	lun_info->free_aun_cnt++;
> +
> +	if (idx < lun_info->free_low_idx)
> +		lun_info->free_low_idx = idx;
> +	else if (idx > lun_info->free_high_idx)
> +		lun_info->free_high_idx = idx;
> +
> +	pr_debug("%s: Successfully freed AU at bit_pos %X, bit map index %X on "
> +		 "lun_id %llX, free_aun_cnt = %llX\n", __func__, bit_pos, idx,
> +		 ba_lun->lun_id, lun_info->free_aun_cnt);
> +
> +	return 0;
> +}
> +
> +/**
> + * ba_clone() - frees a block from the block allocator
> + * @ba_lun:	Block allocator from which to allocate a block.
> + * @to_free:	Block to free.
> + *
> + * Return: 0 on success, -1 on failure
> + */

More accurate description about ba_clone() function.

> +static int ba_clone(struct ba_lun *ba_lun, u64 to_clone)
> +{
> +	struct ba_lun_info *lun_info =
> +	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	if (validate_alloc(lun_info, to_clone)) {
> +		pr_err("%s: AUN %llX is not allocated on lun_id %llX\n",
> +		       __func__, to_clone, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	pr_debug("%s: Received a request to clone AUN %llX on lun_id %llX\n",
> +		 __func__, to_clone, ba_lun->lun_id);
> +
> +	if (lun_info->aun_clone_map[to_clone] == MAX_AUN_CLONE_CNT) {
> +		pr_err("%s: AUN %llX on lun_id %llX hit max clones already\n",
> +		       __func__, to_clone, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	lun_info->aun_clone_map[to_clone]++;
> +
> +	return 0;
> +}
> +/**
> + * init_ba() - initializes and allocates a block allocator
> + * @lun_info:	LUN information structure that owns the block allocator.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int init_ba(struct llun_info *lli)
> +{
> +	int rc = 0;
> +	struct glun_info *gli = lli->parent;
> +	struct blka *blka = &gli->blka;
> +
> +	memset(blka, 0, sizeof(*blka));
> +	mutex_init(&blka->mutex);
> +
> +	/* LUN IDs are unique per port, save the index instead */
> +	blka->ba_lun.lun_id = lli->lun_index;
> +	blka->ba_lun.lsize = gli->max_lba + 1;
> +	blka->ba_lun.lba_size = gli->blk_len;
> +
> +	blka->ba_lun.au_size = MC_CHUNK_SIZE;
> +	blka->nchunk = blka->ba_lun.lsize / MC_CHUNK_SIZE;
> +
> +	rc = ba_init(&blka->ba_lun);

init_ba() and ba_init(). Probably one of them needs more accurate name.

> +	if (rc) {
> +		pr_err("%s: cannot init block_alloc, rc=%d\n", __func__, rc);
> +		goto init_ba_exit;
> +	}
> +
> +init_ba_exit:
> +	pr_debug("%s: returning rc=%d lli=%p\n", __func__, rc, lli);
> +	return rc;
> +}
> +
> +/**
> + * write_same16() - sends a SCSI WRITE_SAME16 (0) command to specified LUN
> + * @sdev:	SCSI device associated with LUN.
> + * @lba:	Logical block address to start write same.
> + * @nblks:	Number of logical blocks to write same.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int write_same16(struct scsi_device *sdev,
> +			u64 lba,
> +			u32 nblks)
> +{
> +	u8 scsi_cmd[MAX_COMMAND_SIZE];
> +	u8 *cmd_buf = NULL;
> +	u8 *sense_buf = NULL;
> +	int rc = 0;
> +	int result = 0;
> +	int ws_limit = SISLITE_MAX_WS_BLOCKS;
> +	u64 offset = lba;
> +	int left = nblks;
> +
> +	memset(scsi_cmd, 0, sizeof(scsi_cmd));
> +	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
> +	sense_buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
> +	if (!cmd_buf || !sense_buf) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	while (left > 0) {
> +
> +		scsi_cmd[0] = WRITE_SAME_16;
> +		put_unaligned_be64(offset, &scsi_cmd[2]);
> +		put_unaligned_be32(ws_limit < left ? ws_limit : left,
> +				   &scsi_cmd[10]);
> +
> +		left -= ws_limit;
> +		offset += ws_limit;
> +
> +		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
> +				      CMD_BUFSIZE, sense_buf,
> +				      (MC_DISCOVERY_TIMEOUT*HZ), 5, 0, NULL);
> +
> +		if (result) {
> +			pr_err("%s: command failed for offset %lld"
> +			      " result=0x%x\n", __func__, offset, result);
> +			rc = -EIO;

free cmd_buf and sense_buf?

> +			goto out;
> +		}
> +	}
> +
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +
> +/**
> + * grow_lxt() - expands the translation table associated with the  
> specified RHTE
> + * @afu:	AFU associated with the host.
> + * @sdev:	SCSI device associated with LUN.
> + * @ctxid:	Context ID of context owning the RHTE.
> + * @rhndl:	Resource handle associated with the RHTE.
> + * @rhte:	Resource handle entry (RHTE).
> + * @new_size:	Number of translation entries associated with RHTE.
> + * @port_sel:	Port selection mask.
> + *
> + * By design, this routine employs a 'best attempt' allocation and will
> + * truncate the requested size down if there is not sufficient space in
> + * the block allocator to satisfy the request but there does exist some
> + * amount of space. The user is made aware of this by returning the size
> + * allocated.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int grow_lxt(struct afu *afu,
> +		    struct scsi_device *sdev,
> +		    ctx_hndl_t ctxid,
> +		    res_hndl_t rhndl,
> +		    struct sisl_rht_entry *rhte,
> +		    u64 *new_size)
> +{
> +	struct sisl_lxt_entry *lxt = NULL, *lxt_old = NULL;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct blka *blka = &gli->blka;
> +	u32 av_size;
> +	u32 ngrps, ngrps_old;
> +	u64 aun;		/* chunk# allocated by block allocator */
> +	u64 delta = *new_size - rhte->lxt_cnt;
> +	u64 my_new_size;
> +	int i, rc = 0;
> +
> +	/*
> +	 * Check what is available in the block allocator before re-allocating
> +	 * LXT array. This is done up front under the mutex which must not be
> +	 * released until after allocation is complete.
> +	 */
> +	mutex_lock(&blka->mutex);
> +	av_size = ba_space(&blka->ba_lun);
> +	if (unlikely(av_size <= 0)) {
> +		pr_err("%s: ba_space error: av_size %d\n", __func__, av_size);
> +		mutex_unlock(&blka->mutex);
> +		rc = -ENOSPC;
> +		goto out;
> +	}
> +
> +	if (av_size < delta)
> +		delta = av_size;
> +
> +	lxt_old = rhte->lxt_start;
> +	ngrps_old = LXT_NUM_GROUPS(rhte->lxt_cnt);
> +	ngrps = LXT_NUM_GROUPS(rhte->lxt_cnt + delta);
> +
> +	if (ngrps != ngrps_old) {
> +		/* reallocate to fit new size */
> +		lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
> +			      GFP_KERNEL);
> +		if (unlikely(!lxt)) {
> +			mutex_unlock(&blka->mutex);
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		/* copy over all old entries */
> +		memcpy(lxt, lxt_old, (sizeof(*lxt) * rhte->lxt_cnt));
> +	} else
> +		lxt = lxt_old;
> +
> +	/* nothing can fail from now on */
> +	my_new_size = rhte->lxt_cnt + delta;
> +
> +	/* add new entries to the end */
> +	for (i = rhte->lxt_cnt; i < my_new_size; i++) {
> +		/*
> +		 * Due to the earlier check of available space, ba_alloc
> +		 * cannot fail here. If it did due to internal error,
> +		 * leave a rlba_base of -1u which will likely be a
> +		 * invalid LUN (too large).
> +		 */
> +		aun = ba_alloc(&blka->ba_lun);
> +		if ((aun == -1ULL) || (aun >= blka->nchunk))
> +			pr_err("%s: ba_alloc error: allocated chunk# %llX, "
> +			       "max %llX\n", __func__, aun, blka->nchunk - 1);
> +
> +		/* select both ports, use r/w perms from RHT */
> +		lxt[i].rlba_base = ((aun << MC_CHUNK_SHIFT) |
> +				    (lli->lun_index << LXT_LUNIDX_SHIFT) |
> +				    (RHT_PERM_RW << LXT_PERM_SHIFT |
> +				     lli->port_sel));
> +	}
> +
> +	mutex_unlock(&blka->mutex);
> +

Should hold the lock for lightwight sync?

> +	/*
> +	 * The following sequence is prescribed in the SISlite spec
> +	 * for syncing up with the AFU when adding LXT entries.
> +	 */
> +	dma_wmb(); /* Make LXT updates are visible */
> +
> +	rhte->lxt_start = lxt;
> +	dma_wmb(); /* Make RHT entry's LXT table update visible */
> +
> +	rhte->lxt_cnt = my_new_size;
> +	dma_wmb(); /* Make RHT entry's LXT table size update visible */
> +
> +	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
> +
> +	/* free old lxt if reallocated */
> +	if (lxt != lxt_old)
> +		kfree(lxt_old);
> +	*new_size = my_new_size;
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +
> +/**
> + * shrink_lxt() - reduces translation table associated with the  
> specified RHTE
> + * @afu:	AFU associated with the host.
> + * @sdev:	SCSI device associated with LUN.
> + * @ctxid:	Context ID of context owning the RHTE.
> + * @rhndl:	Resource handle associated with the RHTE.
> + * @rhte:	Resource handle entry (RHTE).
> + * @new_size:	Number of translation entries associated with RHTE.
> + * @port_sel:	Port selection mask.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int shrink_lxt(struct afu *afu,
> +		      struct scsi_device *sdev,
> +		      ctx_hndl_t ctxid,
> +		      res_hndl_t rhndl,
> +		      struct sisl_rht_entry *rhte,
> +		      u64 *new_size)
> +{
> +	struct sisl_lxt_entry *lxt, *lxt_old;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct blka *blka = &gli->blka;
> +	u32 ngrps, ngrps_old;
> +	u64 aun;		/* chunk# allocated by block allocator */
> +	u64 delta = rhte->lxt_cnt - *new_size;
> +	u64 my_new_size;
> +	int i, rc = 0;
> +
> +	lxt_old = rhte->lxt_start;
> +	ngrps_old = LXT_NUM_GROUPS(rhte->lxt_cnt);
> +	ngrps = LXT_NUM_GROUPS(rhte->lxt_cnt - delta);
> +
> +	if (ngrps != ngrps_old) {
> +		/* reallocate to fit new size unless new size is 0 */
> +		if (ngrps) {
> +			lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
> +				      GFP_KERNEL);
> +			if (unlikely(!lxt)) {
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +
> +			/* copy over old entries that will remain */
> +			memcpy(lxt, lxt_old,
> +			       (sizeof(*lxt) * (rhte->lxt_cnt - delta)));
> +		} else
> +			lxt = NULL;
> +	} else
> +		lxt = lxt_old;
> +
> +	/* nothing can fail from now on */
> +	my_new_size = rhte->lxt_cnt - delta;
> +
> +	/*
> +	 * The following sequence is prescribed in the SISlite spec
> +	 * for syncing up with the AFU when removing LXT entries.
> +	 */
> +	rhte->lxt_cnt = my_new_size;
> +	dma_wmb(); /* Make RHT entry's LXT table size update visible */
> +
> +	rhte->lxt_start = lxt;
> +	dma_wmb(); /* Make RHT entry's LXT table update visible */
> +

Should hold the lock for lightwight sync?

> +	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
> +
> +	/* free LBAs allocated to freed chunks */
> +	mutex_lock(&blka->mutex);
> +	for (i = delta - 1; i >= 0; i--) {
> +		/* Mask the higher 48 bits before shifting, even though
> +		 * it is a noop
> +		 */
> +		aun = (lxt_old[my_new_size + i].rlba_base & SISL_ASTATUS_MASK);
> +		aun = (aun >> MC_CHUNK_SHIFT);
> +		write_same16(sdev, aun, MC_CHUNK_SIZE);
> +		ba_free(&blka->ba_lun, aun);
> +	}
> +	mutex_unlock(&blka->mutex);
> +
> +	/* free old lxt if reallocated */
> +	if (lxt != lxt_old)
> +		kfree(lxt_old);
> +	*new_size = my_new_size;
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +

> +
> +/**
> + * cxlflash_disk_virtual_open() - open a virtual disk of specified size
> + * @sdev:	SCSI device associated with LUN owning virtual LUN.
> + * @arg:	UVirtual ioctl data structure.
> + *
> + * On successful return, the user is informed of the resource handle
> + * to be used to identify the virtual lun and the size (in blocks) of
> + * the virtual lun in last LBA format. When the size of the virtual lun
> + * is zero, the last LBA is reflected as -1.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +
> +	struct dk_cxlflash_uvirtual *virt = (struct dk_cxlflash_uvirtual *)arg;
> +	struct dk_cxlflash_resize resize;
> +
> +	u64 ctxid = DECODE_CTXID(virt->context_id),
> +	    rctxid = virt->context_id;
> +	u64 lun_size = virt->lun_size;
> +	u64 last_lba = 0;
> +	u64 rsrc_handle = -1;
> +
> +	int rc = 0;
> +
> +	struct ctx_info *ctxi = NULL;
> +	struct sisl_rht_entry *rhte = NULL;
> +
> +	pr_debug("%s: ctxid=%llu ls=0x%llx\n", __func__, ctxid, lun_size);
> +
> +	if (gli->mode == MODE_NONE) {
> +		/* Setup the LUN table on the first call */
> +		rc = init_lun_table(cfg, lli);
> +		if (rc) {
> +			pr_err("%s: call to init_lun_table failed rc=%d!\n",
> +			       __func__, rc);
> +			goto out;
> +		}
> +
> +		rc = init_ba(lli);
> +		if (rc) {
> +			pr_err("%s: call to init_ba failed rc=%d!\n",
> +			       __func__, rc);
> +			rc = -ENOMEM;

Do you need to remove the entry you create in init_lun_table() if  
init_ba() fails?

> +			goto out;
> +		}
> +	}
> +
> +	rc = cxlflash_lun_attach(gli, MODE_VIRTUAL);
> +	if (unlikely(rc)) {
> +		pr_err("%s: Failed to attach to LUN! (VIRTUAL)\n", __func__);
> +		goto out;
> +	}
> +
> +	ctxi = get_context(cfg, rctxid, lli, 0);
> +	if (unlikely(!ctxi)) {
> +		pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto err1;
> +	}
> +
> +	rhte = rhte_checkout(ctxi, lli);
> +	if (unlikely(!rhte)) {
> +		pr_err("%s: too many opens for this context\n", __func__);
> +		rc = -EMFILE;	/* too many opens  */
> +		goto err1;
> +	}

Thanks,
Wendy

