Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EA6C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 13:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D719207D8
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 13:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EbBQGhxa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgFZN4a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 09:56:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55771 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgFZN4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 09:56:30 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200626135628euoutp0115307a4e6c21ac561160056782cc6dec~cHJOKFRB30807508075euoutp01P
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 13:56:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200626135628euoutp0115307a4e6c21ac561160056782cc6dec~cHJOKFRB30807508075euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593179788;
        bh=a4vI0VsOOwJL8FbR9Rem46hINKT1NO3X60g4/O17scM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=EbBQGhxaRLwuVM9k2ONgx9yEB6QE83Ej5diiCLQxt4jeo//SkgE5FoU9PPAkTl5i5
         e5zuc2CquqeFEhtmwD0wrcDcAvzMIKM+gmWYmy3yTQNLwsnx19aFaKYmFyRnLS4eOB
         X+LjvEXrvtu6cZrsy3GgDL/T6jvrtCO5hzVOZ3io=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200626135627eucas1p2a9ee726e5fa75cf94cb890204f9238bb~cHJNzl1sV1232512325eucas1p2P;
        Fri, 26 Jun 2020 13:56:27 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 29.10.06318.B8EF5FE5; Fri, 26
        Jun 2020 14:56:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200626135627eucas1p2d68eb5853f90bc636faab69149fbe02c~cHJNfTN7h3013530135eucas1p2t;
        Fri, 26 Jun 2020 13:56:27 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200626135627eusmtrp190e8c28ea5e3042e40fc63d2874ecabf~cHJNespUv2488324883eusmtrp1b;
        Fri, 26 Jun 2020 13:56:27 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-ec-5ef5fe8b3bda
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id A4.0A.06314.B8EF5FE5; Fri, 26
        Jun 2020 14:56:27 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200626135627eusmtip1f72c23802bc5164742dd5d89e62a4a4e~cHJNKS8xE1358813588eusmtip1P;
        Fri, 26 Jun 2020 13:56:27 +0000 (GMT)
Subject: Re: Re: [RFC PATCH v2 5/7] ata_dev_printk: Use dev_printk
To:     tasleson@redhat.com
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <b0118523-eec2-2e60-0b05-8f674d63abd2@samsung.com>
Date:   Fri, 26 Jun 2020 15:56:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e12aeb9e-fe5d-5b5e-d190-401997cecc34@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsWy7djP87rd/77GGbx8pWuxZ9EkJouN/RwW
        e29pW3Rf38FmcfHeTXYHVo9pk06xebzfd5XNY/Ppao/Pm+QCWKK4bFJSczLLUov07RK4Mpo3
        H2UqOCpdcfXyNaYGxr1iXYwcHBICJhK/Xxl2MXJxCAmsYJR40LuXDcL5wijR3NnHBOF8ZpRY
        9XAVI0zH5EXZEPHljBI3nj9ih3DeMkr8W/IbqIOTQ1jASeLdmq/MILaIgLjEvYVrmEGKmAVm
        MEp8P/0RrIhNwEpiYjvIVE4OXgE7ic6be9hBbBYBVYmvE5tYQWxRgQiJTw8Os0LUCEqcnPmE
        BcTmBKqfO6MBbAEz0IJbT+YzQdjyEs1bZ4MtkxCYzC7x9dI5sGYJAReJma3v2SFsYYlXx7dA
        2TISpyf3sEA0rGOU+NvxAqp7O6PE8sn/2CCqrCXunPvFBgoAZgFNifW79CHCjhIX3u5ggYQL
        n8SNt4IQR/BJTNo2nRkizCvR0SYEUa0msWHZBjaYtV07VzJPYFSaheS1WUjemYXknVkIexcw
        sqxiFE8tLc5NTy02zkst1ytOzC0uzUvXS87P3cQITDCn/x3/uoNx35+kQ4wCHIxKPLwvHnyN
        E2JNLCuuzD3EKMHBrCTC63T2dJwQb0piZVVqUX58UWlOavEhRmkOFiVxXuNFL2OFBNITS1Kz
        U1MLUotgskwcnFINjOfyfb9n37Jo35wXUDer51j3Gf81we4+WnsZrshN+p7+bs6Cl/a/1p+U
        imnm2bW6d/7D96ulK+8nn5Xni70xwcvm54af31J+XzFYcWOOUZJ09LS7H06X7N2ZcXN74qHP
        TPwWD6a+m3pn5tpWu5cmLRPyXkkXMtw+4f0/WSdP/qaLc/y+QyqXn7grsRRnJBpqMRcVJwIA
        7L+cqywDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xu7rd/77GGaz8KWWxZ9EkJouN/RwW
        e29pW3Rf38FmcfHeTXYHVo9pk06xebzfd5XNY/Ppao/Pm+QCWKL0bIryS0tSFTLyi0tslaIN
        LYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0Mpo3H2UqOCpdcfXyNaYGxr1iXYwc
        HBICJhKTF2V3MXJxCAksZZS4sqCLBSIuI3F8fVkXIyeQKSzx51oXG0TNa0aJVV97WEASwgJO
        Eu/WfGUGsUUExCXuLVzDDFF0jlHiwNYmsCJmgRmMEv9X5YDYbAJWEhPbVzGC2LwCdhKdN/ew
        g9gsAqoSXyc2sYLYogIREod3zIKqEZQ4OfMJ2BxOoPq5MxqYIWaqS/yZdwnKFpe49WQ+E4Qt
        L9G8dTbzBEahWUjaZyFpmYWkZRaSlgWMLKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzEC42nb
        sZ+bdzBe2hh8iFGAg1GJh/fFg69xQqyJZcWVuYcYJTiYlUR4nc6ejhPiTUmsrEotyo8vKs1J
        LT7EaAr03ERmKdHkfGCs55XEG5oamltYGpobmxubWSiJ83YIHIwREkhPLEnNTk0tSC2C6WPi
        4JRqYAzWcp7qsz2/bPJxx3dPmoIsJLNTUjtq2u44+4idPlcxPzTF5s9LwYSFx4NUrkstnP1o
        Qf819sXMWysOXkybk7iuOGMe4/00HsXg5p7qU27cGm6xj2szIv+x7vi7bqpc+j2TRQovk48c
        uXJm+VqDnms/OXl4rWTljfK6jS8dV4qdfDDTj+81pxJLcUaioRZzUXEiAK0YMOy9AgAA
X-CMS-MailID: 20200626135627eucas1p2d68eb5853f90bc636faab69149fbe02c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200626135627eucas1p2d68eb5853f90bc636faab69149fbe02c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200626135627eucas1p2d68eb5853f90bc636faab69149fbe02c
References: <20200513213621.470411-1-tasleson@redhat.com>
        <20200513213621.470411-6-tasleson@redhat.com>
        <82257837-c5a8-6a38-ce13-0f1ce7e245ac@suse.de>
        <e12aeb9e-fe5d-5b5e-d190-401997cecc34@redhat.com>
        <CGME20200626135627eucas1p2d68eb5853f90bc636faab69149fbe02c@eucas1p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 5/14/20 8:03 PM, Tony Asleson wrote:
> On 5/14/20 12:53 AM, Hannes Reinecke wrote:
>> On 5/13/20 11:36 PM, Tony Asleson wrote:
>>> Utilize the dev_printk function which will add structured data
>>> to the log message.
>>>
>>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>>> ---
>>>   drivers/ata/libata-core.c | 10 +++++++---
>>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index 42c8728f6117..16978d615a17 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -7301,6 +7301,7 @@ EXPORT_SYMBOL(ata_link_printk);
>>>   void ata_dev_printk(const struct ata_device *dev, const char *level,
>>>               const char *fmt, ...)
>>>   {
>>> +    const struct device *gendev;
>>>       struct va_format vaf;
>>>       va_list args;
>>>   @@ -7309,9 +7310,12 @@ void ata_dev_printk(const struct ata_device
>>> *dev, const char *level,
>>>       vaf.fmt = fmt;
>>>       vaf.va = &args;
>>>   -    printk("%sata%u.%02u: %pV",
>>> -           level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
>>> -           &vaf);
>>> +    gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
>>> +
>>> +    dev_printk(level, gendev, "ata%u.%02u: %pV",
>>> +            dev->link->ap->print_id,
>>> +            dev->link->pmp + dev->devno,
>>> +            &vaf);
>>>         va_end(args);
>>>   }
>>>
>> That is wrong.
>> dev_printk() will already prefix the logging message with the device
>> name, so we'll end up having the name printed twice.
> 
> It certainly could be. Early in boot when &dev->sdev->sdev_gendev ==
> NULL and &dev->tdev is used we get
> 
> dev1.0: ata1.00: configured for UDMA/100
> 
> later when &dev->sdev->sdev_gendev != NULL we get
> 
> sd 1:0:0:0: [sdb] 209715200 512-byte logical blocks: (107 GB/100 GiB)

This one comes from the SCSI layer.

From libata we get i.e.:

sd 1:0:0:0: ata2.00: exception Emask 0x0 SAct 0x800000 SErr 0x800000
action 0x6 frozen

instead of

ata2.00: exception Emask 0x0 SAct 0x800000 SErr 0x800000 action 0x6 frozen

> to clarify, your point is dev1.0 is redundant as ata1.00 exists in the
> message?
> 
> 
> In the block layer print_req_error we get:
> 
> block sdb: blk_update_request: I/O error, dev sdb, sector 10000 op
> 0x0:(READ) flags 0x80700 phys_seg 4 prio class 0

I think it should be modified to not include dev any longer: 

block sdb: blk_update_request: I/O error, sector 10000 op
0x0:(READ) flags 0x80700 phys_seg 4 prio class 0

but it is up to Jens to make a final decision on that.

> Which seems a bit more redundant.

Yes but it is a debug message visible only on error while for libata
_all_ messages are now changed.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> I've been trying to be careful to not change the human readable portion
> of the message, so not to disturb all the log scraping tools that exist
> mining errors.  Maybe this is the wrong approach?  In my original patch
> series I brought back printk_emit so that I could add the structured
> data without introducing changes in the message text output.  James
> Bottomley suggested using dev_printk which certainly made things
> cleaner, but it does add the prefix.
> 
> 
> Thanks,
> Tony
> 
