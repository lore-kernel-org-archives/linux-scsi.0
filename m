From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v5 3/3] cxlflash: Virtual LUN support
Date: Thu, 13 Aug 2015 09:27:08 -0400
Message-ID: <20150813092708.Horde.boAqommlb580P0YFHNJ64w2@ltc.linux.ibm.com>
References: <1439423476-15687-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:40933 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbHMN1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 09:27:13 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Thu, 13 Aug 2015 09:27:13 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 276C46E801D
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 09:18:55 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7DDR9WH53739740
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 13:27:09 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7DDR8iu011681
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 09:27:09 -0400
In-Reply-To: <1439423476-15687-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Thanks for merging the comments I made for v3.

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>:

> Add support for physical LUN segmentation (virtual LUNs) to device
> driver supporting the IBM CXL Flash adapter. This patch allows user
> space applications to virtually segment a physical LUN into N virtual
> LUNs, taking advantage of the translation features provided by this
> adapter.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
>  Documentation/powerpc/cxlflash.txt |   63 +-
>  drivers/scsi/cxlflash/Makefile     |    2 +-
>  drivers/scsi/cxlflash/common.h     |    4 +
>  drivers/scsi/cxlflash/lunmgt.c     |    3 +
>  drivers/scsi/cxlflash/main.c       |   13 +
>  drivers/scsi/cxlflash/sislite.h    |   20 +-
>  drivers/scsi/cxlflash/superpipe.c  |   81 ++-
>  drivers/scsi/cxlflash/superpipe.h  |   17 +-
>  drivers/scsi/cxlflash/vlun.c       | 1243  
> ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxlflash/vlun.h       |   86 +++
>  include/uapi/scsi/cxlflash_ioctl.h |   34 +
>  11 files changed, 1549 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/scsi/cxlflash/vlun.c
>  create mode 100644 drivers/scsi/cxlflash/vlun.h
>
> diff --git a/Documentation/powerpc/cxlflash.txt  
> b/Documentation/powerpc/cxlflash.txt
> index 42c3c57..e6e333c 100644
> --- a/Documentation/powerpc/cxlflash.txt
> +++ b/Documentation/powerpc/cxlflash.txt
> @@ -163,7 +163,8 @@ DK_CXLFLASH_ATTACH
>
>          - These tokens are only valid for the process under which they
>            were created. The child of a forked process cannot continue
> -          to use the context id or file descriptor created by its parent.
> +          to use the context id or file descriptor created by its parent
> +          (see DK_CXLFLASH_VLUN_CLONE for further details).
>
>          - These tokens are only valid for the lifetime of the context and
>            the process under which they were created. Once either is
> @@ -193,6 +194,45 @@ DK_CXLFLASH_USER_DIRECT
>      treated as a resource handle that is returned to the user. The user
>      is then able to use the handle to reference the LUN during I/O.
>
> +DK_CXLFLASH_USER_VIRTUAL
> +------------------------
> +    This ioctl is responsible for transitioning the LUN to virtual mode
> +    of access and configuring the AFU for virtual access from user space
> +    on a per-context basis. Additionally, the block size and last logical
> +    block address (LBA) are returned to the user.
> +
> +    As mentioned previously, when operating in user space access mode,
> +    LUNs may be accessed in whole or in part. Only one mode is allowed
> +    at a time and if one mode is active (outstanding references exist),
> +    requests to use the LUN in a different mode are denied.
> +
> +    The AFU is configured for virtual access from user space by adding
> +    an entry to the AFU's resource handle table. The index of the entry
> +    is treated as a resource handle that is returned to the user. The
> +    user is then able to use the handle to reference the LUN during I/O.
> +
> +    By default, the virtual LUN is created with a size of 0. The user
> +    would need to use the DK_CXLFLASH_VLUN_RESIZE ioctl to adjust the grow
> +    the virtual LUN to a desired size. To avoid having to perform this
> +    resize for the initial creation of the virtual LUN, the user has the
> +    option of specifying a size as part of the DK_CXLFLASH_USER_VIRTUAL
> +    ioctl, such that when success is returned to the user, the
> +    resource handle that is provided is already referencing provisioned
> +    storage. This is reflected by the last LBA being a non-zero value.
> +
> +DK_CXLFLASH_VLUN_RESIZE
> +-----------------------
> +    This ioctl is responsible for resizing a previously created virtual
> +    LUN and will fail if invoked upon a LUN that is not in virtual
> +    mode. Upon success, an updated last LBA is returned to the user
> +    indicating the new size of the virtual LUN associated with the
> +    resource handle.
> +
> +    The partitioning of virtual LUNs is jointly mediated by the cxlflash
> +    driver and the AFU. An allocation table is kept for each LUN that is
> +    operating in the virtual mode and used to program a LUN translation
> +    table that the AFU references when provided with a resource handle.
> +
>  DK_CXLFLASH_RELEASE
>  -------------------
>      This ioctl is responsible for releasing a previously obtained
> @@ -214,6 +254,27 @@ DK_CXLFLASH_DETACH
>      success, all "tokens" which had been provided to the user from the
>      DK_CXLFLASH_ATTACH onward are no longer valid.
>
> +DK_CXLFLASH_VLUN_CLONE
> +----------------------
> +    This ioctl is responsible for cloning a previously created
> +    context to a more recently created context. It exists solely to
> +    support maintaining user space access to storage after a process
> +    forks. Upon success, the child process (which invoked the ioctl)
> +    will have access to the same LUNs via the same resource handle(s)
> +    and fd2 as the parent, but under a different context.
> +
> +    Context sharing across processes is not supported with CXL and
> +    therefore each fork must be met with establishing a new context
> +    for the child process. This ioctl simplifies the state management
> +    and playback required by a user in such a scenario. When a process
> +    forks, child process can clone the parents context by first creating
> +    a context (via DK_CXLFLASH_ATTACH) and then using this ioctl to
> +    perform the clone from the parent to the child.
> +
> +    The clone itself is fairly simple. The resource handle and lun
> +    translation tables are copied from the parent context to the child's
> +    and then synced with the AFU.
> +
>  DK_CXLFLASH_VERIFY
>  ------------------
>      This ioctl is used to detect various changes such as the capacity of
> diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
> index c14d24c..9e39866 100644
> --- a/drivers/scsi/cxlflash/Makefile
> +++ b/drivers/scsi/cxlflash/Makefile
> @@ -1,2 +1,2 @@
>  obj-$(CONFIG_CXLFLASH) += cxlflash.o
> -cxlflash-y += main.o superpipe.o lunmgt.o
> +cxlflash-y += main.o superpipe.o lunmgt.o vlun.o
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index d3e54e6..1c56037 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -116,6 +116,9 @@ struct cxlflash_cfg {
>
>  	atomic_t num_user_contexts;
>
> +	/* Parameters that are LUN table related */
> +	int last_lun_index[CXLFLASH_NUM_FC_PORTS];
> +	int promote_lun_index;
>  	struct list_head lluns; /* list of llun_info structs */
>
>  	wait_queue_head_t tmf_waitq;
> @@ -200,5 +203,6 @@ int cxlflash_ioctl(struct scsi_device *, int,  
> void __user *);
>  void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *);
>  int cxlflash_mark_contexts_error(struct cxlflash_cfg *);
>  void cxlflash_term_local_luns(struct cxlflash_cfg *);
> +void cxlflash_restore_luntable(struct cxlflash_cfg *);
>
>  #endif /* ifndef _CXLFLASH_COMMON_H */
> diff --git a/drivers/scsi/cxlflash/lunmgt.c b/drivers/scsi/cxlflash/lunmgt.c
> index 4d2adee..f92df9a 100644
> --- a/drivers/scsi/cxlflash/lunmgt.c
> +++ b/drivers/scsi/cxlflash/lunmgt.c
> @@ -20,6 +20,7 @@
>
>  #include "sislite.h"
>  #include "common.h"
> +#include "vlun.h"
>  #include "superpipe.h"
>
>  /**
> @@ -42,6 +43,7 @@ static struct llun_info *create_local(struct  
> scsi_device *sdev, u8 *wwid)
>  	lli->sdev = sdev;
>  	lli->newly_created = true;
>  	lli->host_no = sdev->host->host_no;
> +	lli->in_table = false;
>
>  	memcpy(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN);
>  out:
> @@ -208,6 +210,7 @@ void cxlflash_term_global_luns(void)
>  	mutex_lock(&global.mutex);
>  	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
>  		list_del(&gli->list);
> +		cxlflash_ba_terminate(&gli->blka.ba_lun);
>  		kfree(gli);
>  	}
>  	mutex_unlock(&global.mutex);
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 102eb887..ee8f22a 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -1971,6 +1971,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
>  	afu_err_intr_init(cfg->afu);
>  	atomic64_set(&afu->room, readq_be(&afu->host_map->cmd_room));
>
> +	/* Restore the LUN mappings */
> +	cxlflash_restore_luntable(cfg);
>  err1:
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -2268,6 +2270,17 @@ static int cxlflash_probe(struct pci_dev *pdev,
>
>  	cfg->init_state = INIT_STATE_NONE;
>  	cfg->dev = pdev;
> +
> +	/*
> +	 * The promoted LUNs move to the top of the LUN table. The rest stay
> +	 * on the bottom half. The bottom half grows from the end
> +	 * (index = 255), whereas the top half grows from the beginning
> +	 * (index = 0).
> +	 */
> +	cfg->promote_lun_index  = 0;
> +	cfg->last_lun_index[0] = CXLFLASH_NUM_VLUNS/2 - 1;
> +	cfg->last_lun_index[1] = CXLFLASH_NUM_VLUNS/2 - 1;
> +
>  	cfg->dev_id = (struct pci_device_id *)dev_id;
>  	cfg->mcctx = NULL;
>
> diff --git a/drivers/scsi/cxlflash/sislite.h  
> b/drivers/scsi/cxlflash/sislite.h
> index 66b8891..63bf394 100644
> --- a/drivers/scsi/cxlflash/sislite.h
> +++ b/drivers/scsi/cxlflash/sislite.h
> @@ -397,16 +397,17 @@ struct cxlflash_afu_map {
>  	};
>  };
>
> -/* LBA translation control blocks */
> -
> +/*
> + * LXT - LBA Translation Table
> + * LXT control blocks
> + */
>  struct sisl_lxt_entry {
>  	u64 rlba_base;	/* bits 0:47 is base
> -				 * b48:55 is lun index
> -				 * b58:59 is write & read perms
> -				 * (if no perm, afu_rc=0x15)
> -				 * b60:63 is port_sel mask
> -				 */
> -
> +			 * b48:55 is lun index
> +			 * b58:59 is write & read perms
> +			 * (if no perm, afu_rc=0x15)
> +			 * b60:63 is port_sel mask
> +			 */
>  };
>
>  /*
> @@ -465,4 +466,7 @@ struct sisl_rht_entry_f1 {
>  #define TMF_LUN_RESET  0x1U
>  #define TMF_CLEAR_ACA  0x2U
>
> +
> +#define SISLITE_MAX_WS_BLOCKS 512
> +
>  #endif /* _SISLITE_H */
> diff --git a/drivers/scsi/cxlflash/superpipe.c  
> b/drivers/scsi/cxlflash/superpipe.c
> index 7da6f8c..a64965e 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -26,11 +26,25 @@
>
>  #include "sislite.h"
>  #include "common.h"
> +#include "vlun.h"
>  #include "superpipe.h"
>
>  struct cxlflash_global global;
>
>  /**
> + * marshal_rele_to_resize() - translate release to resize structure
> + * @rele:	Source structure from which to translate/copy.
> + * @resize:	Destination structure for the translate/copy.
> + */
> +static void marshal_rele_to_resize(struct dk_cxlflash_release *release,
> +				   struct dk_cxlflash_resize *resize)
> +{
> +	resize->hdr = release->hdr;
> +	resize->context_id = release->context_id;
> +	resize->rsrc_handle = release->rsrc_handle;
> +}
> +
> +/**
>   * marshal_det_to_rele() - translate detach to release structure
>   * @detach:	Destination structure for the translate/copy.
>   * @rele:	Source structure from which to translate/copy.
> @@ -449,6 +463,7 @@ void rhte_checkin(struct ctx_info *ctxi,
>  	rhte->fp = 0;
>  	ctxi->rht_out--;
>  	ctxi->rht_lun[rsrc_handle] = NULL;
> +	ctxi->rht_needs_ws[rsrc_handle] = false;
>  }
>
>  /**
> @@ -526,13 +541,21 @@ out:
>  /**
>   * cxlflash_lun_detach() - detaches a user from a LUN and resets  
> the LUN's mode
>   * @gli:	LUN to detach.
> + *
> + * When resetting the mode, terminate block allocation resources as they
> + * are no longer required (service is safe to call even when block  
> allocation
> + * resources were not present - such as when transitioning from  
> physical mode).
> + * These resources will be reallocated when needed (subsequent transition to
> + * virtual mode).
>   */
>  void cxlflash_lun_detach(struct glun_info *gli)
>  {
>  	mutex_lock(&gli->mutex);
>  	WARN_ON(gli->mode == MODE_NONE);
> -	if (--gli->users == 0)
> +	if (--gli->users == 0) {
>  		gli->mode = MODE_NONE;
> +		cxlflash_ba_terminate(&gli->blka.ba_lun);
> +	}
>  	pr_debug("%s: gli->users=%u\n", __func__, gli->users);
>  	WARN_ON(gli->users < 0);
>  	mutex_unlock(&gli->mutex);
> @@ -544,10 +567,12 @@ void cxlflash_lun_detach(struct glun_info *gli)
>   * @ctxi:	Context owning resources.
>   * @release:	Release ioctl data structure.
>   *
> - * Note that the AFU sync should _not_ be performed when the  
> context is sitting
> - * on the error recovery list. A context on the error recovery list  
> is not known
> - * to the AFU due to reset. When the context is recovered, it will  
> be reattached
> - * and made known again to the AFU.
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
>   *
>   * Return: 0 on success, -errno on failure
>   */
> @@ -562,6 +587,7 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
>  	struct afu *afu = cfg->afu;
>  	bool put_ctx = false;
>
> +	struct dk_cxlflash_resize size;
>  	res_hndl_t rhndl = release->rsrc_handle;
>
>  	int rc = 0;
> @@ -594,7 +620,24 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
>  		goto out;
>  	}
>
> +	/*
> +	 * Resize to 0 for virtual LUNS by setting the size
> +	 * to 0. This will clear LXT_START and LXT_CNT fields
> +	 * in the RHT entry and properly sync with the AFU.
> +	 *
> +	 * Afterwards we clear the remaining fields.
> +	 */
>  	switch (gli->mode) {
> +	case MODE_VIRTUAL:
> +		marshal_rele_to_resize(release, &size);
> +		size.req_size = 0;
> +		rc = _cxlflash_vlun_resize(sdev, ctxi, &size);
> +		if (rc) {
> +			dev_dbg(dev, "%s: resize failed rc %d\n", __func__, rc);
> +			goto out;
> +		}
> +
> +		break;
>  	case MODE_PHYSICAL:
>  		/*
>  		 * Clear the Format 1 RHT entry for direct access
> @@ -666,6 +709,7 @@ static void destroy_context(struct cxlflash_cfg *cfg,
>
>  	/* Free memory associated with context */
>  	free_page((ulong)ctxi->rht_start);
> +	kfree(ctxi->rht_needs_ws);
>  	kfree(ctxi->rht_lun);
>  	kfree(ctxi);
>  	atomic_dec_if_positive(&cfg->num_user_contexts);
> @@ -693,11 +737,13 @@ static struct ctx_info *create_context(struct  
> cxlflash_cfg *cfg,
>  	struct afu *afu = cfg->afu;
>  	struct ctx_info *ctxi = NULL;
>  	struct llun_info **lli = NULL;
> +	bool *ws = NULL;
>  	struct sisl_rht_entry *rhte;
>
>  	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
>  	lli = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*lli)), GFP_KERNEL);
> -	if (unlikely(!ctxi || !lli)) {
> +	ws = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*ws)), GFP_KERNEL);
> +	if (unlikely(!ctxi || !lli || !ws)) {
>  		dev_err(dev, "%s: Unable to allocate context!\n", __func__);
>  		goto out;
>  	}
> @@ -709,6 +755,7 @@ static struct ctx_info *create_context(struct  
> cxlflash_cfg *cfg,
>  	}
>
>  	ctxi->rht_lun = lli;
> +	ctxi->rht_needs_ws = ws;
>  	ctxi->rht_start = rhte;
>  	ctxi->rht_perms = perms;
>
> @@ -728,6 +775,7 @@ out:
>  	return ctxi;
>
>  err:
> +	kfree(ws);
>  	kfree(lli);
>  	kfree(ctxi);
>  	ctxi = NULL;
> @@ -1729,6 +1777,12 @@ static int cxlflash_disk_verify(struct  
> scsi_device *sdev,
>  	case MODE_PHYSICAL:
>  		last_lba = gli->max_lba;
>  		break;
> +	case MODE_VIRTUAL:
> +		/* Cast lxt_cnt to u64 for multiply to be treated as 64bit op */
> +		last_lba = ((u64)rhte->lxt_cnt * MC_CHUNK_SIZE * gli->blk_len);
> +		last_lba /= CXLFLASH_BLOCK_SIZE;
> +		last_lba--;
> +		break;
>  	default:
>  		WARN(1, "Unsupported LUN mode!");
>  	}
> @@ -1756,12 +1810,18 @@ static char *decode_ioctl(int cmd)
>  		return __stringify_1(DK_CXLFLASH_ATTACH);
>  	case DK_CXLFLASH_USER_DIRECT:
>  		return __stringify_1(DK_CXLFLASH_USER_DIRECT);
> +	case DK_CXLFLASH_USER_VIRTUAL:
> +		return __stringify_1(DK_CXLFLASH_USER_VIRTUAL);
> +	case DK_CXLFLASH_VLUN_RESIZE:
> +		return __stringify_1(DK_CXLFLASH_VLUN_RESIZE);
>  	case DK_CXLFLASH_RELEASE:
>  		return __stringify_1(DK_CXLFLASH_RELEASE);
>  	case DK_CXLFLASH_DETACH:
>  		return __stringify_1(DK_CXLFLASH_DETACH);
>  	case DK_CXLFLASH_VERIFY:
>  		return __stringify_1(DK_CXLFLASH_VERIFY);
> +	case DK_CXLFLASH_VLUN_CLONE:
> +		return __stringify_1(DK_CXLFLASH_VLUN_CLONE);
>  	case DK_CXLFLASH_RECOVER_AFU:
>  		return __stringify_1(DK_CXLFLASH_RECOVER_AFU);
>  	case DK_CXLFLASH_MANAGE_LUN:
> @@ -1924,12 +1984,18 @@ int cxlflash_ioctl(struct scsi_device *sdev,  
> int cmd, void __user *arg)
>  	{sizeof(struct dk_cxlflash_verify), (sioctl)cxlflash_disk_verify},
>  	{sizeof(struct dk_cxlflash_recover_afu), (sioctl)cxlflash_afu_recover},
>  	{sizeof(struct dk_cxlflash_manage_lun), (sioctl)cxlflash_manage_lun},
> +	{sizeof(struct dk_cxlflash_uvirtual), cxlflash_disk_virtual_open},
> +	{sizeof(struct dk_cxlflash_resize), (sioctl)cxlflash_vlun_resize},
> +	{sizeof(struct dk_cxlflash_clone), (sioctl)cxlflash_disk_clone},
>  	};
>
>  	/* Restrict command set to physical support only for internal LUN */
>  	if (afu->internal_lun)
>  		switch (cmd) {
>  		case DK_CXLFLASH_RELEASE:
> +		case DK_CXLFLASH_USER_VIRTUAL:
> +		case DK_CXLFLASH_VLUN_RESIZE:
> +		case DK_CXLFLASH_VLUN_CLONE:
>  			dev_dbg(dev, "%s: %s not supported for lun_mode=%d\n",
>  				__func__, decode_ioctl(cmd), afu->internal_lun);
>  			rc = -EINVAL;
> @@ -1943,6 +2009,9 @@ int cxlflash_ioctl(struct scsi_device *sdev,  
> int cmd, void __user *arg)
>  	case DK_CXLFLASH_DETACH:
>  	case DK_CXLFLASH_VERIFY:
>  	case DK_CXLFLASH_RECOVER_AFU:
> +	case DK_CXLFLASH_USER_VIRTUAL:
> +	case DK_CXLFLASH_VLUN_RESIZE:
> +	case DK_CXLFLASH_VLUN_CLONE:
>  		dev_dbg(dev, "%s: %s (%08X) on dev(%d/%d/%d/%llu)\n",
>  			__func__, decode_ioctl(cmd), cmd, shost->host_no,
>  			sdev->channel, sdev->id, sdev->lun);
> diff --git a/drivers/scsi/cxlflash/superpipe.h  
> b/drivers/scsi/cxlflash/superpipe.h
> index 9adc42b..e921129 100644
> --- a/drivers/scsi/cxlflash/superpipe.h
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -31,9 +31,11 @@ extern struct cxlflash_global global;
>  #define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
>
>  #define CHAN2PORT(_x)	((_x) + 1)
> +#define PORT2CHAN(_x)	((_x) - 1)
>
>  enum lun_mode {
>  	MODE_NONE = 0,
> +	MODE_VIRTUAL,
>  	MODE_PHYSICAL
>  };
>
> @@ -41,13 +43,14 @@ enum lun_mode {
>  struct glun_info {
>  	u64 max_lba;		/* from read cap(16) */
>  	u32 blk_len;		/* from read cap(16) */
> -	enum lun_mode mode;	/* NONE, PHYSICAL */
> +	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
>  	int users;		/* Number of users w/ references to LUN */
>
>  	u8 wwid[16];
>
>  	struct mutex mutex;
>
> +	struct blka blka;
>  	struct list_head list;
>  };
>
> @@ -58,6 +61,7 @@ struct llun_info {
>  	u32 host_no;		/* host_no from Scsi_host */
>  	u32 port_sel;		/* What port to use for this LUN */
>  	bool newly_created;	/* Whether the LUN was just discovered */
> +	bool in_table;		/* Whether a LUN table entry was created */
>
>  	u8 wwid[16];		/* Keep a duplicate copy here? */
>
> @@ -90,6 +94,7 @@ struct ctx_info {
>  	u32 rht_out;		/* Number of checked out RHT entries */
>  	u32 rht_perms;		/* User-defined permissions for RHT entries */
>  	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
> +	bool *rht_needs_ws;	/* User-desired write-same function per RHTE */
>
>  	struct cxl_ioctl_start_work work;
>  	u64 ctxid;
> @@ -111,10 +116,18 @@ struct cxlflash_global {
>  	struct page *err_page; /* One page of all 0xF for error notification */
>  };
>
> +int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
> +int _cxlflash_vlun_resize(struct scsi_device *, struct ctx_info *,
> +			  struct dk_cxlflash_resize *);
> +
>  int cxlflash_disk_release(struct scsi_device *, struct  
> dk_cxlflash_release *);
>  int _cxlflash_disk_release(struct scsi_device *, struct ctx_info *,
>  			   struct dk_cxlflash_release *);
>
> +int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
> +
> +int cxlflash_disk_virtual_open(struct scsi_device *, void *);
> +
>  int cxlflash_lun_attach(struct glun_info *, enum lun_mode, bool);
>  void cxlflash_lun_detach(struct glun_info *);
>
> @@ -127,6 +140,8 @@ struct sisl_rht_entry *get_rhte(struct ctx_info  
> *, res_hndl_t,
>  struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct llun_info *);
>  void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
>
> +void cxlflash_ba_terminate(struct ba_lun *);
> +
>  int cxlflash_manage_lun(struct scsi_device *, struct  
> dk_cxlflash_manage_lun *);
>
>  #endif /* ifndef _CXLFLASH_SUPERPIPE_H */
> diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
> new file mode 100644
> index 0000000..aa9a546
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/vlun.c
> @@ -0,0 +1,1243 @@
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
> +#include <linux/syscalls.h>
> +#include <misc/cxl.h>
> +#include <asm/unaligned.h>
> +#include <asm/bitsperlong.h>
> +
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> +#include <uapi/scsi/cxlflash_ioctl.h>
> +
> +#include "sislite.h"
> +#include "common.h"
> +#include "vlun.h"
> +#include "superpipe.h"
> +
> +/**
> + * marshal_virt_to_resize() - translate uvirtual to resize structure
> + * @virt:	Source structure from which to translate/copy.
> + * @resize:	Destination structure for the translate/copy.
> + */
> +static void marshal_virt_to_resize(struct dk_cxlflash_uvirtual *virt,
> +				   struct dk_cxlflash_resize *resize)
> +{
> +	resize->hdr = virt->hdr;
> +	resize->context_id = virt->context_id;
> +	resize->rsrc_handle = virt->rsrc_handle;
> +	resize->req_size = virt->lun_size;
> +	resize->last_lba = virt->last_lba;
> +}
> +
> +/**
> + * marshal_clone_to_rele() - translate clone to release structure
> + * @clone:	Source structure from which to translate/copy.
> + * @rele:	Destination structure for the translate/copy.
> + */
> +static void marshal_clone_to_rele(struct dk_cxlflash_clone *clone,
> +				  struct dk_cxlflash_release *release)
> +{
> +	release->hdr = clone->hdr;
> +	release->context_id = clone->context_id_dst;
> +}
> +
> +/**
> + * ba_init() - initializes a block allocator
> + * @ba_lun:	Block allocator to initialize.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int ba_init(struct ba_lun *ba_lun)
> +{
> +	struct ba_lun_info *bali = NULL;
> +	int lun_size_au = 0, i = 0;
> +	int last_word_underflow = 0;
> +	u64 *lam;
> +
> +	pr_debug("%s: Initializing LUN: lun_id = %llX, "
> +		 "ba_lun->lsize = %lX, ba_lun->au_size = %lX\n",
> +		__func__, ba_lun->lun_id, ba_lun->lsize, ba_lun->au_size);
> +
> +	/* Calculate bit map size */
> +	lun_size_au = ba_lun->lsize / ba_lun->au_size;
> +	if (lun_size_au == 0) {
> +		pr_debug("%s: Requested LUN size of 0!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* Allocate lun information container */
> +	bali = kzalloc(sizeof(struct ba_lun_info), GFP_KERNEL);
> +	if (unlikely(!bali)) {
> +		pr_err("%s: Failed to allocate lun_info for lun_id %llX\n",
> +		       __func__, ba_lun->lun_id);
> +		return -ENOMEM;
> +	}
> +
> +	bali->total_aus = lun_size_au;
> +	bali->lun_bmap_size = lun_size_au / BITS_PER_LONG;
> +
> +	if (lun_size_au % BITS_PER_LONG)
> +		bali->lun_bmap_size++;
> +
> +	/* Allocate bitmap space */
> +	bali->lun_alloc_map = kzalloc((bali->lun_bmap_size * sizeof(u64)),
> +				      GFP_KERNEL);
> +	if (unlikely(!bali->lun_alloc_map)) {
> +		pr_err("%s: Failed to allocate lun allocation map: "
> +		       "lun_id = %llX\n", __func__, ba_lun->lun_id);
> +		kfree(bali);
> +		return -ENOMEM;
> +	}
> +
> +	/* Initialize the bit map size and set all bits to '1' */
> +	bali->free_aun_cnt = lun_size_au;
> +
> +	for (i = 0; i < bali->lun_bmap_size; i++)
> +		bali->lun_alloc_map[i] = 0xFFFFFFFFFFFFFFFFULL;
> +
> +	/* If the last word not fully utilized, mark extra bits as allocated */
> +	last_word_underflow = (bali->lun_bmap_size * BITS_PER_LONG);
> +	last_word_underflow -= bali->free_aun_cnt;
> +	if (last_word_underflow > 0) {
> +		lam = &bali->lun_alloc_map[bali->lun_bmap_size - 1];
> +		for (i = (HIBIT - last_word_underflow + 1);
> +		     i < BITS_PER_LONG;
> +		     i++)
> +			clear_bit(i, (ulong *)lam);
> +	}
> +
> +	/* Initialize high elevator index, low/curr already at 0 from kzalloc */
> +	bali->free_high_idx = bali->lun_bmap_size;
> +
> +	/* Allocate clone map */
> +	bali->aun_clone_map = kzalloc((bali->total_aus * sizeof(u8)),
> +				      GFP_KERNEL);
> +	if (unlikely(!bali->aun_clone_map)) {
> +		pr_err("%s: Failed to allocate clone map: lun_id = %llX\n",
> +		       __func__, ba_lun->lun_id);
> +		kfree(bali->lun_alloc_map);
> +		kfree(bali);
> +		return -ENOMEM;
> +	}
> +
> +	/* Pass the allocated lun info as a handle to the user */
> +	ba_lun->ba_lun_handle = bali;
> +
> +	pr_debug("%s: Successfully initialized the LUN: "
> +		 "lun_id = %llX, bitmap size = %X, free_aun_cnt = %llX\n",
> +		__func__, ba_lun->lun_id, bali->lun_bmap_size,
> +		bali->free_aun_cnt);
> +	return 0;
> +}
> +
> +/**
> + * find_free_range() - locates a free bit within the block allocator
> + * @low:	First word in block allocator to start search.
> + * @high:	Last word in block allocator to search.
> + * @bali:	LUN information structure owning the block allocator to search.
> + * @bit_word:	Passes back the word in the block allocator owning  
> the free bit.
> + *
> + * Return: The bit position within the passed back word, -1 on failure
> + */
> +static int find_free_range(u32 low,
> +			   u32 high,
> +			   struct ba_lun_info *bali, int *bit_word)
> +{
> +	int i;
> +	u64 bit_pos = -1;
> +	ulong *lam, num_bits;
> +
> +	for (i = low; i < high; i++)
> +		if (bali->lun_alloc_map[i] != 0) {
> +			lam = (ulong *)&bali->lun_alloc_map[i];
> +			num_bits = (sizeof(*lam) * BITS_PER_BYTE);
> +			bit_pos = find_first_bit(lam, num_bits);
> +
> +			pr_devel("%s: Found free bit %llX in lun "
> +				 "map entry %llX at bitmap index = %X\n",
> +				 __func__, bit_pos, bali->lun_alloc_map[i],
> +				 i);
> +
> +			*bit_word = i;
> +			bali->free_aun_cnt--;
> +			clear_bit(bit_pos, lam);
> +			break;
> +		}
> +
> +	return bit_pos;
> +}
> +
> +/**
> + * ba_alloc() - allocates a block from the block allocator
> + * @ba_lun:	Block allocator from which to allocate a block.
> + *
> + * Return: The allocated block, -1 on failure
> + */
> +static u64 ba_alloc(struct ba_lun *ba_lun)
> +{
> +	u64 bit_pos = -1;
> +	int bit_word = 0;
> +	struct ba_lun_info *bali = NULL;
> +
> +	bali = ba_lun->ba_lun_handle;
> +
> +	pr_debug("%s: Received block allocation request: "
> +		 "lun_id = %llX, free_aun_cnt = %llX\n",
> +		 __func__, ba_lun->lun_id, bali->free_aun_cnt);
> +
> +	if (bali->free_aun_cnt == 0) {
> +		pr_debug("%s: No space left on LUN: lun_id = %llX\n",
> +			 __func__, ba_lun->lun_id);
> +		return -1ULL;
> +	}
> +
> +	/* Search to find a free entry, curr->high then low->curr */
> +	bit_pos = find_free_range(bali->free_curr_idx,
> +				  bali->free_high_idx, bali, &bit_word);
> +	if (bit_pos == -1) {
> +		bit_pos = find_free_range(bali->free_low_idx,
> +					  bali->free_curr_idx,
> +					  bali, &bit_word);
> +		if (bit_pos == -1) {
> +			pr_debug("%s: Could not find an allocation unit on LUN:"
> +				 " lun_id = %llX\n", __func__, ba_lun->lun_id);
> +			return -1ULL;
> +		}
> +	}
> +
> +	/* Update the free_curr_idx */
> +	if (bit_pos == HIBIT)
> +		bali->free_curr_idx = bit_word + 1;
> +	else
> +		bali->free_curr_idx = bit_word;
> +
> +	pr_debug("%s: Allocating AU number %llX, on lun_id %llX, "
> +		 "free_aun_cnt = %llX\n", __func__,
> +		 ((bit_word * BITS_PER_LONG) + bit_pos), ba_lun->lun_id,
> +		 bali->free_aun_cnt);
> +
> +	return (u64) ((bit_word * BITS_PER_LONG) + bit_pos);
> +}
> +
> +/**
> + * validate_alloc() - validates the specified block has been allocated
> + * @ba_lun_info:	LUN info owning the block allocator.
> + * @aun:		Block to validate.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int validate_alloc(struct ba_lun_info *bali, u64 aun)
> +{
> +	int idx = 0, bit_pos = 0;
> +
> +	idx = aun / BITS_PER_LONG;
> +	bit_pos = aun % BITS_PER_LONG;
> +
> +	if (test_bit(bit_pos, (ulong *)&bali->lun_alloc_map[idx]))
> +		return -1;
> +
> +	return 0;
> +}
> +
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
> +	struct ba_lun_info *bali = NULL;
> +
> +	bali = ba_lun->ba_lun_handle;
> +
> +	if (validate_alloc(bali, to_free)) {
> +		pr_debug("%s: The AUN %llX is not allocated on lun_id %llX\n",
> +			 __func__, to_free, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	pr_debug("%s: Received a request to free AU %llX on lun_id %llX, "
> +		 "free_aun_cnt = %llX\n", __func__, to_free, ba_lun->lun_id,
> +		 bali->free_aun_cnt);
> +
> +	if (bali->aun_clone_map[to_free] > 0) {
> +		pr_debug("%s: AUN %llX on lun_id %llX has been cloned. Clone "
> +			 "count = %X\n", __func__, to_free, ba_lun->lun_id,
> +			 bali->aun_clone_map[to_free]);
> +		bali->aun_clone_map[to_free]--;
> +		return 0;
> +	}
> +
> +	idx = to_free / BITS_PER_LONG;
> +	bit_pos = to_free % BITS_PER_LONG;
> +
> +	set_bit(bit_pos, (ulong *)&bali->lun_alloc_map[idx]);
> +	bali->free_aun_cnt++;
> +
> +	if (idx < bali->free_low_idx)
> +		bali->free_low_idx = idx;
> +	else if (idx > bali->free_high_idx)
> +		bali->free_high_idx = idx;
> +
> +	pr_debug("%s: Successfully freed AU at bit_pos %X, bit map index %X on "
> +		 "lun_id %llX, free_aun_cnt = %llX\n", __func__, bit_pos, idx,
> +		 ba_lun->lun_id, bali->free_aun_cnt);
> +
> +	return 0;
> +}
> +
> +/**
> + * ba_clone() - Clone a chunk of the block allocation table
> + * @ba_lun:	Block allocator from which to allocate a block.
> + * @to_free:	Block to free.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int ba_clone(struct ba_lun *ba_lun, u64 to_clone)
> +{
> +	struct ba_lun_info *bali = ba_lun->ba_lun_handle;
> +
> +	if (validate_alloc(bali, to_clone)) {
> +		pr_debug("%s: AUN %llX is not allocated on lun_id %llX\n",
> +			 __func__, to_clone, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	pr_debug("%s: Received a request to clone AUN %llX on lun_id %llX\n",
> +		 __func__, to_clone, ba_lun->lun_id);
> +
> +	if (bali->aun_clone_map[to_clone] == MAX_AUN_CLONE_CNT) {
> +		pr_debug("%s: AUN %llX on lun_id %llX hit max clones already\n",
> +			 __func__, to_clone, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	bali->aun_clone_map[to_clone]++;
> +
> +	return 0;
> +}
> +
> +/**
> + * ba_space() - returns the amount of free space left in the block allocator
> + * @ba_lun:	Block allocator.
> + *
> + * Return: Amount of free space in block allocator
> + */
> +static u64 ba_space(struct ba_lun *ba_lun)
> +{
> +	struct ba_lun_info *bali = ba_lun->ba_lun_handle;
> +
> +	return bali->free_aun_cnt;
> +}
> +
> +/**
> + * cxlflash_ba_terminate() - frees resources associated with the  
> block allocator
> + * @ba_lun:	Block allocator.
> + *
> + * Safe to call in a partially allocated state.
> + */
> +void cxlflash_ba_terminate(struct ba_lun *ba_lun)
> +{
> +	struct ba_lun_info *bali = ba_lun->ba_lun_handle;
> +
> +	if (bali) {
> +		kfree(bali->aun_clone_map);
> +		kfree(bali->lun_alloc_map);
> +		kfree(bali);
> +		ba_lun->ba_lun_handle = NULL;
> +	}
> +}
> +
> +/**
> + * init_vlun() - initializes a LUN for virtual use
> + * @lun_info:	LUN information structure that owns the block allocator.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int init_vlun(struct llun_info *lli)
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
> +	if (unlikely(rc))
> +		pr_debug("%s: cannot init block_alloc, rc=%d\n", __func__, rc);
> +
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
> + * Return: 0 on success, -errno on failure
> + */
> +static int write_same16(struct scsi_device *sdev,
> +			u64 lba,
> +			u32 nblks)
> +{
> +	u8 *cmd_buf = NULL;
> +	u8 *scsi_cmd = NULL;
> +	u8 *sense_buf = NULL;
> +	int rc = 0;
> +	int result = 0;
> +	int ws_limit = SISLITE_MAX_WS_BLOCKS;
> +	u64 offset = lba;
> +	int left = nblks;
> +	u32 tout = sdev->request_queue->rq_timeout;
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct device *dev = &cfg->dev->dev;
> +
> +	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
> +	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
> +	sense_buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> +	if (unlikely(!cmd_buf || !scsi_cmd || !sense_buf)) {
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
> +		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
> +				      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
> +		if (result) {
> +			dev_err_ratelimited(dev, "%s: command failed for "
> +					    "offset %lld result=0x%x\n",
> +					    __func__, offset, result);
> +			rc = -EIO;
> +			goto out;
> +		}
> +		left -= ws_limit;
> +		offset += ws_limit;
> +	}
> +
> +out:
> +	kfree(cmd_buf);
> +	kfree(scsi_cmd);
> +	kfree(sense_buf);
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
> +		pr_debug("%s: ba_space error: av_size %d\n", __func__, av_size);
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
> +			pr_debug("%s: ba_alloc error: allocated chunk# %llX, "
> +				 "max %llX\n", __func__, aun, blka->nchunk - 1);
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
> + * @rhndl:	Resource handle associated with the RHTE.
> + * @rhte:	Resource handle entry (RHTE).
> + * @ctxi:	Context owning resources.
> + * @new_size:	Number of translation entries associated with RHTE.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int shrink_lxt(struct afu *afu,
> +		      struct scsi_device *sdev,
> +		      res_hndl_t rhndl,
> +		      struct sisl_rht_entry *rhte,
> +		      struct ctx_info *ctxi,
> +		      u64 *new_size)
> +{
> +	struct sisl_lxt_entry *lxt, *lxt_old;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct blka *blka = &gli->blka;
> +	ctx_hndl_t ctxid = DECODE_CTXID(ctxi->ctxid);
> +	bool needs_ws = ctxi->rht_needs_ws[rhndl];
> +	bool needs_sync = !ctxi->err_recovery_active;
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
> +		/* Reallocate to fit new size unless new size is 0 */
> +		if (ngrps) {
> +			lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
> +				      GFP_KERNEL);
> +			if (unlikely(!lxt)) {
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +
> +			/* Copy over old entries that will remain */
> +			memcpy(lxt, lxt_old,
> +			       (sizeof(*lxt) * (rhte->lxt_cnt - delta)));
> +		} else
> +			lxt = NULL;
> +	} else
> +		lxt = lxt_old;
> +
> +	/* Nothing can fail from now on */
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
> +	if (needs_sync)
> +		cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
> +
> +	if (needs_ws) {
> +		/*
> +		 * Mark the context as unavailable, so that we can release
> +		 * the mutex safely.
> +		 */
> +		ctxi->unavail = true;
> +		mutex_unlock(&ctxi->mutex);
> +	}
> +
> +	/* Free LBAs allocated to freed chunks */
> +	mutex_lock(&blka->mutex);
> +	for (i = delta - 1; i >= 0; i--) {
> +		/* Mask the higher 48 bits before shifting, even though
> +		 * it is a noop
> +		 */
> +		aun = (lxt_old[my_new_size + i].rlba_base & SISL_ASTATUS_MASK);
> +		aun = (aun >> MC_CHUNK_SHIFT);
> +		if (needs_ws)
> +			write_same16(sdev, aun, MC_CHUNK_SIZE);
> +		ba_free(&blka->ba_lun, aun);
> +	}
> +	mutex_unlock(&blka->mutex);
> +
> +	if (needs_ws) {
> +		/* Make the context visible again */
> +		mutex_lock(&ctxi->mutex);
> +		ctxi->unavail = false;
> +	}
> +
> +	/* Free old lxt if reallocated */
> +	if (lxt != lxt_old)
> +		kfree(lxt_old);
> +	*new_size = my_new_size;
> +out:
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +
> +/**
> + * _cxlflash_vlun_resize() - changes the size of a virtual lun
> + * @sdev:	SCSI device associated with LUN owning virtual LUN.
> + * @ctxi:	Context owning resources.
> + * @resize:	Resize ioctl data structure.
> + *
> + * On successful return, the user is informed of the new size (in blocks)
> + * of the virtual lun in last LBA format. When the size of the virtual
> + * lun is zero, the last LBA is reflected as -1. See comment in the
> + * prologue for _cxlflash_disk_release() regarding AFU syncs and contexts
> + * on the error recovery list.
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
> +	bool put_ctx = false;
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
> +	/*
> +	 * The requested size (req_size) is always assumed to be in 4k blocks,
> +	 * so we have to convert it here from 4k to chunk size.
> +	 */
> +	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
> +	new_size = DIV_ROUND_UP(nsectors, MC_CHUNK_SIZE);
> +
> +	pr_debug("%s: ctxid=%llu rhndl=0x%llx, req_size=0x%llx,"
> +		 "new_size=%llx\n", __func__, ctxid, resize->rsrc_handle,
> +		 resize->req_size, new_size);
> +
> +	if (unlikely(gli->mode != MODE_VIRTUAL)) {
> +		pr_debug("%s: LUN mode does not support resize! (%d)\n",
> +			 __func__, gli->mode);
> +		rc = -EINVAL;
> +		goto out;
> +
> +	}
> +
> +	if (!ctxi) {
> +		ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
> +		if (unlikely(!ctxi)) {
> +			pr_debug("%s: Bad context! (%llu)\n", __func__, ctxid);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		put_ctx = true;
> +	}
> +
> +	rhte = get_rhte(ctxi, rhndl, lli);
> +	if (unlikely(!rhte)) {
> +		pr_debug("%s: Bad resource handle! (%u)\n", __func__, rhndl);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (new_size > rhte->lxt_cnt)
> +		rc = grow_lxt(afu, sdev, ctxid, rhndl, rhte, &new_size);
> +	else if (new_size < rhte->lxt_cnt)
> +		rc = shrink_lxt(afu, sdev, rhndl, rhte, ctxi, &new_size);
> +
> +	resize->hdr.return_flags = 0;
> +	resize->last_lba = (new_size * MC_CHUNK_SIZE * gli->blk_len);
> +	resize->last_lba /= CXLFLASH_BLOCK_SIZE;
> +	resize->last_lba--;
> +
> +out:
> +	if (put_ctx)
> +		put_context(ctxi);
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
> + * cxlflash_restore_luntable() - Restore LUN table to prior state
> + * @cfg:	Internal structure associated with the host.
> + */
> +void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
> +{
> +	struct llun_info *lli, *temp;
> +	u32 chan;
> +	u32 lind;
> +	struct afu *afu = cfg->afu;
> +	struct sisl_global_map *agm = &afu->afu_map->global;
> +
> +	mutex_lock(&global.mutex);
> +
> +	list_for_each_entry_safe(lli, temp, &cfg->lluns, list) {
> +		if (!lli->in_table)
> +			continue;
> +
> +		lind = lli->lun_index;
> +
> +		if (lli->port_sel == BOTH_PORTS) {
> +			writeq_be(lli->lun_id[0], &agm->fc_port[0][lind]);
> +			writeq_be(lli->lun_id[1], &agm->fc_port[1][lind]);
> +			pr_debug("%s: Virtual LUN on slot %d  id0=%llx, "
> +				 "id1=%llx\n", __func__, lind,
> +				 lli->lun_id[0], lli->lun_id[1]);
> +		} else {
> +			chan = PORT2CHAN(lli->port_sel);
> +			writeq_be(lli->lun_id[chan], &agm->fc_port[chan][lind]);
> +			pr_debug("%s: Virtual LUN on slot %d chan=%d, "
> +				 "id=%llx\n", __func__, lind, chan,
> +				 lli->lun_id[chan]);
> +		}
> +	}
> +
> +	mutex_unlock(&global.mutex);
> +}
> +
> +/**
> + * init_luntable() - write an entry in the LUN table
> + * @cfg:	Internal structure associated with the host.
> + * @lli:	Per adapter LUN information structure.
> + *
> + * On successful return, a LUN table entry is created.
> + * At the top for LUNs visible on both ports.
> + * At the bottom for LUNs visible only on one port.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
> +{
> +	u32 chan;
> +	u32 lind;
> +	int rc = 0;
> +	struct afu *afu = cfg->afu;
> +	struct sisl_global_map *agm = &afu->afu_map->global;
> +
> +	mutex_lock(&global.mutex);
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
> +		lind = lli->lun_index = cfg->promote_lun_index;
> +		writeq_be(lli->lun_id[0], &agm->fc_port[0][lind]);
> +		writeq_be(lli->lun_id[1], &agm->fc_port[1][lind]);
> +		cfg->promote_lun_index++;
> +		pr_debug("%s: Virtual LUN on slot %d  id0=%llx, id1=%llx\n",
> +			 __func__, lind, lli->lun_id[0], lli->lun_id[1]);
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
> +		lind = lli->lun_index = cfg->last_lun_index[chan];
> +		writeq_be(lli->lun_id[chan], &agm->fc_port[chan][lind]);
> +		cfg->last_lun_index[chan]--;
> +		pr_debug("%s: Virtual LUN on slot %d  chan=%d, id=%llx\n",
> +			 __func__, lind, chan, lli->lun_id[chan]);
> +	}
> +
> +	lli->in_table = true;
> +out:
> +	mutex_unlock(&global.mutex);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
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
> +	struct device *dev = &cfg->dev->dev;
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
> +	mutex_lock(&gli->mutex);
> +	if (gli->mode == MODE_NONE) {
> +		/* Setup the LUN table and block allocator on first call */
> +		rc = init_luntable(cfg, lli);
> +		if (rc) {
> +			dev_err(dev, "%s: call to init_luntable failed "
> +				"rc=%d!\n", __func__, rc);
> +			goto err0;
> +		}
> +
> +		rc = init_vlun(lli);
> +		if (rc) {
> +			dev_err(dev, "%s: call to init_vlun failed rc=%d!\n",
> +				__func__, rc);
> +			rc = -ENOMEM;
> +			goto err0;
> +		}
> +	}
> +
> +	rc = cxlflash_lun_attach(gli, MODE_VIRTUAL, true);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: Failed to attach to LUN! (VIRTUAL)\n",
> +			__func__);
> +		goto err0;
> +	}
> +	mutex_unlock(&gli->mutex);
> +
> +	ctxi = get_context(cfg, rctxid, lli, 0);
> +	if (unlikely(!ctxi)) {
> +		dev_err(dev, "%s: Bad context! (%llu)\n", __func__, ctxid);
> +		rc = -EINVAL;
> +		goto err1;
> +	}
> +
> +	rhte = rhte_checkout(ctxi, lli);
> +	if (unlikely(!rhte)) {
> +		dev_err(dev, "%s: too many opens for this context\n", __func__);
> +		rc = -EMFILE;	/* too many opens  */
> +		goto err1;
> +	}
> +
> +	rsrc_handle = (rhte - ctxi->rht_start);
> +
> +	/* Populate RHT format 0 */
> +	rhte->nmask = MC_RHT_NMASK;
> +	rhte->fp = SISL_RHT_FP(0U, ctxi->rht_perms);
> +
> +	/* Resize even if requested size is 0 */
> +	marshal_virt_to_resize(virt, &resize);
> +	resize.rsrc_handle = rsrc_handle;
> +	rc = _cxlflash_vlun_resize(sdev, ctxi, &resize);
> +	if (rc) {
> +		dev_err(dev, "%s: resize failed rc %d\n", __func__, rc);
> +		goto err2;
> +	}
> +	last_lba = resize.last_lba;
> +
> +	if (virt->hdr.flags & DK_CXLFLASH_UVIRTUAL_NEED_WRITE_SAME)
> +		ctxi->rht_needs_ws[rsrc_handle] = true;
> +
> +	virt->hdr.return_flags = 0;
> +	virt->last_lba = last_lba;
> +	virt->rsrc_handle = rsrc_handle;
> +
> +out:
> +	if (likely(ctxi))
> +		put_context(ctxi);
> +	pr_debug("%s: returning handle 0x%llx rc=%d llba %lld\n",
> +		 __func__, rsrc_handle, rc, last_lba);
> +	return rc;
> +
> +err2:
> +	rhte_checkin(ctxi, rhte);
> +err1:
> +	cxlflash_lun_detach(gli);
> +	goto out;
> +err0:
> +	/* Special common cleanup prior to successful LUN attach */
> +	cxlflash_ba_terminate(&gli->blka.ba_lun);
> +	mutex_unlock(&gli->mutex);
> +	goto out;
> +}
> +
> +/**
> + * clone_lxt() - copies translation tables from source to destination RHTE
> + * @afu:	AFU associated with the host.
> + * @blka:	Block allocator associated with LUN.
> + * @ctxid:	Context ID of context owning the RHTE.
> + * @rhndl:	Resource handle associated with the RHTE.
> + * @rhte:	Destination resource handle entry (RHTE).
> + * @rhte_src:	Source resource handle entry (RHTE).
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int clone_lxt(struct afu *afu,
> +		     struct blka *blka,
> +		     ctx_hndl_t ctxid,
> +		     res_hndl_t rhndl,
> +		     struct sisl_rht_entry *rhte,
> +		     struct sisl_rht_entry *rhte_src)
> +{
> +	struct sisl_lxt_entry *lxt;
> +	u32 ngrps;
> +	u64 aun;		/* chunk# allocated by block allocator */
> +	int i, j;
> +
> +	ngrps = LXT_NUM_GROUPS(rhte_src->lxt_cnt);
> +
> +	if (ngrps) {
> +		/* allocate new LXTs for clone */
> +		lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
> +				GFP_KERNEL);
> +		if (unlikely(!lxt))
> +			return -ENOMEM;
> +
> +		/* copy over */
> +		memcpy(lxt, rhte_src->lxt_start,
> +		       (sizeof(*lxt) * rhte_src->lxt_cnt));
> +
> +		/* clone the LBAs in block allocator via ref_cnt */
> +		mutex_lock(&blka->mutex);
> +		for (i = 0; i < rhte_src->lxt_cnt; i++) {
> +			aun = (lxt[i].rlba_base >> MC_CHUNK_SHIFT);
> +			if (ba_clone(&blka->ba_lun, aun) == -1ULL) {
> +				/* free the clones already made */
> +				for (j = 0; j < i; j++) {
> +					aun = (lxt[j].rlba_base >>
> +					       MC_CHUNK_SHIFT);
> +					ba_free(&blka->ba_lun, aun);
> +				}
> +
> +				mutex_unlock(&blka->mutex);
> +				kfree(lxt);
> +				return -EIO;
> +			}
> +		}
> +		mutex_unlock(&blka->mutex);
> +	} else {
> +		lxt = NULL;
> +	}
> +
> +	/*
> +	 * The following sequence is prescribed in the SISlite spec
> +	 * for syncing up with the AFU when adding LXT entries.
> +	 */
> +	dma_wmb(); /* Make LXT updates are visible */
> +
> +	rhte->lxt_start = lxt;
> +	dma_wmb(); /* Make RHT entry's LXT table update visible */
> +
> +	rhte->lxt_cnt = rhte_src->lxt_cnt;
> +	dma_wmb(); /* Make RHT entry's LXT table size update visible */
> +
> +	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
> +
> +	pr_debug("%s: returning\n", __func__);
> +	return 0;
> +}
> +
> +/**
> + * cxlflash_disk_clone() - clone a context by making snapshot of another
> + * @sdev:	SCSI device associated with LUN owning virtual LUN.
> + * @clone:	Clone ioctl data structure.
> + *
> + * This routine effectively performs cxlflash_disk_open operation for each
> + * in-use virtual resource in the source context. Note that the destination
> + * context must be in pristine state and cannot have any resource handles
> + * open at the time of the clone.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int cxlflash_disk_clone(struct scsi_device *sdev,
> +			struct dk_cxlflash_clone *clone)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct llun_info *lli = sdev->hostdata;
> +	struct glun_info *gli = lli->parent;
> +	struct blka *blka = &gli->blka;
> +	struct afu *afu = cfg->afu;
> +	struct dk_cxlflash_release release = { { 0 }, 0 };
> +
> +	struct ctx_info *ctxi_src = NULL,
> +			*ctxi_dst = NULL;
> +	struct lun_access *lun_access_src, *lun_access_dst;
> +	u32 perms;
> +	u64 ctxid_src = DECODE_CTXID(clone->context_id_src),
> +	    ctxid_dst = DECODE_CTXID(clone->context_id_dst),
> +	    rctxid_src = clone->context_id_src,
> +	    rctxid_dst = clone->context_id_dst;
> +	int adap_fd_src = clone->adap_fd_src;
> +	int i, j;
> +	int rc = 0;
> +	bool found;
> +	LIST_HEAD(sidecar);
> +
> +	pr_debug("%s: ctxid_src=%llu ctxid_dst=%llu adap_fd_src=%d\n",
> +		 __func__, ctxid_src, ctxid_dst, adap_fd_src);
> +
> +	/* Do not clone yourself */
> +	if (unlikely(rctxid_src == rctxid_dst)) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (unlikely(gli->mode != MODE_VIRTUAL)) {
> +		rc = -EINVAL;
> +		pr_debug("%s: Clone not supported on physical LUNs! (%d)\n",
> +			 __func__, gli->mode);
> +		goto out;
> +	}
> +
> +	ctxi_src = get_context(cfg, rctxid_src, lli, CTX_CTRL_CLONE);
> +	ctxi_dst = get_context(cfg, rctxid_dst, lli, 0);
> +	if (unlikely(!ctxi_src || !ctxi_dst)) {
> +		pr_debug("%s: Bad context! (%llu,%llu)\n", __func__,
> +			 ctxid_src, ctxid_dst);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (unlikely(adap_fd_src != ctxi_src->lfd)) {
> +		pr_debug("%s: Invalid source adapter fd! (%d)\n",
> +			 __func__, adap_fd_src);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Verify there is no open resource handle in the destination context */
> +	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++)
> +		if (ctxi_dst->rht_start[i].nmask != 0) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +	/* Clone LUN access list */
> +	list_for_each_entry(lun_access_src, &ctxi_src->luns, list) {
> +		found = false;
> +		list_for_each_entry(lun_access_dst, &ctxi_dst->luns, list)
> +			if (lun_access_dst->sdev == lun_access_src->sdev) {
> +				found = true;
> +				break;
> +			}
> +
> +		if (!found) {
> +			lun_access_dst = kzalloc(sizeof(*lun_access_dst),
> +						 GFP_KERNEL);
> +			if (unlikely(!lun_access_dst)) {
> +				pr_err("%s: Unable to allocate lun_access!\n",
> +				       __func__);
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +
> +			*lun_access_dst = *lun_access_src;
> +			list_add(&lun_access_dst->list, &sidecar);
> +		}
> +	}
> +
> +	if (unlikely(!ctxi_src->rht_out)) {
> +		pr_debug("%s: Nothing to clone!\n", __func__);
> +		goto out_success;
> +	}
> +
> +	/* User specified permission on attach */
> +	perms = ctxi_dst->rht_perms;
> +
> +	/*
> +	 * Copy over checked-out RHT (and their associated LXT) entries by
> +	 * hand, stopping after we've copied all outstanding entries and
> +	 * cleaning up if the clone fails.
> +	 *
> +	 * Note: This loop is equivalent to performing cxlflash_disk_open and
> +	 * cxlflash_vlun_resize. As such, LUN accounting needs to be taken into
> +	 * account by attaching after each successful RHT entry clone. In the
> +	 * event that a clone failure is experienced, the LUN detach is handled
> +	 * via the cleanup performed by _cxlflash_disk_release.
> +	 */
> +	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++) {
> +		if (ctxi_src->rht_out == ctxi_dst->rht_out)
> +			break;
> +		if (ctxi_src->rht_start[i].nmask == 0)
> +			continue;
> +
> +		/* Consume a destination RHT entry */
> +		ctxi_dst->rht_out++;
> +		ctxi_dst->rht_start[i].nmask = ctxi_src->rht_start[i].nmask;
> +		ctxi_dst->rht_start[i].fp =
> +		    SISL_RHT_FP_CLONE(ctxi_src->rht_start[i].fp, perms);
> +		ctxi_dst->rht_lun[i] = ctxi_src->rht_lun[i];
> +
> +		rc = clone_lxt(afu, blka, ctxid_dst, i,
> +			       &ctxi_dst->rht_start[i],
> +			       &ctxi_src->rht_start[i]);
> +		if (rc) {
> +			marshal_clone_to_rele(clone, &release);
> +			for (j = 0; j < i; j++) {
> +				release.rsrc_handle = j;
> +				_cxlflash_disk_release(sdev, ctxi_dst,
> +						       &release);
> +			}
> +
> +			/* Put back the one we failed on */
> +			rhte_checkin(ctxi_dst, &ctxi_dst->rht_start[i]);
> +			goto err;
> +		}
> +
> +		cxlflash_lun_attach(gli, gli->mode, false);
> +	}
> +
> +out_success:
> +	list_splice(&sidecar, &ctxi_dst->luns);
> +	sys_close(adap_fd_src);
> +
> +	/* fall through */
> +out:
> +	if (ctxi_src)
> +		put_context(ctxi_src);
> +	if (ctxi_dst)
> +		put_context(ctxi_dst);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +
> +err:
> +	list_for_each_entry_safe(lun_access_src, lun_access_dst, &sidecar, list)
> +		kfree(lun_access_src);
> +	goto out;
> +}
> diff --git a/drivers/scsi/cxlflash/vlun.h b/drivers/scsi/cxlflash/vlun.h
> new file mode 100644
> index 0000000..8b29a74
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/vlun.h
> @@ -0,0 +1,86 @@
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
> +#ifndef _CXLFLASH_VLUN_H
> +#define _CXLFLASH_VLUN_H
> +
> +/* RHT - Resource Handle Table */
> +#define MC_RHT_NMASK      16	/* in bits */
> +#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
> +
> +#define HIBIT             (BITS_PER_LONG - 1)
> +
> +#define MAX_AUN_CLONE_CNT 0xFF
> +
> +/*
> + * LXT - LBA Translation Table
> + *
> + * +-------+-------+-------+-------+-------+-------+-------+---+---+
> + * | RLBA_BASE                                     |LUN_IDX| P |SEL|
> + * +-------+-------+-------+-------+-------+-------+-------+---+---+
> + *
> + * The LXT Entry contains the physical LBA where the chunk starts  
> (RLBA_BASE).
> + * AFU ORes the low order bits from the virtual LBA (offset into the chunk)
> + * with RLBA_BASE. The result is the physical LBA to be sent to storage.
> + * The LXT Entry also contains an index to a LUN TBL and a bitmask of which
> + * outgoing (FC) * ports can be selected. The port select bit-mask is ANDed
> + * with a global port select bit-mask maintained by the driver.
> + * In addition, it has permission bits that are ANDed with the
> + * RHT permissions to arrive at the final permissions for the chunk.
> + *
> + * LXT tables are allocated dynamically in groups. This is done to avoid
> + * a malloc/free overhead each time the LXT has to grow or shrink.
> + *
> + * Based on the current lxt_cnt (used), it is always possible to know
> + * how many are allocated (used+free). The number of allocated entries is
> + * not stored anywhere.
> + *
> + * The LXT table is re-allocated whenever it needs to cross into  
> another group.
> +*/
> +#define LXT_GROUP_SIZE          8
> +#define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
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
> +struct ba_lun {
> +	u64 lun_id;
> +	u64 wwpn;
> +	size_t lsize;		/* LUN size in number of LBAs             */
> +	size_t lba_size;	/* LBA size in number of bytes            */
> +	size_t au_size;		/* Allocation Unit size in number of LBAs */
> +	struct ba_lun_info *ba_lun_handle;
> +};
> +
> +/* Block Allocator */
> +struct blka {
> +	struct ba_lun ba_lun;
> +	u64 nchunk;		/* number of chunks */
> +	struct mutex mutex;
> +};
> +
> +#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
> diff --git a/include/uapi/scsi/cxlflash_ioctl.h  
> b/include/uapi/scsi/cxlflash_ioctl.h
> index 5707734..831351b 100644
> --- a/include/uapi/scsi/cxlflash_ioctl.h
> +++ b/include/uapi/scsi/cxlflash_ioctl.h
> @@ -71,6 +71,17 @@ struct dk_cxlflash_udirect {
>  	__u64 reserved[8];		/* Reserved for future use */
>  };
>
> +#define DK_CXLFLASH_UVIRTUAL_NEED_WRITE_SAME	0x8000000000000000ULL
> +
> +struct dk_cxlflash_uvirtual {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context to own virtual resources */
> +	__u64 lun_size;			/* Requested size, in 4K blocks */
> +	__u64 rsrc_handle;		/* Returned resource handle */
> +	__u64 last_lba;			/* Returned last LBA of LUN */
> +	__u64 reserved[8];		/* Reserved for future use */
> +};
> +
>  struct dk_cxlflash_release {
>  	struct dk_cxlflash_hdr hdr;	/* Common fields */
>  	__u64 context_id;		/* Context owning resources */
> @@ -78,6 +89,23 @@ struct dk_cxlflash_release {
>  	__u64 reserved[8];		/* Reserved for future use */
>  };
>
> +struct dk_cxlflash_resize {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id;		/* Context owning resources */
> +	__u64 rsrc_handle;		/* Resource handle of LUN to resize */
> +	__u64 req_size;			/* New requested size, in 4K blocks */
> +	__u64 last_lba;			/* Returned last LBA of LUN */
> +	__u64 reserved[8];		/* Reserved for future use */
> +};
> +
> +struct dk_cxlflash_clone {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 context_id_src;		/* Context to clone from */
> +	__u64 context_id_dst;		/* Context to clone to */
> +	__u64 adap_fd_src;		/* Source context adapter fd */
> +	__u64 reserved[8];		/* Reserved for future use */
> +};
> +
>  #define DK_CXLFLASH_VERIFY_SENSE_LEN	18
>  #define DK_CXLFLASH_VERIFY_HINT_SENSE	0x8000000000000000ULL
>
> @@ -118,7 +146,10 @@ union cxlflash_ioctls {
>  	struct dk_cxlflash_attach attach;
>  	struct dk_cxlflash_detach detach;
>  	struct dk_cxlflash_udirect udirect;
> +	struct dk_cxlflash_uvirtual uvirtual;
>  	struct dk_cxlflash_release release;
> +	struct dk_cxlflash_resize resize;
> +	struct dk_cxlflash_clone clone;
>  	struct dk_cxlflash_verify verify;
>  	struct dk_cxlflash_recover_afu recover_afu;
>  	struct dk_cxlflash_manage_lun manage_lun;
> @@ -136,5 +167,8 @@ union cxlflash_ioctls {
>  #define DK_CXLFLASH_VERIFY		CXL_IOWR(0x84, dk_cxlflash_verify)
>  #define DK_CXLFLASH_RECOVER_AFU		CXL_IOWR(0x85, dk_cxlflash_recover_afu)
>  #define DK_CXLFLASH_MANAGE_LUN		CXL_IOWR(0x86, dk_cxlflash_manage_lun)
> +#define DK_CXLFLASH_USER_VIRTUAL	CXL_IOWR(0x87, dk_cxlflash_uvirtual)
> +#define DK_CXLFLASH_VLUN_RESIZE		CXL_IOWR(0x88, dk_cxlflash_resize)
> +#define DK_CXLFLASH_VLUN_CLONE		CXL_IOWR(0x89, dk_cxlflash_clone)
>
>  #endif /* ifndef _CXLFLASH_IOCTL_H */
> --
> 2.1.0


