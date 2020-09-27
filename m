Return-Path: <SRS0=qC8i=DE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4932CC4346E
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Sep 2020 14:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A4523976
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Sep 2020 14:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJ2++d3A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgI0OWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Sep 2020 10:22:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgI0OWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 27 Sep 2020 10:22:08 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601216527;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUe//uWHNQiAq9CvrOz3zdHn3WpUTW3S6JPfTt5/D7M=;
        b=WJ2++d3Ag75NaCE5/KgIk2bcoNvI32GvFrS//9eF+OBi79WgeuCWtFj2ncchOd206v9jxb
        mwecTWgWe9zez/TMVeBtbq2waqiJEthMJhsf6P1dLKukVxaFLYc8KGQ5FMLDFp1QhAK/Kx
        a8gsmW6KaGKrVQlw3mEebyn21xrZDRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-tJum9GvUOdyLsdF0jCgchA-1; Sun, 27 Sep 2020 10:22:05 -0400
X-MC-Unique: tJum9GvUOdyLsdF0jCgchA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 221488030BA;
        Sun, 27 Sep 2020 14:22:04 +0000 (UTC)
Received: from [10.10.110.11] (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F9AE73662;
        Sun, 27 Sep 2020 14:22:03 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <1cfc145b-180a-d906-5d9b-638c483177c7@gmail.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <90ef294c-2f37-2299-6253-68ea27e312b4@redhat.com>
Date:   Sun, 27 Sep 2020 09:22:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1cfc145b-180a-d906-5d9b-638c483177c7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/20 4:08 AM, Sergei Shtylyov wrote:
> On 25.09.2020 19:19, Tony Asleson wrote:
> 
>> Function callback and function to be used to write a persistent
>> durable name to the supplied character buffer.  This will be used to add
>> structured key-value data to log messages for hardware related errors
>> which allows end users to correlate message and specific hardware.
>>
>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>> ---
>>   drivers/base/core.c    | 24 ++++++++++++++++++++++++
>>   include/linux/device.h |  4 ++++
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 05d414e9e8a4..88696ade8bfc 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -2489,6 +2489,30 @@ int dev_set_name(struct device *dev, const char
>> *fmt, ...)
>>   }
>>   EXPORT_SYMBOL_GPL(dev_set_name);
>>   +/**
>> + * dev_durable_name - Write "DURABLE_NAME"=<durable name> in buffer
>> + * @dev: device
>> + * @buffer: character buffer to write results
>> + * @len: length of buffer
>> + * @return: Number of bytes written to buffer
> 
>    This is not how the kernel-doc commenta describe the function result,
> IIRC...

I did my compile with `make  W=1` and there isn't any warnings/error
with source documentation, but the documentation does indeed outline a
different syntax.  It's interesting how common the @return syntax is in
the existing code base.

I'll re-work the function documentation return.

Thanks

