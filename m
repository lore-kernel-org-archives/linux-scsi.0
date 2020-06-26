Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C37C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 12:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7497A2078D
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 12:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YzaWaSKg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgFZMpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 08:45:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41910 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgFZMpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 08:45:22 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200626124521euoutp02879888cf3f66d39c55a641cdbecd1fcb~cGLICrhCg0083000830euoutp02O
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 12:45:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200626124521euoutp02879888cf3f66d39c55a641cdbecd1fcb~cGLICrhCg0083000830euoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593175521;
        bh=Br4reSMjQBRHqvBX4rIAcOvIsLTABaFwt2mSrPOFheE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=YzaWaSKg22f3klIS/TPbmFaOoLlN9nxVMM5R9dBrQVOJ4WqPkCzbi+Cs4VR0faZb2
         F+T3O6CmSPg8A6EtdABY+x71UvxzQfLTPb+35WsyFYVesIFvnUw/VMTCteW6jUmRWp
         UzcKfbgkpndQvepJAxURvNAZb3I0EhA//pdhwFfE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200626124520eucas1p1108e1ebd7f728635d46558fc01e5be03~cGLHnxRY10607006070eucas1p13;
        Fri, 26 Jun 2020 12:45:20 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 8E.FB.05997.0EDE5FE5; Fri, 26
        Jun 2020 13:45:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200626124520eucas1p14e4f1aa457d0f0f512eef059f1093a0f~cGLHSs8H82774927749eucas1p1a;
        Fri, 26 Jun 2020 12:45:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200626124520eusmtrp1169e0274d5f65a06d73780818b2e405c~cGLHSMg351017910179eusmtrp1l;
        Fri, 26 Jun 2020 12:45:20 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-27-5ef5ede04ac4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 66.9D.06017.0EDE5FE5; Fri, 26
        Jun 2020 13:45:20 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200626124519eusmtip273e55e256adac93281934230bee96666~cGLG-pxzU1366813668eusmtip23;
        Fri, 26 Jun 2020 12:45:19 +0000 (GMT)
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     tasleson@redhat.com
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <9e45d126-f1ac-48b9-56c3-ec0686e38503@samsung.com>
Date:   Fri, 26 Jun 2020 14:45:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <33577b4f-6ee1-f054-8853-b61ca800e10a@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42LZduznOd0Hb7/GGZzplbPYe0vb4tiOR0wW
        3dd3sFlcvHeT3YHF4/2+q2wenzfJBTBFcdmkpOZklqUW6dslcGU8unOPpeCebsXqQ7sYGxi/
        q3QxcnJICJhIzNz1mbWLkYtDSGAFo8SRuWfYIZwvjBJ7569khnA+M0r8PbyYEabl2+avjBCJ
        5YwS56e/g2p5yyixdeNyli5GDg5hATuJxT8LQRpEBMQl7i1cwwxiMwtESOz+d58dxGYTsJKY
        2L4KbCgvUPmerbPB4iwCqhJ7999nAbFFgeo/PTjMClEjKHFy5hOwOCdQ/YFT15ggZopL3Hoy
        H8qWl9j+dg7Y1RICzewSjesPsUBc7SLx50EfK4QtLPHq+BZ2CFtG4vTkHhaIhnVAb3a8gOre
        ziixfPI/Nogqa4k7536xgXzGLKApsX6XPkTYUeLukXdgD0sI8EnceCsIcQSfxKRt05khwrwS
        HW1CENVqEhuWbWCDWdu1cyXzBEalWUhem4XknVlI3pmFsHcBI8sqRvHU0uLc9NRio7zUcr3i
        xNzi0rx0veT83E2MwDRy+t/xLzsYd/1JOsQowMGoxMP74sHXOCHWxLLiytxDjBIczEoivE5n
        T8cJ8aYkVlalFuXHF5XmpBYfYpTmYFES5zVe9DJWSCA9sSQ1OzW1ILUIJsvEwSnVwBjCfEOL
        U+rU3QlfHtRGNKw1r5VVNt5m7LKoRbLm8tf9nPtET+w7X36ucmux+oVtqyqen5R7vvxa772f
        EsvX7ev/0cypdOHqGev9Bw8f+mGdX33cKtrWo9RR+pDSLs6+Y1mM0yesOfOunKN6/qW/8g+D
        hCU+BStWxfedtL/e4DDV0iLv8Ffn3f1KLMUZiYZazEXFiQApPhWfHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t/xe7oP3n6NM5j8l81i7y1ti2M7HjFZ
        dF/fwWZx8d5NdgcWj/f7rrJ5fN4kF8AUpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hs
        HmtlZKqkb2eTkpqTWZZapG+XoJfx6M49loJ7uhWrD+1ibGD8rtLFyMkhIWAi8W3zV0YQW0hg
        KaPEhcnRXYwcQHEZiePryyBKhCX+XOti62LkAip5zSix/vYFdpAaYQE7icU/C0FqRATEJe4t
        XMMMYjMLREhc7XvDDlG/jEni4dx2dpAEm4CVxMT2VWC7eIF692ydDRZnEVCV2Lv/PguILQrU
        fHjHLKgaQYmTM5+AxTmB6g+cusYEsUBd4s+8S1DLxCVuPZkPFZeX2P52DvMERqFZSNpnIWmZ
        haRlFpKWBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQJjZtuxn1t2MHa9Cz7EKMDBqMTD
        ++LB1zgh1sSy4srcQ4wSHMxKIrxOZ0/HCfGmJFZWpRblxxeV5qQWH2I0BXpuIrOUaHI+MJ7z
        SuINTQ3NLSwNzY3Njc0slMR5OwQOxggJpCeWpGanphakFsH0MXFwSjUwymyYW870JnHGOt5U
        ZoFrc//FLuV4HLVN5LJ7ah5LCf/fDW/u8cy6MOGez5RkZlmb2TLe5/dahp/74xLZeaP5p2nX
        puC25yqHVVRW3SrN37tjaovrggXRG5a9dN49z+Ev2/F15QVTuCbeWj7lxAI19kc5MVEfeOpL
        ghXuP+hr3vt+1v3UJxP+uiqxFGckGmoxFxUnAgAjvZ3qrwIAAA==
X-CMS-MailID: 20200626124520eucas1p14e4f1aa457d0f0f512eef059f1093a0f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
References: <20200623191749.115200-1-tasleson@redhat.com>
        <20200623191749.115200-6-tasleson@redhat.com>
        <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
        <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
        <33577b4f-6ee1-f054-8853-b61ca800e10a@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 6/24/20 5:15 PM, Tony Asleson wrote:
> On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
>>
>> [ added linux-ide ML to Cc: ]
>>
>> Hi,
> 
> Hello,
> 
>>
>> On 6/23/20 9:17 PM, Tony Asleson wrote:
>>> Utilize the dev_printk function which will add structured data
>>> to the log message.
>>>
>>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>>> ---
>>>  drivers/ata/libata-core.c | 10 +++++++---
>>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index beca5f91bb4c..44c874367fe3 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -6475,6 +6475,7 @@ EXPORT_SYMBOL(ata_link_printk);
>>>  void ata_dev_printk(const struct ata_device *dev, const char *level,
>>>  		    const char *fmt, ...)
>>>  {
>>> +	const struct device *gendev;
>>>  	struct va_format vaf;
>>>  	va_list args;
>>>  
>>> @@ -6483,9 +6484,12 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
>>>  	vaf.fmt = fmt;
>>>  	vaf.va = &args;
>>>  
>>> -	printk("%sata%u.%02u: %pV",
>>> -	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
>>> -	       &vaf);
>>> +	gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
>>> +
>>> +	dev_printk(level, gendev, "ata%u.%02u: %pV",
>>> +			dev->link->ap->print_id,
>>
>> This duplicates the device information and breaks integrity of
>> libata logging functionality (ata_{dev,link,port}_printk() should
>> be all converted to use dev_printk() at the same time).

BTW:

Similar dev_printk() conversion for ata_dev_printk() has been tried
recently as a part of changes to add dynamic debugging support to
libata (as it also requires dev_printk() to be used) and had to be
dropped:

https://lore.kernel.org/linux-ide/alpine.DEB.2.21.2003241414490.21582@ramsan.of.borg/

Thus I worry that the proposed ata_dev_printk() conversion is not only
causing duplicated information to be printed but it may also confuse
users.

>> The root source of problem is that libata transport uses different
>> naming scheme for ->tdev devices (please see dev_set_name() in
>> ata_t{dev,link,port}_add()) than libata core for its logging
>> functionality (ata_{dev,link,port}_printk()).
>>
>> Since libata transport is part of sysfs ABI we should be careful
>> to not break it so one idea for solving the issue is to convert
>> ata_t{dev,link,port}_add() to use libata logging naming scheme and
>> at the same time add sysfs symlinks for the old libata transport
>> naming scheme.
>>
>> dev->sdev usage is not required for dev_printk() conversion and
>> should be considered as a separate change (since it also breaks
>> integrity of libata logging and can be considered as a mild
>> "layering violation" I don't think that it should be applied).
> 
> The point of this patch series is to attach a device unique identifier
> to the storage device log messages as structured data.  Originally I
> resurrected and used printk_emit, but it was suggested I leverage
> dev_printk.  dev_printk does change the output of the log message to
> include duplicate information if the message isn't changed. You are not
> the first person to raise that concern.  I listed this as an open
> question in the cover letter.  I've wanted to preserve the original log
> message, so as to not break user space mining tools and I've been
> concerned that dev_printk prefixing with an id may already do that.
> Adding structured data is invisible to them, or at the least shouldn't
> break them, eg. adding a new key-value pair.

Please note that with libata transport naming scheme fixed we can use
dev_printk() in libata with unchanged log messages.

> I can understand the desire to make all the ata logging functions
> consistent, and use dev_printk if we go this way.  However, for this
> change it wasn't really the goal to refactor all the logging everywhere
> to use dev_printk, although that may be a good change in general.  This
> is especially true that if at the end of the refactor to use dev_printk
> we consider it a layering violation to call into the existing
> functionality to return the vpd ID for the device and reject that part
> of the change.

Well, I'm against changing the libata log messages but durable name
functionality still should be achievable in libata.

How's about:

* adding:

	ata_dev->tdev.durable_name = ata_scsi_durable_name;

  near the end of ata_scsi_slave_config()

and

* implementing ata_scsi_durable_name() which does

	struct ata_device *ata_dev = container_of(dev, struct ata_device, tdev);
	
	return scsi_durable_name(ata_dev->sdev, buf, len);

?

> What I am hoping is that we can all agree that having a persistent
> identifier associated to storage related log messages is indeed useful.
> If we can agree on that, then I would like to have the discussion on
> what's the best way to achieve that.

Of course I agree that having a persistent identifier associated to
storage related log messages is useful and my previous mail was exactly
a part of discussion on the best way to achieving it. :-)

I agree with James that dev_printk() usage is preferred over legacy
printk_emit() and I've described a way to do it correctly for libata.

Unfortunately it means additional work for getting the new feature 
merged so if you don't agree with doing it you need to convince:

- Jens (libata Maintainer) to accept libata patch as it is

or

- James (& other higher level Maintainers) to use printk_emit() instead

Ultimately they will be the ones merging/long-term supporting proposed
patches and not me..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> 
> Thanks,
> Tony
