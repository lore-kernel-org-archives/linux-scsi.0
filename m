From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH] pm80xx: Fix hibernation issue
Date: Tue, 17 Jun 2014 16:55:06 -0400
Message-ID: <53A0AB2A.1060301@attotech.com>
References: <1402947011-3642-1-git-send-email-bgrove@attotech.com> <1402963463.1934.0.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:41162 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965210AbaFQVKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2014 17:10:20 -0400
In-Reply-To: <1402963463.1934.0.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, bradley.grove@gmail.com
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, ebrown@attotech.com, pcullen@attotech.com


James,

The sleep is there to delay until the work kicked off by the scan start 
is complete.

Jack Wang and I are working on a different fix that won't require the delay.

Brad


On 06/16/2014 08:04 PM, James Bottomley wrote:
> On Mon, 2014-06-16 at 15:30 -0400, bradley.grove@gmail.com wrote:
>> From: Bradley Grove <bgrove@attotech.com>
>>
>> During hibernation, the HBA firmware may lose power and forget the device
>> id info.   This causes the HBA to reject IO upon resume.   The fix is
>> to call the libsas power management routines to make the domain device
>> forgetful.
>>
>> This patch also changes the value of pm8001_flags during resume to allow
>> completions to work.
>>
>> This fixes bug 76681: https://bugzilla.kernel.org/show_bug.cgi?id=76681
>>
>> Signed-off-by: Bradley Grove <bgrove@attotech.com>
>> ---
>>   drivers/scsi/pm8001/pm8001_init.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
>> index c4f31b21..9f51a1f 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -957,6 +957,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>>   	int  i, j;
>>   	u32 device_state;
>>   	pm8001_ha = sha->lldd_ha;
>> +	sas_suspend_ha(sha);
>>   	flush_workqueue(pm8001_wq);
>>   	scsi_block_requests(pm8001_ha->shost);
>>   	if (!pdev->pm_cap) {
>> @@ -1026,7 +1027,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>>   	rc = pci_go_44(pdev);
>>   	if (rc)
>>   		goto err_out_disable;
>> -
>> +	sas_prep_resume_ha(sha);
>>   	/* chip soft rst only for spc */
>>   	if (pm8001_ha->chip_id == chip_8001) {
>>   		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>> @@ -1058,7 +1059,12 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>>   		for (i = 1; i < pm8001_ha->number_of_intr; i++)
>>   			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
>>   	}
>> +	pm8001_ha->flags = PM8001F_INIT_TIME;
>>   	scsi_unblock_requests(pm8001_ha->shost);
>> +	pm8001_scan_start(pm8001_ha->shost);
>> +	msleep(100);
>
> What's the reason for the 0.1s sleep?  Something tells me it's to try to
> ensure that all the work kicked off by the scan start is completed in
> which case a sleep seems to be a bit racy.
>
> James
>
>> +	sas_resume_ha(sha);
>> +	pm8001_ha->flags = PM8001F_RUN_TIME;
>>   	return 0;
>>
>>   err_out_disable:
>
>

