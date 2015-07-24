From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/3] cxlflash: Virtual LUN support
Date: Fri, 24 Jul 2015 15:15:29 -0500
Message-ID: <55B29CE1.4030708@linux.vnet.ibm.com>
References: <1437089217-52200-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57686 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbGXUPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2015 16:15:38 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 24 Jul 2015 14:15:37 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id CD1F63E4003F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 14:15:33 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6OKCvOi39780484
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 13:12:57 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6OKFVcg010746
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2015 14:15:33 -0600
In-Reply-To: <1437089217-52200-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 07/16/2015 06:26 PM, Matthew R. Ochs wrote:
> +
> +/**
> + * ba_clone() - frees a block from the block allocator
> + * @ba_lun:	Block allocator from which to allocate a block.
> + * @to_free:	Block to free.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int ba_clone(struct ba_lun *ba_lun, u64 to_clone)
> +{
> +	struct ba_lun_info *lun_info =
> +	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	if (validate_alloc(lun_info, to_clone)) {
> +		pr_err("%s: AUN %llX is not allocated on lun_id %llX\n",
> +		       __func__, to_clone, ba_lun->lun_id);

Suggest using dev_err here instead to scope the error to the adapter.

> +		return -1;

Might be nice to return a better error to the user in both of the error cases
in this code.

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
> +


> +
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
> +	if (rc) {
> +		pr_err("%s: cannot init block_alloc, rc=%d\n", __func__, rc);
> +		goto init_ba_exit;

The goto here is unnecessary

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

5 seconds seems a little on the short side for this command. Perhaps using
sdev->request_queue->rq_timeout would be better?

> +
> +		if (result) {
> +			pr_err("%s: command failed for offset %lld"
> +			      " result=0x%x\n", __func__, offset, result);
> +			rc = -EIO;
> +			goto out;
> +		}
> +	}
> +
> +out:

You need to free cmd_buf and sense_buf here.

> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +

> +
> +/**
> + * _cxlflash_vlun_resize() - changes the size of a virtual lun
> + * @sdev:	SCSI device associated with LUN owning virtual LUN.
> + * @ctxi:	Context owning resources.
> + * @resize:	Resize ioctl data structure.
> + *
> + * On successful return, the user is informed of the new size (in blocks)
> + * of the virtual lun in last LBA format. When the size of the virtual
> + * lun is zero, the last LBA is reflected as -1.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int _cxlflash_vlun_resize(struct scsi_device *sdev,
> +			  struct ctx_info *ctxi,
> +			  struct dk_cxlflash_resize *resize)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct afu *afu = cfg->afu;
> +	bool unlock_ctx = false;
> +
> +	res_hndl_t rhndl = resize->rsrc_handle;
> +	u64 new_size;
> +	u64 nsectors;
> +	u64 ctxid = DECODE_CTXID(resize->context_id),
> +	    rctxid = resize->context_id;
> +
> +	struct sisl_rht_entry *rhte;
> +
> +	int rc = 0;
> +
> +	/* req_size is always assumed to be in 4k blocks. So we have to convert
> +	 * it from 4k to chunk size
> +	 */
> +	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
> +	new_size = (nsectors + MC_CHUNK_SIZE - 1) / MC_CHUNK_SIZE;

Use DIV_ROUND_UP instead.

> +
> +	pr_debug("%s: ctxid=%llu rhndl=0x%llx, req_size=0x%llx,"
> +		 "new_size=%llx\n", __func__, ctxid, resize->rsrc_handle,
> +		 resize->req_size, new_size);
> +
> +	if (unlikely(gli->mode != MODE_VIRTUAL)) {
> +		pr_err("%s: LUN mode does not support resize! (%d)\n",
> +		       __func__, gli->mode);
> +		rc = -EINVAL;
> +		goto out;
> +
> +	}
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
> +		pr_err("%s: Bad resource handle! (%u)\n", __func__, rhndl);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (new_size > rhte->lxt_cnt)
> +		rc = grow_lxt(afu,
> +			      sdev,
> +			      ctxid,
> +			      rhndl,
> +			      rhte,
> +			      &new_size);
> +	else if (new_size < rhte->lxt_cnt)
> +		rc = shrink_lxt(afu,
> +				sdev,
> +				ctxid,
> +				rhndl,
> +				rhte,
> +				&new_size);
> +
> +	resize->hdr.return_flags = 0;
> +	resize->last_lba = (new_size * MC_CHUNK_SIZE * gli->blk_len);
> +	resize->last_lba /= CXLFLASH_BLOCK_SIZE;
> +	resize->last_lba--;
> +
> +out:
> +	if (unlock_ctx)
> +		mutex_unlock(&ctxi->mutex);
> +	pr_debug("%s: resized to %lld returning rc=%d\n",
> +		 __func__, resize->last_lba, rc);
> +	return rc;
> +}
> +
> +int cxlflash_vlun_resize(struct scsi_device *sdev,
> +			 struct dk_cxlflash_resize *resize)
> +{
> +	return _cxlflash_vlun_resize(sdev, NULL, resize);
> +}
> +
> +/**
> + * init_lun_table() - write an entry in the LUN table
> + * @cfg:        Internal structure associated with the host.
> + * @lli:	Per adapter LUN information structure.
> + *
> + * On successful return, a LUN table entry is created.
> + * At the top for LUNs visible on both ports.
> + * At the bottom for LUNs visible only on one port.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int init_lun_table(struct cxlflash_cfg *cfg, struct llun_info *lli)
> +{
> +	u32 chan;
> +	int rc = 0;
> +	struct afu *afu = cfg->afu;
> +
> +	if (lli->in_table)
> +		goto out;
> +
> +	if (lli->port_sel == BOTH_PORTS) {
> +		/*
> +		 * If this LUN is visible from both ports, we will put
> +		 * it in the top half of the LUN table.
> +		 */
> +		if ((cfg->promote_lun_index == cfg->last_lun_index[0]) ||
> +		    (cfg->promote_lun_index == cfg->last_lun_index[1])) {
> +			rc = -ENOSPC;
> +			goto out;
> +		}
> +
> +		lli->lun_index = cfg->promote_lun_index;
> +		writeq_be(lli->lun_id[0],
> +			  &afu->afu_map->global.fc_port[0]
> +			  [cfg->promote_lun_index]);

Would improve readability IMHO if you either put the second parm all on one
line or used a local variable to make it better fit on one line, rather than
line breaking where you did.

> +		writeq_be(lli->lun_id[1],
> +			  &afu->afu_map->global.fc_port[1]
> +			  [cfg->promote_lun_index]);
> +		cfg->promote_lun_index++;
> +		pr_debug("%s: Virtual LUN on slot %d  id0=%llx, id1=%llx\n",
> +			 __func__, lli->lun_index, lli->lun_id[0],
> +			 lli->lun_id[1]);

Suggest changing the pr_debug calls to dev_dbg calls where possible to scope
the messages to an adapter.

> +	} else {
> +		/*
> +		 * If this LUN is visible only from one port, we will put
> +		 * it in the bottom half of the LUN table.
> +		 */
> +		chan = PORT2CHAN(lli->port_sel);
> +		if (cfg->promote_lun_index == cfg->last_lun_index[chan]) {
> +			rc = -ENOSPC;
> +			goto out;
> +		}
> +
> +		lli->lun_index = cfg->last_lun_index[chan];
> +		writeq_be(lli->lun_id[chan],
> +			  &afu->afu_map->global.fc_port[chan]
> +			  [cfg->last_lun_index[chan]]);
> +		cfg->last_lun_index[chan]--;
> +		pr_debug("%s: Virtual LUN on slot %d  chan=%d, id=%llx\n",
> +			 __func__, lli->lun_index, chan, lli->lun_id[chan]);
> +	}
> +
> +	lli->in_table = true;
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


