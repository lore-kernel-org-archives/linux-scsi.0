From: Don Brace <brace77070@gmail.com>
Subject: Re: [patch] hpsa: logical vs bitwise AND typo
Date: Thu, 12 Nov 2015 09:33:02 -0600
Message-ID: <5644B12E.4040506@pmcs.com>
References: <20151112094338.GB28432@mwanda> <1447322361.2616.10.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1447322361.2616.10.camel@suse.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, Scott Teel <scott.teel@pmcs.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/12/2015 03:59 AM, Johannes Thumshirn wrote:
> On Thu, 2015-11-12 at 12:43 +0300, Dan Carpenter wrote:
>> HPSA_DIAG_OPTS_DISABLE_RLD_CACHING is a mask and bitwise AND was
>> intended here instead of logical &&.  This bug is essentially
>> harmless,
>> it means that sometimes we don't print a warning message which we
>> wanted
>> to print.
>>
>> Fixes: c2adae44e916 ('hpsa: disable report lun data caching')
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 6a8f958..a386036 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -8671,7 +8671,7 @@ static void hpsa_disable_rld_caching(struct
>> ctlr_info *h)
>>   	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
>>   		goto errout;
>>   
>> -	if (*options && HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
>> +	if (*options & HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
>>   		goto out;
>>   
>>   errout:
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

