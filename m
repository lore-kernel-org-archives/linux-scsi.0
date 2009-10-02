From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
Date: Fri, 2 Oct 2009 22:23:22 +0200
Message-ID: <200910022223.27638.eike-kernel@sf-tec.de>
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1293297.bKGqVYPrRg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:49881 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998AbZJBUXc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2009 16:23:32 -0400
In-Reply-To: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com

--nextPart1293297.bKGqVYPrRg
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Stephen M. Cameron wrote:

> +static const char *raid_label[] =3D { "0", "4", "1(1+0)", "5", "5+1", "A=
DG",
> +	"UNKNOWN"
> +};
> +#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0]) - 1)

(ARRAY_SIZE(raid_label) - 1)

> +
> +static ssize_t raid_level_show(struct device *dev,
> +	     struct device_attribute *attr, char *buf)
> +{
> +	ssize_t l =3D 0;
> +	int rlevel;
> +	struct ctlr_info *h;
> +	struct scsi_device *sdev;
> +	struct hpsa_scsi_dev_t *hdev;
> +	unsigned long flags;
> +
> +	sdev =3D to_scsi_device(dev);
> +	h =3D (struct ctlr_info *) sdev->host->hostdata[0];
> +	spin_lock_irqsave(&h->lock, flags);
> +	hdev =3D sdev->hostdata;
> +	if (!hdev) {
> +		spin_unlock_irqrestore(&h->lock, flags);
> +		return -ENODEV;
> +	}
> +
> +	/* Is this even a logical drive? */
> +	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
> +		spin_unlock_irqrestore(&h->lock, flags);
> +		l =3D snprintf(buf, PAGE_SIZE, "N/A\n");
> +		return l;
> +	}
> +
> +	rlevel =3D hdev->raid_level;
> +	spin_unlock_irqrestore(&h->lock, flags);
> +	if (rlevel < 0 || rlevel > RAID_UNKNOWN)
> +		rlevel =3D RAID_UNKNOWN;

How about making raid_level an unsigned int, the check for less than zero=20
could go away then.

> +/* Remove an entry from h->dev[] array. */
> +static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int
>  entry, +	struct hpsa_scsi_dev_t *removed[], int *nremoved)
> +{
> +	/* assumes h->devlock is held */
> +	int i;
> +	struct hpsa_scsi_dev_t *sd;
> +
> +	if (entry < 0 || entry >=3D HPSA_MAX_SCSI_DEVS_PER_HBA)
> +		BUG();

BUG_ON(entry < 0 || entry >=3D HPSA_MAX_SCSI_DEVS_PER_HBA);

> +static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> +	struct hpsa_scsi_dev_t *sd[], int nsds)
> +{
> +	/* sd contains scsi3 addresses and devtypes, and inquiry
> +	 * data.  This function takes what's in sd to be the current
> +	 * reality and updates h->dev[] to reflect that reality.
> +	 */
> +	int i, entry, device_change, changes =3D 0;
> +	struct hpsa_scsi_dev_t *csd;
> +	unsigned long flags;
> +	struct hpsa_scsi_dev_t **added, **removed;
> +	int nadded, nremoved;
> +	struct Scsi_Host *sh =3D NULL;
> +
> +	added =3D kzalloc(sizeof(*added) * HPSA_MAX_SCSI_DEVS_PER_HBA,
> +		GFP_KERNEL);
> +	removed =3D kzalloc(sizeof(*removed) * HPSA_MAX_SCSI_DEVS_PER_HBA,
> +		GFP_KERNEL);

kcalloc()

> +	if (!added || !removed) {
> +		dev_warn(&h->pdev->dev, "out of memory in "
> +			"adjust_hpsa_scsi_table\n");
> +		goto free_and_out;
> +	}

You should better return ENOMEM instead of 0 now. On the other hand the onl=
y=20
caller of this function does not check the return value anyway so this=20
function could also be void.

> +static void hpsa_slave_destroy(struct scsi_device *sdev)
> +{
> +	return; /* nothing to do. */
> +}
> +
> +static void hpsa_scsi_setup(struct ctlr_info *h)
> +{
> +	h->ndevices =3D 0;
> +	h->scsi_host =3D NULL;
> +	spin_lock_init(&h->devlock);
> +	return;
> +}

Those return statements are completely superfluous.

> +static int hpsa_scsi_detect(struct ctlr_info *h)
> +{
> +	struct Scsi_Host *sh;
> +	int error;
> +
> +	sh =3D scsi_host_alloc(&hpsa_driver_template, sizeof(*h));
> +	if (sh =3D=3D NULL)
> +		goto fail;
> +
> +	sh->io_port =3D 0;
> +	sh->n_io_port =3D 0;
> +	sh->this_id =3D -1;
> +	sh->max_channel =3D 3;
> +	sh->max_cmd_len =3D MAX_COMMAND_SIZE;
> +	sh->max_lun =3D HPSA_MAX_LUN;
> +	sh->max_id =3D HPSA_MAX_LUN;
> +	h->scsi_host =3D sh;
> +	sh->hostdata[0] =3D (unsigned long) h;
> +	sh->irq =3D h->intr[SIMPLE_MODE_INT];
> +	sh->unique_id =3D sh->irq;
> +	error =3D scsi_add_host(sh, &h->pdev->dev);
> +	if (error)
> +		goto fail_host_put;
> +	scsi_scan_host(sh);
> +	return 0;
> +
> + fail_host_put:
> +	dev_err(&h->pdev->dev, "hpsa_scsi_detect: scsi_add_host"
> +		" failed for controller %d\n", h->ctlr);
> +	scsi_host_put(sh);
> +	return -1;
> + fail:
> +	dev_err(&h->pdev->dev, "hpsa_scsi_detect: scsi_host_alloc"
> +		" failed for controller %d\n", h->ctlr);
> +	return -1;
> +}

You should forward the error code of scsi_add_host() here and return ENOMEM=
 if=20
scsi_host_alloc() failed, that would make debugging probably easier.

> +static void hpsa_unmap_one(struct pci_dev *pdev,
> +		struct CommandList *cp,
> +		size_t buflen,
> +		int data_direction)
> +{
> +	union u64bit addr64;
> +
> +	addr64.val32.lower =3D cp->SG[0].Addr.lower;
> +	addr64.val32.upper =3D cp->SG[0].Addr.upper;
> +	pci_unmap_single(pdev, (dma_addr_t) addr64.val,
> +		buflen, data_direction);
> +}
> +
> +static void hpsa_map_one(struct pci_dev *pdev,
> +		struct CommandList *cp,
> +		unsigned char *buf,
> +		size_t buflen,
> +		int data_direction)
> +{
> +	__u64 addr64;
> +
> +	if (buflen =3D=3D 0 || data_direction =3D=3D PCI_DMA_NONE) {
> +		cp->Header.SGList =3D 0;
> +		cp->Header.SGTotal =3D 0;
> +		return;
> +	}
> +
> +	addr64 =3D (__u64) pci_map_single(pdev, buf, buflen, data_direction);
> +	cp->SG[0].Addr.lower =3D
> +	  (__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
> +	cp->SG[0].Addr.upper =3D
> +	  (__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);

You want to use upper_32_bits() and lower_32_bits() from linux/kernel.h, I'=
m=20
sure. ;)

> +static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char
>  *scsi3addr, +			unsigned char page, unsigned char *buf,
> +			unsigned char bufsize)
> +{
> +	int rc;
> +	struct CommandList *c;
> +	struct ErrorInfo *ei;
> +
> +	c =3D cmd_special_alloc(h);
> +
> +	if (c =3D=3D NULL) {			/* trouble... */
> +		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
> +		return -1;
> +	}

=2DENOMEM

> +	rc =3D fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr,
> +		TYPE_CMD);
> +	if (rc =3D=3D 0) {
> +		hpsa_scsi_do_simple_cmd_core(h, c);
> +		hpsa_unmap_one(h->pdev, c, bufsize, PCI_DMA_FROMDEVICE);
> +
> +		ei =3D c->err_info;
> +		if (ei->CommandStatus !=3D 0 &&
> +		    ei->CommandStatus !=3D CMD_DATA_UNDERRUN) {
> +			hpsa_scsi_interpret_error(c);
> +			rc =3D -1;

=2DEINVAL or whatever

> +		}
> +	}
> +	cmd_special_free(h, c);
> +	return rc;
> +}
> +
> +static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
> +{
> +	int rc;
> +	struct CommandList *c;
> +	struct ErrorInfo *ei;
> +
> +	c =3D cmd_special_alloc(h);
> +
> +	if (c =3D=3D NULL) {			/* trouble... */
> +		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
> +		return -1;
> +	}

=2DENOMEM

> +	rc =3D fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr,
> +		TYPE_MSG);
> +	if (rc !=3D 0)
> +		goto out;
> +
> +	hpsa_scsi_do_simple_cmd_core(h, c);
> +	/* no unmap needed here because no data xfer. */
> +
> +	ei =3D c->err_info;
> +	if (ei->CommandStatus !=3D 0) {
> +		hpsa_scsi_interpret_error(c);
> +		rc =3D -1;
> +	}

=2DEINVAL

More of those follows.


> +static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
> +		struct ReportLUNdata *buf, int bufsize,
> +		int extended_response)
> +{
> +	int rc;
> +	struct CommandList *c;
> +	unsigned char scsi3addr[8];
> +	struct ErrorInfo *ei;
> +
> +	c =3D cmd_special_alloc(h);
> +	if (c =3D=3D NULL) {			/* trouble... */
> +		dev_err(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
> +		return -1;
> +	}
> +
> +	memset(&scsi3addr[0], 0, 8); /* address the controller */

memset(scsi3addr, 0, sizeof(scsi3addr));

> +static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
> +		struct ReportLUNdata *buf,
> +		int bufsize, int extended_response)
> +{
> +	return hpsa_scsi_do_report_luns(h, 0, buf, bufsize, extended_response);
> +}
> +
> +static inline int hpsa_scsi_do_report_log_luns(struct ctlr_info *h,
> +		struct ReportLUNdata *buf, int bufsize)
> +{
> +	return hpsa_scsi_do_report_luns(h, 1, buf, bufsize, 0);
> +}

Given that these two functions are both absolutely trivial and only called=
=20
from one place each they should be open coded there.

> +static int hpsa_update_device_info(struct ctlr_info *h,
> +	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device)
> +{
> +#define OBDR_TAPE_INQ_SIZE 49
> +	unsigned char *inq_buff =3D NULL;

No need to initialize as you overwrite that anyway.

> +	inq_buff =3D kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
> +	if (!inq_buff)
> +		goto bail_out;
> +
> +	memset(inq_buff, 0, OBDR_TAPE_INQ_SIZE);

kzalloc()

> +	/* Do an inquiry to the device to see what it is. */
> +	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
> +		(unsigned char) OBDR_TAPE_INQ_SIZE) !=3D 0) {
> +		/* Inquiry failed (msg printed already) */
> +		dev_err(&h->pdev->dev,
> +			"hpsa_update_device_info: inquiry failed\n");
> +		goto bail_out;
> +	}
> +
> +	/* As a side effect, record the firmware version number
> +	 * if we happen to be talking to the RAID controller.
> +	 */
> +	if (is_hba_lunid(scsi3addr))
> +		memcpy(h->firm_ver, &inq_buff[32], 4);

I've not looked into the details but you might need le32_to_cpu() or someth=
ing=20
here.

> +static int is_msa2xxx(struct ctlr_info *h, struct hpsa_scsi_dev_t *devic=
e)
> +{
> +	int i;
> +
> +	for (i =3D 0; msa2xxx_model[i]; i++)
> +		if (strncmp(device->model, msa2xxx_model[i],
> +			strlen(msa2xxx_model[i])) =3D=3D 0)
> +			return 1;
> +	return 0;
> +}

This could probably be bool instead of int.

> +static void figure_bus_target_lun(struct ctlr_info *h,
> +	__u8 *lunaddrbytes, int *bus, int *target, int *lun,
> +	struct hpsa_scsi_dev_t *device)
> +{
> +

Extra newline.

> +	__u32 lunid;
> +
> +	if (is_logical_dev_addr_mode(lunaddrbytes)) {
> +		/* logical device */
> +		memcpy(&lunid, lunaddrbytes, sizeof(lunid));
> +		lunid =3D le32_to_cpu(lunid);

Why not "lunid =3D le32_to_cpu(*((__le32 *)lunaddrbytes))"

> +static int hpsa_gather_lun_info(struct ctlr_info *h,
> +	int reportlunsize,
> +	struct ReportLUNdata *physdev, __u32 *nphysicals,
> +	struct ReportLUNdata *logdev, __u32 *nlogicals)
> +{
> +	if (hpsa_scsi_do_report_phys_luns(h, physdev, reportlunsize, 0)) {
> +		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
> +		return -1;
> +	}
> +	memcpy(nphysicals, &physdev->LUNListLength[0], sizeof(*nphysicals));
> +	*nphysicals =3D be32_to_cpu(*nphysicals) / 8;

*nphysicals =3D be32_to_cpu(*((__be32 *)physdev->LUNListLength)) / 8;

There are also some more of these will I will not mark all by themself.

> +#ifdef DEBUG
> +	dev_info(&h->pdev->dev, "number of physical luns is %d\n", *nphysicals);
> +#endif

dev_dbg(...), some more times, too.

> +static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
> +{
[...]
> +out:
> +	kfree(tmpdevice);
> +	for (i =3D 0; i < ndev_allocated; i++)
> +		kfree(currentsd[i]);
> +	kfree(currentsd);
> +	kfree(inq_buff);
> +	kfree(physdev_list);
> +	kfree(logdev_list);
> +	return;
> +}

Superfluous return.

> +/* hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
> + * dma mapping  and fills in the scatter gather entries of the
> + * hpsa command, cp.
> + */
> +static int hpsa_scatter_gather(struct pci_dev *pdev,
> +		struct CommandList *cp,
> +		struct scsi_cmnd *cmd)
> +{
> +	unsigned int len;
> +	struct scatterlist *sg;
> +	__u64 addr64;
> +	int use_sg, i;
> +
> +	BUG_ON(scsi_sg_count(cmd) > MAXSGENTRIES);
> +
> +	use_sg =3D scsi_dma_map(cmd);
> +	if (use_sg < 0)
> +		return use_sg;
> +
> +	if (!use_sg)
> +		goto sglist_finished;
> +
> +	scsi_for_each_sg(cmd, sg, use_sg, i) {
> +		addr64 =3D (__u64) sg_dma_address(sg);
> +		len  =3D sg_dma_len(sg);
> +		cp->SG[i].Addr.lower =3D
> +			(__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
> +		cp->SG[i].Addr.upper =3D
> +			(__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);

upper_32_bits/lower_32_bits

> +static int wait_for_device_to_become_ready(struct ctlr_info *h,
> +	unsigned char lunaddr[])
> +{
> +	int rc;
> +	int count =3D 0;
> +	int waittime =3D HZ;
> +	struct CommandList *c;
> +
> +	c =3D cmd_special_alloc(h);
> +	if (!c) {
> +		dev_warn(&h->pdev->dev, "out of memory in "
> +			"wait_for_device_to_become_ready.\n");
> +		return IO_ERROR;
> +	}
> +
> +	/* Send test unit ready until device ready, or give up. */
> +	while (count < HPSA_TUR_RETRY_LIMIT) {
> +
> +		/* Wait for a bit.  do this first, because if we send
> +		 * the TUR right away, the reset will just abort it.
> +		 */
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule_timeout(waittime);
> +		count++;
> +
> +		/* Increase wait time with each try, up to a point. */
> +		if (waittime < (HZ * HPSA_MAX_WAIT_INTERVAL_SECS))
> +			waittime =3D waittime * 2;
> +
> +		/* Send the Test Unit Ready */
> +		rc =3D fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0,
> +			lunaddr, TYPE_CMD);
> +		if (rc !=3D 0) {
> +			/* We don't expect to get in here */
> +			dev_warn(&h->pdev->dev, "fill_cmd failed at %s:%d\n",
> +				__FILE__, __LINE__);
> +			break;
> +		}

Maybe __func__ is more informative.

> +#ifdef CONFIG_COMPAT
> +
> +static int do_ioctl(struct scsi_device *dev, int cmd, void *arg)
> +{
> +	int ret;
> +
> +	lock_kernel();
> +	ret =3D hpsa_ioctl(dev, cmd, arg);
> +	unlock_kernel();
> +	return ret;
> +}

Are you sure you really need the BKL? I don't think new code that relies on=
=20
that is a good idea anyway.


> +static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void
>  *arg) +{
> +	IOCTL32_Command_struct __user *arg32 =3D
> +	    (IOCTL32_Command_struct __user *) arg;
> +	IOCTL_Command_struct arg64;
> +	IOCTL_Command_struct __user *p =3D compat_alloc_user_space(sizeof(arg64=
));
> +	int err;
> +	u32 cp;
> +
> +	err =3D 0;
> +	err |=3D copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
> +			   sizeof(arg64.LUN_info));
> +	err |=3D copy_from_user(&arg64.Request, &arg32->Request,
> +			   sizeof(arg64.Request));
> +	err |=3D copy_from_user(&arg64.error_info, &arg32->error_info,
> +			   sizeof(arg64.error_info));
> +	err |=3D get_user(arg64.buf_size, &arg32->buf_size);
> +	err |=3D get_user(cp, &arg32->buf);
> +	arg64.buf =3D compat_ptr(cp);
> +	err |=3D copy_to_user(p, &arg64, sizeof(arg64));
> +
> +	if (err)
> +		return -EFAULT;
> +
> +	err =3D do_ioctl(dev, CCISS_PASSTHRU, (void *)p);
> +	if (err)
> +		return err;
> +	err |=3D copy_in_user(&arg32->error_info, &p->error_info,
> +			 sizeof(arg32->error_info));
> +	if (err)
> +		return -EFAULT;
> +	return err;
> +}

return 0;

> +static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *arg=
p)
> +{
> +	BIG_IOCTL_Command_struct *ioc;
> +	struct CommandList *c;
> +	unsigned char **buff =3D NULL;
> +	int *buff_size =3D NULL;
> +	union u64bit temp64;
> +	BYTE sg_used =3D 0;
> +	int status =3D 0;
> +	int i;
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	__u32 left;
> +	__u32 sz;
> +	BYTE __user *data_ptr;
> +
> +	if (!argp)
> +		return -EINVAL;
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +	ioc =3D (BIG_IOCTL_Command_struct *)
> +	    kmalloc(sizeof(*ioc), GFP_KERNEL);
> +	if (!ioc) {
> +		status =3D -ENOMEM;
> +		goto cleanup1;
> +	}
> +	if (copy_from_user(ioc, argp, sizeof(*ioc))) {
> +		status =3D -EFAULT;
> +		goto cleanup1;
> +	}
> +	if ((ioc->buf_size < 1) &&
> +	    (ioc->Request.Type.Direction !=3D XFER_NONE)) {
> +		status =3D -EINVAL;
> +		goto cleanup1;
> +	}
> +	/* Check kmalloc limits  using all SGs */
> +	if (ioc->malloc_size > MAX_KMALLOC_SIZE) {
> +		status =3D -EINVAL;
> +		goto cleanup1;
> +	}
> +	if (ioc->buf_size > ioc->malloc_size * MAXSGENTRIES) {
> +		status =3D -EINVAL;
> +		goto cleanup1;
> +	}
> +	buff =3D kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);

kcalloc()?


> +/*
> + * Map (physical) PCI mem into (virtual) kernel space
> + */
> +static void __iomem *remap_pci_mem(ulong base, ulong size)
> +{
> +	ulong page_base =3D ((ulong) base) & PAGE_MASK;
> +	ulong page_offs =3D ((ulong) base) - page_base;
> +	void __iomem *page_remapped =3D ioremap(page_base, page_offs + size);
> +
> +	return page_remapped ? (page_remapped + page_offs) : NULL;
> +}

You should simply use pci_iomap() and remove this one entirely.


> +static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
> +{
> +	ushort subsystem_vendor_id, subsystem_device_id, command;
> +	__u32 board_id, scratchpad =3D 0;
> +	__u64 cfg_offset;
> +	__u32 cfg_base_addr;
> +	__u64 cfg_base_addr_index;
> +	int i, prod_index, err;
> +
> +	subsystem_vendor_id =3D pdev->subsystem_vendor;
> +	subsystem_device_id =3D pdev->subsystem_device;
> +	board_id =3D (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
> +		    subsystem_vendor_id);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(products); i++)
> +		if (board_id =3D=3D products[i].board_id)
> +			break;
> +
> +	prod_index =3D i;
> +
> +	if (prod_index =3D=3D ARRAY_SIZE(products)) {
> +		prod_index--;
> +		if (subsystem_vendor_id =3D=3D !PCI_VENDOR_ID_HP ||
> +				!hpsa_allow_any) {
> +			dev_warn(&pdev->dev, "unrecognized board ID:"
> +				" 0x%08lx, ignoring.\n",
> +				(unsigned long) board_id);
> +			return -ENODEV;
> +		}
> +	}
> +	/* check to see if controller has been disabled
> +	 * BEFORE trying to enable it
> +	 */
> +	(void)pci_read_config_word(pdev, PCI_COMMAND, &command);
> +	if (!(command & 0x02)) {
> +		dev_warn(&pdev->dev, "controller appears to be disabled\n");
> +		return -ENODEV;
> +	}
> +
> +	err =3D pci_enable_device(pdev);
> +	if (err) {
> +		dev_warn(&pdev->dev, "unable to enable PCI device\n");
> +		return err;
> +	}

I usually suggest at this place to take a look at devres=20
(Documentation/driver-model/devres.txt) as that would make some resource=20
tracking much easier.

> +err_out_free_res:
> +	/*
> +	 * Deliberately omit pci_disable_device(): it does something nasty to
> +	 * Smart Array controllers that pci_enable_device does not undo
> +	 */
> +	pci_release_regions(pdev);
> +	return err;
> +}

That sounds interesting. Maybe the PCI folks would like to hear about that.

> +static unsigned long SA5_completed(struct ctlr_info *h)
> +{
> +	unsigned long register_value
> +		=3D readl(h->vaddr + SA5_REPLY_PORT_OFFSET);
> +
> +	if (register_value !=3D FIFO_EMPTY)
> +		h->commands_outstanding--;
> +
> +#ifdef HPSA_DEBUG
> +	if (register_value !=3D FIFO_EMPTY)
> +		printk(KERN_INFO "hpsa:  Read %lx back from board\n",
> +			register_value);
> +	else
> +		printk(KERN_INFO "hpsa:  FIFO Empty read\n");
> +#endif
> +
> +	return register_value;
> +}

I don't think all those stuff should be implemented in a header file.

> +struct vals32 {
> +	__u32   lower;
> +	__u32   upper;
> +};
> +
> +union u64bit {
> +	struct vals32 val32;
> +	__u64 val;
> +};

There are helpers to access both 32 bit halves of a 64 bit value and other=
=20
nice things. Do you really need those struct things?


> +/* The size of this structure needs to be divisible by 8
> + * od on all architectures, because the controller uses 2
      ^^
??

Greetings,

Eike

--nextPart1293297.bKGqVYPrRg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrGYT8ACgkQXKSJPmm5/E57fQCbBQzdhTJ7KQ4AYDjN/g4O7i6D
AXYAn3BS3tWhgvkh1y39XuWXu8AXhcLZ
=S54h
-----END PGP SIGNATURE-----

--nextPart1293297.bKGqVYPrRg--
