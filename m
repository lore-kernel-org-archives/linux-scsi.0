From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Mon, 18 Jan 2016 12:56:20 +0100
Message-ID: <20160118115620.GJ2742@c203.arch.suse.de>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbcARL4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 06:56:25 -0500
Content-Disposition: inline
In-Reply-To: <1452842182-684-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, thenzl@redhat.com, shane.seymour@hpe.com, David.Carroll@pmcs.com

On Thu, Jan 14, 2016 at 11:16:20PM -0800, Raghava Aditya Renukunta wrot=
e:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> while driver removal is in progress or PCI shutdown is invoked, drive=
r
> kills AIF aacraid thread, but IOCTL requests from the management tool=
s
> re-start AIF thread leading to IOP_RESET.
>=20
> Fixed by setting adapter_shutdown flag when PCI shutdown is invoked.
>=20
> Changes in V2:
> Set adapter_shutdown flag before shutdown command is sent to \
> controller
>=20
> Changes in V3:
> Call aac_send_shut_shutdown first thing in __aac_shutdown
> Convert adapter_shutdown to atomic_t variable to prevent \
> SMP coherency issues(race conditions)
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
>  drivers/scsi/aacraid/aacraid.h  |  2 +-
>  drivers/scsi/aacraid/comminit.c |  6 +++---
>  drivers/scsi/aacraid/linit.c    | 15 ++++++++-------
>  3 files changed, 12 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 2916288..3473668 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1234,7 +1234,7 @@ struct aac_dev
>  	int			msi_enabled;	/* MSI/MSI-X enabled */
>  	struct msix_entry	msixentry[AAC_MAX_MSIX];
>  	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
> -	u8			adapter_shutdown;
> +	atomic_t		adapter_shutdown;
>  	u32			handle_pci_error;
>  };
> =20
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/c=
omminit.c
> index 0e954e3..d361673 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -212,8 +212,9 @@ int aac_send_shutdown(struct aac_dev * dev)
>  		return -ENOMEM;
>  	aac_fib_init(fibctx);
> =20
> -	cmd =3D (struct aac_close *) fib_data(fibctx);
> +	atomic_set(&dev->adapter_shutdown, 1);
> =20
> +	cmd =3D (struct aac_close *) fib_data(fibctx);
>  	cmd->command =3D cpu_to_le32(VM_CloseAll);
>  	cmd->cid =3D cpu_to_le32(0xfffffffe);
> =20
> @@ -229,7 +230,6 @@ int aac_send_shutdown(struct aac_dev * dev)
>  	/* FIB should be freed only after getting the response from the F/W=
 */
>  	if (status !=3D -ERESTARTSYS)
>  		aac_fib_free(fibctx);
> -	dev->adapter_shutdown =3D 1;
>  	if ((dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
>  	     dev->pdev->device =3D=3D PMC_DEVICE_S8 ||
>  	     dev->pdev->device =3D=3D PMC_DEVICE_S9) &&
> @@ -468,7 +468,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *=
dev)
>  	}
>  	dev->max_msix =3D 0;
>  	dev->msi_enabled =3D 0;
> -	dev->adapter_shutdown =3D 0;
> +	atomic_set(&dev->adapter_shutdown, 0);
>  	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
>  	  0, 0, 0, 0, 0, 0,
>  	  status+0, status+1, status+2, status+3, status+4))
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 6944560..27b3fcd 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -706,7 +706,7 @@ static long aac_cfg_ioctl(struct file *file,
>  	int ret;
>  	struct aac_dev *aac;
>  	aac =3D (struct aac_dev *)file->private_data;
> -	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
> +	if (!capable(CAP_SYS_RAWIO) || atomic_read(&aac->adapter_shutdown))
>  		return -EPERM;
>  	mutex_lock(&aac_mutex);
>  	ret =3D aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
> @@ -1078,6 +1078,8 @@ static void __aac_shutdown(struct aac_dev * aac=
)
>  	int i;
>  	int cpu;
> =20
> +	aac_send_shutdown(aac);
> +
>  	if (aac->aif_thread) {
>  		int i;
>  		/* Clear out events first */
> @@ -1089,7 +1091,7 @@ static void __aac_shutdown(struct aac_dev * aac=
)
>  		}
>  		kthread_stop(aac->thread);
>  	}
> -	aac_send_shutdown(aac);
> +
>  	aac_adapter_disable_int(aac);
>  	cpu =3D cpumask_first(cpu_online_mask);
>  	if (aac->pdev->device =3D=3D PMC_DEVICE_S6 ||
> @@ -1474,7 +1476,7 @@ static int aac_resume(struct pci_dev *pdev)
>  	* reset this flag to unblock ioctl() as it was set at
>  	* aac_send_shutdown() to block ioctls from upperlayer
>  	*/
> -	aac->adapter_shutdown =3D 0;
> +	atomic_set(&aac->adapter_shutdown, 0);
>  	scsi_unblock_requests(shost);
> =20
>  	return 0;
> @@ -1553,9 +1555,8 @@ static pci_ers_result_t aac_pci_error_detected(=
struct pci_dev *pdev,
>  	case pci_channel_io_normal:
>  		return PCI_ERS_RESULT_CAN_RECOVER;
>  	case pci_channel_io_frozen:
> -
>  		aac->handle_pci_error =3D 1;
> -		aac->adapter_shutdown =3D 1;
> +		atomic_set(&aac->adapter_shutdown, 1);
> =20
>  		scsi_block_requests(aac->scsi_host_ptr);
>  		aac_flush_ios(aac);
> @@ -1567,7 +1568,7 @@ static pci_ers_result_t aac_pci_error_detected(=
struct pci_dev *pdev,
>  		return PCI_ERS_RESULT_NEED_RESET;
>  	case pci_channel_io_perm_failure:
>  		aac->handle_pci_error =3D 1;
> -		aac->adapter_shutdown =3D 1;
> +		atomic_set(&aac->adapter_shutdown, 1);
> =20
>  		aac_flush_ios(aac);
>  		return PCI_ERS_RESULT_DISCONNECT;
> @@ -1636,7 +1637,7 @@ static void aac_pci_resume(struct pci_dev *pdev=
)
>  	 * reset this flag to unblock ioctl() as it was set
>  	 * at aac_send_shutdown() to block ioctls from upperlayer
>  	 */
> -	aac->adapter_shutdown =3D 0;
> +	atomic_set(&aac->adapter_shutdown, 0);
>  	aac->handle_pci_error =3D 0;
> =20
>  	shost_for_each_device(sdev, shost)
> --=20
> 1.9.1
>=20

Looks good.

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
