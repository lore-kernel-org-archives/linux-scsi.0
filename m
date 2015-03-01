From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v3 2/4] scsi: ufs: add debugfs for ufs
Date: Sun, 1 Mar 2015 08:29:39 -0000
Message-ID: <721fb67352e3cefe26a4fda6d2b289fe.squirrel@codeaurora.org>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
    <1424678898-3723-3-git-send-email-gbroner@codeaurora.org>
    <CAC5umygAXRyJmLPEFSTKKneicPZD4m=_RbkDfwQKoX3fvCP1Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umygAXRyJmLPEFSTKKneicPZD4m=_RbkDfwQKoX3fvCP1Dw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gilad Broner <gbroner@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

>> +#define UFSHCD_UPDATE_TAG_STATS(hba, tag)
>> +#define UFSHCD_UPDATE_TAG_STATS_COMPLETION(hba, cmd)
>> +#define UFSHCD_UPDATE_ERROR_STATS(hba, type)
>> +
>> +#endif
>
> Is there any reason that these are defined as macros instead of
> static functions?

No special reason that I'm aware of. I will convert those to functions.


>>  out_remove_scsi_host:
>> @@ -5769,6 +5969,7 @@ exit_gating:
>>  out_disable:
>>         hba->is_irq_enabled = false;
>>         scsi_host_put(host);
>> +       ufsdbg_remove_debugfs(hba);
>>         ufshcd_hba_exit(hba);
>>  out_error:
>>         return err;
>
> This ufsdbg_remove_debugfs() call on error path of ufshcd_init() is
> unnecessary.  Because ufsdbg_add_debugfs() is called at the last of
> ufshcd_init() and can't fail.
>

I will fix this in the next patchset.


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
