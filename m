From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 4/18] megaraid_sas : Move controller's queue depth
 calculation in adapter specific function
Date: Tue, 21 Apr 2015 16:30:34 +0530
Message-ID: <a0f66636d55fbc674b0a85a0219e5483@mail.gmail.com>
References: <201504201235.t3KCZCCD016481@palmhbs0.lsi.com> <553624BF.7030301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35477 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbDULAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 07:00:36 -0400
Received: by qgej70 with SMTP id j70so66287500qge.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2015 04:00:35 -0700 (PDT)
In-Reply-To: <553624BF.7030301@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Tuesday, April 21, 2015 3:52 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: thenzl@redhat.com; martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH RESEND 4/18] megaraid_sas : Move controller's queu=
e
>depth calculation in adapter specific function
>
>On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
>> This patch will move controller's queue depth calculation in adapter
specific
>functions.
>>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c   |   39
++++++++++--------------
>--
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    9 ++++++
>>  2 files changed, 24 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index e6cb2bd..7f426e0 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -4354,6 +4354,21 @@ megasas_init_adapter_mfi(struct
>megasas_instance *instance)
>>  	instance->max_num_sge =3D (instance->instancet-
>>read_fw_status_reg(reg_set) & 0xFF0000) >>
>>  					0x10;
>>  	/*
>> +	 * For MFI skinny adapters, MEGASAS_SKINNY_INT_CMDS commands
>> +	 * are reserved for IOCTL + driver's internal DCMDs.
>> +	 */
>> +	if ((instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_SAS0073SKINNY=
)
>||
>> +		(instance->pdev->device =3D=3D
>PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
>> +		instance->max_scsi_cmds =3D (instance->max_fw_cmds -
>> +			MEGASAS_SKINNY_INT_CMDS);
>> +		sema_init(&instance->ioctl_sem,
>MEGASAS_SKINNY_INT_CMDS);
>> +	} else {
>> +		instance->max_scsi_cmds =3D (instance->max_fw_cmds -
>> +			MEGASAS_INT_CMDS);
>> +		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
>'- 5' ?
>I'd prefer to have a separate #define as you did for the fusion side..=
=2E

I will resend this patch series(as there are comments from Christoph
Hellwig to rework for other patches of the series as well) and take car=
e
of it.
>
>> +	}
>> +
>> +	/*
>>  	 * Create a pool of commands
>>  	 */
>>  	if (megasas_alloc_cmds(instance))
>> @@ -4751,30 +4766,6 @@ static int megasas_init_fw(struct
>megasas_instance *instance)
>>  	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
>>  		instance->max_sectors_per_req =3D tmp_sectors;
>>
>> -	/*
>> -	 * 1. For fusion adapters, 3 commands for IOCTL and 5 commands
>> -	 *    for driver's internal DCMDs.
>> -	 * 2. For MFI skinny adapters, 5 commands for IOCTL + driver's
>> -	 *    internal DCMDs.
>> -	 * 3. For rest of MFI adapters, 27 commands reserved for IOCTLs
>> -	 *    and 5 commands for drivers's internal DCMD.
>> -	 */
>> -	if (instance->ctrl_context) {
>> -		instance->max_scsi_cmds =3D instance->max_fw_cmds -
>> -
>	(MEGASAS_FUSION_INTERNAL_CMDS +
>> -					MEGASAS_FUSION_IOCTL_CMDS);
>> -		sema_init(&instance->ioctl_sem,
>MEGASAS_FUSION_IOCTL_CMDS);
>> -	} else if ((instance->pdev->device =3D=3D
>PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
>> -		(instance->pdev->device =3D=3D
>PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
>> -		instance->max_scsi_cmds =3D instance->max_fw_cmds -
>> -
>	MEGASAS_SKINNY_INT_CMDS;
>> -		sema_init(&instance->ioctl_sem,
>MEGASAS_SKINNY_INT_CMDS);
>> -	} else {
>> -		instance->max_scsi_cmds =3D instance->max_fw_cmds -
>> -						MEGASAS_INT_CMDS;
>> -		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
>> -	}
>> -
>>  	/* Check for valid throttlequeuedepth module parameter */
>>  	if (throttlequeuedepth &&
>>  			throttlequeuedepth <=3D instance->max_scsi_cmds)
>diff --git
>> a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index c5619f8..3cd1d5f 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -1061,6 +1061,15 @@ megasas_init_adapter_fusion(struct
>megasas_instance *instance)
>>  		fusion->last_reply_idx[i] =3D 0;
>>
>>  	/*
>> +	 * For fusion adapters, 3 commands for IOCTL and 5 commands
>> +	 * for driver's internal DCMDs.
>> +	 */
>> +	instance->max_scsi_cmds =3D instance->max_fw_cmds -
>> +				(MEGASAS_FUSION_INTERNAL_CMDS +
>> +				MEGASAS_FUSION_IOCTL_CMDS);
>> +	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
>> +
>> +	/*
>>  	 * Allocate memory for descriptors
>>  	 * Create a pool of commands
>>  	 */
>>
>See? Here it's a #define ...
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
