Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674D2C25B6F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 10:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbjJZKY7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 06:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbjJZKY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 06:24:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D151A2;
        Thu, 26 Oct 2023 03:24:55 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-53ebf429b4fso1108770a12.1;
        Thu, 26 Oct 2023 03:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698315893; x=1698920693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PtHyqsL08UNBkbgkozrmEZVvg2QPUfXMgyS74tdsVq4=;
        b=mvLGL+avgJMs++L6TyaRRm3G7SgLuYDdgKqUHS5Q4zL3XYlQcpm4E4jFmhQBEyJWqc
         IwK7POsHBOC5EhekzapxTolKfiphFPpV5w3Q2gndkZJ+NR/S2RVx0bMo+o+jBZ6RXAHM
         p8GFuJ8naGaTGYFV+hWNWc/JcvaZpjle6GywCegtaoYux9Ilgr4Nqhb1I3DC2yrWbE8R
         OIv4XwA/if5/TsdsP8b7b81sp0j4B/cEnlQSD1n9QmunRFUP+t1z2DF5EYcO8GUDdHpL
         GRa8A1nVru4aeqskZ8nLFCD2qVPZNS2ZOmSlfqyhXbHTBwIxQUIicc5jF+6aXJIhDLqP
         +NWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698315893; x=1698920693;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PtHyqsL08UNBkbgkozrmEZVvg2QPUfXMgyS74tdsVq4=;
        b=sAtLKZMm5Jk59fQ/gbGByGKxiCTwh4YzyWTrskSYVEqO0ygVFXxS92Irp1fiABw+GX
         xN1hvAjmNARsGNGbI/otRJiuN8MSkuW82wdhxGdkKLR98Vvm6W2z4/FtV5zua5+YqkYx
         FSai3SEBz80AcjMl5m6zC14ZK4BDBxXBlngoqDBFM8LUTpHYL8YMtE8Pw5D3BPOCvmcq
         On1qS52/WNY4/RbUJkJZTju78lYQL0PNi8F8Ic5gCZB9STEIAhPAC9Jv7shl6Le1bZ8q
         1SifuTNYqyEjK/vADSdu9bQd5f8u851xdhYvl5gjhvt4Xbb1uxe86Dy8LGnmiKLqxHr4
         pygQ==
X-Gm-Message-State: AOJu0YxSmokREDzBmxWXo3pCCAB/V1on7tvKOVjn07trBndL4fdmKsJ/
        8TxlCA013RrcXFNG51T4PWaZYPQZ2qI=
X-Google-Smtp-Source: AGHT+IF0Jfa56mk0wVnQY35EuNE7zOHqei+lUS+PK5VBYMEhzJItF8dHnuMdlls4kgXAacu19t9yMA==
X-Received: by 2002:a05:6402:3484:b0:53f:25c4:357f with SMTP id v4-20020a056402348400b0053f25c4357fmr13292314edc.34.1698315893442;
        Thu, 26 Oct 2023 03:24:53 -0700 (PDT)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id v30-20020a50a45e000000b0053da3a9847csm11361733edb.42.2023.10.26.03.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 03:24:53 -0700 (PDT)
Message-ID: <5a7e8f2f-6893-4b00-972d-e995b395f67c@gmail.com>
Date:   Thu, 26 Oct 2023 12:24:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] usb-storage,uas: use host helper to generate driver
 info
Content-Language: en-US
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        oneukum@suse.com
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
 <20231016072604.40179-5-gmazyland@gmail.com>
 <787eea9f-240b-493b-a719-bcec972589e4@rowland.harvard.edu>
From:   Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <787eea9f-240b-493b-a719-bcec972589e4@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/16/23 20:49, Alan Stern wrote:
> On Mon, Oct 16, 2023 at 09:26:01AM +0200, Milan Broz wrote:
>> The USB mass storage quirks flags can be stored in driver_info in
>> a 32-bit integer (unsigned long on 32-bit platforms).
>> As this attribute cannot be enlarged, we need to use some form
>> of translation of 64-bit quirk bits.
>>
>> This problem was discussed on the USB list
>> https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/
>>
>> The initial solution to use a static array extensively increased the size
>> of the kernel module, so I decided to try the second suggested solution:
>> generate a table by host-compiled program and use bit 31 to indicate
>> that the value is an index, not the actual value.
>>
>> This patch adds a host-compiled program that processes unusual_devs.h
>> (and unusual_uas.h) and generates files usb-ids.c and usb-ids-uas.c
>> (for pre-processed USB device table with 32-bit device info).
>> These files also contain a generated translation table for device_info
>> to 64-bit values.
>>
>> The translation function is used only in usb-storage and uas modules; all
>> other USB storage modules store flags directly, using only 32-bit integers.
>>
>> This translation is unnecessary for a 64-bit system, but I keep it
>> in place for simplicity in this patch.
>>
>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
>> ---
>>   drivers/usb/storage/Makefile       |  25 ++++
>>   drivers/usb/storage/mkflags.c      | 226 +++++++++++++++++++++++++++++
>>   drivers/usb/storage/uas-detect.h   |   4 +-
>>   drivers/usb/storage/uas.c          |  20 +--
>>   drivers/usb/storage/usb-ids.h      |  33 +++++
>>   drivers/usb/storage/usb.c          |  10 +-
>>   drivers/usb/storage/usual-tables.c |  23 +--
>>   7 files changed, 301 insertions(+), 40 deletions(-)
>>   create mode 100644 drivers/usb/storage/mkflags.c
>>   create mode 100644 drivers/usb/storage/usb-ids.h
>>
>> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
>> index 46635fa4a340..612678f108d0 100644
>> --- a/drivers/usb/storage/Makefile
>> +++ b/drivers/usb/storage/Makefile
>> @@ -45,3 +45,28 @@ ums-realtek-y		:= realtek_cr.o
>>   ums-sddr09-y		:= sddr09.o
>>   ums-sddr55-y		:= sddr55.o
>>   ums-usbat-y		:= shuttle_usbat.o
>> +
>> +# The mkflags host-compiled generator produces usb-ids.c (usb-storage)
>> +# and usb-ids-uas.c (uas) with USB device tables.
>> +# These tables include pre-computed 32-bit flags as USB driver device_info
> 
> s/flags as/flags, as/
> 
> Otherwise this seems to say that the 32-bit flags are converted to USB
> driver device_info values -- an incorrect parsing that makes no sense
> and will confuse readers.  (It confused me at first.)
> 
> Also, don't you really mean "driver_info" rather than "driver
> device_info"?  That's the name of the field in struct usb_device_id.

Yes, not sure why I mixed these. Fixed in v3 patch (and now only one
patch is needed as 2 previous are merged in usb-next).

I hope I fixed all other comments too, thanks!

Milan
