From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V3 11/16] scsi: ufs: refactor configuring power mode
Date: Mon, 15 Sep 2014 11:10:46 -0000
Message-ID: <f8e2562174ccf1080eff0912c6a3191b.squirrel@www.codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
    <1410350063-23267-12-git-send-email-draviv@codeaurora.org>
    <CAC5umyh4n9+2mRg-q+yjnmPuxVM5q+qKcY67EdGe7-pCst249A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyh4n9+2mRg-q+yjnmPuxVM5q+qKcY67EdGe7-pCst249A@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


> 2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
>> +static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>> +               struct ufs_pa_layer_attr *desired_pwr_mode)
>> +{
>> +       struct ufs_pa_layer_attr final_params = { 0 };
>> +       int ret;
>> +
>> +       if (hba->vops->pwr_change_notify)
>
> If hba->vops is null as no vendor specific callbacks, this causes
> a null pointer dereference.  So null check for hba->vops is also needed
> just like other callbacks.

Sure, will fix both.

>
>> +               hba->vops->pwr_change_notify(hba,
>> +                    PRE_CHANGE, desired_pwr_mode, &final_params);
>> +       else
>> +               memcpy(&final_params, desired_pwr_mode,
>> sizeof(final_params));
>> +
>>         /*
>>          * Configure attributes for power mode change with below.
>>          * - PA_RXGEAR, PA_ACTIVERXDATALANES, PA_RXTERMINATION,
>>          * - PA_TXGEAR, PA_ACTIVETXDATALANES, PA_TXTERMINATION,
>>          * - PA_HSSERIES
>>          */
>> -       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), gear[RX]);
>> -       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES),
>> lanes[RX]);
>> -       if (pwr[RX] == FASTAUTO_MODE)
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR),
>> final_params.gear_rx);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES),
>> +                       final_params.lane_rx);
>> +       if (final_params.pwr_rx == FASTAUTO_MODE ||
>> +                       final_params.pwr_rx == FAST_MODE)
>>                 ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION),
>> TRUE);
>> +       else
>> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION),
>> FALSE);
>>
>> -       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), gear[TX]);
>> -       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
>> lanes[TX]);
>> -       if (pwr[TX] == FASTAUTO_MODE)
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR),
>> final_params.gear_tx);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
>> +                       final_params.lane_tx);
>> +       if (final_params.pwr_tx == FASTAUTO_MODE ||
>> +                       final_params.pwr_tx == FAST_MODE)
>>                 ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION),
>> TRUE);
>> -
>> -       if (pwr[RX] == FASTAUTO_MODE || pwr[TX] == FASTAUTO_MODE)
>> -               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
>> PA_HS_MODE_B);
>> -
>> -       ret = ufshcd_uic_change_pwr_mode(hba, pwr[RX] << 4 | pwr[TX]);
>> -       if (ret)
>> +       else
>> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION),
>> FALSE);
>> +
>> +       if ((final_params.pwr_rx == FASTAUTO_MODE ||
>> +                       final_params.pwr_tx == FASTAUTO_MODE ||
>> +                       final_params.pwr_rx == FAST_MODE ||
>> +                       final_params.pwr_tx == FAST_MODE) &&
>> +                       final_params.hs_rate == PA_HS_MODE_B)
>> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
>> +                               final_params.hs_rate);
>> +
>> +       ret = ufshcd_uic_change_pwr_mode(hba, final_params.pwr_rx << 4
>> +                       | final_params.pwr_tx);
>> +       if (ret) {
>>                 dev_err(hba->dev,
>>                         "pwr_mode: power mode change failed %d\n", ret);
>> +       } else {
>> +               if (hba->vops->pwr_change_notify)
>
> Ditto.
>
>> +                       hba->vops->pwr_change_notify(hba,
>> +                               POST_CHANGE, NULL, &final_params);
>> +
>> +               memcpy(&hba->pwr_info, &final_params,
>> sizeof(final_params));
>> +       }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
