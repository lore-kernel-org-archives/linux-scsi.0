From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/20] [SCSI] mpt3sas: Added Combined Reply Queue feature
 to extend up-to 96 MSIX vector support
Date: Fri, 12 Jun 2015 13:09:15 +0200
Message-ID: <20150612110915.GB2812@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-2-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-2-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:13PM +0530, Sreekanth Reddy wrote:
> In this patch, increased the number of MSIX vector support for SAS3 C=
0 HBAs to up-to 96.
>=20
> Following are changes that are done in this patch
> 1. Support this feature only for SAS3 C0 cards and also only when rep=
ly post free queue count is greater than 8.
> 2. Instead of using single ReplyPostHostIndex system interface, here =
12 ReplyPostHostIndex system interfaces are used. reply post free queue=
s numbered from 0 to 7 use the first ReplyPostHostIndex system interfac=
e to update its corresponding ReplyPostHostIndex values, reply post fre=
e queues numbered from 8 to 15 will use the second ReplyPostHostIndex s=
ystem interface and so on. These 12 ReplyPostHostIndex system interface=
s address are saved in the array replyPostRegisterIndex[].
> 3. Update the ReplyPostHostIndex value of corresponding reply post fr=
ee queue in the (its msix_index/8)th entry of replyPostRegisterIndex[] =
array after processing the reply post descriptor.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 70 +++++++++++++++++++++++++++=
++++++----
>  drivers/scsi/mpt3sas/mpt3sas_base.h |  7 +++-
>  2 files changed, 69 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> index 14a781b..c13a365 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -83,7 +83,7 @@ static int msix_disable =3D -1;
>  module_param(msix_disable, int, 0);
>  MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (def=
ault=3D0)");
> =20
> -static int max_msix_vectors =3D 8;
> +static int max_msix_vectors =3D -1;
>  module_param(max_msix_vectors, int, 0);
>  MODULE_PARM_DESC(max_msix_vectors,
>  	" max msix vectors - (default=3D8)");

When changing the default value, please also update the description ref=
lecting
this change.

> @@ -1009,8 +1009,15 @@ _base_interrupt(int irq, void *bus_id)
>  	}
> =20
>  	wmb();
> -	writel(reply_q->reply_post_host_index | (msix_index <<
> -	    MPI2_RPHI_MSIX_INDEX_SHIFT), &ioc->chip->ReplyPostHostIndex);
> +	if (ioc->msix96_vector) {
> +		writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
> +			MPI2_RPHI_MSIX_INDEX_SHIFT),
> +				ioc->replyPostRegisterIndex[msix_index/8]);
> +	} else {
> +		writel(reply_q->reply_post_host_index | (msix_index <<
> +			MPI2_RPHI_MSIX_INDEX_SHIFT),
> +				&ioc->chip->ReplyPostHostIndex);
> +	}
>  	atomic_dec(&reply_q->busy);
>  	return IRQ_HANDLED;
>  }
> @@ -1560,8 +1567,6 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER =
*ioc)
> =20
>  	pci_read_config_word(ioc->pdev, base + 2, &message_control);
>  	ioc->msix_vector_count =3D (message_control & 0x3FF) + 1;
> -	if (ioc->msix_vector_count > 8)
> -		ioc->msix_vector_count =3D 8;
>  	dinitprintk(ioc, pr_info(MPT3SAS_FMT
>  		"msix is supported, vector_count(%d)\n",
>  		ioc->name, ioc->msix_vector_count));
> @@ -1880,6 +1885,31 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAP=
TER *ioc)
>  	if (r)
>  		goto out_fail;
> =20
> +	/* Use the Combined reply queue feature only for SAS3 C0 HBAs and
> +	 * also only when reply queue count is greater than 8
> +	 */
> +	if (ioc->msix96_vector && ioc->reply_queue_count > 8) {
> +		/* If this is an 96 vector supported device,
> +		set up ReplyPostIndex addresses */
> +		ioc->replyPostRegisterIndex =3D kcalloc(12,
> +			sizeof(resource_size_t *), GFP_KERNEL);
> +		if (!ioc->replyPostRegisterIndex) {
> +			dfailprintk(ioc, printk(MPT3SAS_FMT
> +			"allocation for reply Post Register Index failed!!!\n",
> +								   ioc->name));
> +			r =3D -ENOMEM;
> +			goto out_fail;
> +		}
> +
> +		for (i =3D 0; i < 12; i++) {
> +			ioc->replyPostRegisterIndex[i] =3D (resource_size_t *)
> +				((u8 *)&ioc->chip->Doorbell +
> +				MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
> +				(i * 0x10));
> +		}
> +	} else
> +		ioc->msix96_vector =3D 0;
> +
>  	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
>  		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
>  		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
> @@ -1901,6 +1931,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPT=
ER *ioc)
>  	pci_release_selected_regions(ioc->pdev, ioc->bars);
>  	pci_disable_pcie_error_reporting(pdev);
>  	pci_disable_device(pdev);
> +	if (ioc->msix96_vector)
> +		kfree(ioc->replyPostRegisterIndex);
>  	return r;
>  }
> =20
> @@ -4522,8 +4554,16 @@ _base_make_ioc_operational(struct MPT3SAS_ADAP=
TER *ioc, int sleep_flag)
> =20
>  	/* initialize reply post host index */
>  	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
> -		writel(reply_q->msix_index << MPI2_RPHI_MSIX_INDEX_SHIFT,
> -		    &ioc->chip->ReplyPostHostIndex);
> +		if (ioc->msix96_vector) {
> +			writel((reply_q->msix_index & 7)<<
> +			   MPI2_RPHI_MSIX_INDEX_SHIFT,
> +			   ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
> +		} else {
> +			writel(reply_q->msix_index <<
> +				MPI2_RPHI_MSIX_INDEX_SHIFT,
> +					&ioc->chip->ReplyPostHostIndex);
> +		}
> +
>  		if (!_base_is_controller_msix_enabled(ioc))
>  			goto skip_init_reply_post_host_index;
>  	}
> @@ -4577,6 +4617,9 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAP=
TER *ioc)
>  	_base_free_irq(ioc);
>  	_base_disable_msix(ioc);
> =20
> +	if (ioc->msix96_vector)
> +		kfree(ioc->replyPostRegisterIndex);
> +
>  	if (ioc->chip_phys && ioc->chip)
>  		iounmap(ioc->chip);
>  	ioc->chip_phys =3D 0;
> @@ -4600,6 +4643,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc=
)
>  {
>  	int r, i;
>  	int cpu_id, last_cpu_id =3D 0;
> +	u8 revision;
> =20
>  	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
>  	    __func__));
> @@ -4618,6 +4662,18 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *io=
c)
>  		r =3D -ENOMEM;
>  		goto out_free_resources;
>  	}
> +	/* Check whether the controller revision is C0 or above.
> +	    C0 and above revision controllers support 96 vectors */
> +	revision =3D ioc->pdev->revision;
> +
> +	if ((ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3004 ||
> +	     ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3008 ||
> +	     ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_1 ||
> +	     ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_2 ||
> +	     ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_5 ||
> +	     ioc->pdev->device =3D=3D MPI25_MFGPAGE_DEVID_SAS3108_6) &&
> +	     (revision >=3D 0x02))
> +		ioc->msix96_vector =3D 1;
> =20
>  	ioc->rdpq_array_enable_assigned =3D 0;
>  	ioc->dma_mask =3D 0;
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3s=
as/mpt3sas_base.h
> index afa8816..6b8d8f1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -728,7 +728,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct=
 MPT3SAS_ADAPTER *ioc);
>   *				is assigned only ones
>   * @reply_queue_count: number of reply queue's
>   * @reply_queue_list: link list contaning the reply queue info
> - * @reply_post_host_index: head index in the pool where FW completes=
 IO
> + * @msix96_vector: 96 MSI-X vector support
> + * @replyPostRegisterIndex: index of next position in Reply Desc Pos=
t Queue
>   * @delayed_tr_list: target reset link list
>   * @delayed_tr_volume_list: volume target reset link list
>   * @@temp_sensors_count: flag to carry the number of temperature sen=
sors
> @@ -937,6 +938,10 @@ struct MPT3SAS_ADAPTER {
>  	u8		reply_queue_count;
>  	struct list_head reply_queue_list;
> =20
> +	u8		msix96_vector;
> +	/* reply post register index */
> +	resource_size_t	**replyPostRegisterIndex;
> +

I know there are many uses of mixed-case varibles in this driver and ch=
anging
them when they're already in makes no sense, but maybe you could consid=
er
getting rid of them in your mpt2sas/mpt3sas merge, as it is not really =
a
commonly seen pattern in the linux kernel.

>  	struct list_head delayed_tr_list;
>  	struct list_head delayed_tr_volume_list;
>  	u8		temp_sensors_count;
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
