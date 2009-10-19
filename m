From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2
Date: Mon, 19 Oct 2009 12:26:52 -0400
Message-ID: <4ADC934C.1020401@emulex.com>
References: <20091017011435.GA25197@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51086 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZJSQ06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 12:26:58 -0400
In-Reply-To: <20091017011435.GA25197@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

A few code review comments:

Jayamohan Kallickal wrote:
> +static struct bin_attribute sysfs_drvr_fw_prgrm_attr = {
> +       .attr = {
> +               .name = "be2iscsi_fw_prgrm",
> +               .mode = S_IRUSR | S_IWUSR,
> +               .owner = THIS_MODULE,
> +       },
> +       .size = 0,
> +       .read = beiscsi_sysfs_fw_rd,
> +       .write = beiscsi_sysfs_fw_wr,
> +};
> +

Use the DEVICE_ATTR macro...


> @@ -355,13 +526,32 @@ static irqreturn_t be_isr(int irq, void *dev_id)
>  static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  {
>         struct pci_dev *pcidev = phba->pcidev;
> -       int ret;
> +       struct hwi_controller *phwi_ctrlr;
> +       struct hwi_context_memory *phwi_context;
> +       int ret, msix_vec, i = 0;
> +       char desc[32];
> 
> -       ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED, "beiscsi", phba);
> -       if (ret) {
> -               shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
> -                            "Failed to register irq\\n");
> -               return ret;
> +       phwi_ctrlr = phba->phwi_ctrlr;
> +       phwi_context = phwi_ctrlr->phwi_ctxt;
> +
> +       if (enable_msix) {

This should be checking phba->msix_enabled instead.  This code is checking the 
module-global variable for whether to attempt MSIX mode.  The phba-specific 
value must be checked to see if pci_enable_msix was successful on this adapter.

There are lots of other occurrences of the same issue in the cq/eq create 
routines and handlers, as well as error paths, etc.


> -static int beiscsi_create_eq(struct beiscsi_hba *phba,
> +static int beiscsi_create_eqs(struct beiscsi_hba *phba,
>                              struct hwi_context_memory *phwi_context)
>  {
> -       unsigned int idx;
> -       int ret;
> +       unsigned int i, num_eq_pages;
> +       int ret, eq_for_mcc;
>         struct be_queue_info *eq;
>         struct be_dma_mem *mem;
> -       struct be_mem_descriptor *mem_descr;
>         void *eq_vaddress;
> +       dma_addr_t paddr;
> 
> -       idx = 0;
> -       eq = &phwi_context->be_eq.q;
> -       mem = &eq->dma_mem;
> -       mem_descr = phba->init_mem;
> -       mem_descr += HWI_MEM_EQ;
> -       eq_vaddress = mem_descr->mem_array[idx].virtual_address;
> -
> -       ret = be_fill_queue(eq, phba->params.num_eq_entries,
> -                           sizeof(struct be_eq_entry), eq_vaddress);
> -       if (ret) {
> -               shost_printk(KERN_ERR, phba->shost,
> -                            "be_fill_queue Failed for EQ \n");
> -               return ret;
> -       }
> +       num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries * \
> +                                     sizeof(struct be_eq_entry));
> 
> -       mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
> +       if (enable_msix)
> +               eq_for_mcc = 1;
> +       else
> +               eq_for_mcc = 0;
> +       for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
> +               eq = &phwi_context->be_eq[i].q;
> +               mem = &eq->dma_mem;
> +               phwi_context->be_eq[i].phba = phba;
> +               eq_vaddress = pci_alloc_consistent(phba->pcidev,
> +                                                    num_eq_pages * PAGE_SIZE,
> +                                                    &paddr);

Missing check for NULL return from pci_alloc_consistent().   There are several 
other occurrences of the same issue in the patch.

I see you are no longer applying the "round down" logic for the eq's/cq's.




> +static int
> +beiscsi_alloc_sysfs_attr(struct Scsi_Host *shost)
> +{
> +       int ret;
> +
> +       ret = sysfs_create_bin_file(&shost->shost_dev.kobj,
> +                                   &sysfs_drvr_fw_prgrm_attr);
> +       if (ret)
> +               shost_printk(KERN_WARNING, shost,
> +                            "Failed in be2iscsi_alloc_sysfs_attr\n");
> +       return ret;
> +}
> +
> +static void beiscsi_free_sysfs_attr(struct Scsi_Host *shost)
> +{
> +       sysfs_remove_bin_file(&shost->shost_dev.kobj,
> +                             &sysfs_drvr_fw_prgrm_attr);
> +}

This style of creating sysfs attributes is odd for SCSI hosts.  Attributes 
usually use the DEVICE_ATTR macro, with an attribute array that is set in the 
scsi_host_template via the .shost_attrs field.



> +static void beiscsi_msix_enable(struct beiscsi_hba *phba)
> +{
> +       int i, status;
> +
> +       for (i = 0; i <= phba->num_cpus; i++)
> +               phba->msix_entries[i].entry = i;
> +
> +       status = pci_enable_msix(phba->pcidev, phba->msix_entries,
> +                                (phba->num_cpus + 1));
> +       if (!status)
> +               phba->msix_enabled = true;
> +
> +       return;
> +}
> +

Here's where you set the per-phba setting for msix enabled or not....


> +       if (beiscsi_alloc_sysfs_attr(phba->shost))
> +               goto free_attr_mem;

See comment above on sysfs attributes on scsi hosts....


-- james s
