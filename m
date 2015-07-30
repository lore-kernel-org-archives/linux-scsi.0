From: Viswas G <Viswas.G@pmcs.com>
Subject: RE: [PATCH 2/8] pm80xx: Corrected device state changes in
 I_T_Nexus_Reset
Date: Thu, 30 Jul 2015 06:17:07 +0000
Message-ID: <DB8BCD22E410A84DA91083F3479A3DB3C627511D@BBYEXM02.pmc-sierra.internal>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
 <1438151240-4097-3-git-send-email-Viswas.G@pmcs.com>
 <55B8FAE3.3010801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48501 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbbG3GRM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2015 02:17:12 -0400
In-Reply-To: <55B8FAE3.3010801@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>



On Wed, Jul 29, 2015 at 9:40 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 29.7.2015 08:27, Viswas.G@pmcs.com wrote:
>> From: Viswas G <Viswas.G@pmcs.com>
>>
>> In Nexus reset the device state set to DS_IN_RECOVERY before doing
>> phy reset and internal cleanup. Once internal cleanup finishes,
>> the device state will set to DS_OPERATIONAL.
>>
>> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
>> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>> ---
>>  drivers/scsi/pm8001/pm8001_sas.c |   14 +++++++++++---
>>  drivers/scsi/pm8001/pm8001_sas.h |    8 ++++++++
>>  2 files changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
>> index b93f289..4e6955f 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.c
>> +++ b/drivers/scsi/pm8001/pm8001_sas.c
>> @@ -980,13 +980,21 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
>>                       rc = 0;
>>                       goto out;
>>               }
>> +             pm8001_dev->setds_completion = &completion_setstate;
>> +             PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
>> +                     pm8001_dev, DS_IN_RECOVERY);
>> +             wait_for_completion(&completion_setstate);
>>               rc = sas_phy_reset(phy, 1);
>>               msleep(2000);
>> +             if (rc) {
>> +                     PM8001_EH_DBG(pm8001_ha,
>> +                     pm8001_printk("phy reset failed for device %x\n"
>> +                     "with rc %d\n", pm8001_dev->device_id, rc));
>> +             }
>>               rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
>>                       dev, 1, 0);
>> -             pm8001_dev->setds_completion = &completion_setstate;
>> -             rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
>> -                     pm8001_dev, 0x01);
>> +             PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
>> +                     pm8001_dev, DS_OPERATIONAL);
> Hi Viswas,
> the set_dev_state_req can't fail any more ? Also the
> pm8001_exec_internal_task_abort may fail - shouldn't
> be error handling also added ?
> Cheers,
> Tomas

Hi  Tomas,

The set_dev_state can fail if the ccb/Inbound queue slot is not available. It can happen
If there are more than 256 requests are penning with controller.
Internal task abort failure also can be handled. Will resent the patch with these changes.

Regards,
Viswas G
 

>>               wait_for_completion(&completion_setstate);
>>       } else {
>>               rc = sas_phy_reset(phy, 1);
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
>> index 8dd8b78..c9736cc 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.h
>> +++ b/drivers/scsi/pm8001/pm8001_sas.h
>> @@ -569,6 +569,14 @@ struct pm8001_fw_image_header {
>>  #define      NCQ_READ_LOG_FLAG                       0x80000000
>>  #define      NCQ_ABORT_ALL_FLAG                      0x40000000
>>  #define      NCQ_2ND_RLE_FLAG                        0x20000000
>> +
>> +/* Device states */
>> +#define DS_OPERATIONAL                               0x01
>> +#define DS_PORT_IN_RESET                     0x02
>> +#define DS_IN_RECOVERY                               0x03
>> +#define DS_IN_ERROR                          0x04
>> +#define DS_NON_OPERATIONAL                   0x07
>> +
>>  /**
>>   * brief param structure for firmware flash update.
>>   */
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Wednesday, July 29, 2015 9:40 PM
To: Viswas G; linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com; JBottomley@parallels.com; Suresh Thiagarajan
Subject: Re: [PATCH 2/8] pm80xx: Corrected device state changes in I_T_Nexus_Reset

On 29.7.2015 08:27, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
> 
> In Nexus reset the device state set to DS_IN_RECOVERY before doing phy 
> reset and internal cleanup. Once internal cleanup finishes, the device 
> state will set to DS_OPERATIONAL.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c |   14 +++++++++++---
>  drivers/scsi/pm8001/pm8001_sas.h |    8 ++++++++
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c 
> b/drivers/scsi/pm8001/pm8001_sas.c
> index b93f289..4e6955f 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -980,13 +980,21 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
>  			rc = 0;
>  			goto out;
>  		}
> +		pm8001_dev->setds_completion = &completion_setstate;
> +		PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> +			pm8001_dev, DS_IN_RECOVERY);
> +		wait_for_completion(&completion_setstate);
>  		rc = sas_phy_reset(phy, 1);
>  		msleep(2000);
> +		if (rc) {
> +			PM8001_EH_DBG(pm8001_ha,
> +			pm8001_printk("phy reset failed for device %x\n"
> +			"with rc %d\n", pm8001_dev->device_id, rc));
> +		}
>  		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
>  			dev, 1, 0);
> -		pm8001_dev->setds_completion = &completion_setstate;
> -		rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -			pm8001_dev, 0x01);
> +		PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> +			pm8001_dev, DS_OPERATIONAL);
Hi Viswas,
the set_dev_state_req can't fail any more ? Also the pm8001_exec_internal_task_abort may fail - shouldn't be error handling also added ?
Cheers,
Tomas
>  		wait_for_completion(&completion_setstate);
>  	} else {
>  		rc = sas_phy_reset(phy, 1);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h 
> b/drivers/scsi/pm8001/pm8001_sas.h
> index 8dd8b78..c9736cc 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -569,6 +569,14 @@ struct pm8001_fw_image_header {
>  #define	NCQ_READ_LOG_FLAG			0x80000000
>  #define	NCQ_ABORT_ALL_FLAG			0x40000000
>  #define	NCQ_2ND_RLE_FLAG			0x20000000
> +
> +/* Device states */
> +#define DS_OPERATIONAL				0x01
> +#define DS_PORT_IN_RESET			0x02
> +#define DS_IN_RECOVERY				0x03
> +#define DS_IN_ERROR				0x04
> +#define DS_NON_OPERATIONAL			0x07
> +
>  /**
>   * brief param structure for firmware flash update.
>   */
> 

