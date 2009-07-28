From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Tue, 28 Jul 2009 22:12:01 +0200
Message-ID: <200907282212.14137.eike-kernel@sf-tec.de>
References: <20090728071251.GA13581@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart29045740.9qTpkAixma";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:60405 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZG1UM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 16:12:26 -0400
In-Reply-To: <20090728071251.GA13581@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

--nextPart29045740.9qTpkAixma
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jayamohan Kallickal wrote:
>   Thie file handles initiallization/teardown, allocation/free as well
>   as IO/Management flows.
> +struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
> +{
> +	struct beiscsi_hba *phba;

[...]

> +	phba =3D iscsi_host_priv(shost);
> +	memset(phba, 0x0, sizeof(struct beiscsi_hba *));

memset(phba, 0, sizeof(*phba));

> +}
> +
> +static int be_map_pci_bars(struct beiscsi_hba *phba, struct pci_dev *pde=
v)
> +{
> +	u8 __iomem *addr;
> +
> +	phba->csr_va =3D NULL;
> +	phba->db_va =3D NULL;
> +	phba->pci_va =3D NULL;
> +
> +	addr =3D ioremap_nocache(pci_resource_start(pdev, 2),
> +			       pci_resource_len(pdev, 2));
> +	if (addr =3D=3D NULL)
> +		return -ENOMEM;
> +	phba->ctrl.csr =3D addr;
> +	phba->csr_va =3D addr;
> +
> +	addr =3D ioremap_nocache(pci_resource_start(pdev, 4), 128 * 1024);
> +	if (addr =3D=3D NULL)
> +		goto pci_map_err;
> +	phba->ctrl.db =3D addr;
> +	phba->db_va =3D addr;
> +
> +	addr =3D ioremap_nocache(pci_resource_start(pdev, 1),
> +			       pci_resource_len(pdev, 1));
> +	if (addr =3D=3D NULL)
> +		goto pci_map_err;
> +	phba->ctrl.pcicfg =3D addr;
> +	phba->pci_va =3D addr;
> +
> +	return 0;
> +pci_map_err:
> +	beiscsi_unmap_pci_function(phba);
> +	return -ENOMEM;
> +}

This would be much simpler if you were using devres (see below).

> +int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
> +				const struct pci_device_id *id)
> +{
> +	struct beiscsi_hba *phba =3D NULL;
> +	int ret =3D -1;
> +
> +	ret =3D beiscsi_enable_pci(pcidev);
> +	if (ret < 0) {
> +		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
> +				"Failed to enable pci device \n");
> +		return ret;
> +	}
> +
> +	phba =3D beiscsi_hba_alloc(pcidev);
> +	if (!phba) {
> +		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
> +				" Failed in beiscsi_hba_alloc \n");
> +		goto disable_pci;
> +	}
> +
> +	pci_set_drvdata(pcidev, (void *)phba);

No need to cast to void* from any pointer type.

> +}
> +
> +
> +int beiscsi_init_irqs(struct beiscsi_hba *phba)
> +{
> +
> +	struct pci_dev *pcidev =3D phba->pcidev;

Extra newlines

> +	if (request_irq(pcidev->irq, be_isr, IRQF_SHARED, "beiscsi",
> +				phba) !=3D 0) {
> +		dev_err(&pcidev->dev,
> +				"beiscsi_init_irqs-"
> +					"Failed to register irq\\n");
> +		return -1;

You should forward the error code of request_irq() here.

> +	}
> +	return 0;
> +}

> +/*
> + * Function:
> + *         be_isr
> + *
> + * Parameter:
> + *         irq:    [in]    irq number
> + *         dev_id: [in]    context information
> + *         regs:   [in]    pointer to structure containing CPU registers
> + *
> + * Return:
> + *         None
> + *
> + * Context:
> + *         Interrupt
> + *
> + * Description:
> + *         This routine is the ISR of the driver. It calls be_process_irq
> to + *         handle the interrupts.
> + *
> + *
> + */

Please use prober kerneldoc here, see Documentation/kernel-doc-nano-HOWTO.t=
xt.

> +irqreturn_t be_isr(int irq, void *dev_id)
> +{
> +	struct beiscsi_hba *phba =3D NULL;
> +	struct hwi_controller_ws *phwi_controller;
> +	struct hwi_context_memory *phwi_context;
> +	struct be_eq_entry *eqe =3D NULL;
> +	struct be_queue_info *eq;
> +	unsigned long flags, index;
> +	unsigned int num_eq_processed;
> +
> +	phba =3D (struct beiscsi_hba *)dev_id;

No need to cast from void* to any pointer type.

> +	phwi_controller =3D GET_HWI_CONTROLLER_WS(phba);
> +	phwi_context =3D phwi_controller->phwic;
> +	spin_lock_irqsave(&phba->isr_lock, flags);
> +
> +	eq =3D &phwi_context->be_eq.q;
> +	index =3D 0;
> +	eqe =3D queue_tail_node(eq);
> +	if (!eqe)
> +		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
> +
> +	num_eq_processed =3D 0;
> +	while (eqe->
> +	       dw[offsetof(struct amap_eq_entry, valid) /
> +		  32] & EQE_VALID_MASK) {

The way you break lines here looks strange. I (personally) wouldn't break t=
he=20
[] but right after the &.

> +int beiscsi_init_pci_function(struct beiscsi_hba *phba, struct pci_dev
> *pcidev) +{
> +	u64 pa;
> +
> +	/* CSR */
> +	pa =3D pci_resource_start(pcidev, 2);
> +	phba->csr_pa.u.a64.address =3D pa;

Why don't you assign this directly?

> +	/* Door Bell */
> +	pa =3D pci_resource_start(pcidev, 4);
> +	phba->db_pa.u.a64.address =3D pa;
> +
> +	/* PCI */
> +	pa =3D pci_resource_start(pcidev, 1);
> +	phba->pci_pa.u.a64.address =3D pa;
> +	return 0;
> +}
> +
> +void beiscsi_unmap_pci_function(struct beiscsi_hba *phba)
> +{
> +	if (phba->csr_va) {
> +		iounmap(phba->csr_va);
> +		phba->csr_va =3D NULL;
> +	}
> +	if (phba->db_va) {
> +		iounmap(phba->db_va);
> +		phba->db_va =3D NULL;
> +	}
> +	if (phba->pci_va) {
> +		iounmap(phba->pci_va);
> +		phba->pci_va =3D NULL;
> +	}
> +	return;

No return at end of void function.

> +}
> +
> +

Extra newline

> +int beiscsi_enable_pci(struct pci_dev *pcidev)
> +{
> +

Extra newline

> +	if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
> +		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32))) {
> +			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
> +			return -ENODEV;
> +		}
> +	}

This should be after the pci_enable_device(). I don't find a strong reason =
for=20
this but that's at least what all others are doing.

> +	if (pci_enable_device(pcidev)) {
> +		dev_err(&pcidev->dev, "beiscsi_enable_pci - enable device "
> +			"failed. Returning -ENODEV\n");
> +		return -ENODEV;
> +	}

You may want to take a look on devres (Documentation/driver-model/devres.tx=
t)=20
which would track e.g. your PCI BAR mappings for you.

> +	return 0;
> +}
> +
> +/* initialization */
> +static struct beiscsi_conn *beiscsi_conn_frm_cid(struct beiscsi_hba *phb=
a,
> +					  unsigned int cid)
> +{
> +	if (phba->conn_table[cid]) {
> +		return phba->conn_table[cid];
> +	} else {
> +		dev_err(&phba->pcidev->dev, "Connection table empty\n");
> +		return NULL;
> +	}
> +}

You end up returning the value of phba->conn_table[cid] always (if it's NUL=
L=20
you return NULL). So this core can be simplified.

> +/* This happens under session_lock untill submission to chip */
                                           ^
l--

> +/* Under host lock */
> +static struct sgl_handle *alloc_eh_sgl_handle(struct beiscsi_hba *phba)
> +{
> +	struct sgl_handle *psgl_handle;
> +
> +	if (phba->eh_sgl_handles_available) {
> +		psgl_handle =3D
> +		    (struct sgl_handle *)phba->eh_sgl_handle_base[phba->
> +							 eh_sgl_alloc_index];

Another void*-cast. Save at least one line break here. There are more of th=
em,=20
I will not comment on them any more.

> +static struct async_pdu_handle *hwi_get_async_handle(struct beiscsi_hba
> *phba, +					struct beiscsi_conn *beiscsi_conn,
> +				struct hwi_async_pdu_context *pasync_ctx,
> +				      struct i_t_dpdu_cqe *pdpdu_cqe,
> +						unsigned int *pcq_index)
> +{
> +	struct be_bus_address phys_addr;
> +	struct list_head *pbusy_list, *plink;
> +	struct async_pdu_handle *pasync_handle =3D NULL;
> +	int buffer_len =3D 0;
> +	unsigned char buffer_index =3D -1;
> +	unsigned char is_header =3D 0;
> +
> +	/* This function is invoked to get the right async_handle structure
> +	 * from   a given default PDU CQ entry.
           ^^^

> +static unsigned int
> +hwi_flush_default_pdu_buffer(struct beiscsi_hba *phba,
> +			     struct beiscsi_conn *beiscsi_conn,
> +			     struct i_t_dpdu_cqe *pdpdu_cqe)
> +{

=2E..

> +	pasync_handle =3D
> +	    hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx, pdpdu_cqe,
> +				 &cq_index);
> +	WARN_ON(!pasync_handle);
> +
> +	if (pasync_handle->is_header =3D=3D 0) {

You will dereference the pointer even if it is NULL so you don't need the=20
WARN_ON() before as you would Oops here anyway.

> +
> +		/* If this entry is not yet consumed, then in addition to a
> +		 * completion, it also means that buffers upto the cq_index
> +		 * have been consumed.
> +		 * We can post fresh buffers back if there are atleast 8 free.
> +		 * If this entry is already consumed, then this is only a
> +		 * completion. It doesn't give us a chance to re-post any
> +		 * buffers
> +		 */
> +		if (pasync_handle->consumed =3D=3D 0) {
> +			hwi_update_async_writables(pasync_ctx,
> +						   pasync_handle->is_header,
> +						   cq_index);
> +		}
> +
> +		/* there will not be a consumer for this CQE. The connection's
> +		 * default PDU header and buffer should be simply dropped.
> +		 * So release the buffers
> +		 */
> +		hwi_free_async_msg(phba, pasync_handle->cri);
> +
> +		/* Attempt to post new entries back to the ring. Note that we
> +		 * call the routine to post irrespective of the consumed or
> +		 * completed-only status. This is because though a
> +		 * completed-only status does not update the writables, it does
> +		 * free up some buffers which could  mean that we can post.
> +		 * (Look in hwi_post_async_buffers for more info on posting
> +		 * rules!)
> +		 */
> +		hwi_post_async_buffers(phba, pasync_handle->is_header);
> +	} else {
> +		BUG();

This is also overcomplicated. Simply do:

BUG_ON(pasync_handle->is_header !=3D 0);
if (pasync_handle->consumed =3D=3D 0) {
=2E..

Saves one level of identation and a long trip to the else branch.

> +static unsigned int
> +hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
> +		  struct beiscsi_hba *phba,
> +		  struct hwi_async_pdu_context *pasync_ctx, unsigned short cri)
> +{
> +	struct list_head *plink;
> +	struct async_pdu_handle *pasync_handle;
> +	void *phdr =3D NULL;
> +	unsigned int hdr_len =3D 0, buf_len =3D 0;
> +	unsigned int status, index =3D 0, offset =3D 0;
> +
> +	void *pfirst_buffer =3D NULL;
> +	unsigned int num_buf =3D 0;
> +
> +	plink =3D pasync_ctx->async_entry[cri].wait_queue.list.next;
> +
> +	while ((plink !=3D &pasync_ctx->async_entry[cri].wait_queue.list)) {

Duplicate ()

> +		pasync_handle =3D list_entry(plink, struct async_pdu_handle,
> +					   link);
> +
> +		WARN_ON(!pasync_handle);

Unneeded again.

> +static unsigned int
> +hwi_gather_async_pdu(struct beiscsi_conn *beiscsi_conn,
> +		     struct beiscsi_hba *phba,
> +		     struct async_pdu_handle *pasync_handle)
> +{
> +
> +	struct hwi_async_pdu_context *pasync_ctx;
> +	struct hwi_controller_ws *phwi;
> +	unsigned int bytes_needed =3D 0, status =3D 0;
> +	unsigned short cri =3D pasync_handle->cri;
> +	struct pdu_base *ppdu;
> +
> +	phwi =3D GET_HWI_CONTROLLER_WS(phba);
> +
> +	pasync_ctx =3D HWI_GET_ASYNC_PDU_CTX(phwi);
> +
> +	/* remove the element from the busylist and insert into the waitlist */
> +	list_del(&pasync_handle->link);
> +	if (pasync_handle->is_header) {
> +		pasync_ctx->async_header.busy_entries--;
> +
> +		/* if there is an already stored header, then evict that header
> +		 * and store this one. Only 1 header can be queued currently.
> +		 * It should be ok since the only non-erroroneous case where we
> +		 * could see 2 headers is when an offload is in progress.
> +		 * */
> +		if (pasync_ctx->async_entry[cri].wait_queue.hdr_received) {
> +			BUG();
> +			hwi_free_async_msg(phba, cri);

You wont come back from BUG().

> +static int beiscsi_get_memory(struct beiscsi_hba *phba)
> +{
> +	int ret;
> +	beiscsi_find_mem_req(phba);
> +	ret =3D beiscsi_alloc_mem(phba);
> +	if (0 !=3D ret)
> +		return ret;
> +	return 0;
> +}

{
	beiscsi_find_mem_req(phba);
	return beiscsi_alloc_mem(phba);
}

> +static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
> +{
> +
> +	struct be_mem_descriptor *mem_descr_wrbh, *mem_descr_wrb;
> +	struct wrb_handle *pwrb_handle;
> +	struct hwi_controller_ws *phwi;
> +	struct hwi_wrb_context *pwrb_context;
> +	struct iscsi_wrb *pwrb;
> +	unsigned short arr_index;
> +	unsigned int num_cxn_wrbh;
> +	/* The number of arrays of wrb_handles in this mem_array[i].size */
> +	unsigned int num_cxn_wrb, j, idx, index;
> +
> +	/* Initiallize IO Handle */
> +	mem_descr_wrbh =3D phba->init_mem;
> +	mem_descr_wrbh +=3D HWI_MEM_WRBH;
> +
> +	mem_descr_wrb =3D phba->init_mem;
> +	mem_descr_wrb +=3D HWI_MEM_WRB;
> +
> +	idx =3D 0;
> +	pwrb_handle =3D mem_descr_wrbh->mem_array[idx].virtual_address;
> +	num_cxn_wrbh =3D
> +	    ((mem_descr_wrbh->mem_array[idx].size) /
> +	     ((sizeof(struct wrb_handle)) * phba->params.wrbs_per_cxn));
> +	phwi =3D phba->phwi_ws;
> +
> +	for (index =3D 0; index < phba->params.cxns_per_ctrl * 2; index +=3D 2)=
 {
> +		arr_index =3D 0;
> +		pwrb_context =3D &phwi->wrb_context[index];
> +		SE_DEBUG(DBG_LVL_8, "cid=3D%d pwrb_context=3D%p \n", index,
> +			 pwrb_context);
> +		pwrb_context->pwrb_handle_base =3D
> +		    kmalloc(sizeof(struct wrb_handle *) *
> +			    phba->params.wrbs_per_cxn, GFP_KERNEL);
> +		pwrb_context->pwrb_handle_basestd =3D
> +		    kmalloc(sizeof(struct wrb_handle *) *
> +			    phba->params.wrbs_per_cxn, GFP_KERNEL);

kcalloc()

> +static int
> +beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
> +		struct hwi_context_memory *phwi_context,
> +		struct hwi_controller_ws *phwc)
> +{
> +	unsigned int wrb_mem_index, offset, size, num_wrb_rings;
> +	u64 pa_addr_lo;
> +	uint idx, num, i;
> +	struct mem_array *pwrb_arr;
> +	void *wrb_vaddr;
> +	struct be_dma_mem sgl;
> +	struct be_mem_descriptor *mem_descr;
> +	int status;
> +
> +	idx =3D 0;
> +	mem_descr =3D phba->init_mem;
> +	mem_descr +=3D HWI_MEM_WRB;
> +	pwrb_arr =3D kmalloc(sizeof(*pwrb_arr)
> +			* phba->params.cxns_per_ctrl, GFP_KERNEL);
> +	if (!pwrb_arr) {
> +		dev_err(&phba->pcidev->dev,
> +			"Memory alloc failed in create wrb ring.\n");
> +		return -1;

=2DENOMEM?

> +static void
> +be_complete_io(struct beiscsi_conn *beiscsi_conn,
> +	       struct iscsi_task *task, struct sol_cqe *psol)
> +{

=2E..

> +	if ((io_task->resp_len & 0xff000000)) {
> +		hdr->dlength[2] =3D (io_task->resp_len & 0xff000000) >> 24;
> +		hdr->dlength[1] =3D (io_task->resp_len & 0x00ff0000) >> 16;
> +		hdr->dlength[0] =3D (io_task->resp_len & 0x0000ff00) >> 8;
> +	} else if (io_task->resp_len & 0x00ff0000) {
> +		hdr->dlength[2] =3D 0x00;
> +		hdr->dlength[1] =3D (io_task->resp_len & 0x00ff0000) >> 16;
> +		hdr->dlength[0] =3D (io_task->resp_len & 0x0000ff00) >> 8;
> +	} else if (io_task->resp_len & 0x0000ff00) {
> +		hdr->dlength[2] =3D 0x00;
> +		hdr->dlength[1] =3D 0x00;
> +		hdr->dlength[0] =3D (io_task->resp_len & 0x0000ff00) >> 8;
> +	}

if (io_task->resp_len & 0xffffff00) {
 // first block
}

This should behave exactly the same.

Greetings,

Eike

--nextPart29045740.9qTpkAixma
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkpvW54ACgkQXKSJPmm5/E54GQCfYfoaCSh8+UeyBiJpep3D6Tf1
2xoAn1/5yKnN3zHjcGv7/6vfgnuTv9Kn
=IpS0
-----END PGP SIGNATURE-----

--nextPart29045740.9qTpkAixma--
