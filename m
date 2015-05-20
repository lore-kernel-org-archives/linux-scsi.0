From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 2/3] scsi: ufs-qcom: fix compilation warning if
 compiled as a module
Date: Wed, 20 May 2015 13:49:50 -0000
Message-ID: <77d452918f9dad547ddf728022f82fb0.squirrel@www.codeaurora.org>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
    <1432043231-31102-3-git-send-email-ygardi@codeaurora.org>
    <1432110592.21715.50.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1432110592.21715.50.camel@x220>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> On Tue, 2015-05-19 at 16:47 +0300, Yaniv Gardi wrote:
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -885,7 +885,7 @@ out:
>>
>>  #define	ANDROID_BOOT_DEV_MAX	30
>>  static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
>> -static int get_android_boot_dev(char *str)
>> +static int __maybe_unused get_android_boot_dev(char *str)
>>  {
>>  	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
>>  	return 1;
>
> Wouldn't it be clearer to wrap these few lines (until after the
> __setup() macro) with #ifndef MODULE?
>
> And I think get_android_boot_dev() could be marked __init. Because if
> it's built-in it will never be called after the kernel has finished
> booting, right?
>

That's correct. I will upload an update to this patch.
I accept both comments
#ifndef MODULE is indeed clearer
and __init flag as well, since get_android_boot_dev() will not be called
again after booting finished.

>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
