From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 1/14] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Wed, 23 Sep 2009 19:40:23 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F6ED@HQ-EXCH-7.corp.brocade.com>
References: <200908200658.n7K6wGXt006427@swe57.brocade.com>
 <4A9FD640.6040701@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:39473 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZIXClM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 22:41:12 -0400
In-Reply-To: <4A9FD640.6040701@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, Krishna Gudipati <kgudipat@Brocade.com>

Hi Brian,

Thanks you so much for the detailed code review. I just resubmitted the patch set with changes to address most of your findings. Please find inline reply for each of your code review comment.

Jing

> > +/**
> > + * FC transport template entry, issue a LIP.
> > + */
> > +int
> > +bfad_im_issue_fc_host_lip(struct Scsi_Host *shost)
> > +{
> > +   return 0;
> > +}
>
> Is there code missing here, or can this be removed? If you don't support
> issue_fc_host_lip, then don't setup the function pointer.
>

Removed the function.

> > +
> > +
> > +
> > +
> > +
> > +struct Scsi_Host *
> > +bfad_os_starget_to_shost(struct scsi_target *starget)
> > +{
> > +   return dev_to_shost(starget->dev.parent);
> > +}
> > +
>
> Just call dev_to_shost directly
>

Fixed.

>
> > +
> > +static ssize_t
> > +bfad_im_num_of_discovered_ports_show(struct device *dev,
> > +                   struct device_attribute *attr, char *buf)
> > +{
> > +   struct Scsi_Host *shost = class_to_shost(dev);
> > +   struct bfad_im_port_s *im_port =
> > +                   (struct bfad_im_port_s *) shost->hostdata[0];
> > +   struct bfad_port_s    *port = im_port->port;
> > +   struct bfad_s         *bfad = im_port->bfad;
> > +   int        nrports = 2048;
> > +   wwn_t          *rports = NULL;
> > +   unsigned long   flags;
> > +
> > +   rports = kzalloc(sizeof(wwn_t) * nrports , GFP_ATOMIC);
> > +   if (rports == NULL)
> > +           return snprintf(buf, PAGE_SIZE, "Failed\n");
>
> Just return -ENOMEM here instead of printing Failed.
>

Fixed.

> > +
> > +void
> > +bfad_flags_set(struct bfad_s *bfad, u32 flags)
> > +{
> > +   if (bfad)
> > +           bfad->bfad_flags |= flags;
> > +}
> > +
> > +
> > +/**
> > + * bfa_ioc_diable() callback.
> > + */
> > +void
> > +bfa_cb_ioc_disable(void *drv)
> > +{
> > +   struct bfad_s  *bfad = drv;
> > +
> > +   complete(&bfad->disable_comp);
> > +}
> > +
> > +void
> > +bfa_fcb_exit(struct bfad_s *drv)
> > +{
> > +   complete(&drv->comp);
> > +}
>
> I think a lot of these very small helper functions can just be removed as
> they
> don't really make the driver any easier to read.
>

Removed these small helper functions.

>
> > +
> > +void
> > +bfa_fcb_vf_stop(struct bfad_vf_s *vf_drv)
> > +{
> > +}
> > +
>
> This can be removed.
>

Removed.

> > +
> > +/**
> > + * FCS RPORT free callback.
> > + */
> > +void
> > +bfa_fcb_rport_free(struct bfad_s *bfad, struct bfad_rport_s
> **rport_drv)
> > +{
> > +   kfree(*rport_drv);
> > +}
>
> Why not just call kfree directly?
>

Fixed. We have some code that can be used by multiple OS's, that is the reason for those small helper functions etc. I fixed them anyway.

>
> > +
> > +bfa_status_t
> > +bfad_hal_mem_alloc(struct bfad_s *bfad)
> > +{
> > +   struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
> > +   struct bfa_mem_elem_s *meminfo_elem;
> > +   bfa_status_t    rc = BFA_STATUS_OK;
> > +   dma_addr_t      phys_addr;
> > +   int             retry_count = 0;
> > +   int             reset_value = 1;
> > +   int             min_num_sgpgs = 512;
> > +   void           *kva;
> > +   int             i;
>
> > +           case BFA_MEM_TYPE_DMA:
> > +                   kva = dma_alloc_coherent(&bfad->pcidev->dev,
> > +                                   meminfo_elem->mem_len,
> > +                                   &phys_addr, GFP_KERNEL);
> > +                   if (kva == NULL) {
> > +                           bfad_hal_mem_release(bfad);
> > +                           /*
> > +                            * If we cannot allocate with default
> > +                            * num_sgpages try with half the value.
> > +                            */
> > +                           if (num_sgpgs > min_num_sgpgs) {
> > +                                   printk(KERN_INFO "bfad[%d]: memory"
> > +                                           " allocation failed with"
> > +                                           " num_sgpgs: %d\n",
> > +                                           bfad->inst_no, num_sgpgs);
> > +                                   nextLowerInt(&num_sgpgs);
> > +                                   printk(KERN_INFO "bfad[%d]: trying to"
> > +                                           " allocate memory with"
> > +                                           " num_sgpgs: %d\n",
> > +                                           bfad->inst_no, num_sgpgs);
>
> Can you use dev_info here instead?

Forgot to change this in last submission. Will fix it in subsequent patch.

>
> > +                                   retry_count++;
> > +                                   goto retry;
> > +                           } else {
> > +                                   if (num_sgpgs_parm > 0)
>
>
>
>
> > +
> > +int
> > +bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
> > +{
>
> > +
> > +   bfad->pci_bar0_map = pci_resource_start(pdev, 0);
> > +   bar0_len = pci_resource_len(pdev, 0);
> > +   bfad->pci_bar0_kva = ioremap(bfad->pci_bar0_map, bar0_len);
> > +
> > +   if (bfad->pci_bar0_kva == NULL) {
> > +           BFA_PRINTF(BFA_ERR, "Fail to map bar0\n");
> > +           goto out_release_region;
> > +   }
> > +
> > +   bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
> > +   bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
> > +   bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
> > +   bfad->hal_pcidev.device_id = pdev->device;
> > +   bfad->pci_name = pci_name(pdev);
> > +
> > +   bfad->pci_attr.vendor_id = pdev->vendor;
> > +   bfad->pci_attr.device_id = pdev->device;
> > +   bfad->pci_attr.ssid = pdev->subsystem_device;
> > +   bfad->pci_attr.ssvid = pdev->subsystem_vendor;
> > +   bfad->pci_attr.pcifn = PCI_FUNC(pdev->devfn);
>
> Why do you need to copy all this data to your own structure? Can't you
> just access it from the pdev when you need it?
>

This is also due to some common code consideration. I didn't fix it this time due to the amount of code changes, but I will keep this mind and try to fix it in subsequent patches.

> > +   /*
> > +    * If linkup_delay is set to -1 default; try to retrive the
> > +    * value using the bfad_os_get_linkup_delay(); else use the
> > +    * passed in module param value as the linkup_delay.
> > +    */
> > +   if (linkup_delay < 0) {
> > +#if defined(__ia64__)
> > +           linkup_delay = 10;
> > +#else
> > +           linkup_delay = bfad_os_get_linkup_delay(bfad);
> > +#endif
>
> This looks rather strange. What does ia64 need a different delay?
>

I agree. This linkup delay is introduced for boot-over-san case. We implemented some mechanism in BIOS so that this linkup delay is only introduced to the port that is connected to the boot LUN. This feature was not available for EFI boot at the time when the patch was submitted. We recently implemented similar mechanism for EFI boot, so I can remove it now.

> > +
> > +#define BFAD_MAX_PCIIDS    4
> > +struct pci_device_id bfad_id_table[BFAD_MAX_PCIIDS] = {
>
> Don't need BFAD_MAX_PCIIDS here. Just declare this [] and have
> the compiler figure it out. This could also be flagged __devinitdata.
>

Fixed.

> > +
> > +module_param(os_name, charp, S_IRUGO | S_IWUSR);
> > +module_param(os_patch, charp, S_IRUGO | S_IWUSR);
> > +module_param(host_name, charp, S_IRUGO | S_IWUSR);
> > +module_param(num_rports, int, S_IRUGO | S_IWUSR);
> > +module_param(num_ios, int, S_IRUGO | S_IWUSR);
> > +module_param(num_tms, int, S_IRUGO | S_IWUSR);
> > +module_param(num_fcxps, int, S_IRUGO | S_IWUSR);
> > +module_param(num_ufbufs, int, S_IRUGO | S_IWUSR);
> > +module_param(reqq_size, int, S_IRUGO | S_IWUSR);
> > +module_param(rspq_size, int, S_IRUGO | S_IWUSR);
> > +module_param(num_sgpgs, int, S_IRUGO | S_IWUSR);
> > +module_param(rport_del_timeout, int, S_IRUGO | S_IWUSR);
> > +module_param(bfa_lun_queue_depth, int, S_IRUGO | S_IWUSR);
> > +module_param(bfa_io_max_sge, int, S_IRUGO | S_IWUSR);
> > +module_param(log_level, int, S_IRUGO | S_IWUSR);
> > +module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
> > +module_param(ipfc_enable, int, S_IRUGO | S_IWUSR);
> > +module_param(ipfc_mtu, int, S_IRUGO | S_IWUSR);
> > +module_param(linkup_delay, int, S_IRUGO | S_IWUSR);
> > +module_param(msix_disable, int, S_IRUGO | S_IWUSR);
>
> This seems like a lot of module parameters. Are they all needed?
> Would some of them work better as scsi_host sysfs parameters?
>

Yes. They are all module parameters therefore I chose to not populate them for each scsi_host.

> > +
> > +#ifdef CONFIG_PM
> > +int             pci_save_state(struct pci_dev *pdev);
> > +int             pci_restore_state(struct pci_dev *pdev);
>
> Don't need these..
>

Removed them.

> > + */
> > +static int
> > +bfad_os_suspend(struct pci_dev *pdev, pm_message_t state)
> > +{
> > +   struct bfad_s         *bfad = pci_get_drvdata(pdev);
> > +   pci_power_t     device_state;
> > +
> > +   device_state = pci_choose_state(pdev, state);
> > +
> > +   pci_save_state(pdev);
> > +   init_completion(&bfad->suspend);
> > +   wait_for_completion(&bfad->suspend);
>
> What triggers you to wake up here? Won't you lose initiative here
> and never wake up?
>

Thanks for finding the bug. The suspend/resume and the PCI error recovery are not tested. I removed for now. I will add them back when they are ready.

> > +#define BFAD_IRQ_FLAGS IRQF_SHARED
> > +
> > +#ifndef FC_PORTSPEED_8GBIT
> > +#define FC_PORTSPEED_8GBIT 0x10
> > +#endif
>
> Not needed in an upstream Linux driver.
>

Removed.

> > +
> > +#define BFAD_WORK_HANDLER(name) void name(struct work_struct *work)
> > +#define BFAD_INIT_WORK(x, work, func) INIT_WORK(&(x)->work, func)
>
> Why not just call INIT_WORK directly?
>

Fixed.

> > +
> > +#define list_remove_head(list, entry, type, member)        \
> > +do {                                                       \
> > +   entry = NULL;                                           \
> > +   if (!list_empty(list)) {                                \
> > +           entry = list_entry((list)->next, type, member);         \
> > +           list_del_init(&entry->member);                          \
> > +   }                                                               \
> > +} while (0)
> > +
> > +#define list_get_first(list, type, member)                         \
> > +((list_empty(list)) ? NULL :                                               \
> > +   list_entry((list)->next, type, member))
>
> Why not add these to list.h so others can use them as well?
>

Removed.

> > +int                        bfad_ipfc_port_offline(struct bfad_s *bfad,
> > +                           struct bfad_port_s *port);
> > +int                        bfad_ipfc_port_new(struct bfad_s *bfad,
> > +                           struct bfad_port_s *port, int port_type);
> > +int                        bfad_ipfc_port_delete(struct bfad_s *bfad,
> > +                           struct bfad_port_s *port);
>
> Are all these function prototypes necessary?
>

Removed all unnecessary function prototypes.


> > +
> > +char bfa_version[BFA_VERSION_LEN] = "2.0.0.0 ";
>
> Shouldn't this use BFA_DRIVER_VERSION?
>

Fixed.

> > +void
> > +bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
> > +                   enum bfi_ioim_status io_status, u8 scsi_status,
> > +                   int sns_len, u8 *sns_info, s32 residue)
> > +{
> > +   struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
> > +   struct bfad_s         *bfad = drv;
> > +   struct bfad_itnim_data_s *itnim_data;
> > +   struct bfad_itnim_s *itnim;
> > +   u8         host_status = DID_OK;
>
> Why bother with this local at all? Don't think it simplifies anything...

Removed the local.

> > +
> > +/**
> > + *  Scsi_Host_template SCSI host template
> > + */
> > +/**
> > + * Scsi_Host template entry, returns BFAD PCI info.
> > + */
> > +const char *
> > +bfad_im_info(struct Scsi_Host *shost)
> > +{
> > +   static char     bfa_buf[256];
> > +   struct bfad_im_port_s *im_port =
> > +                   (struct bfad_im_port_s *) shost->hostdata[0];
> > +   struct bfa_ioc_attr_s  ioc_attr;
> > +   struct bfad_s         *bfad = im_port->bfad;
> > +
> > +   memset(&ioc_attr, 0, sizeof(ioc_attr));
> > +   bfa_get_attr(&bfad->bfa, &ioc_attr);
> > +
> > +   memset(bfa_buf, 0, sizeof(bfa_buf));
> > +   snprintf(bfa_buf, sizeof(bfa_buf),
> > +            "Brocade FC/FCOE Adapter, " "model: %s hwpath: %s driver:
> %s",
> > +            ioc_attr.adapter_attr.model, bfad->pci_name,
> > +            BFAD_DRIVER_VERSION);
> > +   return bfa_buf;
> > +}
> > +
>
> Can any of these functions be made static?

Changed them to static.

> > +/**
> > + * Scsi_Host template entry, resets the bus and abort all commands.
> > + */
> > +int
> > +bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
> > +{
> > +   struct Scsi_Host *shost = cmnd->device->host;
> > +   struct bfad_im_port_s *im_port =
> > +                           (struct bfad_im_port_s *) shost->hostdata[0];
> > +   struct bfad_s         *bfad = im_port->bfad;
> > +   struct bfad_itnim_s   *itnim;
> > +   unsigned long   flags;
> > +   u32        i, rc, err_cnt = 0;
> > +   DECLARE_WAIT_QUEUE_HEAD(wq);
> > +   enum bfi_tskim_status task_status;
> > +
> > +   spin_lock_irqsave(&bfad->bfad_lock, flags);
> > +   for (i = 0; i < MAX_FCP_TARGET; i++) {
> > +           itnim = bfad_os_get_itnim(im_port, i);
> > +           if (itnim) {
> > +                   cmnd->SCp.ptr = (char *)&wq;
> > +                   rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
>
> Since you are just sending target resets anyway, why not just support
> eh_target_reset_handler and not support eh_bus_reset_handler?
>

You are right. But the change was not made this time. I will look into it.

> > +void
> > +bfad_wwn_to_str(wwn_t wwn, char *str)
> > +{
> > +   sprintf(str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
> > +           *((u8 *)&wwn),
> > +           *(((u8 *)&wwn) + 1),
> > +           *(((u8 *)&wwn) + 2),
> > +           *(((u8 *)&wwn) + 3),
> > +           *(((u8 *)&wwn) + 4),
> > +           *(((u8 *)&wwn) + 5),
> > +           *(((u8 *)&wwn) + 6),
> > +           *(((u8 *)&wwn) + 7));
> > +}
> > +
>
> Seems like a candidate to go in include/scsi/fc?
>

I agree, removed this function.

>
> I'm seeing a lot of dummy functions... No need for those in an upstream
> Linux driver. It just makes the driver more difficult to understand.
>

Those dummy functions are also introduced for the common code. I fixed most of them. And I will keep working on this.

> > +int
> > +bfad_os_im_dma_map(struct bfad_s *bfad, struct scsi_cmnd *cmnd)
> > +{
> > +   int             sg_cnt, rc = 0;
> > +
> > +   if (scsi_sg_count(cmnd)) {
> > +           sg_cnt = dma_map_sg((struct device *)&bfad->pcidev->dev,
> > +                                   (struct scatterlist *)scsi_sglist(cmnd),
> > +                                   scsi_sg_count(cmnd),
> > +                                   cmnd->sc_data_direction);
> > +           if (sg_cnt == 0 || sg_cnt > bfad->cfg_data.io_max_sge) {
> > +                   printk(KERN_WARNING
> > +                           "bfad%d: dma_map_sg failure, sg_cnt=%d\n",
> > +                           bfad->inst_no, sg_cnt);
> > +                   rc = 1;
> > +           }
> > +
> > +   } else if (scsi_bufflen(cmnd)) {
> > +           cmnd->SCp.dma_handle =
> > +                   dma_map_single((struct device *)&bfad->pcidev->
> > +                                          dev, scsi_sglist(cmnd),
> > +                                          scsi_bufflen(cmnd),
> > +                                          cmnd->sc_data_direction);
> > +   }
>
> This should be simplified to use scsi_dma_map, which would eliminate the
> need
> for this helper function altogether.
>

Fixed.

> > +
> > +static void
> > +bfad_im_fc_rport_add(struct bfad_im_port_s *im_port, struct
> bfad_itnim_s *itnim)
> > +{
> > +   struct fc_rport_identifiers rport_ids;
> > +   struct fc_rport *fc_rport;
> > +   struct bfad_itnim_data_s *itnim_data;
> > +
> > +   rport_ids.node_name =
> > +           bfa_os_htonll(bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim));
>
> As mentioned below, you should be able to do away with the bfa_os_htonll
> wrapper.
>

The swap is necessary here since we save wwnn in native FC format.

> > +   for (i = 0; !(bfad->bfad_flags & BFAD_PORT_ONLINE)
> > +            && i < linkup_delay; i++) {
> > +           set_current_state(TASK_UNINTERRUPTIBLE);
> > +           schedule_timeout(HZ);
>
> This can be simplified to use schedule_timeout_uninterruptible.
> You might also look into using wait_event_timeout as an alternative.
>

Fixed.

> > +
> > diff -urpN orig/drivers/scsi/bfa/bfad_im_compat.h
> patch/drivers/scsi/bfa/bfad_im_compat.h
> > --- orig/drivers/scsi/bfa/bfad_im_compat.h  1969-12-31
> 16:00:00.000000000 -0800
> > +++ patch/drivers/scsi/bfa/bfad_im_compat.h 2009-08-19
> 17:47:54.000000000 -0700
>
> > +
> > +extern u32 *bfi_image_buf;
> > +extern u32 bfi_image_size;
> > +
> > +extern struct device_attribute *bfad_im_host_attrs[];
> > +extern struct device_attribute *bfad_im_vport_attrs[];
>
> I will echo Andrew's comment regarding globals... Can't some of these
> be scoped to a single instance of an adapter?
>

Fixed Andrew's code review comments. I have to keep some globals since they are intended for the module instead of a single instance.

> > +#define FCPI_NAME " fcpim"
> > +
> > +#ifndef KOBJ_NAME_LEN
> > +#define KOBJ_NAME_LEN           20
> > +#endif
>
> This can be removed as it is not needed in an upstream driver.
>

Removed.

> > +
> > +void bfad_os_spin_os_lock_irq(struct Scsi_Host *);
> > +void bfad_os_spin_os_unlock_irq(struct Scsi_Host *);
>
> These sort of wrappers are generally frowned upon in Linux as they
> obfuscate the code and make it more difficult to read. Recommend
> you call the kernel interfaces directly. The same comment follows for
> a lot, if not all, of the function prototypes below.
>

Removed.

> > +
> > +#ifdef CONFIG_PCI_MSI
>
> If CONFIG_PCI_MSI=n, pci_enable_msix will fail with a -1 rc, so there
> is no need to ifdef this code. Just handle pci_enable_msix failing, which
> it looks like you already do.
>

Fixed.

> > +void
> > +bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
> > +                   const char *fmt, ...)
> > +{
> > +   va_list ap;
> > +   #define BFA_STRING_256  256
> > +   char tmp[BFA_STRING_256];
> > +
> > +   va_start(ap, fmt);
> > +   vsprintf(tmp, fmt, ap);
> > +   va_end(ap);
> > +
> > +   printk(tmp);
> > +}
>
> Don't see any value in re-inventing printk and using a printk buffer on
> the
> stack, which seems a little dangerous...
>

This is also due to some common code and log message format consideration. I didn't fix it in last submission due to the amount of code changes. But I will keep this in mind and try to fix them in subsequent patches.

> > +
> > +u32
> > +bfa_os_get_instance_id(struct bfad_s *bfad)
> > +{
> > +   return (bfad->inst_no);
> > +}
>
> Why bother wrappering this in a function?
>

Fixed.

