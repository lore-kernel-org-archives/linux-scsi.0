Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF654C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 15:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D17B2078A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 15:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2uZaiDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbgFXPQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 11:16:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41565 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404507AbgFXPQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jun 2020 11:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593011769;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6SksW3aU3D2PMOgemCe/PL6jOgFjOnbGQFc7Y/at9zM=;
        b=R2uZaiDkyaM3J+HRA5H765j74wtQfnVb9XRFzF5TtNXVmrCsh10qGKhQY2GhZDDazWDXXv
        nghpGR6qut2p0Jd1xygoZUoYclUP76krmrOcwnaWqqC57+dKCrPhQCTFqEh62qyE9AE2Yh
        2xJmfdhbnjK8krqtGQEwd5m7oiOl31Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-Ft8miOGiPE2GsiUiCt6jNQ-1; Wed, 24 Jun 2020 11:15:57 -0400
X-MC-Unique: Ft8miOGiPE2GsiUiCt6jNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0B1991138;
        Wed, 24 Jun 2020 15:15:46 +0000 (UTC)
Received: from [10.3.128.20] (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8299A619D0;
        Wed, 24 Jun 2020 15:15:45 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-6-tasleson@redhat.com>
 <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
 <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <33577b4f-6ee1-f054-8853-b61ca800e10a@redhat.com>
Date:   Wed, 24 Jun 2020 10:15:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> [ added linux-ide ML to Cc: ]
> 
> Hi,

Hello,

> 
> On 6/23/20 9:17 PM, Tony Asleson wrote:
>> Utilize the dev_printk function which will add structured data
>> to the log message.
>>
>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>> ---
>>  drivers/ata/libata-core.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index beca5f91bb4c..44c874367fe3 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -6475,6 +6475,7 @@ EXPORT_SYMBOL(ata_link_printk);
>>  void ata_dev_printk(const struct ata_device *dev, const char *level,
>>  		    const char *fmt, ...)
>>  {
>> +	const struct device *gendev;
>>  	struct va_format vaf;
>>  	va_list args;
>>  
>> @@ -6483,9 +6484,12 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
>>  	vaf.fmt = fmt;
>>  	vaf.va = &args;
>>  
>> -	printk("%sata%u.%02u: %pV",
>> -	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
>> -	       &vaf);
>> +	gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
>> +
>> +	dev_printk(level, gendev, "ata%u.%02u: %pV",
>> +			dev->link->ap->print_id,
> 
> This duplicates the device information and breaks integrity of
> libata logging functionality (ata_{dev,link,port}_printk() should
> be all converted to use dev_printk() at the same time).
> 
> The root source of problem is that libata transport uses different
> naming scheme for ->tdev devices (please see dev_set_name() in
> ata_t{dev,link,port}_add()) than libata core for its logging
> functionality (ata_{dev,link,port}_printk()).
> 
> Since libata transport is part of sysfs ABI we should be careful
> to not break it so one idea for solving the issue is to convert
> ata_t{dev,link,port}_add() to use libata logging naming scheme and
> at the same time add sysfs symlinks for the old libata transport
> naming scheme.
> 
> dev->sdev usage is not required for dev_printk() conversion and
> should be considered as a separate change (since it also breaks
> integrity of libata logging and can be considered as a mild
> "layering violation" I don't think that it should be applied).

The point of this patch series is to attach a device unique identifier
to the storage device log messages as structured data.  Originally I
resurrected and used printk_emit, but it was suggested I leverage
dev_printk.  dev_printk does change the output of the log message to
include duplicate information if the message isn't changed. You are not
the first person to raise that concern.  I listed this as an open
question in the cover letter.  I've wanted to preserve the original log
message, so as to not break user space mining tools and I've been
concerned that dev_printk prefixing with an id may already do that.
Adding structured data is invisible to them, or at the least shouldn't
break them, eg. adding a new key-value pair.

I can understand the desire to make all the ata logging functions
consistent, and use dev_printk if we go this way.  However, for this
change it wasn't really the goal to refactor all the logging everywhere
to use dev_printk, although that may be a good change in general.  This
is especially true that if at the end of the refactor to use dev_printk
we consider it a layering violation to call into the existing
functionality to return the vpd ID for the device and reject that part
of the change.

What I am hoping is that we can all agree that having a persistent
identifier associated to storage related log messages is indeed useful.
If we can agree on that, then I would like to have the discussion on
what's the best way to achieve that.

Thanks,
Tony

