From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH/RESEND V6 13/18] scsi: ufs: refactor configuring power mode
Date: Fri, 3 Oct 2014 09:42:35 -0700
Message-ID: <001001cfdf29$098de0e0$1ca9a2a0$@codeaurora.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>	<1411648356-3883-14-git-send-email-draviv@codeaurora.org> <CAC5umyjk=ugd58B4FXg+c3-Y1ZE0gLLKVMHepC7y+fHDWF=1ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyjk=ugd58B4FXg+c3-Y1ZE0gLLKVMHepC7y+fHDWF=1ZQ@mail.gmail.com>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Akinobu Mita' <akinobu.mita@gmail.com>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: 'Jej B' <James.Bottomley@hansenpartnership.com>, 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, 'Santosh Y' <santoshsy@gmail.com>, 'Yaniv Gardi' <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

> If the UFS Power management level 5 is chosen, the UIC link is down during suspend.  And the power mode should be configured during resume again.  Unfortunately, it will not be configured because the above condition hits unintentionally.

Yes, it seems a bug.

> I would like to propose a fix which changes the type of hba->pwr_info to struct ufs_pwr_mode_info, and turn off hba->pwr_info.is_valid when UIC link is down and add check for hba->pwr_info.is_valid in above condition.

Agreed, Please send your fix on git://git.infradead.org/users/hch/scsi-queue.git -b drivers-for-3.18.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Akinobu Mita
Sent: Friday, October 03, 2014 9:20 AM
To: Dolev Raviv
Cc: Jej B; Christoph Hellwig; linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org; linux-arm-msm@vger.kernel.org; Santosh Y; Yaniv Gardi
Subject: Re: [PATCH/RESEND V6 13/18] scsi: ufs: refactor configuring power mode

2014-09-25 21:32 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:

> +int ufshcd_change_power_mode(struct ufs_hba *hba,
> +                            struct ufs_pa_layer_attr *pwr_mode) {
> +       int ret;
> +
> +       /* if already configured to the requested pwr_mode */
> +       if (pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
> +           pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
> +           pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
> +           pwr_mode->lane_tx == hba->pwr_info.lane_tx &&
> +           pwr_mode->pwr_rx == hba->pwr_info.pwr_rx &&
> +           pwr_mode->pwr_tx == hba->pwr_info.pwr_tx &&
> +           pwr_mode->hs_rate == hba->pwr_info.hs_rate) {
> +               dev_dbg(hba->dev, "%s: power already configured\n", __func__);
> +               return 0;
>         }

If the UFS Power management level 5 is chosen, the UIC link is down during suspend.  And the power mode should be configured during resume again.  Unfortunately, it will not be configured because the above condition hits unintentionally.

I would like to propose a fix which changes the type of hba->pwr_info to struct ufs_pwr_mode_info, and turn off hba->pwr_info.is_valid when UIC link is down and add check for hba->pwr_info.is_valid in above condition.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
