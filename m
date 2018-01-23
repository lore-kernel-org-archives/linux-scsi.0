From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: add new match array for cache_type
Date: Mon, 22 Jan 2018 19:23:47 -0500
Message-ID: <yq11sihjucs.fsf@oracle.com>
References: <20180118141928.GA28320@bogon.didichuxing.com>
        <yq17eseo9j6.fsf@oracle.com>
        <CAA70yB4EfEywgi-MTJg8b4jhGU_iOCH4UZe7vuA3WBjxz3Hw6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38084 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeAWAYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 19:24:00 -0500
In-Reply-To: <CAA70yB4EfEywgi-MTJg8b4jhGU_iOCH4UZe7vuA3WBjxz3Hw6g@mail.gmail.com>
        (weiping zhang's message of "Fri, 19 Jan 2018 12:46:13 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zwp10758@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, weiping zhang <zhangweiping@didichuxing.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


Hi Weiping,

> currently, there are four combinations as following: "write through",
> "none", "write back", "write back, no read (daft)"
>
> cache_type can control both write and read cache, but for "write
> through" and "write back" we can not know clearly how to control the
> read cache.

That's what I meant by using the term "arcane" and alluding to the fact
that this interface is not well enough documented.

> I prefer use words like"w0r1", "w0r0", "w1r1", "w1r0", that "1" means
> enable, "0" means disable. The user know clearly what they are doing
> when typing these short words.

We can't change the existing interface without breaking stuff. We can
entertain adding stuff, but I do think that a better solution is to
document what's there so the effect of echoing each of the following
strings becomes crystal clear:

static const char *sd_cache_types[] = {
        "write through", "none", "write back",
        "write back, no read (daft)"
};

I would also like to see the "temporary" string documented.

-- 
Martin K. Petersen	Oracle Linux Engineering
