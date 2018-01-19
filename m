From: weiping zhang <zwp10758@gmail.com>
Subject: Re: [PATCH v2] scsi: sd: add new match array for cache_type
Date: Fri, 19 Jan 2018 12:46:13 +0800
Message-ID: <CAA70yB4EfEywgi-MTJg8b4jhGU_iOCH4UZe7vuA3WBjxz3Hw6g@mail.gmail.com>
References: <20180118141928.GA28320@bogon.didichuxing.com> <yq17eseo9j6.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36122 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbeASEqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jan 2018 23:46:15 -0500
Received: by mail-wm0-f45.google.com with SMTP id f3so1005265wmc.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 20:46:14 -0800 (PST)
In-Reply-To: <yq17eseo9j6.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: weiping zhang <zhangweiping@didichuxing.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

2018-01-19 10:41 GMT+08:00 Martin K. Petersen <martin.petersen@oracle.com>:
>
> Hi Weiping,
>
>> Add user friendly command strings sd_wce_rcd to enable/disable
>> write&read cache. User can enable both write and read cache by one of
>> the following commands:
>
> I am not entirely sure what the rationale is behind your patch. Is there
> some deficiency in the existing cache control interface that you are
> trying to address? Or is the problem simply that it is poorly
> documented?

Hi Marin,

currently, there are four combinations as following:
"write through", "none", "write back", "write back, no read (daft)"

cache_type can control both write and read cache, but for "write through" and
"write back" we can not know clearly how to control the read cache.

I prefer use words like"w0r1", "w0r0", "w1r1", "w1r0", that "1" means
enable, "0"
means disable. The user know clearly what they are doing when typing
these short words.

Hi James,

> I don't think we can do this.  The output of the cache type in sysfs is
> a user exported ABI.  We'd potentially break it if we add extra stuff.

If so, I'll not change the output, only add new match array.

> --
> Martin K. Petersen      Oracle Linux Engineering
