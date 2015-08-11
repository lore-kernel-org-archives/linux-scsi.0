From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v4 3/3] cxlflash: Virtual LUN support
Date: Tue, 11 Aug 2015 20:54:33 +1000
Message-ID: <1439290473.28873.3.camel@neuling.org>
References: <1439226594-7944-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49331 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933872AbbHKKyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 06:54:38 -0400
In-Reply-To: <1439226594-7944-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Comments inline.

I'm not keen on the numerous pr_err() in here.  I think it'll make the driver
chatty especially with a badly behaving userspace.

On Mon, 2015-08-10 at 12:09 -0500, Matthew R. Ochs wrote:
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
>  drivers/scsi/cxlflash/common.h     |    4 +
>  drivers/scsi/cxlflash/main.c       |   14 +-
>  drivers/scsi/cxlflash/sislite.h    |    3 +
>  drivers/scsi/cxlflash/superpipe.c  |   63 +-
>  drivers/scsi/cxlflash/superpipe.h  |   20 +-
>  drivers/scsi/cxlflash/vlun.c       | 1241 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxlflash/vlun.h       |   74 +++
>  include/uapi/scsi/cxlflash_ioctl.h |   34 +
>  9 files changed, 1448 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/scsi/cxlflash/vlun.c
>  create mode 100644 drivers/scsi/cxlflash/vlun.h
> 
> diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
> index 3de309c..fac300b 100644
> --- a/drivers/scsi/cxlflash/Makefile
> +++ b/drivers/scsi/cxlflash/Makefile
> @@ -1,2 +1,2 @@
>  obj-$(CONFIG_CXLFLASH) += cxlflash.o
> -cxlflash-y += main.o superpipe.o
> +cxlflash-y += main.o superpipe.o vlun.o
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index a890a9a..d07cbf7 100644
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
>  	spinlock_t slock;
>  
> @@ -200,6 +203,7 @@ int cxlflash_ioctl(struct scsi_device *, int, void __user *);
>  void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *);
>  int cxlflash_mark_contexts_error(struct cxlflash_cfg *);
>  void cxlflash_term_luns(struct cxlflash_cfg *);
> +void cxlflash_restore_luntable(struct cxlflash_cfg *);
>  
>  #endif /* ifndef _CXLFLASH_COMMON_H */
>  
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index eb1bdd7..e178074 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -723,7 +723,6 @@ static struct scsi_host_template driver_template = {
>  	.module = THIS_MODULE,
>  	.name = CXLFLASH_ADAPTER_NAME,
>  	.info = cxlflash_driver_info,
> -	.ioctl = cxlflash_ioctl,

Where are you hooking this in now?  This seems broken.

>  	.proc_name = CXLFLASH_NAME,
>  	.queuecommand = cxlflash_queuecommand,
>  	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
> @@ -1969,6 +1968,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
>  	afu_err_intr_init(cfg->afu);
>  	atomic64_set(&afu->room, readq_be(&afu->host_map->cmd_room));
>  
> +	/* Restore the LUN mappings */
> +	cxlflash_restore_luntable(cfg);
>  err1:
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -2266,6 +2267,17 @@ static int cxlflash_probe(struct pci_dev *pdev,
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
> diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
> index bf5d399..e599e7f 100644
> --- a/drivers/scsi/cxlflash/sislite.h
> +++ b/drivers/scsi/cxlflash/sislite.h
> @@ -462,4 +462,7 @@ struct sisl_rht_entry_f1 {
>  #define TMF_LUN_RESET  0x1U
>  #define TMF_CLEAR_ACA  0x2U
>  
> +
> +#define SISLITE_MAX_WS_BLOCKS 512
> +
>  #endif /* _SISLITE_H */
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index 802f1f5..563e437 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -27,11 +27,25 @@
>  
>  #include "sislite.h"
>  #include "common.h"
> +#include "vlun.h"
>  #include "superpipe.h"
>  
>  static struct cxlflash_global global;
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
> @@ -63,6 +77,7 @@ static struct llun_info *create_local(struct scsi_device *sdev, u8 *wwid)
>  	lli->sdev = sdev;
>  	lli->newly_created = true;
>  	lli->host_no = sdev->host->host_no;
> +	lli->in_table = false;
>  
>  	memcpy(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN);
>  out:
> @@ -237,6 +252,7 @@ void cxlflash_list_terminate(void)
>  	spin_lock_irqsave(&global.slock, flags);
>  	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
>  		list_del(&gli->list);
> +		cxlflash_ba_terminate(&gli->blka.ba_lun);
>  		kfree(gli);
>  	}
>  
> @@ -610,6 +626,7 @@ void rhte_checkin(struct ctx_info *ctxi,
>  	rhte->fp = 0;
>  	ctxi->rht_out--;
>  	ctxi->rht_lun[rsrc_handle] = NULL;
> +	ctxi->rht_needs_ws[rsrc_handle] = false;
>  }
>  
>  /**
> @@ -694,8 +711,10 @@ void cxlflash_lun_detach(struct glun_info *gli)
>  {
>  	spin_lock(&gli->slock);
>  	WARN_ON(gli->mode == MODE_NONE);
> -	if (--gli->users == 0)
> +	if (--gli->users == 0) {
>  		gli->mode = MODE_NONE;
> +		cxlflash_ba_terminate(&gli->blka.ba_lun);
> +	}
>  	pr_debug("%s: gli->users=%u\n", __func__, gli->users);
>  	WARN_ON(gli->users < 0);
>  	spin_unlock(&gli->slock);
> @@ -726,6 +745,7 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
>  	struct afu *afu = cfg->afu;
>  	bool unlock_ctx = false;
>  
> +	struct dk_cxlflash_resize size;
>  	res_hndl_t rhndl = release->rsrc_handle;
>  
>  	int rc = 0;
> @@ -764,6 +784,16 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
>  	 * Afterwards we clear the remaining fields.
>  	 */
>  	switch (gli->mode) {
> +	case MODE_VIRTUAL:
> +		marshal_rele_to_resize(release, &size);
> +		size.req_size = 0;
> +		rc = _cxlflash_vlun_resize(sdev, ctxi, &size);
> +		if (rc) {
> +			pr_err("%s: resize failed rc %d\n", __func__, rc);
> +			goto out;
> +		}
> +
> +		break;
>  	case MODE_PHYSICAL:
>  		/*
>  		 * Clear the Format 1 RHT entry for direct access
> @@ -834,9 +864,9 @@ static void destroy_context(struct cxlflash_cfg *cfg,
>  	}
>  
>  	/*
> -	 * Free the RHT memory and context; note that rht_lun
> -	 * was carved from the same memory as the context.
> -	 */
> +	 * Free the RHT memory and context; note that rht_lun and rht_needs_ws
> +	 * were carved from the same memory as the context.
> +	 * */
>  	free_page((ulong)ctxi->rht_start);
>  	kfree(ctxi);
>  	atomic_dec_if_positive(&cfg->num_user_contexts);
> @@ -867,6 +897,7 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
>  	struct sisl_rht_entry *rhte;
>  
>  	size = (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
> +	size += (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_needs_ws));

This needs to be cleaned up as per my comment on patch 2.  Make this a separate
allocation.

>  	size += sizeof(*ctxi);
>  
>  	tmp = kzalloc(size, GFP_KERNEL);
> @@ -885,6 +916,8 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
>  	ctxi = (struct ctx_info *)tmp;
>  	tmp += sizeof(*ctxi);
>  	ctxi->rht_lun = (struct llun_info **)tmp;
> +	tmp += (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
> +	ctxi->rht_needs_ws = (bool *)tmp;
>  	ctxi->rht_start = rhte;
>  	ctxi->rht_perms = perms;
>  
> @@ -1929,6 +1962,12 @@ static int cxlflash_disk_verify(struct scsi_device *sdev,
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
> @@ -1956,12 +1995,18 @@ static char *decode_ioctl(int cmd)
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
> +	case DK_CXLFLASH_CLONE:
> +		return __stringify_1(DK_CXLFLASH_CLONE);
>  	case DK_CXLFLASH_RECOVER_AFU:
>  		return __stringify_1(DK_CXLFLASH_RECOVER_AFU);
>  	case DK_CXLFLASH_MANAGE_LUN:
> @@ -2075,6 +2120,7 @@ static int ioctl_common(struct scsi_device *sdev, int cmd)
>  	rc = check_state(cfg);
>  	if (unlikely(rc) && (cfg->state == STATE_FAILTERM)) {
>  		switch (cmd) {
> +		case DK_CXLFLASH_VLUN_RESIZE:
>  		case DK_CXLFLASH_RELEASE:
>  		case DK_CXLFLASH_DETACH:
>  			pr_debug("%s: Command override! (%d)\n", __func__, rc);
> @@ -2115,9 +2161,12 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
>  	} ioctl_tbl[] = {	/* NOTE: order matters here */
>  	{sizeof(struct dk_cxlflash_attach), (sioctl)cxlflash_disk_attach},
>  	{sizeof(struct dk_cxlflash_udirect), cxlflash_disk_direct_open},
> +	{sizeof(struct dk_cxlflash_uvirtual), cxlflash_disk_virtual_open},
> +	{sizeof(struct dk_cxlflash_resize), (sioctl)cxlflash_vlun_resize},
>  	{sizeof(struct dk_cxlflash_release), (sioctl)cxlflash_disk_release},
>  	{sizeof(struct dk_cxlflash_detach), (sioctl)cxlflash_disk_detach},
>  	{sizeof(struct dk_cxlflash_verify), (sioctl)cxlflash_disk_verify},
> +	{sizeof(struct dk_cxlflash_clone), (sioctl)cxlflash_disk_clone},
>  	{sizeof(struct dk_cxlflash_recover_afu), (sioctl)cxlflash_afu_recover},
>  	{sizeof(struct dk_cxlflash_manage_lun), (sioctl)cxlflash_manage_lun},

Does this actually work if we don't have this patch?  If the IOCTLS are sparse
(like with only patch 2/3) won't this table be broken?

>  	};
> @@ -2125,7 +2174,10 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
>  	/* Restrict command set to physical support only for internal LUN */
>  	if (afu->internal_lun)
>  		switch (cmd) {
> +		case DK_CXLFLASH_USER_VIRTUAL:
> +		case DK_CXLFLASH_VLUN_RESIZE:
>  		case DK_CXLFLASH_RELEASE:
> +		case DK_CXLFLASH_CLONE:
>  			pr_err("%s: %s not supported for lun_mode=%d\n",
>  			       __func__, decode_ioctl(cmd), afu->internal_lun);
>  			rc = -EINVAL;

If someone creates an internal lun and then does this, then we are going to get
a bunch of errors on the console.  I don't think that should happen.  Just
return it to the caller.

> @@ -2135,9 +2187,12 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
>  	switch (cmd) {
>  	case DK_CXLFLASH_ATTACH:
>  	case DK_CXLFLASH_USER_DIRECT:
> +	case DK_CXLFLASH_USER_VIRTUAL:
> +	case DK_CXLFLASH_VLUN_RESIZE:
>  	case DK_CXLFLASH_RELEASE:
>  	case DK_CXLFLASH_DETACH:
>  	case DK_CXLFLASH_VERIFY:
> +	case DK_CXLFLASH_CLONE:
>  	case DK_CXLFLASH_RECOVER_AFU:
>  		pr_debug("%s: %s (%08X) on dev(%d/%d/%d/%llu)\n", __func__,
>  			 decode_ioctl(cmd), cmd, shost->host_no, sdev->channel,
> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> index 030892b..ea0f57e 100644
> --- a/drivers/scsi/cxlflash/superpipe.h
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -29,9 +29,11 @@
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
> @@ -39,13 +41,14 @@ enum lun_mode {
>  struct glun_info {
>  	u64 max_lba;		/* from read cap(16) */
>  	u32 blk_len;		/* from read cap(16) */
> -	enum lun_mode mode;	/* NONE, PHYSICAL */
> +	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
>  	int users;		/* Number of users w/ references to LUN */
>  
>  	u8 wwid[16];
>  
>  	spinlock_t slock;
>  
> +	struct blka blka;
>  	struct list_head list;
>  };
>  
> @@ -56,6 +59,7 @@ struct llun_info {
>  	u32 host_no;		/* host_no from Scsi_host */
>  	u32 port_sel;		/* What port to use for this LUN */
>  	bool newly_created;	/* Whether the LUN was just discovered */
> +	bool in_table;		/* Whether a LUN table entry was created */
>  
>  	u8 wwid[16];		/* Keep a duplicate copy here? */
>  
> @@ -88,6 +92,7 @@ struct ctx_info {
>  	u32 rht_out;		/* Number of checked out RHT entries */
>  	u32 rht_perms;		/* User-defined permissions for RHT entries */
>  	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
> +	bool *rht_needs_ws;	/* User-desired write-same function per RHTE */
>  
>  	struct cxl_ioctl_start_work work;
>  	u64 ctxid;
> @@ -109,10 +114,19 @@ struct cxlflash_global {
>  	struct page *err_page; /* One page of all 0xF for error notification */
>  };
>  
> +
> +int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
> +int _cxlflash_vlun_resize(struct scsi_device *, struct ctx_info *,
> +			  struct dk_cxlflash_resize *);
> +
>  int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
>  int _cxlflash_disk_release(struct scsi_device *, struct ctx_info *,
>  			   struct dk_cxlflash_release *);
>  
> +int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
> +
> +int cxlflash_disk_virtual_open(struct scsi_device *, void *);
> +
>  int cxlflash_lun_attach(struct glun_info *, enum lun_mode);
>  void cxlflash_lun_detach(struct glun_info *);
>  
> @@ -124,4 +138,8 @@ struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
>  struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct llun_info *);
>  void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
>  
> +void cxlflash_ba_terminate(struct ba_lun *);
> +
> + won't this table be broken?

>  	};
> @@ -2125,7 +2174,10 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
>  	/* Restrict command set to physical support only for internal LUN */
>  	if (afu->internal_lun)
>  		switch (cmd) {
> +		case DK_CXLFLASH_USER_VIRTUAL:
> +		case DK_CXLFLASH_VLUN_RESIZE:
>  		case DK_CXLFLASH_RELEASE:
> +		case DK_CXLFLASH_CLONE:
>  			pr_err("%s: %s not supported for lun_mode=%d\n",
>  			       __func__, decode_ioctl(cmd), afu->internal_lun);
>  			rc = -EINVAL;

If someone creates an internal lun and then does this, then we are going to get
a bunch of errors on the console.  I don't think that should happen.  Just
return it to the caller.

> @@ -2135,9 +2187,12 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
>  	switch (cmd) {
>  	case DK_CXLFLASH_ATTACH:
>  	case DK_CXLFLASH_USER_DIRECT:
> +	case DK_CXLFLASH_USER_VIRTUAL:
> +	case DK_CXLFLASH_VLUN_RESIZE:
>  	case DK_CXLFLASH_RELEASE:
>  	case DK_CXLFLASH_DETACH:
>  	case DK_CXLFLASH_VERIFY:
> +	case DK_CXLFLASH_CLONE:
>  	case DK_CXLFLASH_RECOVER_AFU:
>  		pr_debug("%s: %s (%08X) on dev(%d/%d/%d/%llu)\n", __func__,
>  			 decode_ioctl(cmd), cmd, shost->host_no, sdev->channel,
> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> index 030892b..ea0f57e 100644
> --- a/drivers/scsi/cxlflash/superpipe.h
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -29,9 +29,11 @@
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
> @@ -39,13 +41,14 @@ enum lun_mode {
>  struct glun_info {
>  	u64 max_lba;		/* from read cap(16) */
>  	u32 blk_len;		/* from read cap(16) */
> -	enum lun_mode mode;	/* NONE, PHYSICAL */
> +	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
>  	int users;		/* Number of users w/ references to LUN */
>  
>  	u8 wwid[16];
>  
>  	spinlock_t slock;
>  
> +	struct blka blka;
>  	struct list_head list;
>  };
>  
> @@ -56,6 +59,7 @@ struct llun_info {
>  	u32 host_no;		/* host_no from Scsi_host */
>  	u32 port_sel;		/* What port to use for this LUN */
>  	bool newly_created;	/* Whether the LUN was just discovered */
> +	bool in_table;		/* Whether a LUN table entry was created */
>  
>  	u8 wwid[16];		/* Keep a duplicate copy here? */
>  
> @@ -88,6 +92,7 @@ struct ctx_info {
>  	u32 rht_out;		/* Number of checked out RHT entries */
>  	u32 rht_perms;		/* User-defined permissions for RHT entries */
>  	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
> +	bool *rht_needs_ws;	/* User-desired write-same function per RHTE */
>  
>  	struct cxl_ioctl_start_work work;
>  	u64 ctxid;
> @@ -109,10 +114,19 @@ struct cxlflash_global {
>  	struct page *err_page; /* One page of all 0xF for error notification */
>  };
>  
> +
> +int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
> +int _cxlflash_vlun_resize(struct scsi_device *, struct ctx_info *,
> +			  struct dk_cxlflash_resize *);
> +
>  int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
>  int _cxlflash_disk_release(struct scsi_device *, struct ctx_info *,
>  			   struct dk_cxlflash_release *);
>  
> +int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
> +
> +int cxlflash_disk_virtual_open(struct scsi_device *, void *);
> +
>  int cxlflash_lun_attach(struct glun_info *, enum lun_mode);
>  void cxlflash_lun_detach(struct glun_info *);
>  
> @@ -124,4 +138,8 @@ struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
>  struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct llun_info *);
>  void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
>  
> +void cxlflash_ba_terminate(struct ba_lun *);
> +
> +
> +
>  #endif /* ifndef _CXLFLASH_SUPERPIPE_H */
> diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
> new file mode 100644
> index 0000000..ca0bf19
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/vlun.c
> @@ -0,0 +1,1241 @@
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
> +		pr_err("%s: Requested LUN size of 0!\n", __func__);
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
> +	bali->lun_bmap_size = lun_size_au / BPL;
> +
> +	if (lun_size_au % BPL)
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
> +	last_word_underflow = (bali->lun_bmap_size * BPL) - bali->free_aun_cnt;
> +	if (last_word_underflow > 0) {
> +		lam = &bali->lun_alloc_map[bali->lun_bmap_size - 1];
> +		for (i = (HIBIT - last_word_underflow + 1); i < BPL; i++)
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
> +	ba_lun->ba_lun_handle = (void *)bali;
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
> + * @bit_word:	Passes back the word in the block allocator owning the free bit.
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
> +	bali = (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	pr_debug("%s: Received block allocation request: "
> +		 "lun_id = %llX, free_aun_cnt = %llX\n",
> +		 __func__, ba_lun->lun_id, bali->free_aun_cnt);
> +
> +	if (bali->free_aun_cnt == 0) {
> +		pr_err("%s: No space left on LUN: lun_id = %llX\n",
> +		       __func__, ba_lun->lun_id);
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
> +			pr_err("%s: Could not find an allocation unit on LUN: "
> +			       "lun_id = %llX\n", __func__, ba_lun->lun_id);
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
> +		 ((bit_word * BPL) + bit_pos), ba_lun->lun_id,
> +		 bali->free_aun_cnt);
> +
> +	return (u64) ((bit_word * BPL) + bit_pos);
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
> +	idx = aun / BPL;
> +	bit_pos = aun % BPL;
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
> +	bali = (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	if (validate_alloc(bali, to_free)) {
> +		pr_err("%s: The AUN %llX is not allocated on lun_id %llX\n",
> +		       __func__, to_free, ba_lun->lun_id);
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
> +	idx = to_free / BPL;
> +	bit_pos = to_free % BPL;
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
> +	struct ba_lun_info *bali = (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	if (validate_alloc(bali, to_clone)) {
> +		pr_err("%s: AUN %llX is not allocated on lun_id %llX\n",
> +		       __func__, to_clone, ba_lun->lun_id);
> +		return -1;
> +	}
> +
> +	pr_debug("%s: Received a request to clone AUN %llX on lun_id %llX\n",
> +		 __func__, to_clone, ba_lun->lun_id);
> +
> +	if (bali->aun_clone_map[to_clone] == MAX_AUN_CLONE_CNT) {
> +		pr_err("%s: AUN %llX on lun_id %llX hit max clones already\n",
> +		       __func__, to_clone, ba_lun->lun_id);
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
> +	struct ba_lun_info *bali = (struct ba_lun_info *)ba_lun->ba_lun_handle;
> +
> +	return bali->free_aun_cnt;
> +}
> +
> +/**
> + * cxlflash_ba_terminate() - frees resources associated with the block allocator
> + * @ba_lun:	Block allocator.
> + *
> + * Safe to call in a partially allocated state.
> + */
> +void cxlflash_ba_terminate(struct ba_lun *ba_lun)
> +{
> +	struct ba_lun_info *bali = (struct ba_lun_info *)ba_lun->ba_lun_handle;
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
> +		pr_err("%s: cannot init block_alloc, rc=%d\n", __func__, rc);
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
> +	u8 *buf = NULL;
> +	u8 *cmd_buf = NULL;
> +	u8 *scsi_cmd = NULL;
> +	u8 *sense_buf = NULL;
> +	int rc = 0;
> +	int result = 0;
> +	int ws_limit = SISLITE_MAX_WS_BLOCKS;
> +	u64 offset = lba;
> +	int left = nblks;
> +	u32 tout = sdev->request_queue->rq_timeout;
> +	size_t size;
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
> +	struct device *dev = &cfg->dev->dev;
> +
> +	size = CMD_BUFSIZE + MAX_COMMAND_SIZE + SCSI_SENSE_BUFFERSIZE;
> +	buf = kzalloc(size, GFP_KERNEL);
> +	if (unlikely(!buf)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	cmd_buf = buf;
> +	scsi_cmd = cmd_buf + CMD_BUFSIZE;
> +	sense_buf = scsi_cmd + MAX_COMMAND_SIZE;
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
> +	kfree(buf);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +
> +/**
> + * grow_lxt() - expands the translation table associated with the specified RHTE
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
> + * shrink_lxt() - reduces translation table associated with the specified RHTE
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

Be good to do some clear sanity check the "struct dk_cxlflash_resize *resize"
here.  It's passed from userspace but then gets propogated to a bunch of other
things here like nsectors, get_context etc who will all now be responsible for
handling any dodgy data passed in.

Same with all the other ioctl calls.  Sanity check the parameters ASAP.  Don't
propagate potentially dodgy values all over the code base.

> +	/*
> +	 * The requested size (req_size) is always assumed to be in 4k blocks,
> +	 * so we have to convert it here from 4k to chunk size.
> +	 */
> +	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
> +	new_size = DIV_ROUND_UP(nsectors, MC_CHUNK_SIZE);

Like here. resize->req_size => new_size => grow_lxt() now grow_lxt() need to
sanity check new_size.

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
> + * cxlflash_restore_luntable() - Restore LUN table to prior state
> + * @cfg:	Internal structure associated with the host.
> + */
> +void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
> +{
> +	struct llun_info *lli, *temp;
> +	ulong lock_flags;
> +	u32 chan;
> +	u32 lind;
> +	struct afu *afu = cfg->afu;
> +	struct sisl_global_map *agm = &afu->afu_map->global;
> +
> +	spin_lock_irqsave(&cfg->slock, lock_flags);
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
> +	spin_unlock_irqrestore(&cfg->slock, lock_flags);
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
> +	ulong lock_flags;
> +
> +	spin_lock_irqsave(&cfg->slock, lock_flags);
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
> +	spin_unlock_irqrestore(&cfg->slock, lock_flags);
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

Again, this should be sanity checked.  

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
> +		rc = init_luntable(cfg, lli);
> +		if (rc) {
> +			dev_err(dev, "%s: call to init_luntable failed "
> +				"rc=%d!\n", __func__, rc);
> +			goto out;
> +		}
> +
> +		rc = init_vlun(lli);
> +		if (rc) {
> +			dev_err(dev, "%s: call to init_vlun failed rc=%d!\n",
> +				__func__, rc);
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +	}
> +
> +	rc = cxlflash_lun_attach(gli, MODE_VIRTUAL);
> +	if (unlikely(rc)) {
> +		dev_err(dev, "%s: Failed to attach to LUN! (VIRTUAL)\n",
> +			__func__);
> +		goto out;
> +	}
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

Virt has not been sanity checked.  So now resize can contain bad data.


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
> +		mutex_unlock(&ctxi->mutex);
> +	pr_debug("%s: returning handle 0x%llx rc=%d llba %lld\n",
> +		 __func__, rsrc_handle, rc, last_lba);
> +	return rc;
> +
> +err2:
> +	rhte_checkin(ctxi, rhte);
> +err1:
> +	cxlflash_lun_detach(gli);
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

Nice documentation here for the memory barriers!

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
> +		pr_err("%s: Clone not supported on physical LUNs! (%d)\n",
> +		       __func__, gli->mode);
> +		goto out;
> +	}
> +
> +	ctxi_src = get_context(cfg, rctxid_src, lli, CTX_CTRL_CLONE);
> +	ctxi_dst = get_context(cfg, rctxid_dst, lli, 0);
> +	if (unlikely(!ctxi_src || !ctxi_dst)) {
> +		pr_err("%s: Bad context! (%llu,%llu)\n", __func__,
> +		       ctxid_src, ctxid_dst);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (unlikely(adap_fd_src != ctxi_src->lfd)) {
> +		pr_err("%s: Invalid source adapter fd! (%d)\n",
> +		       __func__, adap_fd_src);
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
> +		pr_err("%s: Nothing to clone!\n", __func__);
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
> +		cxlflash_lun_attach(gli, gli->mode);
> +	}
> +
> +out_success:
> +	list_splice(&sidecar, &ctxi_dst->luns);
> +	sys_close(adap_fd_src);
> +
> +	/* fall through */
> +out:
> +	if (ctxi_src)
> +		mutex_unlock(&ctxi_src->mutex);
> +	if (ctxi_dst)
> +		mutex_unlock(&ctxi_dst->mutex);
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +
> +err:
> +	list_for_each_entry_safe(lun_access_src, lun_access_dst, &sidecar, list)
> +		kfree(lun_access_src);
> +	goto out;
> +}
> +
> diff --git a/drivers/scsi/cxlflash/vlun.h b/drivers/scsi/cxlflash/vlun.h
> new file mode 100644
> index 0000000..219ea9b
> --- /dev/null
> +++ b/drivers/scsi/cxlflash/vlun.h
> @@ -0,0 +1,74 @@
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
> +#define MC_RHT_NMASK      16	/* in bits */
> +#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */

What is LXT?

> +
> +#define BITS_PER_LONG     64

Please use #include <asm/bitsperlong.h>

> +#define BPL               BITS_PER_LONG

Don't redefine this.  Make it harder for others to read.  No one wants to learn
your TLAs.  

> +#define HIBIT             (BPL - 1)
> +
> +#define MAX_AUN_CLONE_CNT 0xFF
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
> +struct ba_lun {
> +	u64 lun_id;
> +	u64 wwpn;
> +	size_t lsize;		/* LUN size in number of LBAs             */
> +	size_t lba_size;	/* LBA size in number of bytes            */
> +	size_t au_size;		/* Allocation Unit size in number of LBAs */
> +	void *ba_lun_handle;

ba_lun_handle seems to be commonly cast to a struct ba_lun_info *.  Can it just
be a pointer to that?


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
> +#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
> +
> diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
> index f11bdcf..b20abab 100644
> --- a/include/uapi/scsi/cxlflash_ioctl.h
> +++ b/include/uapi/scsi/cxlflash_ioctl.h
> @@ -69,6 +69,17 @@ struct dk_cxlflash_udirect {
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
> @@ -76,6 +87,23 @@ struct dk_cxlflash_release {
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
> @@ -116,7 +144,10 @@ union cxlflash_ioctls {
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
> @@ -130,9 +161,12 @@ union cxlflash_ioctls {
>  
>  #define DK_CXLFLASH_ATTACH		CXL_IOWR(0x80, dk_cxlflash_attach)
>  #define DK_CXLFLASH_USER_DIRECT		CXL_IOWR(0x81, dk_cxlflash_udirect)
> +#define DK_CXLFLASH_USER_VIRTUAL	CXL_IOWR(0x82, dk_cxlflash_uvirtual)
> +#define DK_CXLFLASH_VLUN_RESIZE		CXL_IOWR(0x83, dk_cxlflash_resize)
>  #define DK_CXLFLASH_RELEASE		CXL_IOWR(0x84, dk_cxlflash_release)
>  #define DK_CXLFLASH_DETACH		CXL_IOWR(0x85, dk_cxlflash_detach)
>  #define DK_CXLFLASH_VERIFY		CXL_IOWR(0x86, dk_cxlflash_verify)
> +#define DK_CXLFLASH_CLONE		CXL_IOWR(0x87, dk_cxlflash_clone)
>  #define DK_CXLFLASH_RECOVER_AFU		CXL_IOWR(0x88, dk_cxlflash_recover_afu)
>  #define DK_CXLFLASH_MANAGE_LUN		CXL_IOWR(0x89, dk_cxlflash_manage_lun)
>  

