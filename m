From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: [PATCH] pm8001: Fix potential null pointer dereference and
 memory leak.
Date: Fri, 20 Jun 2014 07:30:43 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E1CD7152E@BBYEXM02.pmc-sierra.internal>
References: <1403003740-27487-1-git-send-email-mlombard@redhat.com>
 <53A03488.9060407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:52622 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845AbaFTIEl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2014 04:04:41 -0400
In-Reply-To: <53A03488.9060407@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>, Maurizio Lombardi <mlombard@redhat.com>
Cc: "lindar_liu@usish.com" <lindar_liu@usish.com>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jun 17, 2014 at 5:58 PM, Jack Wang <xjtuwjp@gmail.com> wrote:
> On 06/17/2014 01:15 PM, Maurizio Lombardi wrote:
>> The pm8001_get_phy_settings_info() function does not check
>> the kzalloc() return value and does not free the allocated memory.
>>
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>
> Looks good, thanks
> Acked-by: Jack Wang <xjtuwjp@gmail.com>
Looks good, Thanks Maurizio
Acked-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>> ---
>>  drivers/scsi/pm8001/pm8001_init.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
>> index c4f31b21..e90c89f 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -677,7 +677,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>>   * pm8001_get_phy_settings_info : Read phy setting values.
>>   * @pm8001_ha : our hba.
>>   */
>> -void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>> +static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>>  {
>>
>>  #ifdef PM8001_READ_VPD
>> @@ -691,11 +691,15 @@ void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>>       payload.offset = 0;
>>       payload.length = 4096;
>>       payload.func_specific = kzalloc(4096, GFP_KERNEL);
>> +     if (!payload.func_specific)
>> +             return -ENOMEM;
>>       /* Read phy setting values from flash */
>>       PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
>>       wait_for_completion(&completion);
>>       pm8001_set_phy_profile(pm8001_ha, sizeof(u8), payload.func_specific);
>> +     kfree(payload.func_specific);
>>  #endif
>> +     return 0;
>>  }
>>
>>  #ifdef PM8001_USE_MSIX
>> @@ -879,8 +883,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>>       pm8001_init_sas_add(pm8001_ha);
>>       /* phy setting support for motherboard controller */
>>       if (pdev->subsystem_vendor != PCI_VENDOR_ID_ADAPTEC2 &&
>> -             pdev->subsystem_vendor != 0)
>> -             pm8001_get_phy_settings_info(pm8001_ha);
>> +             pdev->subsystem_vendor != 0) {
>> +             rc = pm8001_get_phy_settings_info(pm8001_ha);
>> +             if (rc)
>> +                     goto err_out_shost;
>> +     }
>>       pm8001_post_sas_ha_init(shost, chip);
>>       rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>>       if (rc)
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
