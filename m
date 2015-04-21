From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 5/18] megaraid_sas : Enhanced few prints
Date: Tue, 21 Apr 2015 12:23:37 +0200
Message-ID: <55362529.6070503@suse.de>
References: <201504201235.t3KCZMVU016508@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbDUKXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:23:40 -0400
In-Reply-To: <201504201235.t3KCZMVU016508@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
> This patch will update few prints.=20
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>=20
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |   49 ++++++++++++++-----=
----------
>  1 files changed, 24 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index 7f426e0..d8e7075 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4091,12 +4091,11 @@ static void megasas_update_ext_vd_details(str=
uct megasas_instance *instance)
>  		instance->fw_supported_vd_count =3D MAX_LOGICAL_DRIVES;
>  		instance->fw_supported_pd_count =3D MAX_PHYSICAL_DEVICES;
>  	}
> -	dev_info(&instance->pdev->dev, "Firmware supports %d VD %d PD\n",
> -		instance->fw_supported_vd_count,
> -		instance->fw_supported_pd_count);
> -	dev_info(&instance->pdev->dev, "Driver supports %d VD  %d PD\n",
> -		instance->drv_supported_vd_count,
> -		instance->drv_supported_pd_count);
> +
> +	dev_info(&instance->pdev->dev,
> +		"firmware type\t: %s\n",
> +		instance->supportmax256vd ? "Extended VD(240 VD)firmware" :
> +		"Legacy(64 VD) firmware");
> =20
>  	old_map_sz =3D  sizeof(struct MR_FW_RAID_MAP) +
>  				(sizeof(struct MR_LD_SPAN_MAP) *
> @@ -4713,9 +4712,6 @@ static int megasas_init_fw(struct megasas_insta=
nce *instance)
>  		ctrl_info->adapterOperations2.supportUnevenSpans;
>  	if (instance->UnevenSpanSupport) {
>  		struct fusion_context *fusion =3D instance->ctrl_context;
> -
> -		dev_info(&instance->pdev->dev, "FW supports: "
> -		"UnevenSpanSupport=3D%x\n", instance->UnevenSpanSupport);
>  		if (MR_ValidateMapInfo(instance))
>  			fusion->fast_path_io =3D 1;
>  		else
> @@ -4742,13 +4738,11 @@ static int megasas_init_fw(struct megasas_ins=
tance *instance)
>  	instance->crash_dump_drv_support =3D
>  		(instance->crash_dump_fw_support &&
>  		instance->crash_dump_buf);
> -	if (instance->crash_dump_drv_support) {
> -		dev_info(&instance->pdev->dev, "Firmware Crash dump "
> -			"feature is supported\n");
> +	if (instance->crash_dump_drv_support)
>  		megasas_set_crash_dump_params(instance,
>  			MR_CRASH_BUF_TURN_OFF);
> =20
> -	} else {
> +	else {
>  		if (instance->crash_dump_buf)
>  			pci_free_consistent(instance->pdev,
>  				CRASH_DMA_BUF_SIZE,
> @@ -4759,8 +4753,23 @@ static int megasas_init_fw(struct megasas_inst=
ance *instance)
> =20
>  	instance->secure_jbod_support =3D
>  		ctrl_info->adapterOperations3.supportSecurityonJBOD;
> -	if (instance->secure_jbod_support)
> -		dev_info(&instance->pdev->dev, "Firmware supports Secure JBOD\n");
> +
> +	dev_info(&instance->pdev->dev,
> +		"pci id\t\t: (0x%04x)/(0x%04x)/(0x%04x)/(0x%04x)\n",
> +		le16_to_cpu(ctrl_info->pci.vendor_id),
> +		le16_to_cpu(ctrl_info->pci.device_id),
> +		le16_to_cpu(ctrl_info->pci.sub_vendor_id),
> +		le16_to_cpu(ctrl_info->pci.sub_device_id));
> +	dev_info(&instance->pdev->dev, "unevenspan support	: %s\n",
> +		instance->UnevenSpanSupport ? "yes" : "no");
> +	dev_info(&instance->pdev->dev, "disable ocr		: %s\n",
> +		instance->disableOnlineCtrlReset ? "yes" : "no");
> +	dev_info(&instance->pdev->dev, "firmware crash dump	: %s\n",
> +		instance->crash_dump_drv_support ? "yes" : "no");
> +	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
> +		instance->secure_jbod_support ? "yes" : "no");
> +
> +
Hmm. This has a good chance of being broken up into several lines (ie
one line per 'dev_info' call.
I'd prefer to have it modified to use one line eg by merging it into on=
e
call to dev_info().

>  	instance->max_sectors_per_req =3D instance->max_num_sge *
>  						PAGE_SIZE / 512;
>  	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
> @@ -5205,16 +5214,6 @@ static int megasas_probe_one(struct pci_dev *p=
dev,
>  	}
> =20
>  	/*
> -	 * Announce PCI information
> -	 */
> -	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
> -	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
> -	       pdev->subsystem_device);
> -
> -	printk("bus %d:slot %d:func %d\n",
> -	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->dev=
fn));
> -
> -	/*
>  	 * PCI prepping: enable device set bus mastering and dma mask
>  	 */
>  	rval =3D pci_enable_device_mem(pdev);
>=20

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
