From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cxlflash: Base superpipe support
Date: Fri, 10 Jul 2015 14:49:17 -0500
Message-ID: <55A021BD.5090501@linux.vnet.ibm.com>
References: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60247 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbbGJTtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 15:49:22 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 10 Jul 2015 13:49:22 -0600
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id A5602C9003E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2015 15:40:25 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6AJnJt062980326
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2015 19:49:19 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6AJnHFh028452
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2015 15:49:18 -0400
In-Reply-To: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 06/19/2015 05:37 PM, Matthew R. Ochs wrote:
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 76a7286..2773177 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -679,10 +679,13 @@ static struct scsi_host_template driver_template = {
>  	.module = THIS_MODULE,
>  	.name = CXLFLASH_ADAPTER_NAME,
>  	.info = cxlflash_driver_info,
> +	.ioctl = cxlflash_ioctl,
>  	.proc_name = CXLFLASH_NAME,
>  	.queuecommand = cxlflash_queuecommand,
>  	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
>  	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
> +	.slave_alloc = cxlflash_slave_alloc,
> +	.slave_configure = cxlflash_slave_configure,
>  	.change_queue_depth = cxlflash_change_queue_depth,
>  	.cmd_per_lun = 16,
>  	.can_queue = CXLFLASH_MAX_CMDS,
> @@ -2198,9 +2201,12 @@ static int cxlflash_probe(struct pci_dev *pdev,
> 
>  	cfg->init_state = INIT_STATE_NONE;
>  	cfg->dev = pdev;
> +	cfg->last_lun_index[0] = 0;
> +	cfg->last_lun_index[1] = 0;
>  	cfg->dev_id = (struct pci_device_id *)dev_id;
>  	cfg->mcctx = NULL;
>  	cfg->err_recovery_active = 0;
> +	cfg->num_user_contexts = 0;

No need to set these to zero, since they get allocated via scsi_host_alloc,
which zeroes the memory for you.

> 
>  	init_waitqueue_head(&cfg->tmf_waitq);
>  	init_waitqueue_head(&cfg->eeh_waitq);

> --- /dev/null
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -0,0 +1,1856 @@
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
> +#include <linux/delay.h>
> +#include <linux/file.h>
> +#include <linux/moduleparam.h>
> +#include <linux/syscalls.h>
> +#include <misc/cxl.h>
> +#include <asm/unaligned.h>
> +
> +#include <scsi/scsi_host.h>
> +#include <uapi/scsi/cxlflash_ioctl.h>
> +
> +#include "sislite.h"
> +#include "common.h"
> +#include "superpipe.h"
> +
> +struct cxlflash_global global;
> +
> +/**
> + * marshall_det_to_rele() - translate detach to release structure
> + * @detach:	Destination structure for the translate/copy.
> + * @rele:	Source structure from which to translate/copy.
> + */
> +static void marshall_det_to_rele(struct dk_cxlflash_detach *detach,
> +				 struct dk_cxlflash_release *release)
> +{
> +	release->hdr = detach->hdr;
> +	release->context_id = detach->context_id;

Function name could be better. Marshal should have only one 'l' in this usage...

> +}
> +
> +/**
> + * create_lun_info() - allocate and initialize a LUN information structure
> + * @sdev:	SCSI device associated with LUN.
> + *
> + * Return: Allocated lun_info structure on success, NULL on failure
> + */
> +static struct lun_info *create_lun_info(struct scsi_device *sdev)
> +{
> +	struct lun_info *lun_info = NULL;
> +
> +	lun_info = kzalloc(sizeof(*lun_info), GFP_KERNEL);
> +	if (unlikely(!lun_info)) {
> +		pr_err("%s: could not allocate lun_info\n", __func__);
> +		goto create_lun_info_exit;
> +	}
> +
> +	lun_info->sdev = sdev;
> +
> +	spin_lock_init(&lun_info->slock);
> +
> +create_lun_info_exit:
> +	return lun_info;
> +}
> +
> +/**
> + * lookup_lun() - find or create a LUN information structure
> + * @sdev:	SCSI device associated with LUN.
> + * @wwid:	WWID associated with LUN.
> + *
> + * Return: Found/Allocated lun_info structure on success, NULL on failure
> + */
> +static struct lun_info *lookup_lun(struct scsi_device *sdev, __u8 *wwid)
> +{
> +	struct lun_info *lun_info, *temp;
> +	ulong flags = 0UL;
> +
> +	if (wwid)
> +		list_for_each_entry_safe(lun_info, temp, &global.luns, list) {
> +			if (!memcmp(lun_info->wwid, wwid,
> +				    DK_CXLFLASH_MANAGE_LUN_WWID_LEN))
> +				return lun_info;
> +		}

You probably want to be grabbing global.slock hre, right? list_for_each_entry_safe doesn't protect
you from other threads deleting things off the list, it only allows you to delete
entries off the list in your loop and continue to iterate.

> +
> +	lun_info = create_lun_info(sdev);
> +	if (unlikely(!lun_info))
> +		goto out;
> +
> +	spin_lock_irqsave(&global.slock, flags);
> +	if (wwid)
> +		memcpy(lun_info->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN);
> +	list_add(&lun_info->list, &global.luns);
> +	spin_unlock_irqrestore(&global.slock, flags);
> +
> +out:
> +	pr_debug("%s: returning %p\n", __func__, lun_info);
> +	return lun_info;
> +}
> +
> +/**
> + * cxlflash_slave_alloc() - allocate and associate LUN information structure
> + * @sdev:	SCSI device associated with LUN.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_slave_alloc(struct scsi_device *sdev)
> +{
> +	int rc = 0;
> +	struct lun_info *lun_info = NULL;
> +
> +	lun_info = lookup_lun(sdev, NULL);
> +	if (unlikely(!lun_info)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	sdev->hostdata = lun_info;
> +
> +out:
> +	pr_debug("%s: returning sdev %p rc=%d\n", __func__, sdev, rc);
> +	return rc;
> +}
> +
> +/**
> + * cxlflash_slave_configure() - configure and make device aware of LUN
> + * @sdev:	SCSI device associated with LUN.
> + *
> + * Stores the LUN id and lun_index and programs the AFU's LUN mapping table.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_slave_configure(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct cxlflash_cfg *cfg = shost_priv(shost);
> +	struct afu *afu = cfg->afu;
> +
> +	pr_debug("%s: id = %d/%d/%d/%llu\n", __func__, shost->host_no,
> +		 sdev->channel, sdev->id, sdev->lun);
> +
> +	/* Store off lun in unpacked, AFU-friendly format */
> +	lun_info->lun_id = lun_to_lunid(sdev->lun);
> +	lun_info->lun_index = cfg->last_lun_index[sdev->channel];
> +
> +	writeq_be(lun_info->lun_id,
> +		  &afu->afu_map->global.fc_port[sdev->channel]
> +		  [cfg->last_lun_index[sdev->channel]++]);

Do you need a slave_destroy that undoes this and makes the AFU forget
about this LUN? I'm thinking you probably want to also destroy any
user contexts to this device in slave_destroy as well. Otherwise
if you have a superpipe open to a scsi_device and someone deletes that
scsi_device through sysfs, you will have an open superpipe to that
device still and no way to tear it down since you don't have a
way to issue the detach ioctl any longer.

> +
> +	return 0;
> +}
> +
> +/**
> + * cxlflash_list_init() - initializes the global LUN list
> + */
> +void cxlflash_list_init(void)
> +{
> +	INIT_LIST_HEAD(&global.luns);
> +	spin_lock_init(&global.slock);
> +	global.err_page = NULL;
> +}
> +
> +/**
> + * cxlflash_list_terminate() - frees resources associated with global LUN list
> + */
> +void cxlflash_list_terminate(void)
> +{
> +	struct lun_info *lun_info, *temp;
> +	ulong flags = 0;
> +
> +	spin_lock_irqsave(&global.slock, flags);> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> new file mode 100644
> index 0000000..1bf9f60
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -0,0 +1,210 @@
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
> +/*----------------------------------------------------------------------------*/
> +/* Constants                                                                  */
> +/*----------------------------------------------------------------------------*/
> +
> +#define SL_INI_SINI_MARKER      0x53494e49
> +#define SL_INI_ELMD_MARKER      0x454c4d44
> +/*----------------------------------------------------------------------------*/
> +/* Types                                                                      */
> +/*----------------------------------------------------------------------------*/
> +
> +#define MAX_AUN_CLONE_CNT    0xFF
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
> +#define MC_RHT_NMASK      16	/* in bits */
> +#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs, see mclient.h */
> +#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
> +
> +/* LXT tables are allocated dynamically in groups. This is done to
> +   avoid a malloc/free overhead each time the LXT has to grow
> +   or shrink.
> +
> +   Based on the current lxt_cnt (used), it is always possible to
> +   know how many are allocated (used+free). The number of allocated
> +   entries is not stored anywhere.
> +
> +   The LXT table is re-allocated whenever it needs to cross into
> +   another group.
> +*/
> +#define LXT_GROUP_SIZE          8
> +#define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
> +
> +#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
> +
> +enum lun_mode {
> +	MODE_NONE = 0,
> +	MODE_VIRTUAL,
> +	MODE_PHYSICAL
> +};
> +
> +/* SCSI Defines                                                          */
> +
> +struct request_sense_data  {
> +	uint8_t     err_code;        /* error class and code   */
> +	uint8_t     rsvd0;
> +	uint8_t     sense_key;
> +#define CXLFLASH_VENDOR_UNIQUE         0x09
> +#define CXLFLASH_EQUAL_CMD             0x0C
> +	uint8_t     sense_byte0;
> +	uint8_t     sense_byte1;
> +	uint8_t     sense_byte2;
> +	uint8_t     sense_byte3;
> +	uint8_t     add_sense_length;
> +	uint8_t     add_sense_byte0;
> +	uint8_t     add_sense_byte1;
> +	uint8_t     add_sense_byte2;
> +	uint8_t     add_sense_byte3;
> +	uint8_t     add_sense_key;
> +	uint8_t     add_sense_qualifier;
> +	uint8_t     fru;
> +	uint8_t     flag_byte;
> +	uint8_t     field_ptrM;
> +	uint8_t     field_ptrL;
> +};
> +
> +struct ba_lun {
> +	u64 lun_id;
> +	u64 wwpn;
> +	size_t lsize;		/* LUN size in number of LBAs             */
> +	size_t lba_size;	/* LBA size in number of bytes            */
> +	size_t au_size;		/* Allocation Unit size in number of LBAs */
> +	void *ba_lun_handle;
> +};
> +
> +struct ba_lun_info {
> +	u64 *lun_alloc_map;
> +	u32 lun_bmap_size;
> +	u32 total_aus;
> +	u64 free_aun_cnt;
> +
> +	/* indices to be used for elevator lookup of free map */
> +	u32 free_low_idx;
> +	u32 free_curr_idx;
> +	u32 free_high_idx;
> +
> +	u8 *aun_clone_map;
> +};
> +
> +/* Block Allocator */
> +struct blka {
> +	struct ba_lun ba_lun;
> +	u64 nchunk;		/* number of chunks */
> +	struct mutex mutex;
> +};
> +
> +/* LUN discovery results are in lun_info */
> +struct lun_info {
> +	u64 lun_id;		/* from REPORT_LUNS */
> +	u64 max_lba;		/* from read cap(16) */
> +	u32 blk_len;		/* from read cap(16) */
> +	u32 lun_index;
> +	int users;		/* Number of users w/ references to LUN */
> +	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
> +
> +	__u8 wwid[16];
> +
> +	spinlock_t slock;
> +
> +	struct blka blka;
> +	struct scsi_device *sdev;
> +	struct list_head list;
> +};
> +
> +struct lun_access {
> +	struct lun_info *lun_info;
> +	struct scsi_device *sdev;
> +	struct list_head list;
> +};
> +
> +enum ctx_ctrl {
> +	CTX_CTRL_CLONE		= (1 << 1),
> +	CTX_CTRL_ERR		= (1 << 2),
> +	CTX_CTRL_ERR_FALLBACK	= (1 << 3),
> +	CTX_CTRL_NOPID		= (1 << 4)
> +};
> +
> +#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0) << 28) | _id)
> +#define DECODE_CTXID(_val)	(_val & 0xFFFFFFFF)
> +
> +struct ctx_info {
> +	struct sisl_ctrl_map *ctrl_map; /* initialized at startup */
> +	struct sisl_rht_entry *rht_start; /* 1 page (req'd for alignment),
> +					     alloc/free on attach/detach */
> +	u32 rht_out;		/* Number of checked out RHT entries */
> +	u32 rht_perms;		/* User-defined permissions for RHT entries */
> +	struct lun_info **rht_lun; /* Mapping of RHT entries to LUNs */
> +
> +	struct cxl_ioctl_start_work work;
> +	u64 ctxid;
> +	int lfd;
> +	pid_t pid;
> +	atomic_t nrefs;	/* Number of active references, must be 0 for removal */
> +	bool err_recovery_active;
> +	struct cxl_context *ctx;
> +	struct list_head luns;	/* LUNs attached to this context */
> +	const struct vm_operations_struct *cxl_mmap_vmops;
> +	struct address_space *mapping;
> +	struct list_head list; /* Link contexts in error recovery */
> +};
> +
> +struct cxlflash_global {
> +	spinlock_t slock;
> +	struct list_head luns;  /* list of lun_info structs */
> +	struct page *err_page; /* One page of all 0xF for error notification */
> +};
> +
> +
> +int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
> +
> +int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
> +
> +int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
> +
> +int cxlflash_disk_virtual_open(struct scsi_device *, void *);
> +
> +int cxlflash_lun_attach(struct lun_info *, enum lun_mode);
> +void cxlflash_lun_detach(struct lun_info *);
> +
> +int cxlflash_check_status(struct afu_cmd *);
> +
> +struct ctx_info *get_context(struct cxlflash_cfg *, u64, struct lun_info *,
> +			     enum ctx_ctrl);
> +
> +struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
> +				struct lun_info *);
> +
> +struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct lun_info *);
> +void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
> +
> +void cxlflash_ba_terminate(struct ba_lun *);
> +
> +#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
> +	list_for_each_entry_safe(lun_info, temp, &global.luns, list) {
> +		list_del(&lun_info->list);
> +		kfree(lun_info);
> +	}
> +
> +	if (global.err_page) {
> +		__free_page(global.err_page);
> +		global.err_page = NULL;
> +	}
> +	spin_unlock_irqrestore(&global.slock, flags);
> +}
> +
> +/**
> + * find_error_context() - locates a context by cookie on the error recovery list
> + * @cfg:	Internal structure associated with the host.
> + * @ctxid:	Desired context.
> + *
> + * Return: Found context on success, NULL on failure
> + */
> +static struct ctx_info *find_error_context(struct cxlflash_cfg *cfg, u64 ctxid)
> +{
> +	struct ctx_info *ctx_info;
> +
> +	list_for_each_entry(ctx_info, &cfg->ctx_err_recovery, list)
> +		if (ctx_info->ctxid == ctxid)
> +			return ctx_info;
> +
> +	return NULL;
> +}
> +
> +/**
> + * get_context() - obtains a validated context reference
> + * @cfg:	Internal structure associated with the host.
> + * @ctxid:	Desired context.
> + * @lun_info:	LUN associated with request.
> + * @ctx_ctrl:	Control information to 'steer' desired lookup.
> + *
> + * NOTE: despite the name pid, in linux, current->pid actually refers
> + * to the lightweight process id (tid) and can change if the process is
> + * multi threaded. The tgid remains constant for the process and only changes
> + * when the process of fork. For all intents and purposes, think of tgid
> + * as a pid in the traditional sense.
> + *
> + * Return: Validated context on success, NULL on failure
> + */
> +struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 ctxid,
> +			     struct lun_info *lun_info, enum ctx_ctrl ctx_ctrl)
> +{
> +	struct ctx_info *ctx_info = NULL;
> +	struct lun_access *lun_access = NULL;
> +	bool found = false;
> +	pid_t pid = current->tgid, ctxpid = 0;
> +	ulong flags = 0;
> +
> +	if (unlikely(ctx_ctrl & CTX_CTRL_CLONE))

I'm seeing what is a bit of an overuse of likely / unlikely. Basically, IMHO,
the only place where you should be using these compiler hints is in the performance
path and even then, only when the odds are pretty high that you will go down
the likely path.

> +		pid = current->parent->tgid;
> +
> +	if (likely(ctxid < MAX_CONTEXT)) {
> +		spin_lock_irqsave(&cfg->ctx_tbl_slock, flags);
> +		ctx_info = cfg->ctx_tbl[ctxid];
> +
> +		if (unlikely(ctx_ctrl & CTX_CTRL_ERR))
> +			ctx_info = find_error_context(cfg, ctxid);
> +		if (unlikely(!ctx_info)) {
> +			if (ctx_ctrl & CTX_CTRL_ERR_FALLBACK) {
> +				ctx_info = find_error_context(cfg, ctxid);
> +				if (ctx_info)
> +					goto found_context;
> +			}
> +			spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
> +			goto out;
> +		}
> +found_context:
> +		/*
> +		 * Increment the reference count under lock so the context
> +		 * is not yanked from under us on a removal thread.
> +		 */
> +		atomic_inc(&ctx_info->nrefs);
> +		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
> +
> +		ctxpid = ctx_info->pid;
> +		if (likely(!(ctx_ctrl & CTX_CTRL_NOPID)))
> +			if (pid != ctxpid)
> +				goto denied;
> +
> +		if (likely(lun_info)) {
> +			list_for_each_entry(lun_access, &ctx_info->luns, list)
> +				if (lun_access->lun_info == lun_info) {
> +					found = true;
> +					break;
> +				}

Do we need some locking here?

> +
> +			if (!found)
> +				goto denied;
> +		}
> +	}
> +
> +out:
> +	pr_debug("%s: ctxid=%llu ctxinfo=%p ctxpid=%u pid=%u ctx_ctrl=%u "
> +		 "found=%d\n", __func__, ctxid, ctx_info, ctxpid, pid,
> +		 ctx_ctrl, found);
> +
> +	return ctx_info;
> +
> +denied:
> +	atomic_dec(&ctx_info->nrefs);
> +	ctx_info = NULL;
> +	goto out;
> +}
> +
> +/**
> + * afu_attach() - attach a context to the AFU
> + * @cfg:	Internal structure associated with the host.
> + * @ctx_info:	Context to attach.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctx_info)
> +{
> +	struct afu *afu = cfg->afu;
> +	int rc = 0;
> +	u64 reg;
> +
> +	/* Restrict user to read/write cmds in translated mode */
> +	(void)readq_be(&ctx_info->ctrl_map->mbox_r);	/* unlock ctx_cap */
> +	writeq_be((SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD),
> +		  &ctx_info->ctrl_map->ctx_cap);
> +
> +	reg = readq_be(&ctx_info->ctrl_map->ctx_cap);
> +
> +	/* if the write failed, the ctx must have been
> +	 * closed since the mbox read and the ctx_cap
> +	 * register locked up. Fail the registration.
> +	 */
> +	if (reg != (SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD)) {
> +		pr_err("%s: ctx may be closed reg=%llx\n", __func__, reg);
> +		rc = -EAGAIN;
> +		goto out;
> +	}
> +
> +	/* set up MMIO registers pointing to the RHT */
> +	writeq_be((u64)ctx_info->rht_start, &ctx_info->ctrl_map->rht_start);
> +	writeq_be(SISL_RHT_CNT_ID((u64)MAX_RHT_PER_CONTEXT,
> +				  (u64)(afu->ctx_hndl)),
> +		  &ctx_info->ctrl_map->rht_cnt_id);
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +
> +}
> +
> +/**
> + * cxlflash_check_status() - evaluates the status of an AFU command
> + * @ioasa:	The IOASA of an AFU command.
> + *
> + * Return: 1 when IOASA has error, 0 when IOASA does not have an error
> + */
> +int cxlflash_check_status(struct afu_cmd *cmd)
> +{
> +	struct sisl_ioasa *ioasa = &cmd->sa;
> +	ulong lock_flags;
> +
> +	/* not retrying afu timeouts (B_TIMEOUT) */
> +	/* returns 1 if the cmd should be retried, 0 otherwise */
> +	/* sets B_ERROR flag based on IOASA */
> +
> +	if (ioasa->ioasc == 0)
> +		return 0;
> +
> +	spin_lock_irqsave(&cmd->slock, lock_flags);
> +	ioasa->host_use_b[0] |= B_ERROR;
> +	spin_unlock_irqrestore(&cmd->slock, lock_flags);
> +
> +	if (!(ioasa->host_use_b[1]++ < MC_RETRY_CNT))
> +		return 0;
> +
> +	switch (ioasa->rc.afu_rc) {
> +	case SISL_AFU_RC_NO_CHANNELS:
> +	case SISL_AFU_RC_OUT_OF_DATA_BUFS:
> +		msleep(20);
> +		return 1;
> +
> +	case 0:
> +		/* no afu_rc, but either scsi_rc and/or fc_rc is set */
> +		/* retry all scsi_rc and fc_rc after a small delay */
> +		msleep(20);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * read_cap16() - issues a SCSI READ_CAP16 command
> + * @afu:	AFU associated with the host.
> + * @lun_info:	LUN to destined for capacity request.
> + * @port_sel:	Port to send request.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int read_cap16(struct afu *afu, struct lun_info *lun_info, u32 port_sel)
> +{
> +	struct afu_cmd *cmd = NULL;
> +	int rc = 0;
> +

Suggest using scsi_execute instead. That way it goes up through the block layer
via the normal execution path, should result in less code, and then you also get
error recovery for free. You can then get rid of the nasty looping on cxlflash_check_status.

> +	cmd = cxlflash_cmd_checkout(afu);
> +	if (unlikely(!cmd)) {
> +		pr_err("%s: could not get a free command\n", __func__);
> +		return -1;
> +	}
> +
> +	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
> +			      SISL_REQ_FLAGS_SUP_UNDERRUN |
> +			      SISL_REQ_FLAGS_HOST_READ);
> +
> +	cmd->rcb.port_sel = port_sel;
> +	cmd->rcb.lun_id = lun_info->lun_id;
> +	cmd->rcb.data_len = CMD_BUFSIZE;
> +	cmd->rcb.data_ea = (u64) cmd->buf;
> +	cmd->rcb.timeout = MC_DISCOVERY_TIMEOUT;
> +
> +	cmd->rcb.cdb[0] = 0x9E;	/* read cap(16) */

Use SERVICE_ACTION_IN_16 here

> +	cmd->rcb.cdb[1] = 0x10;	/* service action */

Use SAI_READ_CAPACITY_16 here

> +	put_unaligned_be32(CMD_BUFSIZE, &cmd->rcb.cdb[10]);
> +
> +	pr_debug("%s: sending cmd(0x%x) with RCB EA=%p data EA=0x%llx\n",
> +		 __func__, cmd->rcb.cdb[0], &cmd->rcb, cmd->rcb.data_ea);
> +
> +	do {
> +		rc = cxlflash_send_cmd(afu, cmd);
> +		if (unlikely(rc))
> +			goto out;
> +		cxlflash_wait_resp(afu, cmd);
> +	} while (cxlflash_check_status(cmd));
> +
> +	if (unlikely(cmd->sa.host_use_b[0] & B_ERROR)) {
> +		pr_err("%s: command failed\n", __func__);
> +		rc = -1;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Read cap was successful, grab values from the buffer;
> +	 * note that we don't need to worry about unaligned access
> +	 * as the buffer is allocated on an aligned boundary.
> +	 */
> +	spin_lock(&lun_info->slock);
> +	lun_info->max_lba = swab64(*((u64 *)&cmd->buf[0]));
> +	lun_info->blk_len = swab32(*((u32 *)&cmd->buf[8]));
> +	spin_unlock(&lun_info->slock);
> +
> +out:
> +	if (cmd)
> +		cxlflash_cmd_checkin(cmd);
> +	pr_debug("%s: maxlba=%lld blklen=%d pcmd %p\n",
> +		 __func__, lun_info->max_lba, lun_info->blk_len, cmd);
> +	return rc;
> +}
> +
> +/**
> + * get_rhte() - obtains validated resource handle table entry reference
> + * @ctx_info:	Context owning the resource handle.
> + * @res_hndl:	Resource handle associated with entry.
> + * @lun_info:	LUN associated with request.
> + *
> + * Return: Validated RHTE on success, NULL on failure
> + */
> +struct sisl_rht_entry *get_rhte(struct ctx_info *ctx_info, res_hndl_t res_hndl,
> +				struct lun_info *lun_info)
> +{
> +	struct sisl_rht_entry *rhte = NULL;
> +
> +	if (unlikely(!ctx_info->rht_start)) {
> +		pr_err("%s: Context does not have an allocated RHT!\n",
> +		       __func__);
> +		goto out;
> +	}
> +
> +	if (unlikely(res_hndl >= MAX_RHT_PER_CONTEXT)) {
> +		pr_err("%s: Invalid resource handle! (%d)\n",
> +		       __func__, res_hndl);
> +		goto out;
> +	}
> +
> +	if (unlikely(ctx_info->rht_lun[res_hndl] != lun_info)) {
> +		pr_err("%s: Resource handle invalid for LUN! (%d)\n",
> +		       __func__, res_hndl);
> +		goto out;
> +	}
> +
> +	rhte = &ctx_info->rht_start[res_hndl];
> +	if (unlikely(rhte->nmask == 0)) {
> +		pr_err("%s: Unopened resource handle! (%d)\n",
> +		       __func__, res_hndl);
> +		rhte = NULL;
> +		goto out;
> +	}
> +
> +out:
> +	return rhte;
> +}
> +
> +/**
> + * rhte_checkout() - obtains free/empty resource handle table entry
> + * @ctx_info:	Context owning the resource handle.
> + * @lun_info:	LUN associated with request.
> + *
> + * Return: Free RHTE on success, NULL on failure
> + */
> +struct sisl_rht_entry *rhte_checkout(struct ctx_info *ctx_info,
> +				     struct lun_info *lun_info)
> +{
> +	struct sisl_rht_entry *rht_entry = NULL;
> +	int i;
> +
> +	/* Find a free RHT entry */
> +	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++)
> +		if (ctx_info->rht_start[i].nmask == 0) {
> +			rht_entry = &ctx_info->rht_start[i];
> +			ctx_info->rht_out++;
> +			break;
> +		}
> +
> +	if (likely(rht_entry))
> +		ctx_info->rht_lun[i] = lun_info;
> +
> +	pr_debug("%s: returning rht_entry=%p (%d)\n", __func__, rht_entry, i);
> +	return rht_entry;
> +}
> +
> +/**
> + * rhte_checkin() - releases a resource handle table entry
> + * @ctx_info:	Context owning the resource handle.
> + * @rht_entry:	RHTE to release.
> + */
> +void rhte_checkin(struct ctx_info *ctx_info,
> +		  struct sisl_rht_entry *rht_entry)
> +{
> +	rht_entry->nmask = 0;
> +	rht_entry->fp = 0;
> +	ctx_info->rht_out--;
> +	ctx_info->rht_lun[rht_entry - ctx_info->rht_start] = NULL;

Do you need some locking in both the checkout and checkin path?

> +}
> +
> +/**
> + * rhte_format1() - populates a RHTE for format 1
> + * @rht_entry:	RHTE to populate.
> + * @lun_id:	LUN ID of LUN associated with RHTE.
> + * @perm:	Desired permissions for RHTE.
> + */
> +static void rht_format1(struct sisl_rht_entry *rht_entry, u64 lun_id, u32 perm)
> +{
> +	/*
> +	 * Populate the Format 1 RHT entry for direct access (physical
> +	 * LUN) using the synchronization sequence defined in the
> +	 * SISLite specification.
> +	 */
> +	struct sisl_rht_entry_f1 dummy = { 0 };
> +	struct sisl_rht_entry_f1 *rht_entry_f1 =
> +	    (struct sisl_rht_entry_f1 *)rht_entry;
> +	memset(rht_entry_f1, 0, sizeof(struct sisl_rht_entry_f1));
> +	rht_entry_f1->fp = SISL_RHT_FP(1U, 0);
> +	smp_wmb(); /* Make setting of format bit visible */
> +
> +	rht_entry_f1->lun_id = lun_id;
> +	smp_wmb(); /* Make setting of LUN id visible */
> +
> +	/*
> +	 * Use a dummy RHT Format 1 entry to build the second dword
> +	 * of the entry that must be populated in a single write when
> +	 * enabled (valid bit set to TRUE).
> +	 */
> +	dummy.valid = 0x80;
> +	dummy.fp = SISL_RHT_FP(1U, perm);
> +	dummy.port_sel = BOTH_PORTS;
> +	rht_entry_f1->dw = dummy.dw;
> +
> +	smp_wmb(); /* Make remaining RHT entry fields visible */
> +}
> +
> +/**
> + * cxlflash_lun_attach() - attaches a user to a LUN and manages the LUN's mode
> + * @lun_info:	LUN to attach.
> + * @mode:	Desired mode of the LUN.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_lun_attach(struct lun_info *lun_info, enum lun_mode mode)
> +{
> +	int rc = 0;
> +
> +	spin_lock(&lun_info->slock);
> +	if (lun_info->mode == MODE_NONE)
> +		lun_info->mode = mode;
> +	else if (lun_info->mode != mode) {
> +		pr_err("%s: LUN operating in mode %d, requested mode %d\n",
> +		       __func__, lun_info->mode, mode);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	lun_info->users++;
> +	BUG_ON(lun_info->users <= 0);
> +out:
> +	pr_debug("%s: Returning rc=%d li_mode=%u li_users=%u\n",
> +		 __func__, rc, lun_info->mode, lun_info->users);
> +	spin_unlock(&lun_info->slock);
> +	return rc;
> +}
> +
> +/**
> + * cxlflash_lun_detach() - detaches a user from a LUN and resets the LUN's mode
> + * @lun_info:	LUN to detach.
> + */
> +void cxlflash_lun_detach(struct lun_info *lun_info)
> +{
> +	spin_lock(&lun_info->slock);
> +	if (--lun_info->users == 0)
> +		lun_info->mode = MODE_NONE;
> +	pr_debug("%s: li_users=%u\n", __func__, lun_info->users);
> +	BUG_ON(lun_info->users < 0);
> +	spin_unlock(&lun_info->slock);
> +}
> +
> +/**
> + * cxlflash_disk_release() - releases the specified resource entry
> + * @sdev:	SCSI device associated with LUN.
> + * @release:	Release ioctl data structure.
> + *
> + * For LUN's in virtual mode, the virtual lun associated with the specified
> + * resource handle is resized to 0 prior to releasing the RHTE.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_disk_release(struct scsi_device *sdev,
> +			  struct dk_cxlflash_release *release)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct afu *afu = cfg->afu;
> +
> +	res_hndl_t res_hndl = release->rsrc_handle;
> +
> +	int rc = 0;
> +	u64 ctxid = DECODE_CTXID(release->context_id);
> +
> +	struct ctx_info *ctx_info = NULL;
> +	struct sisl_rht_entry *rht_entry;
> +	struct sisl_rht_entry_f1 *rht_entry_f1;
> +
> +	pr_debug("%s: ctxid=%llu res_hndl=0x%llx li->mode=%u li->users=%u\n",
> +		 __func__, ctxid, release->rsrc_handle, lun_info->mode,
> +		 lun_info->users);
> +
> +	ctx_info = get_context(cfg, ctxid, lun_info, 0);
> +	if (unlikely(!ctx_info)) {
> +		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	rht_entry = get_rhte(ctx_info, res_hndl, lun_info);
> +	if (unlikely(!rht_entry)) {
> +		pr_err("%s: Invalid resource handle! (%d)\n",
> +		       __func__, res_hndl);
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
> +	switch (lun_info->mode) {
> +	case MODE_PHYSICAL:
> +		/*
> +		 * Clear the Format 1 RHT entry for direct access
> +		 * (physical LUN) using the synchronization sequence
> +		 * defined in the SISLite specification.
> +		 */
> +		rht_entry_f1 = (struct sisl_rht_entry_f1 *)rht_entry;
> +
> +		rht_entry_f1->valid = 0;
> +		smp_wmb(); /* Make revocation of RHT entry visible */

I think what you actually want to use here is dma_wmb() rather than smp_wmb(),
assuming you are trying to ensure these writes occur in order with respect
to the AFU. If you were to build the kernel as a UP kernel, rather than an SMP
kernel, all these smp_wmb calls would turn into mere compiler barriers, which is
not what you want, I think... Suggest auditing the entire patch as there are
likely other barriers you may want to change as well.

> +
> +		rht_entry_f1->lun_id = 0;
> +		smp_wmb(); /* Make clearing of LUN id visible */
> +
> +		rht_entry_f1->dw = 0;
> +		smp_wmb(); /* Make RHT entry bottom-half clearing visible */
> +
> +		cxlflash_afu_sync(afu, ctxid, res_hndl, AFU_HW_SYNC);
> +		break;
> +	default:
> +		BUG();
> +		goto out;
> +	}
> +
> +	rhte_checkin(ctx_info, rht_entry);
> +	cxlflash_lun_detach(lun_info);
> +
> +out:
> +	if (likely(ctx_info))
> +		atomic_dec(&ctx_info->nrefs);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +
> +/**
> + * destroy_context() - releases a context
> + * @cfg:	Internal structure associated with the host.
> + * @ctx_info:	Context to release.
> + *
> + * Note that the rht_lun member of the context was cut from a single
> + * allocation when the context was created and therefore does not need
> + * to be explicitly freed.
> + */
> +static void destroy_context(struct cxlflash_cfg *cfg,
> +			    struct ctx_info *ctx_info)
> +{
> +	BUG_ON(!list_empty(&ctx_info->luns));
> +
> +	/* Clear RHT registers and drop all capabilities for this context */
> +	writeq_be(0, &ctx_info->ctrl_map->rht_start);
> +	writeq_be(0, &ctx_info->ctrl_map->rht_cnt_id);
> +	writeq_be(0, &ctx_info->ctrl_map->ctx_cap);
> +
> +	/* Free the RHT memory */
> +	free_page((ulong)ctx_info->rht_start);
> +
> +	/* Free the context; note that rht_lun was allocated at same time */
> +	kfree(ctx_info);
> +	cfg->num_user_contexts--;

What guarantees atomicity of this increment? I don't see any locking around the callers...

> +}
> +
> +/**
> + * create_context() - allocates and initializes a context
> + * @cfg:	Internal structure associated with the host.
> + * @ctx:	Previously obtained CXL context reference.
> + * @ctxid:	Previously obtained process element associated with CXL context.
> + * @adap_fd:	Previously obtained adapter fd associated with CXL context.
> + * @perms:	User-specified permissions.
> + *
> + * Return: Allocated context on success, NULL on failure
> + */
> +static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
> +				       struct cxl_context *ctx, int ctxid,
> +				       int adap_fd, u32 perms)
> +{
> +	char *tmp = NULL;
> +	size_t size;
> +	struct afu *afu = cfg->afu;
> +	struct ctx_info *ctx_info = NULL;
> +	struct sisl_rht_entry *rht;
> +
> +	size = ((MAX_RHT_PER_CONTEXT * sizeof(*ctx_info->rht_lun)) +
> +		sizeof(*ctx_info));
> +
> +	tmp = kzalloc(size, GFP_KERNEL);
> +	if (unlikely(!tmp)) {
> +		pr_err("%s: Unable to allocate context! (%ld)\n",
> +		       __func__, size);
> +		goto out;
> +	}
> +
> +	rht = (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
> +	if (unlikely(!rht)) {
> +		pr_err("%s: Unable to allocate RHT!\n", __func__);
> +		goto err;
> +	}
> +
> +	ctx_info = (struct ctx_info *)tmp;
> +	ctx_info->rht_lun = (struct lun_info **)(tmp + sizeof(*ctx_info));
> +	ctx_info->rht_start = rht;
> +	ctx_info->rht_perms = perms;
> +
> +	ctx_info->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
> +	ctx_info->ctxid = ENCODE_CTXID(ctx_info, ctxid);
> +	ctx_info->lfd = adap_fd;
> +	ctx_info->pid = current->tgid; /* tgid = pid */
> +	ctx_info->ctx = ctx;
> +	INIT_LIST_HEAD(&ctx_info->luns);
> +	INIT_LIST_HEAD(&ctx_info->luns);
> +	atomic_set(&ctx_info->nrefs, 1);
> +
> +	cfg->num_user_contexts++;
> +
> +out:
> +	return ctx_info;
> +
> +err:
> +	kfree(tmp);
> +	goto out;
> +}
> +
> +/**
> + * cxlflash_disk_detach() - detaches a LUN from a context
> + * @sdev:	SCSI device associated with LUN.
> + * @detach:	Detach ioctl data structure.
> + *
> + * As part of the detach, all per-context resources associated with the LUN
> + * are cleaned up. When detaching the last LUN for a context, the context
> + * itself is cleaned up and released.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_disk_detach(struct scsi_device *sdev,
> +				struct dk_cxlflash_detach *detach)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct lun_access *lun_access, *t;
> +	struct dk_cxlflash_release rel;
> +	struct ctx_info *ctx_info = NULL;
> +
> +	int i;
> +	int rc = 0;
> +	int lfd;
> +	u64 ctxid = DECODE_CTXID(detach->context_id);
> +	ulong flags = 0;
> +
> +	pr_debug("%s: ctxid=%llu\n", __func__, ctxid);
> +
> +	ctx_info = get_context(cfg, ctxid, lun_info, 0);
> +	if (unlikely(!ctx_info)) {
> +		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Cleanup outstanding resources tied to this LUN */
> +	if (ctx_info->rht_out) {
> +		marshall_det_to_rele(detach, &rel);
> +		for (i = 0; i < MAX_RHT_PER_CONTEXT; i++) {
> +			if (ctx_info->rht_lun[i] == lun_info) {
> +				rel.rsrc_handle = i;
> +				cxlflash_disk_release(sdev, &rel);
> +			}
> +
> +			/* No need to loop further if we're done */
> +			if (ctx_info->rht_out == 0)
> +				break;
> +		}
> +	}
> +
> +	/* Take our LUN out of context, free the node */
> +	list_for_each_entry_safe(lun_access, t, &ctx_info->luns, list)
> +		if (lun_access->lun_info == lun_info) {
> +			list_del(&lun_access->list);
> +			kfree(lun_access);
> +			lun_access = NULL;
> +			break;
> +		}

Do you need to do some locking around this? Can others be reading / writing
to / from this list concurrently?

> +
> +	/* Tear down context following last LUN cleanup */
> +	if (list_empty(&ctx_info->luns)) {
> +		spin_lock_irqsave(&cfg->ctx_tbl_slock, flags);
> +		cfg->ctx_tbl[ctxid] = NULL;
> +		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
> +
> +		while (atomic_read(&ctx_info->nrefs) > 1) {
> +			pr_debug("%s: waiting on threads... (%d)\n",
> +				 __func__, atomic_read(&ctx_info->nrefs));
> +			cpu_relax();

Hmm. Would an msleep with an overall timeout be more appropriate here? It might
actually be cleaner just to use a kref in the ctx_info struct to manage your
reference count and then use the release function to do that cleanup,
then you could simplify all this and eliminate the wait.

> +		}
> +
> +		lfd = ctx_info->lfd;
> +		destroy_context(cfg, ctx_info);
> +		ctx_info = NULL;
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
> +	if (likely(ctx_info))
> +		atomic_dec(&ctx_info->nrefs);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +

> +
> +/**
> + * cxlflash_mark_contexts_error() - move contexts to error list and install
> + * error page
> + * @cfg:	Internal structure associated with the host.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg)
> +{
> +	int i, rc = 0;
> +	ulong lock_flags;
> +	struct ctx_info *ctx_info = NULL;
> +
> +	spin_lock_irqsave(&cfg->ctx_tbl_slock, lock_flags);
> +
> +	for (i = 0; i < MAX_CONTEXT; i++) {
> +		ctx_info = cfg->ctx_tbl[i];
> +
> +		if (ctx_info) {
> +			cfg->ctx_tbl[i] = NULL;
> +			list_add(&ctx_info->list, &cfg->ctx_err_recovery);
> +			ctx_info->err_recovery_active = true;
> +			unmap_context(ctx_info);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&cfg->ctx_tbl_slock, lock_flags);
> +
> +	return rc;
> +}

This function doesn't appear to be called anywhere. Not even in the follow on patch...

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
> +	struct afu *afu = cfg->afu;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct cxl_ioctl_start_work *work;
> +	struct ctx_info *ctx_info = NULL;
> +	struct lun_access *lun_access = NULL;
> +	int rc = 0;
> +	u32 perms;
> +	int ctxid = -1;
> +	struct file *file;
> +
> +	struct cxl_context *ctx;
> +
> +	int fd = -1;
> +
> +	/* On first attach set fileops */
> +	if (cfg->num_user_contexts == 0)
> +		cfg->cxl_fops = cxlflash_cxl_fops;

I'm not seeing any synchronization or locking here. How are you managing a hundred different users
hitting your ioctl path at the same time? You are iterating through lists below with no locks
held, but it seems to me like that list could be changing on you. Am I missing something here?


> +
> +	if (attach->num_interrupts > 4) {
> +		pr_err("%s: Cannot support this many interrupts %llu\n",
> +		       __func__, attach->num_interrupts);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (lun_info->max_lba == 0) {
> +		pr_debug("%s: No capacity info yet for this LUN "
> +			"(%016llX)\n", __func__, lun_info->lun_id);
> +		read_cap16(afu, lun_info, sdev->channel + 1);
> +		pr_debug("%s: LBA = %016llX\n", __func__, lun_info->max_lba);
> +		pr_debug("%s: BLK_LEN = %08X\n", __func__, lun_info->blk_len);
> +	}
> +
> +	if (attach->hdr.flags & DK_CXLFLASH_ATTACH_REUSE_CONTEXT) {
> +		ctxid = DECODE_CTXID(attach->context_id);
> +		ctx_info = get_context(cfg, ctxid, NULL, 0);
> +		if (!ctx_info) {
> +			pr_err("%s: Invalid context! (%d)\n", __func__, ctxid);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		list_for_each_entry(lun_access, &ctx_info->luns, list)
> +			if (lun_access->lun_info == lun_info) {
> +				pr_err("%s: Context already attached!\n",
> +				       __func__);
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +	}
> +
> +	lun_access = kzalloc(sizeof(*lun_access), GFP_KERNEL);
> +	if (unlikely(!lun_access)) {
> +		pr_err("%s: Unable to allocate lun_access!\n", __func__);
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	lun_access->lun_info = lun_info;
> +	lun_access->sdev = sdev;
> +
> +	/* Non-NULL context indicates reuse */
> +	if (ctx_info) {
> +		pr_debug("%s: Reusing context for LUN! (%d)\n",
> +			 __func__, ctxid);
> +		list_add(&lun_access->list, &ctx_info->luns);
> +		fd = ctx_info->lfd;
> +		goto out_attach;
> +	}
> +
> +	ctx = cxl_dev_context_init(cfg->dev);
> +	if (!ctx) {
> +		pr_err("%s: Could not initialize context\n", __func__);
> +		rc = -ENODEV;
> +		goto err0;
> +	}
> +
> +	ctxid = cxl_process_element(ctx);
> +	if ((ctxid > MAX_CONTEXT) || (ctxid < 0)) {
> +		pr_err("%s: ctxid (%d) invalid!\n", __func__, ctxid);
> +		rc = -EPERM;
> +		goto err1;
> +	}
> +
> +	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
> +	if (fd < 0) {
> +		rc = -ENODEV;
> +		pr_err("%s: Could not get file descriptor\n", __func__);
> +		goto err1;
> +	}
> +
> +	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
> +	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
> +
> +	ctx_info = create_context(cfg, ctx, ctxid, fd, perms);
> +	if (unlikely(!ctx_info)) {
> +		pr_err("%s: Failed to create context! (%d)\n", __func__, ctxid);
> +		goto err2;
> +	}
> +
> +	work = &ctx_info->work;
> +	work->num_interrupts = attach->num_interrupts;
> +	work->flags = CXL_START_WORK_NUM_IRQS;
> +
> +	rc = cxl_start_work(ctx, work);
> +	if (rc) {
> +		pr_err("%s: Could not start context rc=%d\n", __func__, rc);
> +		goto err3;
> +	}
> +
> +	rc = afu_attach(cfg, ctx_info);
> +	if (rc) {
> +		pr_err("%s: Could not attach AFU rc %d\n", __func__, rc);
> +		goto err4;
> +	}
> +
> +	/*
> +	 * No error paths after this point. Once the fd is installed it's
> +	 * visible to user space and can't be undone safely on this thread.
> +	 */
> +	list_add(&lun_access->list, &ctx_info->luns);
> +	cfg->ctx_tbl[ctxid] = ctx_info;
> +	fd_install(fd, file);
> +
> +out_attach:
> +	attach->hdr.return_flags = 0;
> +	attach->context_id = ctx_info->ctxid;
> +	attach->block_size = lun_info->blk_len;
> +	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
> +	attach->last_lba = lun_info->max_lba;
> +	attach->max_xfer = (sdev->host->max_sectors * 512) / lun_info->blk_len;
> +
> +out:
> +	attach->adap_fd = fd;
> +
> +	if (likely(ctx_info))
> +		atomic_dec(&ctx_info->nrefs);
> +
> +	pr_debug("%s: returning ctxid=%d fd=%d bs=%lld rc=%d llba=%lld\n",
> +		 __func__, ctxid, fd, attach->block_size, rc, attach->last_lba);
> +	return rc;
> +
> +err4:
> +	cxl_stop_context(ctx);
> +err3:
> +	destroy_context(cfg, ctx_info);
> +err2:
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
> + * cxlflash_manage_lun() - handles lun management activities
> + * @sdev:	SCSI device associated with LUN.
> + * @manage:	Manage ioctl data structure.
> + *
> + * This routine is used to notify the driver about a LUN's WWID and associate
> + * SCSI devices (sdev) with a global LUN instance. Additionally it serves to
> + * change a LUN's operating mode: legacy or superpipe.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_manage_lun(struct scsi_device *sdev,
> +			       struct dk_cxlflash_manage_lun *manage)
> +{
> +	struct lun_info *lun_info = NULL;
> +
> +	lun_info = lookup_lun(sdev, manage->wwid);
> +	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
> +		 __func__, get_unaligned_le64(&manage->wwid[0]),
> +		 get_unaligned_le64(&manage->wwid[8]),
> +		 manage->hdr.flags, lun_info);
> +	return 0;
> +}
> +
> +/**
> + * recover_context() - recovers a context in error
> + * @cfg:	Internal structure associated with the host.
> + * @ctx_info:	Context to release.
> + *
> + * Restablishes the state for a context-in-error.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctx_info)
> +{
> +	int rc = 0;
> +	int fd = -1;
> +	int ctxid = -1;
> +	struct file *file;
> +	struct cxl_context *ctx;
> +	struct afu *afu = cfg->afu;
> +
> +	ctx = cxl_dev_context_init(cfg->dev);
> +	if (!ctx) {
> +		pr_err("%s: Could not initialize context\n", __func__);
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +
> +	ctxid = cxl_process_element(ctx);
> +	if ((ctxid > MAX_CONTEXT) || (ctxid < 0)) {

Too many parentheses

> +		pr_err("%s: ctxid (%d) invalid!\n", __func__, ctxid);
> +		rc = -EPERM;
> +		goto err1;
> +	}
> +
> +	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
> +	if (fd < 0) {
> +		rc = -ENODEV;
> +		pr_err("%s: Could not get file descriptor\n", __func__);
> +		goto err1;
> +	}
> +
> +	rc = cxl_start_work(ctx, &ctx_info->work);
> +	if (rc) {
> +		pr_err("%s: Could not start context rc=%d\n", __func__, rc);
> +		goto err2;
> +	}
> +
> +	/* Update with new MMIO area based on updated context id */
> +	ctx_info->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
> +
> +	rc = afu_attach(cfg, ctx_info);
> +	if (rc) {
> +		pr_err("%s: Could not attach AFU rc %d\n", __func__, rc);
> +		goto err3;
> +	}
> +
> +	/*
> +	 * No error paths after this point. Once the fd is installed it's
> +	 * visible to user space and can't be undone safely on this thread.
> +	 */
> +	ctx_info->ctxid = ENCODE_CTXID(ctx_info, ctxid);
> +	ctx_info->lfd = fd;
> +	ctx_info->ctx = ctx;
> +
> +	cfg->ctx_tbl[ctxid] = ctx_info;
> +	fd_install(fd, file);
> +
> +out:
> +	pr_debug("%s: returning ctxid=%d fd=%d rc=%d\n",
> +		 __func__, ctxid, fd, rc);
> +	return rc;
> +
> +err3:
> +	cxl_stop_context(ctx);
> +err2:
> +	fput(file);
> +	put_unused_fd(fd);
> +err1:
> +	cxl_release_context(ctx);
> +	goto out;
> +}
> +
> +/**
> + * cxlflash_afu_recover() - initiates AFU recovery
> + * @sdev:	SCSI device associated with LUN.
> + * @recover:	Recover ioctl data structure.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_afu_recover(struct scsi_device *sdev,
> +				struct dk_cxlflash_recover_afu *recover)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct afu *afu = cfg->afu;
> +	struct ctx_info *ctx_info = NULL;
> +	u64 ctxid = DECODE_CTXID(recover->context_id);
> +	long reg;
> +	int rc = 0;
> +
> +	/* Ensure that this process is attached to the context */
> +	ctx_info = get_context(cfg, ctxid, lun_info, 0);
> +	if (unlikely(!ctx_info)) {
> +		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	rc = recover_context(cfg, ctx_info);
> +	if (unlikely(rc)) {
> +		pr_err("%s: Error recovery failed for context %llu (rc=%d)\n",
> +		       __func__, ctxid, rc);
> +		goto out;
> +	}
> +
> +	ctx_info->err_recovery_active = false;
> +	recover->context_id = ctx_info->ctxid;
> +	recover->adap_fd = ctx_info->lfd;
> +	recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
> +
> +	reg = readq_be(&afu->ctrl_map->mbox_r);	/* Try MMIO */
> +	/* MMIO returning 0xff, need to reset */
> +	if (reg == -1) {
> +		pr_info("%s: afu=%p reason 0x%llx\n",
> +			__func__, afu, recover->reason);
> +		cxlflash_afu_reset(cfg);
> +	} else {
> +		pr_debug("%s: reason 0x%llx MMIO working, no reset performed\n",
> +			 __func__, recover->reason);
> +		rc = -EINVAL;

This seems a little strange to me. The user asked you to recover the AFU, the AFU looks
fine to you, so you do nothing, yet you fail the request to recover the AFU. What about
multiple users issuing this IOCTL at the same time? Seems like we might want to just
return success rather than make the user second guess what they did wrong in building
the ioctl.

> +	}
> +
> +out:
> +	if (likely(ctx_info))
> +		atomic_dec(&ctx_info->nrefs);
> +	return rc;
> +}
> +
> +/**
> + * process_sense() - evaluates and processes sense data
> + * @sdev:	SCSI device associated with LUN.
> + * @verify:	Verify ioctl data structure.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int process_sense(struct scsi_device *sdev,
> +			 struct dk_cxlflash_verify *verify)
> +{
> +	struct request_sense_data *sense_data = (struct request_sense_data *)
> +		&verify->sense_data;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct afu *afu = cfg->afu;
> +	u64 prev_lba = lun_info->max_lba;
> +	int rc = 0;
> +
> +	switch (sense_data->sense_key) {
> +	case NO_SENSE:
> +	case RECOVERED_ERROR:
> +		/* fall through */
> +	case NOT_READY:
> +		break;
> +	case UNIT_ATTENTION:
> +		switch (sense_data->add_sense_key) {
> +		case 0x29: /* Power on Reset or Device Reset */
> +			/* fall through */
> +		case 0x2A: /* Device settings/capacity changed */
> +			read_cap16(afu, lun_info, sdev->channel + 1);
> +			if (prev_lba != lun_info->max_lba)
> +				pr_debug("%s: Capacity changed old=%lld "
> +					 "new=%lld\n", __func__, prev_lba,
> +					 lun_info->max_lba);
> +			break;
> +		case 0x3F: /* Report LUNs changed, Rescan. */
> +			scsi_scan_host(cfg->host);
> +			break;
> +		default:
> +			rc = -EIO;
> +			break;
> +		}
> +		break;
> +	default:
> +		rc = -EIO;
> +		break;
> +	}
> +	pr_debug("%s: sense_key %x asc %x rc %d\n", __func__,
> +		 sense_data->sense_key, sense_data->add_sense_key, rc);
> +	return rc;
> +}
> +
> +/**
> + * cxlflash_disk_verify() - verifies a LUN is the same and handle size changes
> + * @sdev:	SCSI device associated with LUN.
> + * @verify:	Verify ioctl data structure.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_disk_verify(struct scsi_device *sdev,
> +				struct dk_cxlflash_verify *verify)
> +{
> +	int rc = 0;
> +	struct ctx_info *ctx_info = NULL;
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct lun_info *lun_info = sdev->hostdata;
> +	struct sisl_rht_entry *rht_entry = NULL;
> +	res_hndl_t res_hndl = verify->rsrc_handle;
> +	u64 ctxid = DECODE_CTXID(verify->context_id);
> +	u64 last_lba = 0;
> +
> +	pr_debug("%s: ctxid=%llu res_hndl=0x%llx, hint=0x%llx\n",
> +		 __func__, ctxid, verify->rsrc_handle, verify->hint);
> +
> +	ctx_info = get_context(cfg, ctxid, lun_info, 0);
> +	if (unlikely(!ctx_info)) {
> +		pr_err("%s: Invalid context! (%llu)\n",
> +		       __func__, ctxid);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	rht_entry = get_rhte(ctx_info, res_hndl, lun_info);
> +	if (unlikely(!rht_entry)) {
> +		pr_err("%s: Invalid resource handle! (%d)\n",
> +		       __func__, res_hndl);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Look at the hint/sense to see if it requires us to redrive
> +	 * inquiry (i.e. the Unit attention is due to the WWN changing).
> +	 */
> +	if (verify->hint & DK_CXLFLASH_VERIFY_HINT_SENSE) {
> +		rc = process_sense(sdev, verify);
> +		if (unlikely(rc)) {
> +			pr_err("%s: Failed to validate sense data! (%d)\n",
> +			       __func__, rc);
> +			goto out;
> +		}
> +	}
> +
> +	switch (lun_info->mode) {
> +	case MODE_PHYSICAL:
> +		last_lba = lun_info->max_lba;
> +		break;
> +	case MODE_VIRTUAL:
> +		last_lba = (((rht_entry->lxt_cnt * MC_CHUNK_SIZE *
> +			      lun_info->blk_len) / CXLFLASH_BLOCK_SIZE) - 1);
> +		break;

Should this go in the second patch?

> +	default:
> +		BUG();
> +	}
> +
> +	verify->last_lba = last_lba;
> +
> +out:
> +	if (likely(ctx_info))
> +		atomic_dec(&ctx_info->nrefs);
> +	pr_debug("%s: returning rc=%d llba=%lld\n",
> +		 __func__, rc, verify->last_lba);
> +	return rc;
> +}
> +
> +/**
> + * decode_ioctl() - translates an encoded ioctl to an easily identifiable string
> + * @cmd:	The ioctl command to decode.
> + *
> + * Return: A string identifying the decoded ioctl.
> + */
> +static char *decode_ioctl(int cmd)
> +{
> +	switch (cmd) {
> +	case DK_CXLFLASH_ATTACH:
> +		return __stringify_1(DK_CXLFLASH_ATTACH);
> +	case DK_CXLFLASH_USER_DIRECT:
> +		return __stringify_1(DK_CXLFLASH_USER_DIRECT);
> +	case DK_CXLFLASH_USER_VIRTUAL:
> +		return __stringify_1(DK_CXLFLASH_USER_VIRTUAL);
> +	case DK_CXLFLASH_VLUN_RESIZE:
> +		return __stringify_1(DK_CXLFLASH_VLUN_RESIZE);
> +	case DK_CXLFLASH_RELEASE:
> +		return __stringify_1(DK_CXLFLASH_RELEASE);
> +	case DK_CXLFLASH_DETACH:
> +		return __stringify_1(DK_CXLFLASH_DETACH);
> +	case DK_CXLFLASH_VERIFY:
> +		return __stringify_1(DK_CXLFLASH_VERIFY);
> +	case DK_CXLFLASH_CLONE:
> +		return __stringify_1(DK_CXLFLASH_CLONE);
> +	case DK_CXLFLASH_RECOVER_AFU:
> +		return __stringify_1(DK_CXLFLASH_RECOVER_AFU);
> +	case DK_CXLFLASH_MANAGE_LUN:
> +		return __stringify_1(DK_CXLFLASH_MANAGE_LUN);
> +	}
> +
> +	return "UNKNOWN";
> +}
> +
> +/**
> + * cxlflash_disk_direct_open() - opens a direct (physical) disk
> + * @sdev:	SCSI device associated with LUN.
> + * @arg:	UDirect ioctl data structure.
> + *
> + * On successful return, the user is informed of the resource handle
> + * to be used to identify the direct lun and the size (in blocks) of
> + * the direct lun in last LBA format.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int cxlflash_disk_direct_open(struct scsi_device *sdev, void *arg)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct afu *afu = cfg->afu;
> +	struct lun_info *lun_info = sdev->hostdata;
> +
> +	struct dk_cxlflash_udirect *pphys = (struct dk_cxlflash_udirect *)arg;
> +
> +	u64 ctxid = DECODE_CTXID(pphys->context_id);
> +	u64 lun_size = 0;
> +	u64 last_lba = 0;
> +	u64 rsrc_handle = -1;
> +
> +	int rc = 0;
> +
> +	struct ctx_info *ctx_info = NULL;
> +	struct sisl_rht_entry *rht_entry = NULL;
> +
> +	pr_debug("%s: ctxid=%llu ls=0x%llx\n", __func__, ctxid, lun_size);
> +
> +	rc = cxlflash_lun_attach(lun_info, MODE_PHYSICAL);
> +	if (unlikely(rc)) {
> +		pr_err("%s: Failed to attach to LUN! mode=%u\n",
> +		       __func__, MODE_PHYSICAL);
> +		goto out;
> +	}
> +
> +	ctx_info = get_context(cfg, ctxid, lun_info, 0);
> +	if (unlikely(!ctx_info)) {
> +		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto err1;
> +	}
> +
> +	rht_entry = rhte_checkout(ctx_info, lun_info);
> +	if (unlikely(!rht_entry)) {
> +		pr_err("%s: too many opens for this context\n", __func__);
> +		rc = -EMFILE;	/* too many opens  */
> +		goto err1;
> +	}
> +
> +	rsrc_handle = (rht_entry - ctx_info->rht_start);
> +
> +	rht_format1(rht_entry, lun_info->lun_id, ctx_info->rht_perms);
> +	cxlflash_afu_sync(afu, ctxid, rsrc_handle, AFU_LW_SYNC);
> +
> +	last_lba = lun_info->max_lba;
> +	pphys->hdr.return_flags = 0;
> +	pphys->last_lba = last_lba;
> +	pphys->rsrc_handle = rsrc_handle;
> +
> +out:
> +	if (likely(ctx_info))
> +		atomic_dec(&ctx_info->nrefs);
> +	pr_debug("%s: returning handle 0x%llx rc=%d llba %lld\n",
> +		 __func__, rsrc_handle, rc, last_lba);
> +	return rc;
> +
> +err1:
> +	cxlflash_lun_detach(lun_info);
> +	goto out;
> +}
> +
> +/**
> + * cxlflash_ioctl() - IOCTL handler for driver
> + * @sdev:	SCSI device associated with LUN.
> + * @arg:	Userspace ioctl data structure.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
> +{
> +	typedef int (*sioctl) (struct scsi_device *, void *);
> +
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct afu *afu = cfg->afu;
> +	struct dk_cxlflash_hdr *hdr;
> +	char buf[MAX_CXLFLASH_IOCTL_SZ];
> +	size_t size = 0;
> +	bool known_ioctl = false;
> +	int idx;
> +	int rc = 0;
> +	struct Scsi_Host *shost = sdev->host;
> +	sioctl do_ioctl = NULL;
> +
> +	static const struct {
> +		size_t size;
> +		sioctl ioctl;
> +	} ioctl_tbl[] = {	/* NOTE: order matters here */
> +	{sizeof(struct dk_cxlflash_attach), (sioctl)cxlflash_disk_attach},
> +	{sizeof(struct dk_cxlflash_udirect), cxlflash_disk_direct_open},
> +	{sizeof(struct dk_cxlflash_release), (sioctl)cxlflash_disk_release},
> +	{sizeof(struct dk_cxlflash_detach), (sioctl)cxlflash_disk_detach},
> +	{sizeof(struct dk_cxlflash_verify), (sioctl)cxlflash_disk_verify},
> +	{sizeof(struct dk_cxlflash_recover_afu), (sioctl)cxlflash_afu_recover},
> +	{sizeof(struct dk_cxlflash_manage_lun), (sioctl)cxlflash_manage_lun},
> +	};
> +
> +	/* Restrict command set to physical support only for internal LUN */
> +	if (afu->internal_lun)
> +		switch (cmd) {
> +		case DK_CXLFLASH_USER_VIRTUAL:
> +		case DK_CXLFLASH_VLUN_RESIZE:
> +		case DK_CXLFLASH_RELEASE:
> +		case DK_CXLFLASH_CLONE:
> +			pr_err("%s: %s not supported for lun_mode=%d\n",
> +			       __func__, decode_ioctl(cmd), afu->internal_lun);
> +			rc = -EINVAL;
> +			goto cxlflash_ioctl_exit;
> +		}
> +
> +	switch (cmd) {
> +	case DK_CXLFLASH_ATTACH:
> +	case DK_CXLFLASH_USER_DIRECT:
> +	case DK_CXLFLASH_USER_VIRTUAL:
> +	case DK_CXLFLASH_VLUN_RESIZE:
> +	case DK_CXLFLASH_RELEASE:
> +	case DK_CXLFLASH_DETACH:
> +	case DK_CXLFLASH_VERIFY:
> +	case DK_CXLFLASH_CLONE:
> +	case DK_CXLFLASH_RECOVER_AFU:
> +	case DK_CXLFLASH_MANAGE_LUN:
> +		known_ioctl = true;
> +		idx = _IOC_NR(cmd) - _IOC_NR(DK_CXLFLASH_ATTACH);
> +		size = ioctl_tbl[idx].size;
> +		do_ioctl = ioctl_tbl[idx].ioctl;
> +
> +		if (likely(do_ioctl))
> +			break;
> +
> +		/* fall through */
> +	default:
> +		rc = -EINVAL;
> +		goto cxlflash_ioctl_exit;
> +	}
> +
> +	if (unlikely(copy_from_user(&buf, arg, size))) {
> +		pr_err("%s: copy_from_user() fail! "
> +		       "size=%lu cmd=%d (%s) arg=%p\n",
> +		       __func__, size, cmd, decode_ioctl(cmd), arg);
> +		rc = -EFAULT;
> +		goto cxlflash_ioctl_exit;
> +	}
> +
> +	hdr = (struct dk_cxlflash_hdr *)&buf;
> +	if (hdr->version != 0) {
> +		pr_err("%s: Version %u not supported for %s\n",
> +		       __func__, hdr->version, decode_ioctl(cmd));
> +		rc = -EINVAL;
> +		goto cxlflash_ioctl_exit;
> +	}
> +
> +	rc = do_ioctl(sdev, (void *)&buf);
> +	if (likely(!rc))
> +		if (unlikely(copy_to_user(arg, &buf, size))) {
> +			pr_err("%s: copy_to_user() fail! "
> +			       "size=%lu cmd=%d (%s) arg=%p\n",
> +			       __func__, size, cmd, decode_ioctl(cmd), arg);
> +			rc = -EFAULT;
> +		}
> +
> +	/* fall through to exit */
> +
> +cxlflash_ioctl_exit:
> +	if (unlikely(rc && known_ioctl))
> +		pr_err("%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
> +		       "returned rc %d\n", __func__,
> +		       decode_ioctl(cmd), cmd, shost->host_no,
> +		       sdev->channel, sdev->id, sdev->lun, rc);
> +	else
> +		pr_debug("%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
> +			 "returned rc %d\n", __func__, decode_ioctl(cmd),
> +			 cmd, shost->host_no, sdev->channel, sdev->id,
> +			 sdev->lun, rc);
> +	return rc;
> +}
> +

> diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
> new file mode 100644
> index 0000000..dd1f954
> --- /dev/null
> +++ b/include/uapi/scsi/cxlflash_ioctl.h
> @@ -0,0 +1,159 @@
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
> +#ifndef _CXLFLASH_IOCTL_H
> +#define _CXLFLASH_IOCTL_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Structure and flag definitions CXL Flash superpipe ioctls
> + */
> +
> +struct dk_cxlflash_hdr {
> +	__u16 version;			/* Version data */
> +	__u16 rsvd[3];			/* Reserved for future use */
> +	__u64 flags;			/* Input flags */
> +	__u64 return_flags;		/* Returned flags */
> +};
> +
> +/*
> + * Notes:
> + * -----
> + * The 'context_id' field of all ioctl structures contains the context
> + * identifier for a context in the lower 32-bits (upper 32-bits are not
> + * to be used when identifying a context to the AFU). That said, the value
> + * in its entirety (all 64-bits) is to be treated as an opaque cookie and
> + * should be presented as such when issuing ioctls.
> + *
> + * For DK_CXLFLASH_ATTACH ioctl, user specifies read/write access
> + * permissions via the O_RDONLY, O_WRONLY, and O_RDWR flags defined in
> + * the fcntl.h header file.
> + */
> +#define DK_CXLFLASH_ATTACH_REUSE_CONTEXT	0x8000000000000000ULL
> +
> +struct dk_cxlflash_attach {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 num_interrupts;		/* Requested number of interrupts */
> +	__u64 context_id;		/* Returned context */
> +	__u64 mmio_size;		/* Returned size of MMIO area */
> +	__u64 block_size;		/* Returned block size, in bytes */
> +	__u64 adap_fd;			/* Returned adapter file descriptor */
> +	__u64 last_lba;			/* Returned last LBA on the device */
> +	__u64 max_xfer;			/* Returned max transfer size, blocks */
> +};
> +
> +struct dk_cxlflash_detach {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context to detach */
> +};
> +
> +struct dk_cxlflash_udirect {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context to own physical resources */
> +	__u64 rsrc_handle;		/* Returned resource handle */
> +	__u64 last_lba;			/* Returned last LBA on the device */
> +};
> +
> +struct dk_cxlflash_uvirtual {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context to own virtual resources */
> +	__u64 lun_size;			/* Requested size, in 4K blocks */
> +	__u64 rsrc_handle;		/* Returned resource handle */
> +	__u64 last_lba;			/* Returned last LBA of LUN */
> +};

This isn't used in this patch, so should really be in the second patch.

> +
> +struct dk_cxlflash_release {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context owning resources */
> +	__u64 rsrc_handle;		/* Resource handle to release */
> +};
> +
> +struct dk_cxlflash_resize {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context owning resources */
> +	__u64 rsrc_handle;		/* Resource handle of LUN to resize */
> +	__u64 req_size;			/* New requested size, in 4K blocks */
> +	__u64 last_lba;			/* Returned last LBA of LUN */
> +};

Looks like the same is true here. Ideally all the virtual LUN definitions, function
prototypes, etc, would be in the second patch.

> +
> +struct dk_cxlflash_clone {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id_src;		/* Context to clone from */
> +	__u64 context_id_dst;		/* Context to clone to */
> +	__u64 adap_fd_src;		/* Source context adapter fd */
> +};
> +
> +#define DK_CXLFLASH_VERIFY_SENSE_LEN	18
> +#define DK_CXLFLASH_VERIFY_HINT_SENSE	0x8000000000000000ULL> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> new file mode 100644
> index 0000000..1bf9f60
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -0,0 +1,210 @@
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
> +/*----------------------------------------------------------------------------*/
> +/* Constants                                                                  */
> +/*----------------------------------------------------------------------------*/
> +
> +#define SL_INI_SINI_MARKER      0x53494e49
> +#define SL_INI_ELMD_MARKER      0x454c4d44
> +/*----------------------------------------------------------------------------*/
> +/* Types                                                                      */
> +/*----------------------------------------------------------------------------*/
> +
> +#define MAX_AUN_CLONE_CNT    0xFF
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
> +#define MC_RHT_NMASK      16	/* in bits */
> +#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs, see mclient.h */
> +#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
> +
> +/* LXT tables are allocated dynamically in groups. This is done to
> +   avoid a malloc/free overhead each time the LXT has to grow
> +   or shrink.
> +
> +   Based on the current lxt_cnt (used), it is always possible to
> +   know how many are allocated (used+free). The number of allocated
> +   entries is not stored anywhere.
> +
> +   The LXT table is re-allocated whenever it needs to cross into
> +   another group.
> +*/
> +#define LXT_GROUP_SIZE          8
> +#define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
> +
> +#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
> +
> +enum lun_mode {
> +	MODE_NONE = 0,
> +	MODE_VIRTUAL,
> +	MODE_PHYSICAL
> +};
> +
> +/* SCSI Defines                                                          */
> +
> +struct request_sense_data  {
> +	uint8_t     err_code;        /* error class and code   */
> +	uint8_t     rsvd0;
> +	uint8_t     sense_key;
> +#define CXLFLASH_VENDOR_UNIQUE         0x09
> +#define CXLFLASH_EQUAL_CMD             0x0C
> +	uint8_t     sense_byte0;
> +	uint8_t     sense_byte1;
> +	uint8_t     sense_byte2;
> +	uint8_t     sense_byte3;
> +	uint8_t     add_sense_length;
> +	uint8_t     add_sense_byte0;
> +	uint8_t     add_sense_byte1;
> +	uint8_t     add_sense_byte2;
> +	uint8_t     add_sense_byte3;
> +	uint8_t     add_sense_key;
> +	uint8_t     add_sense_qualifier;
> +	uint8_t     fru;
> +	uint8_t     flag_byte;
> +	uint8_t     field_ptrM;
> +	uint8_t     field_ptrL;
> +};
> +
> +struct ba_lun {
> +	u64 lun_id;
> +	u64 wwpn;
> +	size_t lsize;		/* LUN size in number of LBAs             */
> +	size_t lba_size;	/* LBA size in number of bytes            */
> +	size_t au_size;		/* Allocation Unit size in number of LBAs */
> +	void *ba_lun_handle;
> +};
> +
> +struct ba_lun_info {
> +	u64 *lun_alloc_map;
> +	u32 lun_bmap_size;
> +	u32 total_aus;
> +	u64 free_aun_cnt;
> +
> +	/* indices to be used for elevator lookup of free map */
> +	u32 free_low_idx;
> +	u32 free_curr_idx;
> +	u32 free_high_idx;
> +
> +	u8 *aun_clone_map;
> +};
> +
> +/* Block Allocator */
> +struct blka {
> +	struct ba_lun ba_lun;
> +	u64 nchunk;		/* number of chunks */
> +	struct mutex mutex;
> +};
> +
> +/* LUN discovery results are in lun_info */
> +struct lun_info {
> +	u64 lun_id;		/* from REPORT_LUNS */
> +	u64 max_lba;		/* from read cap(16) */
> +	u32 blk_len;		/* from read cap(16) */
> +	u32 lun_index;
> +	int users;		/* Number of users w/ references to LUN */
> +	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
> +
> +	__u8 wwid[16];
> +
> +	spinlock_t slock;
> +
> +	struct blka blka;
> +	struct scsi_device *sdev;
> +	struct list_head list;
> +};
> +
> +struct lun_access {
> +	struct lun_info *lun_info;
> +	struct scsi_device *sdev;
> +	struct list_head list;
> +};
> +
> +enum ctx_ctrl {
> +	CTX_CTRL_CLONE		= (1 << 1),
> +	CTX_CTRL_ERR		= (1 << 2),
> +	CTX_CTRL_ERR_FALLBACK	= (1 << 3),
> +	CTX_CTRL_NOPID		= (1 << 4)
> +};
> +
> +#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0) << 28) | _id)
> +#define DECODE_CTXID(_val)	(_val & 0xFFFFFFFF)
> +
> +struct ctx_info {
> +	struct sisl_ctrl_map *ctrl_map; /* initialized at startup */
> +	struct sisl_rht_entry *rht_start; /* 1 page (req'd for alignment),
> +					     alloc/free on attach/detach */
> +	u32 rht_out;		/* Number of checked out RHT entries */
> +	u32 rht_perms;		/* User-defined permissions for RHT entries */
> +	struct lun_info **rht_lun; /* Mapping of RHT entries to LUNs */
> +
> +	struct cxl_ioctl_start_work work;
> +	u64 ctxid;
> +	int lfd;
> +	pid_t pid;
> +	atomic_t nrefs;	/* Number of active references, must be 0 for removal */
> +	bool err_recovery_active;
> +	struct cxl_context *ctx;
> +	struct list_head luns;	/* LUNs attached to this context */
> +	const struct vm_operations_struct *cxl_mmap_vmops;
> +	struct address_space *mapping;
> +	struct list_head list; /* Link contexts in error recovery */
> +};
> +
> +struct cxlflash_global {
> +	spinlock_t slock;
> +	struct list_head luns;  /* list of lun_info structs */
> +	struct page *err_page; /* One page of all 0xF for error notification */
> +};
> +
> +
> +int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
> +
> +int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
> +
> +int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
> +
> +int cxlflash_disk_virtual_open(struct scsi_device *, void *);
> +
> +int cxlflash_lun_attach(struct lun_info *, enum lun_mode);
> +void cxlflash_lun_detach(struct lun_info *);
> +
> +int cxlflash_check_status(struct afu_cmd *);
> +
> +struct ctx_info *get_context(struct cxlflash_cfg *, u64, struct lun_info *,
> +			     enum ctx_ctrl);
> +
> +struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
> +				struct lun_info *);
> +
> +struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct lun_info *);
> +void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
> +
> +void cxlflash_ba_terminate(struct ba_lun *);
> +
> +#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
> +
> +struct dk_cxlflash_verify {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context owning resources to verify */
> +	__u64 rsrc_handle;		/* Resource handle of LUN */
> +	__u64 hint;			/* Reasons for verify */
> +	__u64 last_lba;			/* Returned last LBA of device */
> +	__u8 sense_data[DK_CXLFLASH_VERIFY_SENSE_LEN]; /* SCSI sense data */
> +	__u8 pad[6];			/* Pad to next 8-byte boundary */
> +};
> +
> +struct dk_cxlflash_recover_afu {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 reason;			/* Reason for recovery request */
> +	__u64 context_id;		/* Context to recover / updated ID */
> +	__u64 mmio_size;		/* Returned size of MMIO area */
> +	__u64 adap_fd;			/* Returned adapter file descriptor */
> +};
> +
> +#define DK_CXLFLASH_MANAGE_LUN_WWID_LEN			16
> +#define DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE		0x8000000000000000ULL
> +#define DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE	0x4000000000000000ULL
> +#define DK_CXLFLASH_MANAGE_LUN_ALL_PORTS_ACCESSIBLE	0x2000000000000000ULL
> +
> +struct dk_cxlflash_manage_lun {
> +	struct dk_cxlflash_hdr hdr;			/* Common fields */
> +	__u8 wwid[DK_CXLFLASH_MANAGE_LUN_WWID_LEN];	/* Page83 WWID, NAA-6 */
> +};
> +
> +union cxlflash_ioctls {
> +	struct dk_cxlflash_attach attach;
> +	struct dk_cxlflash_detach detach;
> +	struct dk_cxlflash_udirect udirect;
> +	struct dk_cxlflash_uvirtual uvirtual;
> +	struct dk_cxlflash_release release;
> +	struct dk_cxlflash_resize resize;
> +	struct dk_cxlflash_clone clone;
> +	struct dk_cxlflash_verify verify;
> +	struct dk_cxlflash_recover_afu recover_afu;
> +	struct dk_cxlflash_manage_lun manage_lun;
> +};
> +
> +#define MAX_CXLFLASH_IOCTL_SZ	(sizeof(union cxlflash_ioctls))
> +
> +
> +#define CXL_MAGIC 0xCA
> +#define CXL_IOW(_n, _s)	_IOW(CXL_MAGIC, _n, struct _s)
> +
> +#define DK_CXLFLASH_ATTACH		CXL_IOW(0x80, dk_cxlflash_attach)

It would probably be good to add a comment to include/uapi/misc/cxl.h to indicate
that cxlflash is reserving this ioctl range so you don't conflict with other
cxl users.

> +#define DK_CXLFLASH_USER_DIRECT		CXL_IOW(0x81, dk_cxlflash_udirect)
> +#define DK_CXLFLASH_USER_VIRTUAL	CXL_IOW(0x82, dk_cxlflash_uvirtual)
> +#define DK_CXLFLASH_VLUN_RESIZE		CXL_IOW(0x83, dk_cxlflash_resize)
> +#define DK_CXLFLASH_RELEASE		CXL_IOW(0x84, dk_cxlflash_release)
> +#define DK_CXLFLASH_DETACH		CXL_IOW(0x85, dk_cxlflash_detach)
> +#define DK_CXLFLASH_VERIFY		CXL_IOW(0x86, dk_cxlflash_verify)
> +#define DK_CXLFLASH_CLONE		CXL_IOW(0x87, dk_cxlflash_clone)
> +#define DK_CXLFLASH_RECOVER_AFU		CXL_IOW(0x88, dk_cxlflash_recover_afu)
> +#define DK_CXLFLASH_MANAGE_LUN		CXL_IOW(0x89, dk_cxlflash_manage_lun)
> +
> +#endif /* ifndef _CXLFLASH_IOCTL_H */
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


