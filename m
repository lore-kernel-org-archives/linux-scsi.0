From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: check link active or not after switch to HS
 mode
Date: Wed, 28 Jun 2017 16:48:21 -0700
Message-ID: <0c41133960c09f1aac4c0abeb38afbfd@codeaurora.org>
References: <20170624114405.18475-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdF1XsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 19:48:23 -0400
In-Reply-To: <20170624114405.18475-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-06-24 04:44, Zang Leigang wrote:
> Some device can successfully link and switch to HS mode. But failed
> to do more. ufshcd_verify_dev_init can help to find this earlier.
> 
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ffe8d8608818..eb03388fc4bd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6373,6 +6373,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  					__func__, ret);
>  			goto out;
>  		}
> +
> +		/*
> +		 * Some device lost link after switch to HS mode. Check if
> +		 * connect is established here.
> +		 */

I have never across such failures. If this issue is limited to certain 
device vendors then I don't think if we want to do send NOP 
unconditionally for all the devices.
We should probably add quirk for these failed devices and send NOP only 
for such devices.


> +		ret = ufshcd_verify_dev_init(hba);
> +		if (ret)
> +			goto out;
>  	}
> 
>  	/* set the state as operational after switching to desired gear */

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
