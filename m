From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/14] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Thu, 03 Sep 2009 09:44:16 -0500
Message-ID: <4A9FD640.6040701@linux.vnet.ibm.com>
References: <200908200658.n7K6wGXt006427@swe57.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755810AbZICOon@vger.kernel.org>
In-Reply-To: <200908200658.n7K6wGXt006427@swe57.brocade.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

Below are a few comments based on a quick review. Many of the comments
are general comments that will apply across all the patches.

-Brian

Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains code that interfaces to upper layer linux kernel, such as
> PCI, SCSI mid-layer and sysfs etc.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
> ---
>  bfad.c           | 1407 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  bfad_attr.c      |  660 +++++++++++++++++++++++++
>  bfad_attr.h      |   67 ++
>  bfad_drv.h       |  385 +++++++++++++++
>  bfad_fwimg.c     |   97 +++
>  bfad_im.c        | 1349 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  bfad_im.h        |  205 ++++++++
>  bfad_im_compat.h |   46 +
>  bfad_intr.c      |  241 +++++++++
>  bfad_ipfc.h      |   42 +
>  bfad_os.c        |   56 ++
>  bfad_tm.h        |   59 ++
>  bfad_trcmod.h    |   52 ++
>  13 files changed, 4666 insertions(+)
> 
> diff -urpN orig/drivers/scsi/bfa/bfad_attr.c patch/drivers/scsi/bfa/bfad_attr.c
> --- orig/drivers/scsi/bfa/bfad_attr.c	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_attr.c	2009-08-19 17:47:54.000000000 -0700


> +
> +/**
> + * FC transport template entry, issue a LIP.
> + */
> +int
> +bfad_im_issue_fc_host_lip(struct Scsi_Host *shost)
> +{
> +	return 0;
> +}

Is there code missing here, or can this be removed? If you don't support
issue_fc_host_lip, then don't setup the function pointer.


> +
> +
> +
> +
> +
> +struct Scsi_Host *
> +bfad_os_starget_to_shost(struct scsi_target *starget)
> +{
> +	return dev_to_shost(starget->dev.parent);
> +}
> +

Just call dev_to_shost directly



> +
> +static ssize_t
> +bfad_im_num_of_discovered_ports_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct bfad_im_port_s *im_port =
> +			(struct bfad_im_port_s *) shost->hostdata[0];
> +	struct bfad_port_s    *port = im_port->port;
> +	struct bfad_s         *bfad = im_port->bfad;
> +	int        nrports = 2048;
> +	wwn_t          *rports = NULL;
> +	unsigned long   flags;
> +
> +	rports = kzalloc(sizeof(wwn_t) * nrports , GFP_ATOMIC);
> +	if (rports == NULL)
> +		return snprintf(buf, PAGE_SIZE, "Failed\n");

Just return -ENOMEM here instead of printing Failed.

> +
> +	spin_lock_irqsave(&bfad->bfad_lock, flags);
> +	bfa_fcs_port_get_rports(port->fcs_port, rports, &nrports);
> +	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> +	kfree(rports);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
> +}


> +#endif /*  __BFAD_ATTR_H__ */
> diff -urpN orig/drivers/scsi/bfa/bfad.c patch/drivers/scsi/bfa/bfad.c
> --- orig/drivers/scsi/bfa/bfad.c	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad.c	2009-08-19 17:47:54.000000000 -0700



> +
> +void
> +bfad_flags_set(struct bfad_s *bfad, u32 flags)
> +{
> +	if (bfad)
> +		bfad->bfad_flags |= flags;
> +}
> +
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
> +
> +void
> +bfa_fcb_exit(struct bfad_s *drv)
> +{
> +	complete(&drv->comp);
> +}

I think a lot of these very small helper functions can just be removed as they
don't really make the driver any easier to read.


> +
> +void
> +bfa_fcb_vf_stop(struct bfad_vf_s *vf_drv)
> +{
> +}
> +

This can be removed.

> +
> +/**
> + * FCS RPORT free callback.
> + */
> +void
> +bfa_fcb_rport_free(struct bfad_s *bfad, struct bfad_rport_s **rport_drv)
> +{
> +	kfree(*rport_drv);
> +}

Why not just call kfree directly?


> +
> +bfa_status_t
> +bfad_hal_mem_alloc(struct bfad_s *bfad)
> +{
> +	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
> +	struct bfa_mem_elem_s *meminfo_elem;
> +	bfa_status_t    rc = BFA_STATUS_OK;
> +	dma_addr_t      phys_addr;
> +	int             retry_count = 0;
> +	int             reset_value = 1;
> +	int             min_num_sgpgs = 512;
> +	void           *kva;
> +	int             i;

> +		case BFA_MEM_TYPE_DMA:
> +			kva = dma_alloc_coherent(&bfad->pcidev->dev,
> +					meminfo_elem->mem_len,
> +					&phys_addr, GFP_KERNEL);
> +			if (kva == NULL) {
> +				bfad_hal_mem_release(bfad);
> +				/*
> +				 * If we cannot allocate with default
> +				 * num_sgpages try with half the value.
> +				 */
> +				if (num_sgpgs > min_num_sgpgs) {
> +					printk(KERN_INFO "bfad[%d]: memory"
> +						" allocation failed with"
> +						" num_sgpgs: %d\n",
> +						bfad->inst_no, num_sgpgs);
> +					nextLowerInt(&num_sgpgs);
> +					printk(KERN_INFO "bfad[%d]: trying to"
> +						" allocate memory with"
> +						" num_sgpgs: %d\n",
> +						bfad->inst_no, num_sgpgs);

Can you use dev_info here instead?

> +					retry_count++;
> +					goto retry;
> +				} else {
> +					if (num_sgpgs_parm > 0)




> +
> +int
> +bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
> +{

> +
> +	bfad->pci_bar0_map = pci_resource_start(pdev, 0);
> +	bar0_len = pci_resource_len(pdev, 0);
> +	bfad->pci_bar0_kva = ioremap(bfad->pci_bar0_map, bar0_len);
> +
> +	if (bfad->pci_bar0_kva == NULL) {
> +		BFA_PRINTF(BFA_ERR, "Fail to map bar0\n");
> +		goto out_release_region;
> +	}
> +
> +	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
> +	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
> +	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
> +	bfad->hal_pcidev.device_id = pdev->device;
> +	bfad->pci_name = pci_name(pdev);
> +
> +	bfad->pci_attr.vendor_id = pdev->vendor;
> +	bfad->pci_attr.device_id = pdev->device;
> +	bfad->pci_attr.ssid = pdev->subsystem_device;
> +	bfad->pci_attr.ssvid = pdev->subsystem_vendor;
> +	bfad->pci_attr.pcifn = PCI_FUNC(pdev->devfn);

Why do you need to copy all this data to your own structure? Can't you
just access it from the pdev when you need it? 

> +
> +	bfad->pcidev = pdev;
> +	return 0;
> +
> +out_release_region:
> +	pci_release_regions(pdev);
> +out_disable_device:
> +	pci_disable_device(pdev);
> +out:
> +	return rc;
> +}
> +



> +/**
> + * PCI probe entry.
> + */
> +int
> +bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
> +{
> +	struct bfad_s  *bfad;
> +	int             error = -ENODEV, retval;
> +	char            buf[16];
> +

> +	/*
> +	 * If linkup_delay is set to -1 default; try to retrive the
> +	 * value using the bfad_os_get_linkup_delay(); else use the
> +	 * passed in module param value as the linkup_delay.
> +	 */
> +	if (linkup_delay < 0) {
> +#if defined(__ia64__)
> +		linkup_delay = 10;
> +#else
> +		linkup_delay = bfad_os_get_linkup_delay(bfad);
> +#endif

This looks rather strange. What does ia64 need a different delay?

> +		bfad_os_rport_online_wait(bfad);
> +		linkup_delay = -1;
> +	} else {
> +		bfad_os_rport_online_wait(bfad);
> +	}


> +
> +#define BFAD_MAX_PCIIDS	4
> +struct pci_device_id bfad_id_table[BFAD_MAX_PCIIDS] = {

Don't need BFAD_MAX_PCIIDS here. Just declare this [] and have
the compiler figure it out. This could also be flagged __devinitdata.

> +	{
> +	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
> +	 .device = BFA_PCI_DEVICE_ID_FC_8G2P,
> +	 .subvendor = PCI_ANY_ID,
> +	 .subdevice = PCI_ANY_ID,
> +	 },



> +
> +module_param(os_name, charp, S_IRUGO | S_IWUSR);
> +module_param(os_patch, charp, S_IRUGO | S_IWUSR);
> +module_param(host_name, charp, S_IRUGO | S_IWUSR);
> +module_param(num_rports, int, S_IRUGO | S_IWUSR);
> +module_param(num_ios, int, S_IRUGO | S_IWUSR);
> +module_param(num_tms, int, S_IRUGO | S_IWUSR);
> +module_param(num_fcxps, int, S_IRUGO | S_IWUSR);
> +module_param(num_ufbufs, int, S_IRUGO | S_IWUSR);
> +module_param(reqq_size, int, S_IRUGO | S_IWUSR);
> +module_param(rspq_size, int, S_IRUGO | S_IWUSR);
> +module_param(num_sgpgs, int, S_IRUGO | S_IWUSR);
> +module_param(rport_del_timeout, int, S_IRUGO | S_IWUSR);
> +module_param(bfa_lun_queue_depth, int, S_IRUGO | S_IWUSR);
> +module_param(bfa_io_max_sge, int, S_IRUGO | S_IWUSR);
> +module_param(log_level, int, S_IRUGO | S_IWUSR);
> +module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
> +module_param(ipfc_enable, int, S_IRUGO | S_IWUSR);
> +module_param(ipfc_mtu, int, S_IRUGO | S_IWUSR);
> +module_param(linkup_delay, int, S_IRUGO | S_IWUSR);
> +module_param(msix_disable, int, S_IRUGO | S_IWUSR);

This seems like a lot of module parameters. Are they all needed?
Would some of them work better as scsi_host sysfs parameters?

> +
> +#ifdef CONFIG_PM
> +int             pci_save_state(struct pci_dev *pdev);
> +int             pci_restore_state(struct pci_dev *pdev);

Don't need these..

> +
> +/**
> + * PCI suspend entry.
> + */
> +static int
> +bfad_os_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct bfad_s         *bfad = pci_get_drvdata(pdev);
> +	pci_power_t     device_state;
> +
> +	device_state = pci_choose_state(pdev, state);
> +
> +	pci_save_state(pdev);
> +	init_completion(&bfad->suspend);
> +	wait_for_completion(&bfad->suspend);

What triggers you to wake up here? Won't you lose initiative here
and never wake up?

> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, device_state);
> +
> +	return 0;
> +}
> +
> +/**
> + * PCI resume entry.
> + */
> +static int
> +bfad_os_resume(struct pci_dev *pdev)
> +{
> +
> +	/* Resume the device power state to D0 */
> +	pci_set_power_state(pdev, 0);

There is a define for PCI_D0 you could use here..

> +
> +	/* Restore all device PCI configuation space to its original state. */
> +	pci_restore_state(pdev);
> +
> +	if (pci_enable_device(pdev))
> +		goto out;
> +
> +	return 0;
> +
> +out:
> +	return 1;
> +
> +}
> +#endif
> +
> +#ifdef SUPPORT_PCI_AER
> +/*
> + * PCI error recovery support, this fearure is only availbe for kernel
> + * .6.16 or later.
> + */
> +/**
> + * PCI Error Recovery entry, error detected.
> + */
> +static          pci_ers_result_t
> +bfad_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
> +{
> +	struct bfad_s         *bfad = pci_get_drvdata(pdev);
> +
> +	switch (state) {
> +	case pci_channel_io_perm_failure:
> +		/*
> +		 * PCI bus has permanently failed. This is
> +		 * unrecoveralbe, Do we need to do the cleanup like PCI
> +		 * remove? or kernel will automatically do it?
> +		 */

You need to clean things up yourself. Just be careful you don't go off and
try to talk to the adapter, like you might do in the PCI remove case.


> +
> +/**
> + * PCI Error Recovery entry, re-initialize the chip.
> + */
> +static          pci_ers_result_t
> +bfad_pci_slot_reset(struct pci_dev *pdev)
> +{
> +	struct bfad_s         *bfad = pci_get_drvdata(pdev);
> +	int             retval;
> +
> +	if (pci_enable_device(pdev))
> +		goto out;
> +
> +	pci_set_master(pdev);
> +
> +	retval = pci_set_mwi(pdev);
> +
> +	if (retval)
> +		dev_printk(KERN_WARNING, &pdev->dev,
> +			   "Warning: pci_set_mwi returned %d\n", retval);

Could use dev_warn here instead.


> +
> diff -urpN orig/drivers/scsi/bfa/bfad_drv.h patch/drivers/scsi/bfa/bfad_drv.h
> --- orig/drivers/scsi/bfa/bfad_drv.h	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_drv.h	2009-08-19 17:47:54.000000000 -0700
> @@ -0,0 +1,385 @@

> +
> +#if defined(CONFIG_PCIEPORTBUS) && defined(CONFIG_PCIEAER)
> +#define BFAD_ENABLE_PCIE_AER(x) pci_enable_pcie_error_reporting(x)
> +#else
> +#define BFAD_ENABLE_PCIE_AER(x) {}
> +#endif

Shouldn't need to ifdef this sort of stuff. If CONFIG_PCIAER=n,
pci_enable_pcie_error_reporting will return -EINVAL.

> +#define BFAD_IRQ_FLAGS IRQF_SHARED
> +
> +#ifndef FC_PORTSPEED_8GBIT
> +#define FC_PORTSPEED_8GBIT 0x10
> +#endif

Not needed in an upstream Linux driver.


> +
> +#define BFAD_WORK_HANDLER(name) void name(struct work_struct *work)
> +#define BFAD_INIT_WORK(x, work, func) INIT_WORK(&(x)->work, func)

Why not just call INIT_WORK directly?

> +
> +#define list_remove_head(list, entry, type, member)       	\
> +do {                                                    	\
> +	entry = NULL;                                           \
> +	if (!list_empty(list)) {                                \
> +		entry = list_entry((list)->next, type, member); 	\
> +		list_del_init(&entry->member);                  	\
> +	}								\
> +} while (0)
> +
> +#define list_get_first(list, type, member)				\
> +((list_empty(list)) ? NULL :						\
> +	list_entry((list)->next, type, member))

Why not add these to list.h so others can use them as well?

> +
> +bfa_boolean_t   bfad_is_ready(void);
> +bfa_status_t    bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
> +				  struct bfa_port_cfg_s *port_cfg);
> +bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
> +			       struct bfa_port_cfg_s *port_cfg);
> +bfa_status_t    bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role);
> +bfa_status_t    bfad_drv_init(struct bfad_s *bfad);
> +struct bfad_s         *bfad_find_bfad_by_inst_no(int inst_no);
> +void            bfad_drv_start(struct bfad_s *bfad);
> +void            bfad_uncfg_pport(struct bfad_s *bfad);
> +void            bfad_drv_stop(struct bfad_s *bfad);
> +void            bfad_remove_intr(struct bfad_s *bfad);
> +void            bfad_hal_mem_release(struct bfad_s *bfad);
> +void            bfad_hcb_comp(void *arg, bfa_status_t status);
> +
> +int             bfad_os_ioctl_init(void);
> +int             bfad_os_ioctl_exit(void);
> +int             bfad_setup_intr(struct bfad_s *bfad);
> +void            bfad_remove_intr(struct bfad_s *bfad);
> +int             bfad_os_pci_register_driver(struct pci_driver *drv);
> +void            bfad_os_pci_unregister_driver(struct pci_driver *drv);
> +void            bfad_os_device_sysfs_create(struct bfad_s *);
> +void            bfad_os_device_sysfs_remove(struct bfad_s *);
> +void            bfad_os_pci_set_mwi(struct pci_dev *pdev);
> +void            bfad_os_idr_init(struct idr *idr);
> +void            bfad_os_idr_destroy(struct idr *idr);
> +void 		*bfad_os_dma_alloc(struct bfad_s *bfad, struct bfa_mem_elem_s
> +				*meminfo_elem, dma_addr_t *phys_addr);
> +void 		bfad_os_dma_free(struct bfad_s *bfad, struct bfa_mem_elem_s
> +					*meminfo_elem);
> +void 		bfad_os_idr_remove(struct idr *idp, int id);
> +int 		bfad_os_idr_pre_get(struct idr *idp, gfp_t gfp_mask);
> +void 		bfad_os_iounmap(struct pci_dev *pdev, struct bfad_s *bfad);
> +
> +void		bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg);
> +bfa_status_t	bfad_hal_mem_alloc(struct bfad_s *bfad);
> +void		bfad_bfa_tmo(unsigned long data);
> +void		bfad_init_timer(struct bfad_s *bfad);
> +int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad);
> +void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad);
> +void		bfad_fcs_port_cfg(struct bfad_s *bfad);
> +void		bfad_drv_uninit(struct bfad_s *bfad);
> +void		bfad_drv_log_level_set(struct bfad_s *bfad);
> +bfa_status_t	bfad_fc4_module_init(void);
> +void		bfad_fc4_module_exit(void);
> +int 		bfad_ipfc_probe(struct bfad_s *bfad);
> +int 		bfad_ipfc_probe_undo(struct bfad_s *bfad);
> +void 		bfad_ipfc_probe_post(struct bfad_s *bfad);
> +int 		bfad_ipfc_module_init(void);
> +void 		bfad_ipfc_module_exit(void);
> +int			bfad_ipfc_port_online(struct bfad_s *bfad,
> +				struct bfad_port_s *port);
> +int			bfad_ipfc_port_offline(struct bfad_s *bfad,
> +				struct bfad_port_s *port);
> +int			bfad_ipfc_port_new(struct bfad_s *bfad,
> +				struct bfad_port_s *port, int port_type);
> +int			bfad_ipfc_port_delete(struct bfad_s *bfad,
> +				struct bfad_port_s *port);

Are all these function prototypes necessary?

> +#endif /* __BFAD_DRV_H__ */
> diff -urpN orig/drivers/scsi/bfa/bfad_fwimg.c patch/drivers/scsi/bfa/bfad_fwimg.c
> --- orig/drivers/scsi/bfa/bfad_fwimg.c	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_fwimg.c	2009-08-19 17:47:54.000000000 -0700


> +
> +char bfa_version[BFA_VERSION_LEN] = "2.0.0.0 ";

Shouldn't this use BFA_DRIVER_VERSION?

> diff -urpN orig/drivers/scsi/bfa/bfad_im.c patch/drivers/scsi/bfa/bfad_im.c
> --- orig/drivers/scsi/bfa/bfad_im.c	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_im.c	2009-08-19 17:47:54.000000000 -0700

> +
> +void
> +bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
> +			enum bfi_ioim_status io_status, u8 scsi_status,
> +			int sns_len, u8 *sns_info, s32 residue)
> +{
> +	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
> +	struct bfad_s         *bfad = drv;
> +	struct bfad_itnim_data_s *itnim_data;
> +	struct bfad_itnim_s *itnim;
> +	u8         host_status = DID_OK;

Why bother with this local at all? Don't think it simplifies anything...

> +
> +	switch (io_status) {
> +	case BFI_IOIM_STS_OK:
> +		bfa_trc(bfad, scsi_status);
> +		cmnd->result = ScsiResult(host_status, scsi_status);
> +		scsi_set_resid(cmnd, 0);
> +
> +		if (sns_len > 0) {
> +			bfa_trc(bfad, sns_len);
> +			if (sns_len > SCSI_SENSE_BUFFERSIZE)
> +				sns_len = SCSI_SENSE_BUFFERSIZE;
> +			memcpy(cmnd->sense_buffer, sns_info, sns_len);
> +		}
> +		if (residue > 0)
> +			scsi_set_resid(cmnd, residue);
> +		break;
> +
> +	case BFI_IOIM_STS_ABORTED:
> +	case BFI_IOIM_STS_TIMEDOUT:
> +	case BFI_IOIM_STS_PATHTOV:
> +	default:
> +		host_status = DID_ERROR;
> +		cmnd->result = ScsiResult(host_status, 0);
> +	}
> +
> +	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
> +	if (cmnd->device->host != NULL)
> +		bfad_os_im_dma_unmap(bfad, cmnd);
> +
> +	cmnd->host_scribble = NULL;
> +	bfa_trc(bfad, cmnd->result);
> +
> +	itnim_data = cmnd->device->hostdata;
> +	if (itnim_data) {
> +		itnim = itnim_data->itnim;
> +		if (!cmnd->result && itnim &&
> +			 (bfa_lun_queue_depth > cmnd->device->queue_depth)) {
> +			/* Queue depth adjustment for good status completion */
> +			bfad_os_ramp_up_qdepth(itnim, cmnd->device);
> +		} else if (cmnd->result == SAM_STAT_TASK_SET_FULL && itnim) {
> +			/* qfull handling */
> +			bfad_os_handle_qfull(itnim, cmnd->device);
> +		}
> +	}
> +
> +	cmnd->scsi_done(cmnd);
> +}
> +


> +
> +/**
> + *  Scsi_Host_template SCSI host template
> + */
> +/**
> + * Scsi_Host template entry, returns BFAD PCI info.
> + */
> +const char *
> +bfad_im_info(struct Scsi_Host *shost)
> +{
> +	static char     bfa_buf[256];
> +	struct bfad_im_port_s *im_port =
> +			(struct bfad_im_port_s *) shost->hostdata[0];
> +	struct bfa_ioc_attr_s  ioc_attr;
> +	struct bfad_s         *bfad = im_port->bfad;
> +
> +	memset(&ioc_attr, 0, sizeof(ioc_attr));
> +	bfa_get_attr(&bfad->bfa, &ioc_attr);
> +
> +	memset(bfa_buf, 0, sizeof(bfa_buf));
> +	snprintf(bfa_buf, sizeof(bfa_buf),
> +		 "Brocade FC/FCOE Adapter, " "model: %s hwpath: %s driver: %s",
> +		 ioc_attr.adapter_attr.model, bfad->pci_name,
> +		 BFAD_DRIVER_VERSION);
> +	return bfa_buf;
> +}
> +

Can any of these functions be made static?


> +
> +/**
> + * Scsi_Host template entry, resets the bus and abort all commands.
> + */
> +int
> +bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
> +{
> +	struct Scsi_Host *shost = cmnd->device->host;
> +	struct bfad_im_port_s *im_port =
> +				(struct bfad_im_port_s *) shost->hostdata[0];
> +	struct bfad_s         *bfad = im_port->bfad;
> +	struct bfad_itnim_s   *itnim;
> +	unsigned long   flags;
> +	u32        i, rc, err_cnt = 0;
> +	DECLARE_WAIT_QUEUE_HEAD(wq);
> +	enum bfi_tskim_status task_status;
> +
> +	spin_lock_irqsave(&bfad->bfad_lock, flags);
> +	for (i = 0; i < MAX_FCP_TARGET; i++) {
> +		itnim = bfad_os_get_itnim(im_port, i);
> +		if (itnim) {
> +			cmnd->SCp.ptr = (char *)&wq;
> +			rc = bfad_im_target_reset_send(bfad, cmnd, itnim);

Since you are just sending target resets anyway, why not just support
eh_target_reset_handler and not support eh_bus_reset_handler?


> +
> +void
> +bfad_wwn_to_str(wwn_t wwn, char *str)
> +{
> +	sprintf(str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
> +		*((u8 *)&wwn),
> +		*(((u8 *)&wwn) + 1),
> +		*(((u8 *)&wwn) + 2),
> +		*(((u8 *)&wwn) + 3),
> +		*(((u8 *)&wwn) + 4),
> +		*(((u8 *)&wwn) + 5),
> +		*(((u8 *)&wwn) + 6),
> +		*(((u8 *)&wwn) + 7));
> +}
> +

Seems like a candidate to go in include/scsi/fc?



> +
> +/**
> + * Path TOV processing begin notification -- dummy for linux
> + */
> +void
> +bfa_fcb_itnim_tov_begin(struct bfad_itnim_s *itnim)
> +{
> +}
> +
> +

I'm seeing a lot of dummy functions... No need for those in an upstream
Linux driver. It just makes the driver more difficult to understand.


> +
> +int
> +bfad_os_im_dma_map(struct bfad_s *bfad, struct scsi_cmnd *cmnd)
> +{
> +	int             sg_cnt, rc = 0;
> +
> +	if (scsi_sg_count(cmnd)) {
> +		sg_cnt = dma_map_sg((struct device *)&bfad->pcidev->dev,
> +					(struct scatterlist *)scsi_sglist(cmnd),
> +					scsi_sg_count(cmnd),
> +					cmnd->sc_data_direction);
> +		if (sg_cnt == 0 || sg_cnt > bfad->cfg_data.io_max_sge) {
> +			printk(KERN_WARNING
> +				"bfad%d: dma_map_sg failure, sg_cnt=%d\n",
> +				bfad->inst_no, sg_cnt);
> +			rc = 1;
> +		}
> +
> +	} else if (scsi_bufflen(cmnd)) {
> +		cmnd->SCp.dma_handle =
> +			dma_map_single((struct device *)&bfad->pcidev->
> +					       dev, scsi_sglist(cmnd),
> +					       scsi_bufflen(cmnd),
> +					       cmnd->sc_data_direction);
> +	}

This should be simplified to use scsi_dma_map, which would eliminate the need
for this helper function altogether.

> +
> +static void
> +bfad_im_fc_rport_add(struct bfad_im_port_s *im_port, struct bfad_itnim_s *itnim)
> +{
> +	struct fc_rport_identifiers rport_ids;
> +	struct fc_rport *fc_rport;
> +	struct bfad_itnim_data_s *itnim_data;
> +
> +	rport_ids.node_name =
> +		bfa_os_htonll(bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim));

As mentioned below, you should be able to do away with the bfa_os_htonll wrapper.



> +
> +/**
> + * Scsi_Host template entry, queue a SCSI command to the BFAD.
> + */
> +int
> +bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
> +{
> +	struct bfad_im_port_s *im_port =
> +		(struct bfad_im_port_s *) cmnd->device->host->hostdata[0];

You can use shost_priv here instead.

> +	struct bfad_s         *bfad = im_port->bfad;
> +	struct bfad_itnim_data_s *itnim_data = cmnd->device->hostdata;

> +
> +void
> +bfad_os_rport_online_wait(struct bfad_s *bfad)
> +{
> +	int i;
> +	int rport_delay = 10;
> +
> +	for (i = 0; !(bfad->bfad_flags & BFAD_PORT_ONLINE)
> +		 && i < linkup_delay; i++) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule_timeout(HZ);

This can be simplified to use schedule_timeout_uninterruptible.
You might also look into using wait_event_timeout as an alternative.

> +
> diff -urpN orig/drivers/scsi/bfa/bfad_im_compat.h patch/drivers/scsi/bfa/bfad_im_compat.h
> --- orig/drivers/scsi/bfa/bfad_im_compat.h	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_im_compat.h	2009-08-19 17:47:54.000000000 -0700

> +
> +extern u32 *bfi_image_buf;
> +extern u32 bfi_image_size;
> +
> +extern struct device_attribute *bfad_im_host_attrs[];
> +extern struct device_attribute *bfad_im_vport_attrs[];

I will echo Andrew's comment regarding globals... Can't some of these
be scoped to a single instance of an adapter?

> diff -urpN orig/drivers/scsi/bfa/bfad_im.h patch/drivers/scsi/bfa/bfad_im.h
> --- orig/drivers/scsi/bfa/bfad_im.h	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_im.h	2009-08-19 17:47:54.000000000 -0700

> +#define FCPI_NAME " fcpim"
> +
> +#ifndef KOBJ_NAME_LEN
> +#define KOBJ_NAME_LEN           20
> +#endif

This can be removed as it is not needed in an upstream driver.



> +
> +void bfad_os_spin_os_lock_irq(struct Scsi_Host *);
> +void bfad_os_spin_os_unlock_irq(struct Scsi_Host *);

These sort of wrappers are generally frowned upon in Linux as they
obfuscate the code and make it more difficult to read. Recommend
you call the kernel interfaces directly. The same comment follows for
a lot, if not all, of the function prototypes below.

> +void bfad_os_fc_release_transp(struct Scsi_Host *shost);
> +struct Scsi_Host *bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port,
> +				struct bfad_s *);
> +int bfad_os_scsi_register(struct Scsi_Host *shost,
> +				struct bfad_im_port_s *im_port, void *key);
> +int bfad_os_fc_attach(struct Scsi_Host *shost,
> +				struct fc_function_template *fct);
> +int bfad_os_reset_tgt(struct scsi_cmnd *cmnd);
> +void bfad_os_scsi_set_pci_device(struct Scsi_Host *shost,
> +				struct pci_dev *pcidev);
> +void bfad_os_select_queue_depths(struct bfad_im_port_s *im_port);
> +bfa_status_t bfad_os_thread_workq(struct bfad_s *bfad);
> +void bfad_os_destroy_workq(struct bfad_im_s *im);
> +void bfad_os_queue_work(void *workq, void *work);
> +void bfad_os_itnim_alloc(struct bfad_itnim_s *itnim_drv);
> +void bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv);
> +void bfad_os_itnim_tov(struct bfad_itnim_s *itnim_drv);
> +void bfad_os_scsi_unregister(struct Scsi_Host *shost);
> +void bfad_os_scsi_remove_host(struct Scsi_Host *shost);
> +void bfad_os_scsi_put_host(struct Scsi_Host *shost);
> +int bfad_os_scsi_add_host(struct Scsi_Host *shost,
> +		struct bfad_im_port_s *im_port, struct bfad_s *bfad);
> +int bfad_os_fc_attach(struct Scsi_Host *shost,
> +				  struct fc_function_template *fct);
> +
> +struct bfad_itnim_data_s *bfad_os_itnim_data(struct bfad_im_port_s *im_port,
> +				struct scsi_cmnd *cmnd);
> +void bfad_os_fc_host_init(struct bfad_im_port_s *im_port);
> +void bfad_os_fc_remove_host(struct Scsi_Host *shost);
> +void bfad_os_init_work(struct bfad_im_port_s *im_port);
> +int  bfad_os_dev_init(struct Scsi_Host *shost);
> +void bfad_os_transp_templ(struct Scsi_Host *sh,
> +				struct scsi_transport_template *stt);
> +dma_addr_t bfad_os_dma_map_single(struct device *dev, void *cpu_addr,
> +			size_t size, enum dma_data_direction direction);
> +void bfad_os_dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
> +			size_t size, enum dma_data_direction direction);
> +int bfad_os_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> +			enum dma_data_direction direction);
> +void bfad_os_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
> +			int nhwentries, enum dma_data_direction direction);
> +int bfad_os_im_dma_map(struct bfad_s *bfad, struct scsi_cmnd *cmnd);
> +void bfad_os_im_dma_unmap(struct bfad_s *bfad, struct scsi_cmnd *cmnd);
> +int bfad_os_idr_get_new(struct idr *idp, void *ptr, int *id);
> +void bfad_os_scsi_state_changed(struct Scsi_Host *shost,
> +				struct bfad_itnim_s *itnim);
> +void bfad_os_scsi_scan(struct bfad_im_port_s *im_port);
> +void bfad_os_scsi_host_free(struct bfad_s *bfad,
> +				 struct bfad_im_port_s *im_port);
> +void bfad_wwn_to_str(wwn_t wwn, char *str);
> +void bfad_fcid_to_str(u32 fcid, char *str);
> +void bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim,
> +				 struct scsi_device *sdev);
> +void bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev);
> +void bfad_os_set_dev_loss_tmo(struct scsi_device *sdev);
> +struct bfad_itnim_s *bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id);
> +int bfad_os_im_itnim_is_online(struct bfad_itnim_s *itnim);
> +
> +/*
> + * scsi_host_template entries
> + */
> +int bfad_im_queuecommand(struct scsi_cmnd *cmnd,
> +					void (*done)(struct scsi_cmnd *));
> +const char *bfad_im_info(struct Scsi_Host *host);
> +int bfad_im_slave_alloc(struct scsi_device *sdev);
> +void bfad_im_slave_destroy(struct scsi_device *sdev);
> +int bfad_im_abort_handler(struct scsi_cmnd *cmnd);
> +int bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd);
> +int bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd);
> +void bfad_im_itnim_unmap(struct bfad_im_port_s  *im_port,
> +			 struct bfad_itnim_s *itnim);
> +
> +extern struct scsi_host_template bfad_im_scsi_host_template;
> +extern struct scsi_host_template bfad_im_vport_template;
> +extern struct fc_function_template bfad_im_fc_function_template;
> +extern struct scsi_transport_template *bfad_im_scsi_transport_template;
> +
> +#endif
> diff -urpN orig/drivers/scsi/bfa/bfad_intr.c patch/drivers/scsi/bfa/bfad_intr.c
> --- orig/drivers/scsi/bfa/bfad_intr.c	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_intr.c	2009-08-19 17:47:54.000000000 -0700

> +
> +#ifdef CONFIG_PCI_MSI

If CONFIG_PCI_MSI=n, pci_enable_msix will fail with a -1 rc, so there
is no need to ifdef this code. Just handle pci_enable_msix failing, which
it looks like you already do.

> +
> +static irqreturn_t
> +bfad_msix(int irq, void *dev_id)
> +{


> diff -urpN orig/drivers/scsi/bfa/bfad_os.c patch/drivers/scsi/bfa/bfad_os.c
> --- orig/drivers/scsi/bfa/bfad_os.c	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/bfad_os.c	2009-08-19 17:47:54.000000000 -0700
> +
> +void
> +bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
> +			const char *fmt, ...)
> +{
> +	va_list ap;
> +	#define BFA_STRING_256	256
> +	char tmp[BFA_STRING_256];
> +
> +	va_start(ap, fmt);
> +	vsprintf(tmp, fmt, ap);
> +	va_end(ap);
> +
> +	printk(tmp);
> +}

Don't see any value in re-inventing printk and using a printk buffer on the
stack, which seems a little dangerous...

> +
> +u32
> +bfa_os_get_instance_id(struct bfad_s *bfad)
> +{
> +	return (bfad->inst_no);
> +}

Why bother wrappering this in a function?

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
