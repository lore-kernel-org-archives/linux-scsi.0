Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A70C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 18:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F41020671
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 18:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OBFzdABP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgENSD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 14:03:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbgENSD2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 14:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589479407;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tE7zZsDmw/yZbrfqaJT36sACACFD7o4pfgXiX6CyaVE=;
        b=OBFzdABPq/YKikQ7jCq/qxFXTRcCHLhDYay4/TUVG+vnu3EVSWWDK7tmPP3nMYSpQgeRJE
        +kCa78rwpdslUu9X03DeE4Giwc4xSI1NJbq3fUmXP9E743T1dGwTwrCVarNLWWQyLOFJDA
        rybVGjupjgI+gDDPhJJcSgMdpo+LUJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-Hxoc4choN32rFwGvVK4wyA-1; Thu, 14 May 2020 14:03:22 -0400
X-MC-Unique: Hxoc4choN32rFwGvVK4wyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14E96872FEB;
        Thu, 14 May 2020 18:03:21 +0000 (UTC)
Received: from [10.3.128.23] (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1741376E95;
        Thu, 14 May 2020 18:03:19 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [RFC PATCH v2 5/7] ata_dev_printk: Use dev_printk
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20200513213621.470411-1-tasleson@redhat.com>
 <20200513213621.470411-6-tasleson@redhat.com>
 <82257837-c5a8-6a38-ce13-0f1ce7e245ac@suse.de>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <e12aeb9e-fe5d-5b5e-d190-401997cecc34@redhat.com>
Date:   Thu, 14 May 2020 13:03:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <82257837-c5a8-6a38-ce13-0f1ce7e245ac@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/20 12:53 AM, Hannes Reinecke wrote:
> On 5/13/20 11:36 PM, Tony Asleson wrote:
>> Utilize the dev_printk function which will add structured data
>> to the log message.
>>
>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>> ---
>>   drivers/ata/libata-core.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 42c8728f6117..16978d615a17 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -7301,6 +7301,7 @@ EXPORT_SYMBOL(ata_link_printk);
>>   void ata_dev_printk(const struct ata_device *dev, const char *level,
>>               const char *fmt, ...)
>>   {
>> +    const struct device *gendev;
>>       struct va_format vaf;
>>       va_list args;
>>   @@ -7309,9 +7310,12 @@ void ata_dev_printk(const struct ata_device
>> *dev, const char *level,
>>       vaf.fmt = fmt;
>>       vaf.va = &args;
>>   -    printk("%sata%u.%02u: %pV",
>> -           level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
>> -           &vaf);
>> +    gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
>> +
>> +    dev_printk(level, gendev, "ata%u.%02u: %pV",
>> +            dev->link->ap->print_id,
>> +            dev->link->pmp + dev->devno,
>> +            &vaf);
>>         va_end(args);
>>   }
>>
> That is wrong.
> dev_printk() will already prefix the logging message with the device
> name, so we'll end up having the name printed twice.

It certainly could be. Early in boot when &dev->sdev->sdev_gendev ==
NULL and &dev->tdev is used we get

dev1.0: ata1.00: configured for UDMA/100

later when &dev->sdev->sdev_gendev != NULL we get

sd 1:0:0:0: [sdb] 209715200 512-byte logical blocks: (107 GB/100 GiB)

to clarify, your point is dev1.0 is redundant as ata1.00 exists in the
message?


In the block layer print_req_error we get:

block sdb: blk_update_request: I/O error, dev sdb, sector 10000 op
0x0:(READ) flags 0x80700 phys_seg 4 prio class 0

Which seems a bit more redundant.

I've been trying to be careful to not change the human readable portion
of the message, so not to disturb all the log scraping tools that exist
mining errors.  Maybe this is the wrong approach?  In my original patch
series I brought back printk_emit so that I could add the structured
data without introducing changes in the message text output.  James
Bottomley suggested using dev_printk which certainly made things
cleaner, but it does add the prefix.


Thanks,
Tony

