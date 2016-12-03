From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: use-after-free in bio_copy_from_iter
Date: Sat, 3 Dec 2016 16:22:39 +0100
Message-ID: <CACT4Y+bB+oxjPoC0WVCUV_Bq9ePqdV3m_V4snsfUrZ2BSWub2Q@mail.gmail.com>
References: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
 <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com> <20161203103802.dmvqzzquthwa7kd7@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34355 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbcLCPXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Dec 2016 10:23:02 -0500
Received: by mail-lf0-f47.google.com with SMTP id o141so214360412lff.1
        for <linux-scsi@vger.kernel.org>; Sat, 03 Dec 2016 07:23:01 -0800 (PST)
In-Reply-To: <20161203103802.dmvqzzquthwa7kd7@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, David Rientjes <rientjes@google.com>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>

On Sat, Dec 3, 2016 at 11:38 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Fri, Dec 02, 2016 at 05:50:39PM +0100, Dmitry Vyukov wrote:
>> On Fri, Nov 25, 2016 at 8:08 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> [...]
>
>>
>> +David did some debugging of a similar case. His 0x400 at location
>> 0x2000efdc refers to 0xffff at 0x20012fdc in the provided reproducer:
>>     NONFAILING(*(uint32_t*)0x20012fdc = (uint32_t)0xffff);
>> Here is his explanation:
>> =====
>> That's not nice, it's passing a reply_len mismatch of 0x400 which is going
>> to cause an sg_write warning (in 988 bytes, out 38 bytes).  input_size
>> will be 74 since count == 80, the mxsize is 0x400 (!) so after subtracting
>> SZ_SG_HEADER we get the 988 bytes in.  This forces SG_DXFER_TO_FROM_DEV
>> when we really want SG_DXFER_TO_DEV.  If you set the value at 0x2000efdc
>> to 0x24 rather than 0x400 so there's a legitimate reply_len equal to
>> SG_DXFER_TO_FROM_DEV, I'd assume this passes just fine, assuming your
>> container can get enough memory.
>> =====
>>
>> I've tried to replace 0xffff in the provided reproducer with 0x24 and
>> it indeed does not crash.
>
> This is somewhat expected, AFAICS the value at 0x20012fdc ends up as
> hp->dxfer_len in the SG driver. I did a lot of debugging (actually I spend the
> whole last work week soley on this) but I can't find where it does the actual
> use-after-free, so if you have anything to share I'd be glad.

Hi Johannes,

Thanks for looking into this!

As I noted I don't think this is use-after-free, more likely it is an
out-of-bounds access against non-slab range.

Report says that we are copying 0x1000 bytes starting at 0xffff880062c6e02a.
The first bad address is 0xffff880062c6f000, this address was freed
previously and that's why KASAN reports UAF.
But this is already next page, and KASAN does not insert redzones
around pages (only around slab allocations).
So most likely the code should have not touch 0xffff880062c6f000 as it
is not his memory.
Also I noticed that the report happens after few minutes of repeatedly
running this program, so I would expect that this is some kind of race
-- either between kernel threads, or maybe between user space threads
and kernel. Or maybe it's just that the next page is not always marked
as free, so we just don't detect the bad access.

Does it all make any sense to you?
Can you think of any additional sanity checks that will ensure that
this code copies only memory it owns?
