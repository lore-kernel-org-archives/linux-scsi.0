From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3 6/6] scsi: ufs: configure the attribute for power mode
Date: Tue, 27 Aug 2013 15:57:38 +0530
Message-ID: <521C7F1A.5060205@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com> <003b01cea26a$48ffa670$dafef350$%jun@samsung.com> <521C7DA9.1080602@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53149 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3H0K1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2013 06:27:45 -0400
In-Reply-To: <521C7DA9.1080602@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

On 8/27/2013 3:51 PM, Subhash Jadavani wrote:
> On 8/26/2013 8:11 PM, Seungwon Jeon wrote:
>> UIC attributes can be set with using DME_SET command for
>> power mode change. For configuration the link capability
>> attributes are used, which is updated after successful
>> link startup.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c |   66 
>> +++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/scsi/ufs/unipro.h |   21 ++++++++++++++
>>   2 files changed, 87 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c67118d..2ae845c 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1598,6 +1598,70 @@ out:
>>   }
>>     /**
>> + * ufshcd_config_max_pwr_mode - Set & Change power mode with
>> + *    maximum capability attribute information.
>> + * @hba: per adapter instance
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int ufshcd_config_max_pwr_mode(struct ufs_hba *hba)
>> +{
>> +    enum {RX = 0, TX = 1};
>> +    u32 lanes[] = {1, 1};
>> +    u32 gear[] = {1, 1};
>> +    u8 pwr[] = {FASTAUTO_MODE, FASTAUTO_MODE};
>> +    int ret;
>> +
>> +    /* Get the connected lane count */
>> +    ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), 
>> &lanes[RX]);
>> +    ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), 
>> &lanes[TX]);
>> +
>> +    /*
>> +     * First, get the maximum gears of HS speed.
>> +     * If a zero value, it means there is no HSGEAR capability.
>> +     * Then, get the maximum gears of PWM speed.
>> +     */
>> +    ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[RX]);
>> +    if (!gear[RX]) {
>> +        ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR), &gear[RX]);
>> +        pwr[RX] = SLOWAUTO_MODE;
>> +    }
> As per UniPro specification, PA_MaxRxHsGear valid values are 0 (NO, 
> HS), 1 (HS_Gear1), 2 (HS_Gear2) & 3 (HS_Gear3). But UFS device 
> specification (v1.1) only mandates to support Gear-1 and Gear-2 is 
> optional. Gear-3 is no where mentioned in the specifcation so it means 
> unsupported gear. So i guess after reading PA_MaxRxHsGear attribute, 
> we have to ensure that we only set the Gear-1 or Gear-2 as mandated by 
> UFS 1.1 spec.
>
> Also, for PA_MaxRxPWMGear both UniPro and UFS device specification 
> support the gear-1 to gear-7. so i guess we should have some safely 
> check to ensure that gear is not 0 or greater than 7.

Sorry, please ignore this comment. PA_MaxRxHsGear and PA_MaxRxPWMGear 
are automatically updated after the capability negotiation between host 
and device during link start up so they must be supporting the mutually 
agreed gears.
>
>> +
>> +    ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[TX]);
>> +    if (!gear[TX]) {
>> +        ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
>> +                    &gear[TX]);
>> +        pwr[TX] = SLOWAUTO_MODE;
>> +    }
>> +
>> +    /*
>> +     * Configure attributes for power mode change with below.
>> +     * - PA_RXGEAR, PA_ACTIVERXDATALANES, PA_RXTERMINATION,
>> +     * - PA_TXGEAR, PA_ACTIVETXDATALANES, PA_TXTERMINATION,
>> +     * - PA_HSSERIES
>> +     */
>> +    ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), gear[RX]);
>> +    ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES), lanes[RX]);
>> +    if (pwr[RX] == FASTAUTO_MODE)
>> +        ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
>> +
>> +    ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), gear[TX]);
>> +    ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES), lanes[TX]);
>> +    if (pwr[TX] == FASTAUTO_MODE)
>> +        ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
>> +
>> +    if (pwr[RX] == FASTAUTO_MODE || pwr[TX] == FASTAUTO_MODE)
>> +        ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES), PA_HS_MODE_B);
>> +
>> +    ret = ufshcd_uic_change_pwr_mode(hba, pwr[RX] << 4 | pwr[TX]);
>> +    if (ret)
>> +        dev_err(hba->dev,
>> +            "pwr_mode: power mode change failed %d\n", ret);
> I guess it would be helpful to print the powermode, Gear, Lanes & Rate 
> information after error. Also, i guess the gear change is one time 
> operation, won't it be useful to print this information so we know 
> what is the host-device configuration?

This is just a debug enhancement so its upto you whether you want to fix 
it now or not. In any case, you will still have my Reviewed-by: Subhash 
Jadavani <subhashj@codeauora.org>

>
>> +
>> +    return ret;
>> +}
>> +
>> +/**
>>    * ufshcd_complete_dev_init() - checks device readiness
>>    * hba: per-adapter instance
>>    *
>> @@ -2942,6 +3006,8 @@ static void ufshcd_async_scan(void *data, 
>> async_cookie_t cookie)
>>       if (ret)
>>           goto out;
>>   +    ufshcd_config_max_pwr_mode(hba);
>> +
>>       ret = ufshcd_verify_dev_init(hba);
>>       if (ret)
>>           goto out;
>> diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
>> index 3a710eb..0bb8041 100644
>> --- a/drivers/scsi/ufs/unipro.h
>> +++ b/drivers/scsi/ufs/unipro.h
>> @@ -72,6 +72,21 @@
>>   #define PA_STALLNOCONFIGTIME    0x15A3
>>   #define PA_SAVECONFIGTIME    0x15A4
>>   +/* PA power modes */
>> +enum {
>> +    FAST_MODE    = 1,
>> +    SLOW_MODE    = 2,
>> +    FASTAUTO_MODE    = 4,
>> +    SLOWAUTO_MODE    = 5,
>> +    UNCHANGED    = 7,
>> +};
>> +
>> +/* PA TX/RX Frequency Series */
>> +enum {
>> +    PA_HS_MODE_A    = 1,
>> +    PA_HS_MODE_B    = 2,
>> +};
>> +
>>   /*
>>    * Data Link Layer Attributes
>>    */
>> @@ -127,4 +142,10 @@
>>   #define T_TC0TXMAXSDUSIZE    0x4060
>>   #define T_TC1TXMAXSDUSIZE    0x4061
>>   +/* Boolean attribute values */
>> +enum {
>> +    FALSE = 0,
>> +    TRUE,
>> +};
>> +
>>   #endif /* _UNIPRO_H_ */
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

