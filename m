From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] Add Marvell UMI driver
Date: Wed, 20 Apr 2011 18:55:18 +0200
Message-ID: <201104201855.20521.eike-kernel@sf-tec.de>
References: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Jianyun <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Li Jianyun wrote:

> +/**
> + * mvumi_init_data -	Initialize requested date for FW
> + * @mhba:			Adapter soft state
> + */
> +static int mvumi_init_data(struct mvumi_hba *mhba)
> +{
> +	struct mv_ob_data_pool *ob_pool;
> +	struct mvumi_res_mgnt *res_mgnt;
> +	unsigned int tmp_size, offset, i;
> +	void *virmem, *v;
> +	dma_addr_t p;
> +
> +	if (mhba->fw_flag & MVUMI_FW_ALLOC)
> +		return 0;
> +	tmp_size = 128 + mhba->ib_max_entry_size_bytes * mhba->max_io + 16
> +							+ sizeof(unsigned int);
> +	tmp_size += 8 + mhba->ob_max_entry_size_bytes * mhba->max_io + 4;
> +	res_mgnt = mvumi_alloc_mem_resource(mhba,
> +			RESOURCE_UNCACHED_MEMORY, tmp_size);
> +	if (!res_mgnt) {
> +		dev_printk(KERN_ERR, &mhba->pdev->dev,
> +			"failed to allocate memory for inbound list\n");
> +		goto fail_alloc_dma_buf;
> +	}
> +
> +	p = res_mgnt->bus_addr;
> +	v = res_mgnt->virt_addr;
> +	offset = (unsigned int)(round_up(res_mgnt->bus_addr, 128) -
> +							res_mgnt->bus_addr);
> +	p += offset;

p now has offset again, no? Is this intentional?

> +	v = (unsigned char *) v + offset;

I don't think you need the cast. The kernel relies on the gcc extension that 
"void* += n" moves up n bytes.

> +	mhba->ib_list = v;
> +	mhba->ib_list_phys = p;
> +
> +	v = (unsigned char *) v + mhba->ib_max_entry_size_bytes * mhba->max_io;
> +	p += mhba->ib_max_entry_size_bytes * mhba->max_io;
> +
> +	offset = (unsigned int)(round_up(p, 8) - p);
> +	p += offset;
> +	v = (unsigned char *) v + offset;
> +	mhba->ib_shadow = v;
> +	mhba->ib_shadow_phys = p;
> +
> +	p += sizeof(unsigned int);
> +	v = (unsigned char *) v + sizeof(unsigned int);
> +
> +	offset = round_up(p, 8) - p;
> +	p += offset;
> +	v = (unsigned char *) v + offset;
> +	mhba->ob_shadow = v;
> +	mhba->ob_shadow_phys = p;
> +	p += 8;
> +	v = (unsigned char *) v + 8;
> +	offset = (unsigned int) (round_up(p, 128) - p);

Sometimes you cast the result of round_up() to unsigned int and sometimes not. 
So I guess you just need to never cast. Since the result will be in range 
8..128 anyway I think the casting can just go away completely.

> +
> +	return 0;
> +}
> +/**

Newline missing here.

> + * mvumi_probe_one -	PCI hotplug entry point
> + * @pdev:		PCI device structure
> + * @id:			PCI ids of supported hotplugged adapter
> + */
> +static int __devinit mvumi_probe_one(struct pci_dev *pdev,
> +					const struct pci_device_id *id)
> +{
> +	int ret;
> +	struct Scsi_Host *host;
> +	struct mvumi_hba *mhba;
> +	unsigned short class_code = 0xFFFF;
> +
> +	pci_read_config_word(pdev, 0x0A,  &class_code);
> +	dev_printk(KERN_INFO, &pdev->dev,
> +			" %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
> +			pdev->vendor, pdev->device, pdev->subsystem_vendor,
> +			pdev->subsystem_device);
> +	dev_printk(KERN_INFO, &pdev->dev,
> +			"bus %d:slot %d:func %d:class_code:%#4.04x\n",
> +			pdev->bus->number, PCI_SLOT(pdev->devfn),
> +			PCI_FUNC(pdev->devfn), class_code);
> +
> +	ret = pci_enable_device(pdev);

You may want to use pcim_enable_device(). Look at Documentation/driver-
model/devres.txt. This would take care of some of your error handling for 
free.

> +	if (ret)
> +		return ret;
> +
> +	pci_set_master(pdev);
> +
> +	if (IS_DMA64) {
> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
> +			if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
> +				goto fail_set_dma_mask;
> +		}
> +	} else {
> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
> +			goto fail_set_dma_mask;
> +	}

I don't like that you lose the error code of pci_set_dma_mask() here.

> +	host = scsi_host_alloc(&mvumi_template, sizeof(struct mvumi_hba));
> +	if (!host) {
> +		dev_printk(KERN_ERR, &pdev->dev, "scsi_host_alloc failed\n");
> +		goto fail_alloc_instance;
> +	}
> +	mhba = (struct mvumi_hba *) host->hostdata;

mhba = shost_priv(host);

> +	memset(mhba, 0, sizeof(*mhba));
> +
> +	INIT_LIST_HEAD(&mhba->cmd_pool);
> +	INIT_LIST_HEAD(&mhba->ob_data_pool_list);
> +	INIT_LIST_HEAD(&mhba->free_ob_list);
> +	INIT_LIST_HEAD(&mhba->res_list);
> +	INIT_LIST_HEAD(&mhba->waiting_req_list);
> +	atomic_set(&mhba->fw_outstanding, 0);
> +
> +	init_waitqueue_head(&mhba->int_cmd_wait_q);
> +
> +	spin_lock_init(&mhba->cmd_pool_lock);
> +	spin_lock_init(&mhba->tag_lock);
> +
> +	mhba->pdev = pdev;
> +	mhba->shost = host;
> +	mhba->unique_id = pdev->bus->number << 8 | pdev->devfn;
> +
> +	if (mvumi_init_fw(mhba))
> +		goto fail_init_fw;

You are once again loosing an error code here.

> +	ret = request_irq(mhba->pdev->irq, mvumi_isr_handler, IRQF_SHARED,
> +				"mvumi", mhba);
> +	if (ret) {
> +		dev_printk(KERN_ERR, &pdev->dev, "failed to register IRQ\n");
> +		goto fail_init_irq;
> +	}
> +
> +	mhba->instancet->enable_intr(mhba->mmio);
> +	pci_set_drvdata(pdev, mhba);
> +
> +	if (mvumi_io_attach(mhba))
> +		goto fail_io_attach;
> +	dev_printk(KERN_INFO, &pdev->dev, "probe mvumi driver successfully.\n");
> +	return 0;

I don't know if the ordering is correct here. Once you have registered the IRQ 
handler you must be prepared to get interrupts. In fact with IRQ debugging 
enabled your IRQ handler will be called immediately in request_irq(). So when 
you set up other stuff here that is needed in the IRQ handler this can do all 
sort of things wrong.

> +fail_io_attach:
> +	pci_set_drvdata(pdev, NULL);
> +	mhba->instancet->disable_intr(mhba->mmio);
> +	free_irq(mhba->pdev->irq, mhba);
> +fail_init_irq:
> +	mvumi_release_fw(mhba);
> +fail_init_fw:
> +	scsi_host_put(host);
> +
> +fail_alloc_instance:
> +fail_set_dma_mask:
> +	pci_disable_device(pdev);
> +
> +	return -ENODEV;
> +}

You always lose the error codes of anything in your probe function. I don't 
think this is a good idea.

> +
> +static void mvumi_detach_one(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *host;
> +	struct mvumi_hba *mhba;
> +
> +	mhba = pci_get_drvdata(pdev);
> +	host = mhba->shost;
> +	scsi_remove_host(mhba->shost);
> +	mvumi_flush_cache(mhba);
> +
> +	mhba->instancet->disable_intr(mhba->mmio);
> +	free_irq(mhba->pdev->irq, mhba);

Same as above here: you may still get an IRQ until this point. So be careful 
with what you free first.

> +	mvumi_release_fw(mhba);
> +	scsi_host_put(host);
> +	pci_set_drvdata(pdev, NULL);
> +	pci_disable_device(pdev);
> +	dev_printk(KERN_INFO, &pdev->dev, "driver is removed!\n");
> +}

Greetings,

Eike
