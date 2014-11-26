From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH -next] scsi: ufs: don't kfree() devm_kzalloc()'ed memory
Date: Thu, 27 Nov 2014 01:11:47 +0900
Message-ID: <CAC5umyhb=dpQVP3UhdKNXFUfQtoiH3E_4qNe76aeM0+wO-LOUg@mail.gmail.com>
References: <1417016257-9693-1-git-send-email-akinobu.mita@gmail.com>
	<1417017089.2202.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:62921 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaKZQLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2014 11:11:49 -0500
Received: by mail-la0-f50.google.com with SMTP id pn19so1984174lab.9
        for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2014 08:11:47 -0800 (PST)
In-Reply-To: <1417017089.2202.3.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Christoph Hellwig <hch@lst.de>

2014-11-27 0:51 GMT+09:00 James Bottomley
<James.Bottomley@hansenpartnership.com>:
> On Thu, 2014-11-27 at 00:37 +0900, Akinobu Mita wrote:
>> In ufshcd_parse_clock_info(), temporary memory allocated by
>> devm_kzalloc() is released by kfree().  The devres mechanism cannot
>> track the release and it causes trouble when removing the driver.
>>
>> Fix it by allocating it with plain kcalloc() instead of devm_kzalloc()
>> as the temporary memory is always freed in that function.
>>
>> Signed-off-by: Akinobu Mita <mita@fixstars.com>
>> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
>> Cc: Dolev Raviv <draviv@codeaurora.org>
>> Cc: Subhash Jadavani <subhashj@codeaurora.org>
>> Cc: Yaniv Gardi <ygardi@codeaurora.org>
>> Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
>> Cc: Maya Erez <merez@codeaurora.org>
>> Cc: Sahitya Tummala <stummala@codeaurora.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: linux-scsi@vger.kernel.org
>> ---
>>  drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> index 0c030ad..67b1f6c 100644
>> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> @@ -99,8 +99,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
>>               goto out;
>>       }
>>
>> -     clkfreq = devm_kzalloc(dev, sz * sizeof(*clkfreq),
>> -                     GFP_KERNEL);
>> +     clkfreq = kcalloc(sz, sizeof(*clkfreq), GFP_KERNEL);
>
> I agree this doesn't need to be devm memory since it's copied into clki,
> but where is it freed?  I think you need a kfree(clkfreq) at the bottom
> of the routine.

Oops.  I was working on the older code, and blindly applied the -next just
before sending this patch.  The problem I said in this commit log has been
fixed by the commit e8cb64db81e8c88c5c824ca74c2e57b4c6919ca6 ("scsi: ufs:
fix static checker warning in ufshcd_parse_clock_info").

So I withdraw this patch for now.  I will try with another title next time.
