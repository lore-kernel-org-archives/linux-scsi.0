From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Mon, 20 Jul 2009 09:43:09 +0200
Message-ID: <20090720074309.GC6340@merkur.ravnborg.org>
References: <200907200622.n6K6MmW7011265@swe57.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:51212 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZGTHnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2009 03:43:10 -0400
Content-Disposition: inline
In-Reply-To: <200907200622.n6K6MmW7011265@swe57.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com, xmzhang@brocade.com


A few small nit-picks. I have not looked into the functionality.

I notice you use semaphores in several places.
Today mutexes is the preferred choice for locking
where you use semaphores.

> +
> +BFA_TRC_FILE(LDRV, BFAD);

Looks like some prive tracing infrastructure.
Why not use what we already have?

pr_*

> +
> +static bfa_status_t bfad_fc4_port_new(struct bfad_s *bfad,
> +				      struct bfad_port_s *port, int roles);
> +static void     bfad_fc4_port_delete(struct bfad_s *bfad,
> +				     struct bfad_port_s *port, int roles);

Please rearrange code so these are not needed.

> +
> +struct semaphore bfad_sem;
> +int             bfad_scan_done;
> +
> +LIST_HEAD(bfad_list);
> +
> +static int      bfad_inst;
> +int             supported_fc4s;
> +

> +char           *host_name;
> +char           *os_name;
> +char           *os_patch;
> +int             num_rports;
> +int             num_ios;
> +int             num_tms;
> +int             num_fcxps;
> +int             num_ufbufs;
> +int             reqq_size;
> +int             rspq_size;
> +int             num_sgpgs;
> +int             rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
The above are defined in the global scope.
If this is needed prefix them with bfad_ as you do for
other global variables.

> +int             bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
> +int             bfa_io_max_sge = BFAD_IO_MAX_SGE;
> +int             log_level = BFA_LOG_WARNING;
> +int             ioc_auto_recover = BFA_TRUE;
> +int             ipfc_enable = BFA_FALSE;
> +int             ipfc_mtu = -1;
> +int             linkup_delay = -1;

Same goes here..

> +
> +/*
> + * Stores the module parm num_sgpgs value;
> + * used to reset for bfad next instance.
> + */
> +static int num_sgpgs_parm;
> +
> +bfa_boolean_t
> +bfad_is_ready(void)

What is the purpose of bfa_boolean_t?
Do we need such private typedef?


> +{
> +	struct bfad_s  *bfad = NULL;
> +
> +	down(&bfad_sem);
> +	if (!bfad_scan_done) {
> +		up(&bfad_sem);
> +		return BFA_FALSE;
> +	}
> +
> +	list_for_each_entry(bfad, &bfad_list, list_entry) {
> +		if (!(bfad->bfad_flags & BFAD_DRV_INIT_DONE)) {
> +			up(&bfad_sem);
> +			return BFA_FALSE;
> +		}
> +	}
> +	up(&bfad_sem);
> +
> +	return BFA_TRUE;
> +}
> +
> +void
> +bfad_flags_set(struct bfad_s *bfad, u32 flags)
> +{
> +	if (bfad)
> +		bfad->bfad_flags |= flags;
> +}
> +
> +/**
> + *  BFA callbacks
> + */
> +void
> +bfad_hcb_comp(void *arg, bfa_status_t status)
> +{
> +	struct bfad_hal_comp *fcomp = (struct bfad_hal_comp *)arg;
> +
> +	fcomp->status = status;
> +	complete(&fcomp->comp);
> +}
> +
> +/**
> + * bfa_init callback
> + */
> +void
> +bfa_cb_init(void *drv, bfa_status_t init_status)
> +{
> +	struct bfad_s  *bfad = drv;
> +
> +	if (init_status == BFA_STATUS_OK)
> +		bfad->bfad_flags |= BFAD_HAL_INIT_DONE;
> +
> +	complete(&bfad->comp);
> +}
This is unused?
[Not referenced, not in a header]


> +
> +/**
> + * bfa_stop callback
> + */
> +void
> +bfa_cb_stop(void *drv, bfa_status_t stop_status)
> +{
> +	struct bfad_s  *bfad = drv;
> +
> +	/*
> +	 * Signal the BFAD stop waiting thread
> +	 */
> +	complete(&bfad->comp);
> +}
This is unused?
[Not referenced, not in a header]

> +
> +/**
> + * bfa_ioc_diable() callback.
> + */
> +void
> +bfa_cb_ioc_disable(void *drv)
> +{
> +	struct bfad_s  *bfad = drv;
> +
> +	complete(&bfad->disable_comp);
> +}
ditto

> +
> +void
> +bfa_fcb_exit(struct bfad_s *drv)
> +{
> +	complete(&drv->comp);
> +}
ditto

> +
> +
> +
> +/**
> + *  BFA_FCS callbacks
> + */
> +static struct bfad_port_s *
> +bfad_get_drv_port(struct bfad_s *bfad, struct bfad_vf_s *vf_drv,
> +		  struct bfad_vport_s *vp_drv)
> +{
> +	return ((vp_drv) ? (&(vp_drv)->drv_port)
> +		: ((vf_drv) ? (&(vf_drv)->base_port) : (&(bfad)->pport)));
> +}
> +
> +struct bfad_port_s *
> +bfa_fcb_port_new(struct bfad_s *bfad, struct bfa_fcs_port_s *port,
> +		 enum bfa_port_role roles, struct bfad_vf_s *vf_drv,
> +		 struct bfad_vport_s *vp_drv)
> +{
> +	bfa_status_t    rc;
> +	struct bfad_port_s *port_drv;
> +
> +	if (!vp_drv && !vf_drv) {
> +		port_drv = &bfad->pport;
> +		port_drv->pvb_type = BFAD_PORT_PHYS_BASE;
> +	} else if (!vp_drv && vf_drv) {
> +		port_drv = &vf_drv->base_port;
> +		port_drv->pvb_type = BFAD_PORT_VF_BASE;
> +	} else if (vp_drv && !vf_drv) {
> +		port_drv = &vp_drv->drv_port;
> +		port_drv->pvb_type = BFAD_PORT_PHYS_VPORT;
> +	} else {
> +		port_drv = &vp_drv->drv_port;
> +		port_drv->pvb_type = BFAD_PORT_VF_VPORT;
> +	}
> +
> +	port_drv->fcs_port = port;
> +	port_drv->roles = roles;
> +	rc = bfad_fc4_port_new(bfad, port_drv, roles);
> +	if (rc != BFA_STATUS_OK) {
> +		bfad_fc4_port_delete(bfad, port_drv, roles);
> +		port_drv = NULL;
> +	}
> +
> +	return port_drv;
> +}
unused?
> +
> +void
> +bfa_fcb_port_delete(struct bfad_s *bfad, enum bfa_port_role roles,
> +		    struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
> +{
> +	struct bfad_port_s *port_drv;
> +
> +	/*
> +	 * this will be only called from rmmod context
> +	 */
> +	if (vp_drv && !vp_drv->comp_del) {
> +		port_drv = bfad_get_drv_port(bfad, vf_drv, vp_drv);
> +		bfa_trc(bfad, roles);
> +		bfad_fc4_port_delete(bfad, port_drv, roles);
> +	}
> +}
unused?

> +
> +void
> +bfa_fcb_port_online(struct bfad_s *bfad, enum bfa_port_role roles,
> +		    struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
> +{
> +	struct bfad_port_s *port_drv = bfad_get_drv_port(bfad, vf_drv, vp_drv);
> +
> +	if (roles & BFA_PORT_ROLE_FCP_IM)
> +		bfad_im_port_online(bfad, port_drv);
> +
> +	if (roles & BFA_PORT_ROLE_FCP_TM)
> +		bfad_tm_port_online(bfad, port_drv);
> +
> +	if ((roles & BFA_PORT_ROLE_FCP_IPFC) && ipfc_enable)
> +		bfad_ipfc_port_online(bfad, port_drv);
> +
> +	bfad_flags_set(bfad, BFAD_PORT_ONLINE);
> +}
unused?

As I hit so many seemlingly unused funtions I gues there is
a header file missing in the patch to make it complete.
So I will stop checking for this.


I have noticed that some functiones are prefixed with "bfa_",
and others are prefixed with "bfad_".
Any specific reason for this difference?


> +
> +	/*
> +	 * populate the hal values back to the driver for sysfs use.
> +	 * otherwise, the default values will be shown as 0 in sysfs
> +	 */
> +	num_rports = bfa_cfg->fwcfg.num_rports;
> +	num_ios = bfa_cfg->fwcfg.num_ioim_reqs;
> +	num_tms = bfa_cfg->fwcfg.num_tskim_reqs;
> +	num_fcxps = bfa_cfg->fwcfg.num_fcxp_reqs;
> +	num_ufbufs = bfa_cfg->fwcfg.num_uf_bufs;
> +	reqq_size = bfa_cfg->drvcfg.num_reqq_elems;
> +	rspq_size = bfa_cfg->drvcfg.num_rspq_elems;
> +	num_sgpgs = bfa_cfg->drvcfg.num_sgpgs;

This would be more readable if you aligned it like this:
> +	num_rports = bfa_cfg->fwcfg.num_rports;
> +	num_ios    = bfa_cfg->fwcfg.num_ioim_reqs;
> +	num_tms    = bfa_cfg->fwcfg.num_tskim_reqs;
> +	num_fcxps  = bfa_cfg->fwcfg.num_fcxp_reqs;
> +	num_ufbufs = bfa_cfg->fwcfg.num_uf_bufs;
> +	reqq_size  = bfa_cfg->drvcfg.num_reqq_elems;
> +	rspq_size  = bfa_cfg->drvcfg.num_rspq_elems;
> +	num_sgpgs  = bfa_cfg->drvcfg.num_sgpgs;


> +bfa_status_t
> +bfad_hal_mem_alloc(struct bfad_s *bfad)
> +{
> +	int             i;
> +	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
> +	struct bfa_mem_elem_s *meminfo_elem;
> +	dma_addr_t      phys_addr;
> +	void           *kva;
> +	bfa_status_t    rc = BFA_STATUS_OK;
> +	int             retry_count = 0;
> +	int             reset_value = 1;
> +	int             min_num_sgpgs = 512;

It is preferred to split declaration and assignment.
We know it cost an extra line or two - but it makes code
more explicit.

Also try to list the variables in inverse order of their length.

So the longest lines are topmost when you declare a variable.
Something like this:

> +	struct bfa_mem_elem_s *meminfo_elem;
> +	struct bfa_meminfo_s *hal_meminfo;
> +	int             min_num_sgpgs;
> +	int             retry_count;
> +	int             reset_value;
> +	dma_addr_t      phys_addr;
> +	void           *kva;
> +	bfa_status_t    rc;
> +	int             i;

> +	hal_meminfo   = &bfad->meminfo;
> +	min_num_sgpgs = 512;
> +	retry_count   = 0;
> +	reset_value   = 1;
> +	rc            = BFA_STATUS_OK;


[ran out of time...]

	Sam
