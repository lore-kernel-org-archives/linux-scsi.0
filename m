From: Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: Re: [PATCH V3 12/16] scsi: ufs: Add support for clock gating
Date: Thu, 18 Sep 2014 18:35:39 +0530
Message-ID: <541AD8A3.2060305@smartplayin.com>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org> <1410350063-23267-13-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1410350063-23267-13-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sahitya Tummala <stummala@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 10 September 2014 05:24 PM, Dolev Raviv wrote:
> From: Sahitya Tummala <stummala@codeaurora.org>
> 
> The UFS controller clocks can be gated after certain period of
> inactivity, which is typically less than runtime suspend timeout.
> In addition to clocks the link will also be put into Hibern8 mode
> to save more power.
> 

<snip>

>  
> @@ -1902,12 +2149,16 @@ out:
>  static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
>  {
>  	struct uic_command uic_cmd = {0};
> +	int ret;
>  
>  	uic_cmd.command = UIC_CMD_DME_SET;
>  	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
>  	uic_cmd.argument3 = mode;
> -
> -	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> +	ufshcd_hold(hba, false);
> +	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> +	ufshcd_release(hba);
> +out:

May be you can remove this label because it is not used anywhere.

> +	return ret;
>  }
>  
>  static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
> @@ -2306,6 +2557,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
>  	int err = 0;
>  	int retries;
>  
> +	ufshcd_hold(hba, false);
>  	mutex_lock(&hba->dev_cmd.lock);
>  	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
>  		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
> @@ -2317,6 +2569,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
>  		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
>  	}
>  	mutex_unlock(&hba->dev_cmd.lock);
> +	ufshcd_release(hba);
>  

Thanks,
--Kiran
