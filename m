From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 5/18] megaraid_sas : Enhanced few prints
Date: Tue, 21 Apr 2015 16:45:50 +0530
Message-ID: <3ea794ac482bde7a204b62a0e3865f17@mail.gmail.com>
References: <201504201235.t3KCZMVU016508@palmhbs0.lsi.com> <55362529.6070503@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33640 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbDULPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 07:15:52 -0400
Received: by qcrf4 with SMTP id f4so73811482qcr.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2015 04:15:51 -0700 (PDT)
In-Reply-To: <55362529.6070503@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Tuesday, April 21, 2015 3:54 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: thenzl@redhat.com; martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH RESEND 5/18] megaraid_sas : Enhanced few prints
>
>On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
>> This patch will update few prints.
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c |   49
++++++++++++++---------
>------
>>  1 files changed, 24 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index 7f426e0..d8e7075 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -4091,12 +4091,11 @@ static void
>megasas_update_ext_vd_details(struct megasas_instance *instance)
>>  		instance->fw_supported_vd_count =3D MAX_LOGICAL_DRIVES;
>>  		instance->fw_supported_pd_count =3D
>MAX_PHYSICAL_DEVICES;
>>  	}
>> -	dev_info(&instance->pdev->dev, "Firmware supports %d VD %d
>PD\n",
>> -		instance->fw_supported_vd_count,
>> -		instance->fw_supported_pd_count);
>> -	dev_info(&instance->pdev->dev, "Driver supports %d VD  %d PD\n",
>> -		instance->drv_supported_vd_count,
>> -		instance->drv_supported_pd_count);
>> +
>> +	dev_info(&instance->pdev->dev,
>> +		"firmware type\t: %s\n",
>> +		instance->supportmax256vd ? "Extended VD(240
>VD)firmware" :
>> +		"Legacy(64 VD) firmware");
>>
>>  	old_map_sz =3D  sizeof(struct MR_FW_RAID_MAP) +
>>  				(sizeof(struct MR_LD_SPAN_MAP) *
>> @@ -4713,9 +4712,6 @@ static int megasas_init_fw(struct
>megasas_instance *instance)
>>  		ctrl_info->adapterOperations2.supportUnevenSpans;
>>  	if (instance->UnevenSpanSupport) {
>>  		struct fusion_context *fusion =3D instance->ctrl_context;
>> -
>> -		dev_info(&instance->pdev->dev, "FW supports: "
>> -		"UnevenSpanSupport=3D%x\n", instance-
>>UnevenSpanSupport);
>>  		if (MR_ValidateMapInfo(instance))
>>  			fusion->fast_path_io =3D 1;
>>  		else
>> @@ -4742,13 +4738,11 @@ static int megasas_init_fw(struct
>megasas_instance *instance)
>>  	instance->crash_dump_drv_support =3D
>>  		(instance->crash_dump_fw_support &&
>>  		instance->crash_dump_buf);
>> -	if (instance->crash_dump_drv_support) {
>> -		dev_info(&instance->pdev->dev, "Firmware Crash dump "
>> -			"feature is supported\n");
>> +	if (instance->crash_dump_drv_support)
>>  		megasas_set_crash_dump_params(instance,
>>  			MR_CRASH_BUF_TURN_OFF);
>>
>> -	} else {
>> +	else {
>>  		if (instance->crash_dump_buf)
>>  			pci_free_consistent(instance->pdev,
>>  				CRASH_DMA_BUF_SIZE,
>> @@ -4759,8 +4753,23 @@ static int megasas_init_fw(struct
>> megasas_instance *instance)
>>
>>  	instance->secure_jbod_support =3D
>>  		ctrl_info->adapterOperations3.supportSecurityonJBOD;
>> -	if (instance->secure_jbod_support)
>> -		dev_info(&instance->pdev->dev, "Firmware supports Secure
>JBOD\n");
>> +
>> +	dev_info(&instance->pdev->dev,
>> +		"pci id\t\t: (0x%04x)/(0x%04x)/(0x%04x)/(0x%04x)\n",
>> +		le16_to_cpu(ctrl_info->pci.vendor_id),
>> +		le16_to_cpu(ctrl_info->pci.device_id),
>> +		le16_to_cpu(ctrl_info->pci.sub_vendor_id),
>> +		le16_to_cpu(ctrl_info->pci.sub_device_id));
>> +	dev_info(&instance->pdev->dev, "unevenspan support	:
>%s\n",
>> +		instance->UnevenSpanSupport ? "yes" : "no");
>> +	dev_info(&instance->pdev->dev, "disable ocr		: %s\n",
>> +		instance->disableOnlineCtrlReset ? "yes" : "no");
>> +	dev_info(&instance->pdev->dev, "firmware crash dump	:
>%s\n",
>> +		instance->crash_dump_drv_support ? "yes" : "no");
>> +	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
>> +		instance->secure_jbod_support ? "yes" : "no");
>> +
>> +
>Hmm. This has a good chance of being broken up into several lines (ie =
one
line
>per 'dev_info' call.
>I'd prefer to have it modified to use one line eg by merging it into o=
ne
call to
>dev_info().

Understood.. We can go either way. Can we do it(one call to dev_info())=
 in
next updates(not in to be resent patches) to avoid regression/rework fo=
r
patches?
>
>>  	instance->max_sectors_per_req =3D instance->max_num_sge *
>>  						PAGE_SIZE / 512;
>>  	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
>@@
>> -5205,16 +5214,6 @@ static int megasas_probe_one(struct pci_dev *pde=
v,
>>  	}
>>
>>  	/*
>> -	 * Announce PCI information
>> -	 */
>> -	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
>> -	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
>> -	       pdev->subsystem_device);
>> -
>> -	printk("bus %d:slot %d:func %d\n",
>> -	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev-
>>devfn));
>> -
>> -	/*
>>  	 * PCI prepping: enable device set bus mastering and dma mask
>>  	 */
>>  	rval =3D pci_enable_device_mem(pdev);
>>
>
>Cheers,
>
>Hannes
>--
>Dr. Hannes Reinecke		      zSeries & Storage
>hare@suse.de			      +49 911 74053 688
>SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnber=
g)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
