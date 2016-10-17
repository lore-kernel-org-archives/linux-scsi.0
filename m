From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 3/7] megaraid_sas: Do not fire DCMDs during PCI shutdown/detach
Date: Mon, 17 Oct 2016 17:49:19 +0530
Message-ID: <2cd63d31d86ebbfbb41a0a6311324c79@mail.gmail.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-4-git-send-email-sumit.saxena@broadcom.com> <cba7dc68-e472-bece-a71a-88db54160829@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:32982 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933692AbcJQMTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 08:19:22 -0400
Received: by mail-oi0-f44.google.com with SMTP id y2so210125099oie.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 05:19:21 -0700 (PDT)
In-Reply-To: <cba7dc68-e472-bece-a71a-88db54160829@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Monday, October 17, 2016 5:01 PM
>To: Sumit Saxena; linux-scsi@vger.kernel.org
>Cc: martin.petersen@oracle.com; thenzl@redhat.com;
jejb@linux.vnet.ibm.com;
>kashyap.desai@broadcom.com
>Subject: Re: [PATCH 3/7] megaraid_sas: Do not fire DCMDs during PCI
>shutdown/detach
>
>On 10/17/2016 12:24 PM, Sumit Saxena wrote:
>> This patch addresses the issue of driver firing DCMDs in PCI
>> shutdown/detach path irrespective of firmware state.
>> Driver will check for whether firmware is operational state or not
>> before firing DCMDs. If firmware is in unrecoverbale state or does not
>> become operational within specfied time, driver will skip firing
>> DCMDs.
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c   | 46
>+++++++++++++++++++++++++++++
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  9 ++++--
>>  2 files changed, 52 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index 9ff57de..092387f 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -6248,6 +6248,32 @@ fail_reenable_msix:
>>  #define megasas_resume	NULL
>>  #endif
>>
>> +static inline int
>> +megasas_wait_for_adapter_operational(struct megasas_instance
>> +*instance) {
>> +	int wait_time =3D MEGASAS_RESET_WAIT_TIME * 2;
>> +	int i;
>> +
>> +	for (i =3D 0; i < wait_time; i++) {
>> +		if (atomic_read(&instance->adprecovery)
>> +			=3D=3D MEGASAS_HBA_OPERATIONAL)
>> +			break;
>> +
>> +		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL))
>> +			dev_notice(&instance->pdev->dev, "waiting for
>controller reset to
>> +finish\n");
>> +
>> +		msleep(1000);
>> +	}
>> +
>> +	if (atomic_read(&instance->adprecovery) !=3D
>MEGASAS_HBA_OPERATIONAL) {
>> +		dev_info(&instance->pdev->dev, "%s timed out while waiting
for
>HBA to recover.\n",
>> +			__func__);
>> +		return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  /**
>>   * megasas_detach_one -	PCI hot"un"plug entry point
>>   * @pdev:		PCI device structure
>> @@ -6272,9 +6298,18 @@ static void megasas_detach_one(struct pci_dev
>*pdev)
>>  	if (instance->fw_crash_state !=3D UNAVAILABLE)
>>  		megasas_free_host_crash_buffer(instance);
>>  	scsi_remove_host(instance->host);
>> +
>> +	msleep(1000);
>> +	if ((atomic_read(&instance->adprecovery) =3D=3D
>MEGASAS_HW_CRITICAL_ERROR)
>> +		|| ((atomic_read(&instance->adprecovery)
>> +			!=3D MEGASAS_HBA_OPERATIONAL) &&
>> +		megasas_wait_for_adapter_operational(instance)))
>> +		goto skip_firing_dcmds;
>> +
>>  	megasas_flush_cache(instance);
>>  	megasas_shutdown_controller(instance,
>MR_DCMD_CTRL_SHUTDOWN);
>>
>> +skip_firing_dcmds:
>>  	/* cancel the delayed work if this work still in queue*/
>>  	if (instance->ev !=3D NULL) {
>>  		struct megasas_aen_event *ev =3D instance->ev;
>Why not move the 'msleep' and 'atomic_read' into the call to
>megasas_wait_for_adapter_operational?
I will rectify this in next version of this patch.

>Plus I'm not sure if the unconditional 'msleep' is a good idea here;
maybe one
>should read 'adprecovery' first and _then_ call msleep if required?
Agreed.. I will cleanup this and resend the patch.

Thanks,
Sumit
>
>Cheers,
>
>Hannes
>--
>Dr. Hannes Reinecke		   Teamlead Storage & Networking
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB
21284 (AG
>N=C3=BCrnberg)
