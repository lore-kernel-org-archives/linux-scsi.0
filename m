From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH v2] Add Marvell UMI driver
Date: Mon, 09 May 2011 23:23:51 +0200
Message-ID: <8883108.HpZuVnkiNA@donald.sf-tec.de>
References: <1304943577-2876-1-git-send-email-jianyunff@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart16736183.Cej9N2uDKn"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1304943577-2876-1-git-send-email-jianyunff@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianyun Li <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, Jianyun Li <jyli@marvell.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--nextPart16736183.Cej9N2uDKn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("jyli@marvell.com");
> +
> +
> +MODULE_DESCRIPTION("Marvell UMI Driver");
> +
> +

You have plenty of places where you have duplicate newlines or e.g. useless 
newlines before } like the end of mvumi_receive_ob_list_entry() or missing 
newlines between two functions. Please clean them up in the next round.


> +static unsigned char tag_is_empty(struct tag_stack *st)
> +{
> +	if (st->top == 0)
> +		return 1;
> +	else
> +		return 0;
> +}

The return value should be bool. But I don't think this function is worth it, 
I can only find one place where it is used at all.

> +static int mvumi_map_pci_addr(struct pci_dev *dev, void **addr_array)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_BASE_ADDRESS; i++) {
> +		if (pci_resource_flags(dev, i) & IORESOURCE_MEM) {
> +			addr_array[i] = pci_iomap(dev, i, 0);
> +			if (!addr_array[i]) {
> +				dev_err(&dev->dev, "failed to map IO mem\n");
> +				return -ENOMEM;
> +			}
> +		} else
> +			addr_array[i] = NULL;
> +
> +		dev_dbg(&dev->dev, "Bar %d : %p.\n", i, addr_array[i]);
> +	}
> +	return 0;
> +}

If this functiion fails you don't pci_iounmap() the regions you already got. 
Also it may be useful to print which BAR failed to map.

> +static void mvumi_unmap_pci_addr(struct pci_dev *dev, void **addr_array)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_BASE_ADDRESS; i++)
> +		if (pci_resource_flags(dev, i) & IORESOURCE_MEM)
> +			pci_iounmap(dev, addr_array[i]);
> +}
> +
> +static struct mvumi_res_mgnt *mvumi_alloc_mem_resource(struct mvumi_hba
> *mhba, +				enum resource_type type, unsigned int size)
> +{
> +	struct mvumi_res_mgnt *res_mgnt =
> +			kzalloc(sizeof(struct mvumi_res_mgnt), GFP_KERNEL);

sizeof(*res_mgnt)

So whenever you change the type you always get the right size. And it's 
shorter.

> +	if (!res_mgnt) {
> +		dev_err(&mhba->pdev->dev,
> +			"Failed to allocate memory for mod_res.\n");
> +		return NULL;
> +	}
> +
> +	switch (type) {
> +	case RESOURCE_CACHED_MEMORY:
> +		res_mgnt->virt_addr = kzalloc(size, GFP_KERNEL);
> +		if (!res_mgnt->virt_addr) {
> +			dev_err(&mhba->pdev->dev,
> +				"unable to allocate memory,size = %d.\n", size);
> +			kfree(res_mgnt);
> +			return NULL;
> +		}
> +		break;
> +
> +	case RESOURCE_UNCACHED_MEMORY:
> +		size = round_up(size, 8);
> +		res_mgnt->virt_addr = (void *) pci_alloc_consistent(mhba->pdev,
> +							size,
> +							&res_mgnt->bus_addr);

pci_alloc_consistent() already returns void*, no need to cast.

> +		if (!res_mgnt->virt_addr) {
> +			dev_err(&mhba->pdev->dev,
> +					"unable to allocate consistent mem,"
> +							"size = %d.\n", size);
> +			kfree(res_mgnt);
> +			return NULL;
> +		}
> +		memset(res_mgnt->virt_addr, 0, size);
> +		break;
> +
> +	default:
> +		dev_err(&mhba->pdev->dev, "resource type %d is unknown.\n",
> +									type);
> +		kfree(res_mgnt);
> +		return NULL;
> +	}
> +
> +	res_mgnt->type = type;
> +	res_mgnt->size = size;
> +	list_add_tail(&res_mgnt->res_entry, &mhba->res_list);

This will give you an error if you turn on list debugging because you did not 
properly initialize the list head. You should turn on all debugging options 
and run your driver for a while with them to see what comes up from those.

> +/**
> + * mvumi_make_sgl -	Prepares  SGL
> + * @mhba:		Adapter soft state
> + * @scmd:		SCSI command from the mid-layer
> + * @sgl_p:		SGL to be filled in
> + *
> + * If successful, this function returns the number of SG elements.
> Otherwise, + * it returnes -1.
> + */

>From what I see it will return 0 in case of error instead of -1. And the 
return value should probably be unsigned then since that is was sg_count is 
internally.

> +static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *scmd,
> +					void *sgl_p)
> +{
> +	struct scatterlist *sg;
> +	struct mv_sgl *m_sg = (struct mv_sgl *) sgl_p;
> +	unsigned int sg_count = 0, i;
> +	unsigned int len, sgnum = scsi_sg_count(scmd);
> +	dma_addr_t busaddr = 0;
> +
> +	if (sgnum) {
> +		sg = (struct scatterlist *) scsi_sglist(scmd);

No need to cast, scsi_sglist() already returns that type.

> +		sg_count = pci_map_sg(mhba->pdev, sg, sgnum,
> +				(int) scmd->sc_data_direction);
> +
> +		for (i = 0; i < sg_count; i++) {
> +			busaddr = sg_dma_address(&sg[i]);
> +			len = sg_dma_len(&sg[i]);
> +			m_sg->baseaddr_l = cpu_to_le32((unsigned int) busaddr);
> +			m_sg->baseaddr_h = cpu_to_le32((unsigned int)
> +						((busaddr >> 16) >> 16));

Use upper_32_bits() and lower_32_bits() here.

> +			m_sg->flags = 0;
> +			m_sg->size = cpu_to_le32(len);

Why the intermediate len variable? Because of line length?

> +			if ((i + 1) == sg_count)
> +				m_sg->flags |= SGD_EOT;
> +
> +			m_sg++;
> +		}
> +	} else {
> +		scmd->SCp.dma_handle = scsi_bufflen(scmd) ?
> +			pci_map_single(mhba->pdev, scsi_sglist(scmd),
> +				scsi_bufflen(scmd),
> +				(int) scmd->sc_data_direction)
> +			: 0;
> +		busaddr = scmd->SCp.dma_handle;
> +		m_sg->baseaddr_l = cpu_to_le32((unsigned int) busaddr);
> +		m_sg->baseaddr_h =
> +			cpu_to_le32((unsigned int) ((busaddr >> 16) >> 16));

upper/lower macros like above.

> +		m_sg->flags = SGD_EOT;
> +		m_sg->size = cpu_to_le32(scsi_bufflen(scmd));
> +		sg_count = 1;
> +	}
> +
> +	return sg_count;
> +}
> +
> +static int mvumi_internal_cmd_sgl(struct mvumi_hba *mhba, struct mvumi_cmd
> *cmd, +							unsigned int size)
> +{
> +	struct mv_sgl *m_sg;
> +	void *virt_addr;
> +	dma_addr_t phy_addr;
> +
> +	if (size) {

Why not simply "if (size == 0) return 0;" here? This would save one level of 
identation for the rest of the function.

> +		virt_addr = (void *) pci_alloc_consistent(mhba->pdev, size,
> +								&phy_addr);

cast.

> +		if (!virt_addr)
> +			return -1;
> +
> +		memset(virt_addr, 0, size);
> +
> +		m_sg = (struct mv_sgl *) &cmd->frame->payload[0];
> +		cmd->frame->sg_counts = 1;
> +		cmd->data_buf = virt_addr;
> +
> +		m_sg->baseaddr_l = cpu_to_le32(phy_addr);
> +		m_sg->baseaddr_h = cpu_to_le32((phy_addr >> 16) >> 16);

upper/lower_32_bits

> +		m_sg->flags = SGD_EOT;
> +		m_sg->size = cpu_to_le32(size);
> +	}
> +	return 0;
> +}
> +static struct mvumi_cmd *mvumi_create_internal_cmd(struct mvumi_hba *mhba,
> +				unsigned int buf_size)
> +{
> +	struct mvumi_cmd *cmd;
> +
> +	cmd = kzalloc(sizeof(struct mvumi_cmd), GFP_KERNEL);

sizeof(*cmd)

> +/**
> + * mvumi_alloc_cmds -	Allocates the command packets
> + * @mhba:		Adapter soft state
> + *
> + */
> +static int mvumi_alloc_cmds(struct mvumi_hba *mhba)
> +{
> +	int i, ret = 0;

No need for ret. On successful return it will always be 0, otherwise -ENOMEM. 
Just hardcode it at the two return statements.

> +	struct mvumi_cmd *cmd;
> +
> +

Extra newline

> +	for (i = 0; i < mhba->max_io; i++) {
> +		cmd = kzalloc(sizeof(struct mvumi_cmd), GFP_KERNEL);

sizeof(*cmd);

> +static void mvumi_send_ib_list_entry(struct mvumi_hba *mhba)
> +{
> +	iowrite32(0xfff, mhba->ib_shadow);
> +	iowrite32(mhba->ib_cur_slot, mhba->mmio + CLA_INB_WRITE_POINTER);
> +}
> +static char mvumi_check_ob_frame(struct mvumi_hba *mhba,
> +		unsigned int cur_obf, struct mvumi_rsp_frame *p_outb_frame)
> +{
> +	unsigned short tag, request_id;
> +
> +	udelay(1);
> +	p_outb_frame = (struct mvumi_rsp_frame *)
> +			((unsigned char *) mhba->ob_list +
> +				cur_obf * mhba->ob_max_entry_size_bytes);

ob_list is void* so you can simply add bytes to it. And you don't need to cast 
the result then as void* is compatible to any other pointer type.

> +static void mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
> +{
> +	unsigned int ob_write_reg, ob_write_shadow_reg;
> +	unsigned int cur_obf, assign_obf_end, i;
> +	struct mv_ob_data_pool *free_ob_pool;
> +	struct mvumi_rsp_frame *p_outb_frame;
> +	do {

insert newline before "do {" to add a break between declarations and code.

> +		ob_write_reg = ioread32(mhba->mmio + CLA_OUTB_COPY_POINTER);
> +		ob_write_shadow_reg = ioread32(mhba->ob_shadow);
> +	} while ((ob_write_reg & CL_SLOT_NUM_MASK) !=
> +					ob_write_shadow_reg);
> +
> +	cur_obf = mhba->ob_cur_slot & CL_SLOT_NUM_MASK;
> +	assign_obf_end = ob_write_reg & CL_SLOT_NUM_MASK;
> +
> +	if ((ob_write_reg & CL_POINTER_TOGGLE) !=
> +			(mhba->ob_cur_slot & CL_POINTER_TOGGLE)) {
> +		assign_obf_end += mhba->list_num_io;
> +
> +	}

Extra newline.

> +
> +	for (i = (assign_obf_end - cur_obf); i != 0; i--) {
> +

Again.

> +static unsigned char mvumi_check_handshake(struct mvumi_hba *mhba)
> +{
> +	void *regs = mhba->mmio;
> +	unsigned int tmp;
> +	unsigned long before;
> +
> +	dev_dbg(&mhba->pdev->dev, "Waiting for firmware ready...\n");
> +
> +	before = jiffies;
> +	tmp = ioread32(regs + CPU_ARM_TO_PCIEA_MSG1);
> +	while ((tmp != HANDSHAKE_READYSTATE) && (tmp != HANDSHAKE_DONESTATE)) {
> +		if (tmp != HANDSHAKE_READYSTATE)
> +			iowrite32(DRBL_MU_RESET,
> +					regs + CPU_PCIEA_TO_ARM_DRBL_REG);
> +		if (time_after(jiffies, before + FW_MAX_DELAY * HZ)) {
> +			dev_err(&mhba->pdev->dev,
> +				"invalid handshake signature 0x%x\n", tmp);
> +			return -1;
> +		}
> +		usleep_range(1000, 2000);
> +		rmb();
> +		tmp = ioread32(regs + CPU_ARM_TO_PCIEA_MSG1);
> +	}
> +	dev_dbg(&mhba->pdev->dev, "Handshake signature = 0x%x.\n",
> +					ioread32(regs + CPU_ARM_TO_PCIEA_MSG1));
> +
> +	mhba->fw_state = FW_STATE_STARTING;
> +	dev_dbg(&mhba->pdev->dev, "start firmware handshake.\n");
> +	while (1) {

do {

> +		if (mvumi_handshake_event(mhba)) {
> +			dev_err(&mhba->pdev->dev,
> +				"start firmware failed at state 0x%x.\n",
> +				  mhba->fw_state);
> +			return -1;
> +		}
> +
> +		if (mhba->fw_state == FW_STATE_STARTED)
> +			break;
> +	}

} while (mhba->fw_state != FW_STATE_STARTED);

> +static int __devinit mvumi_probe_one(struct pci_dev *pdev,
> +					const struct pci_device_id *id)
> +{
> +	struct Scsi_Host *host;
> +	struct mvumi_hba *mhba;
> +	int ret;
> +
> +	dev_dbg(&pdev->dev, " %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
> +			pdev->vendor, pdev->device, pdev->subsystem_vendor,
> +			pdev->subsystem_device);
> +	dev_dbg(&pdev->dev, "bus %d:slot %d:func %d:class_code:%#4.04x\n",
> +			pdev->bus->number, PCI_SLOT(pdev->devfn),
> +			PCI_FUNC(pdev->devfn), pdev->class >> 8);

The PCI-device itself already should print bus/slot/function, no?

> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_set_master(pdev);
> +
> +	if (IS_DMA64) {
> +		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +		if (ret) {
> +			ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +			if (ret)
> +				goto fail_set_dma_mask;
> +		}
> +	} else {
> +		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (ret)
> +			goto fail_set_dma_mask;
> +	}
> +
> +	host = scsi_host_alloc(&mvumi_template, sizeof(struct mvumi_hba));
> +	if (!host) {
> +		dev_err(&pdev->dev, "scsi_host_alloc failed\n");
> +		ret = -ENOMEM;
> +		goto fail_alloc_instance;
> +	}
> +	mhba = shost_priv(host);
> +
> +	INIT_LIST_HEAD(&mhba->cmd_pool);
> +	INIT_LIST_HEAD(&mhba->ob_data_pool_list);
> +	INIT_LIST_HEAD(&mhba->free_ob_list);
> +	INIT_LIST_HEAD(&mhba->res_list);
> +	INIT_LIST_HEAD(&mhba->waiting_req_list);
> +	atomic_set(&mhba->fw_outstanding, 0);
> +	init_waitqueue_head(&mhba->int_cmd_wait_q);
> +
> +	mhba->pdev = pdev;
> +	mhba->shost = host;
> +	mhba->unique_id = pdev->bus->number << 8 | pdev->devfn;
> +
> +	ret = mvumi_init_fw(mhba);
> +	if (ret)
> +		goto fail_init_fw;
> +
> +	mhba->instancet->enable_intr(mhba->mmio);
> +	ret = request_irq(mhba->pdev->irq, mvumi_isr_handler, IRQF_SHARED,
> +				"mvumi", mhba);

You enable the IRQs before registering the handler. What happens if the device 
immediately fires an IRQ? Or registering the handler fails? I think you better 
register the handler first and then activate the IRQs. Same on resume.

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 4e2c915..2a72ed8 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1569,10 +1569,12 @@
>  #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334
> 
>  #define PCI_VENDOR_ID_MARVELL		0x11ab
> +#define PCI_VENDOR_ID_MARVELL_2		0x1b4b
>  #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
>  #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
>  #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
>  #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
> +#define PCI_DEVICE_ID_MARVELL_MV9143	0x9143
>  #define PCI_DEVICE_ID_MARVELL_88ALP01_NAND	0x4100
>  #define PCI_DEVICE_ID_MARVELL_88ALP01_SD	0x4101
>  #define PCI_DEVICE_ID_MARVELL_88ALP01_CCIC	0x4102

If you only use the device id in your driver then don't put it here, but use 
it only in your driver.

HTH

Eike
--nextPart16736183.Cej9N2uDKn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3IW24ACgkQXKSJPmm5/E4L2ACgmHkcFrgqnz3IwMyU6vZ0lyXN
UL0AoJaXCSqClwH3jEpltdHltM/F52pg
=tmkv
-----END PGP SIGNATURE-----

--nextPart16736183.Cej9N2uDKn--
