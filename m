From: merez@codeaurora.org
Subject: Re: [PATCH 1/5] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Wed, 1 May 2013 00:46:13 -0700
Message-ID: <834f89cbe5f4830db1547ed8fbcff7c2.squirrel@www.codeaurora.org>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
    <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
    <517FA84B.2070009@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22164 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3EAHqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 May 2013 03:46:14 -0400
In-Reply-To: <517FA84B.2070009@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

Tested-by: Maya Erez <merez@codeaurora.org>

>
> Looks good. Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>
> On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
>> Move the ufshcd_hba_stop from header file.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> ---
>>  drivers/scsi/ufs/ufshcd.c |    9 +++++++++
>>  drivers/scsi/ufs/ufshcd.h |    9 ---------
>>  2 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 60fd40c..41b9639 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -285,6 +285,15 @@ static inline void ufshcd_hba_start(struct ufs_hba
>> *hba)
>>  }
>>
>>  /**
>> + * ufshcd_hba_stop - Send controller to reset state
>> + * @hba: per adapter instance
>> + */
>> +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
>> +{
>> +	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
>> +}
>> +
>> +/**
>>   * ufshcd_is_hba_active - Get controller state
>>   * @hba: per adapter instance
>>   *
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 6b99a42..1680394 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -190,13 +190,4 @@ int ufshcd_init(struct device *, struct ufs_hba **
>> , void __iomem * ,
>>  			unsigned int);
>>  void ufshcd_remove(struct ufs_hba *);
>>
>> -/**
>> - * ufshcd_hba_stop - Send controller to reset state
>> - * @hba: per adapter instance
>> - */
>> -static inline void ufshcd_hba_stop(struct ufs_hba *hba)
>> -{
>> -	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
>> -}
>> -
>>  #endif /* End of Header */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

