From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 3/9] aacraid: Added EEH support
Date: Mon, 18 Jan 2016 12:16:34 +0100
Message-ID: <20160118111634.GH2742@c203.arch.suse.de>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-4-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbcARLQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 06:16:37 -0500
Content-Disposition: inline
In-Reply-To: <1452842182-684-4-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, thenzl@redhat.com, shane.seymour@hpe.com, David.Carroll@pmcs.com

On Thu, Jan 14, 2016 at 11:16:16PM -0800, Raghava Aditya Renukunta wrot=
e:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> Added support for PCI EEH(extended error handling).
>=20
> Changes in V2:
> Made local functions static
> Removed call to  aac_fib_free_tag
> Set adapter_shutdown flag when PCI error detected
>=20
> Changes in V3:
> None
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/aacraid/aacraid.h |   1 +
>  drivers/scsi/aacraid/linit.c   | 140 +++++++++++++++++++++++++++++++=
++++++++++
>  2 files changed, 141 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index fff1306..2916288 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1235,6 +1235,7 @@ struct aac_dev
>  	struct msix_entry	msixentry[AAC_MAX_MSIX];
>  	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
>  	u8			adapter_shutdown;
> +	u32			handle_pci_error;
>  };
> =20
>  #define aac_adapter_interrupt(dev) \
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 129a515..08c6835 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -38,6 +38,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/pci.h>
> +#include <linux/aer.h>
>  #include <linux/pci-aspm.h>
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
> @@ -1298,6 +1299,9 @@ static int aac_probe_one(struct pci_dev *pdev, =
const struct pci_device_id *id)
>  		goto out_deinit;
>  	scsi_scan_host(shost);
> =20
> +	pci_enable_pcie_error_reporting(pdev);
> +	pci_save_state(pdev);
> +
>  	return 0;
> =20
>   out_deinit:
> @@ -1501,6 +1505,141 @@ static void aac_remove_one(struct pci_dev *pd=
ev)
>  	}
>  }
> =20
> +static void aac_flush_ios(struct aac_dev *aac)
> +{
> +	int i;
> +	struct scsi_cmnd *cmd;
> +
> +	for (i =3D 0; i < aac->scsi_host_ptr->can_queue; i++) {
> +		cmd =3D (struct scsi_cmnd *)aac->fibs[i].callback_data;
> +		if (cmd && (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE)) {
> +			scsi_dma_unmap(cmd);
> +
> +			if (aac->handle_pci_error)
> +				cmd->result =3D DID_NO_CONNECT << 16;
> +			else
> +				cmd->result =3D DID_RESET << 16;
> +
> +			cmd->scsi_done(cmd);
> +		}
> +	}
> +}
> +
> +static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
> +					enum pci_channel_state error)
> +{
> +	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> +	struct aac_dev *aac =3D shost_priv(shost);
> +
> +	dev_err(&pdev->dev, "aacraid: PCI error detected %x\n", error);
> +
> +	switch (error) {
> +	case pci_channel_io_normal:
> +		return PCI_ERS_RESULT_CAN_RECOVER;
> +	case pci_channel_io_frozen:
> +
> +		aac->handle_pci_error =3D 1;
> +		aac->adapter_shutdown =3D 1;
> +
> +		scsi_block_requests(aac->scsi_host_ptr);
> +		aac_flush_ios(aac);
> +		aac_release_resources(aac);
> +
> +		pci_disable_pcie_error_reporting(pdev);
> +		aac_adapter_ioremap(aac, 0);
> +
> +		return PCI_ERS_RESULT_NEED_RESET;
> +	case pci_channel_io_perm_failure:
> +		aac->handle_pci_error =3D 1;
> +		aac->adapter_shutdown =3D 1;
> +
> +		aac_flush_ios(aac);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +static pci_ers_result_t aac_pci_mmio_enabled(struct pci_dev *pdev)
> +{
> +	dev_err(&pdev->dev, "aacraid: PCI error - mmio enabled\n");
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +static pci_ers_result_t aac_pci_slot_reset(struct pci_dev *pdev)
> +{
> +	dev_err(&pdev->dev, "aacraid: PCI error - slot reset\n");
> +	pci_restore_state(pdev);
> +	if (pci_enable_device(pdev)) {
> +		dev_warn(&pdev->dev,
> +			"aacraid: failed to enable slave\n");
> +		goto fail_device;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	if (pci_enable_device_mem(pdev)) {
> +		dev_err(&pdev->dev, "pci_enable_device_mem failed\n");
> +		goto fail_device;
> +	}
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +
> +fail_device:
> +	dev_err(&pdev->dev, "aacraid: PCI error - slot reset failed\n");
> +	return PCI_ERS_RESULT_DISCONNECT;
> +}
> +
> +
> +static void aac_pci_resume(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> +	struct scsi_device *sdev =3D NULL;
> +	struct aac_dev *aac =3D (struct aac_dev *)shost_priv(shost);
> +
> +	pci_cleanup_aer_uncorrect_error_status(pdev);
> +
> +	if (aac_adapter_ioremap(aac, aac->base_size)) {
> +
> +		dev_err(&pdev->dev, "aacraid: ioremap failed\n");
> +		/* remap failed, go back ... */
> +		aac->comm_interface =3D AAC_COMM_PRODUCER;
> +		if (aac_adapter_ioremap(aac, AAC_MIN_FOOTPRINT_SIZE)) {
> +			dev_warn(&pdev->dev,
> +				"aacraid: unable to map adapter.\n");
> +
> +			return;
> +		}
> +	}
> +
> +	msleep(10000);
> +
> +	aac_acquire_resources(aac);
> +
> +	/*
> +	 * reset this flag to unblock ioctl() as it was set
> +	 * at aac_send_shutdown() to block ioctls from upperlayer
> +	 */
> +	aac->adapter_shutdown =3D 0;
> +	aac->handle_pci_error =3D 0;
> +
> +	shost_for_each_device(sdev, shost)
> +		if (sdev->sdev_state =3D=3D SDEV_OFFLINE)
> +			sdev->sdev_state =3D SDEV_RUNNING;
> +	scsi_unblock_requests(aac->scsi_host_ptr);
> +	scsi_scan_host(aac->scsi_host_ptr);
> +	pci_save_state(pdev);
> +
> +	dev_err(&pdev->dev, "aacraid: PCI error - resume\n");
> +}
> +
> +static struct pci_error_handlers aac_pci_err_handler =3D {
> +	.error_detected		=3D aac_pci_error_detected,
> +	.mmio_enabled		=3D aac_pci_mmio_enabled,
> +	.slot_reset		=3D aac_pci_slot_reset,
> +	.resume			=3D aac_pci_resume,
> +};
> +
>  static struct pci_driver aac_pci_driver =3D {
>  	.name		=3D AAC_DRIVERNAME,
>  	.id_table	=3D aac_pci_tbl,
> @@ -1511,6 +1650,7 @@ static struct pci_driver aac_pci_driver =3D {
>  	.resume		=3D aac_resume,
>  #endif
>  	.shutdown	=3D aac_shutdown,
> +	.err_handler    =3D &aac_pci_err_handler,
>  };
> =20
>  static int __init aac_init(void)
> --=20
> 1.9.1
>=20

Looks good,

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
