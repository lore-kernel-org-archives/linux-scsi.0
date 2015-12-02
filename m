From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/10] aacraid: Added EEH support
Date: Wed, 02 Dec 2015 10:41:30 +0100
Message-ID: <1449049290.3103.44.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-4-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbbLBJld (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 04:41:33 -0500
In-Reply-To: <1448973589-9216-4-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> Added support for PCI EEH(extended error handling).
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/aacraid.h |=C2=A0=C2=A0=C2=A01 +
> =C2=A0drivers/scsi/aacraid/linit.c=C2=A0=C2=A0=C2=A0| 138
> +++++++++++++++++++++++++++++++++++++++++
> =C2=A02 files changed, 139 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index d133c4a..594de5f 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1235,6 +1235,7 @@ struct aac_dev
> =C2=A0	struct msix_entry	msixentry[AAC_MAX_MSIX];
> =C2=A0	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
> =C2=A0	u8			adapter_shutdown;
> +	u32			handle_pci_error;
> =C2=A0};
> =C2=A0
> =C2=A0#define aac_adapter_interrupt(dev) \
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index fa0fc44..0147210 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -38,6 +38,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/moduleparam.h>
> =C2=A0#include <linux/pci.h>
> +#include <linux/aer.h>
> =C2=A0#include <linux/pci-aspm.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/mutex.h>
> @@ -1298,6 +1299,9 @@ static int aac_probe_one(struct pci_dev *pdev, =
const
> struct pci_device_id *id)
> =C2=A0		goto out_deinit;
> =C2=A0	scsi_scan_host(shost);
> =C2=A0
> +	pci_enable_pcie_error_reporting(pdev);
> +	pci_save_state(pdev);
> +
> =C2=A0	return 0;
> =C2=A0
> =C2=A0 out_deinit:
> @@ -1501,6 +1505,139 @@ static void aac_remove_one(struct pci_dev *pd=
ev)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> +void aac_flush_ios(struct aac_dev *aac)
> +{
> +	int i;
> +	struct scsi_cmnd *cmd;
> +
> +	for (i =3D 0; i < aac->scsi_host_ptr->can_queue; i++) {
> +		cmd =3D (struct scsi_cmnd *)aac->fibs[i].callback_data;
> +		if (cmd && (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE)) {
> +			scsi_dma_unmap(cmd);
> +			aac_fib_free_tag(&aac->fibs[i]);
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
> +pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
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
> +		aac_flush_ios(aac);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +pci_ers_result_t aac_pci_mmio_enabled(struct pci_dev *pdev)
> +{
> +	dev_err(&pdev->dev, "aacraid: PCI error - mmio enabled\n");
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +pci_ers_result_t aac_pci_slot_reset(struct pci_dev *pdev)
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
> +void aac_pci_resume(struct pci_dev *pdev)
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
> +	=C2=A0* reset this flag to unblock ioctl() as it was set
> +	=C2=A0* at aac_send_shutdown() to block ioctls from upperlayer
> +	=C2=A0*/
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
> =C2=A0static struct pci_driver aac_pci_driver =3D {
> =C2=A0	.name		=3D AAC_DRIVERNAME,
> =C2=A0	.id_table	=3D aac_pci_tbl,
> @@ -1511,6 +1648,7 @@ static struct pci_driver aac_pci_driver =3D {
> =C2=A0	.resume		=3D aac_resume,
> =C2=A0#endif
> =C2=A0	.shutdown	=3D aac_shutdown,
> +	.err_handler=C2=A0=C2=A0=C2=A0=C2=A0=3D &aac_pci_err_handler,
> =C2=A0};
> =C2=A0
> =C2=A0static int __init aac_init(void)

I really think the new aac_flush_io() and pci error hanler methods shou=
ld be
static as they're nowhere used outside of this file's scope.=C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
