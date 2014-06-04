From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c: Cleaning up missing
 null-terminate after strncpy call
Date: Thu, 5 Jun 2014 00:25:49 +0200
Message-ID: <CAFo99gaC_D=RbvTRbkSCsxUF7AWpbENEt63+gisdi5z=YL_t+Q@mail.gmail.com>
References: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1401919283.26329.7.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60307 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaFDWZu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 18:25:50 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so175950obc.39
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2014 15:25:49 -0700 (PDT)
In-Reply-To: <1401919283.26329.7.camel@joe-AO725>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi

A little embarrassing, but I actually did not know that there was a
better replacement for strncpy.

Sorry, but I will send a new platch based on strlcpy instead then.

Will investigate cover letter then to.


Best regards
Rickard Strandqvist


2014-06-05 0:01 GMT+02:00 Joe Perches <joe@perches.com>:
> On Wed, 2014-06-04 at 23:36 +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>
> Next time you submit a patch series like this
> can you please use a cover letter?
>
> That way I can reply to the cover letter with
> a comment about the series instead of multiple
> replies to various patches.
>
> I think all of these should be using strlcpy not
> strncpy.
>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> []
>> @@ -2097,7 +2097,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>>       u32 bios_version;
>>
>>       bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
>> -     strncpy(desc, ioc->manu_pg0.ChipName, 16);
>> +     strncpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
>> +     desc[sizeof(desc) - 1] = '\0';
>
>
