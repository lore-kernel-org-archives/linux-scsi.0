From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1 12/12] scsi: ufs: Improve fatal error logs
Date: Mon, 12 Dec 2016 17:38:54 -0800
Message-ID: <95884c970ff59a6421272cac13264483@codeaurora.org>
References: <1481590599-17765-1-git-send-email-subhashj@codeaurora.org>
 <1481591985.29291.15.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45512 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752999AbcLMBiz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 20:38:55 -0500
In-Reply-To: <1481591985.29291.15.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, open list <linux-kernel@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On 2016-12-12 17:19, Joe Perches wrote:
> On Mon, 2016-12-12 at 16:56 -0800, Subhash Jadavani wrote:
>> Errors such as UIC error, illegal OCS values, and others may require
>> more information for debugging. Such information could be hibern8 
>> events,
>> events sequences, recoverable errors, error history, and more.
> []
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> []
>> @@ -346,6 +346,37 @@ static inline void 
>> ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
> []
>> +static void ufshcd_print_uic_err_hist(struct ufs_hba *hba,
>> +		struct ufs_uic_err_reg_hist *err_hist, char *err_name)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < UIC_ERR_REG_HIST_LENGTH; i++) {
>> +		int p = (i + err_hist->pos - 1) % UIC_ERR_REG_HIST_LENGTH;
>> +
>> +		if (err_hist->reg[p] == 0)
>> +			continue;
>> +		dev_err(hba->dev, "%s[%d] = 0x%x at %lld us", err_name, i,
>> +			err_hist->reg[p], ktime_to_us(err_hist->tstamp[p]));
> 
> Please consistently use a terminating \n

Sure, will do that. Thanks.

> 
>> +	}
>> +}
>> +
>>  static void ufshcd_print_host_regs(struct ufs_hba *hba)
>>  {
>>  	/*
>> @@ -362,6 +393,21 @@ static void ufshcd_print_host_regs(struct ufs_hba 
>> *hba)
>>  	dev_err(hba->dev,
>>  		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x",
>>  		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
>> +	dev_err(hba->dev,
>> +		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d",
> 
> etc...
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
