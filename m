From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 8/8] scsi: ufs-qcom: add QUniPro hardware support and
 power optimizations
Date: Thu, 20 Aug 2015 13:31:30 -0000
Message-ID: <1684abfb98b709024bf68a9507ba99a2.squirrel@www.codeaurora.org>
References: <1439720057-9186-1-git-send-email-ygardi@codeaurora.org>
    <1439720057-9186-9-git-send-email-ygardi@codeaurora.org>
    <CAC5umyhquEQh8O=8cz8xKTEzUcD3wKAiLd5RNzAMzEL6C9GWUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyhquEQh8O=8cz8xKTEzUcD3wKAiLd5RNzAMzEL6C9GWUA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Thank you Mita for the review.
Your comments were correct and helpful.
I appreciate your time and effort.

please see inline.

> 2015-08-16 19:14 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> @@ -1208,6 +1510,7 @@ static struct ufs_hba_variant_ops
>> ufs_hba_qcom_vops = {
>>         .resume                 = ufs_qcom_resume,
>>         .dbg_register_dump      = ufs_qcom_dump_dbg_regs,
>>  };
>> +EXPORT_SYMBOL(ufs_hba_qcom_vops);
>
> As I said in the view comment for the patch 5, this shouldn't be exported
> again.

I removed this export at all. it is not needed anymore.

>
>> @@ -775,6 +781,12 @@ static inline int ufshcd_vops_resume(struct ufs_hba
>> *hba, enum ufs_pm_op op)
>>         return 0;
>>  }
>>
>> +static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
>> +{
>> +       if (hba->vops && hba->vops->dbg_register_dump)
>> +               hba->vops->dbg_register_dump(hba);
>> +}
>> +
>
> This change should be done in the patch 7?

you are correct.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
