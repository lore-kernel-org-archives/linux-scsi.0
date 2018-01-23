From: weiping zhang <zwp10758@gmail.com>
Subject: Re: [PATCH v2] scsi: sd: add new match array for cache_type
Date: Tue, 23 Jan 2018 22:32:21 +0800
Message-ID: <CAA70yB5fsJCLYKzQqbEgobzRPGc88mzDYhgSM-UUimNx_SxvMQ@mail.gmail.com>
References: <20180118141928.GA28320@bogon.didichuxing.com> <yq17eseo9j6.fsf@oracle.com>
 <CAA70yB4EfEywgi-MTJg8b4jhGU_iOCH4UZe7vuA3WBjxz3Hw6g@mail.gmail.com> <yq11sihjucs.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35675 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbeAWOcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 09:32:23 -0500
Received: by mail-wm0-f45.google.com with SMTP id r78so2335174wme.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2018 06:32:23 -0800 (PST)
In-Reply-To: <yq11sihjucs.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: weiping zhang <zhangweiping@didichuxing.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

2018-01-23 8:23 GMT+08:00 Martin K. Petersen <martin.petersen@oracle.com>:
>
> Hi Weiping,
>
>> currently, there are four combinations as following: "write through",
>> "none", "write back", "write back, no read (daft)"
>>
>> cache_type can control both write and read cache, but for "write
>> through" and "write back" we can not know clearly how to control the
>> read cache.
>
> That's what I meant by using the term "arcane" and alluding to the fact
> that this interface is not well enough documented.
>
>> I prefer use words like"w0r1", "w0r0", "w1r1", "w1r0", that "1" means
>> enable, "0" means disable. The user know clearly what they are doing
>> when typing these short words.
>
> We can't change the existing interface without breaking stuff. We can
> entertain adding stuff, but I do think that a better solution is to
> document what's there so the effect of echoing each of the following
> strings becomes crystal clear:
>
OK, I'll add more detail comments for these words, but I prefer add new
stuff like "w0r1", for old user script keep using "write back", for new script
users can also use "w1r1".

> static const char *sd_cache_types[] = {
>         "write through", "none", "write back",
>         "write back, no read (daft)"
> };
>
> I would also like to see the "temporary" string documented.

OK, add it in V3.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
