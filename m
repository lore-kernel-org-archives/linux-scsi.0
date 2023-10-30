Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDF4C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 18:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjJ3SQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 14:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjJ3SQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 14:16:33 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D15698;
        Mon, 30 Oct 2023 11:16:30 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso766348666b.1;
        Mon, 30 Oct 2023 11:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698689789; x=1699294589; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=E+SLeA2ywujo0UQWzu6cCHaMWc4I0sH1eRVwPgmtHyM=;
        b=CgvScvb7u5M/zNDLnCJGYeNEdWSQOnTaBgiMx+lpvIQ9Mvxz1F83WSyF1GoAbR7ESu
         fElcQJ/1aEACJDWhNpv9TAqY2mGWlPvoiytAHIiU8lUx1OJZrvWypLoZalxP6tKJ/g8+
         DosokS0+ycF5J/z1wY9CENDFksAv/8+fUV72JHouGKg3NGspZnoSVJ5SEfbosDog0DJr
         RFpnbIGIlvalfjB3nkvOBRKDYnBzWtTBFFL2/M2Y3em6yBupseHOCjN0CS8AUI2p6tJM
         TFAqSLPJyyjiWbs8MRDJhBReSFh0Q/UsWtGbnp1o4mJhJBahS45p5MCYck9hBizKt5Cl
         zQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698689789; x=1699294589;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+SLeA2ywujo0UQWzu6cCHaMWc4I0sH1eRVwPgmtHyM=;
        b=SPL0d7ONn0kAVtarPFwbABMVAitgNHjCF3weRdgjKYefknyT1SIMNKyWhNtO6nUmZK
         CvtmdSWTVSICX9hVaYGbPwuHFCVcBlfn8pPiWdyDmRXp3WV2cndBJxtdPvDiR3+A+xF7
         eNlVIEM+8NWHDvePrpDoRQAX3lJXzPQVmtvs8rCxLcm1JypS/QVUhkl2/GdmECCJ/Bby
         p8hq994KAZSTw/SW4BBoxiwx2EZNsp9ntka8Mu2bDJoTQ988fABwIicl5RAvWxUscH7B
         xYGgefgobSo+BkoCU88n7OneDTYdMM65jQD4UQQ8nHJ5wlL4xQ5jjIeRjDUJ4dCDyj49
         a8BQ==
X-Gm-Message-State: AOJu0Yxhx9F2yX0WPnHBu8M39XA8TepM2KtpV5VKnEr/3rTcN72zcBWm
        v80zC0ckPJ0mxu8v60eMhxE=
X-Google-Smtp-Source: AGHT+IExySIDlqCzufDXY5RxYGxYbPo8d+PjFIx5GhNWy7cZ1oeYLQdSrBJHnEgU5Z9HZbJPS9CUgw==
X-Received: by 2002:a17:906:b257:b0:9d2:9dbe:a2f9 with SMTP id ce23-20020a170906b25700b009d29dbea2f9mr3942214ejb.50.1698689788708;
        Mon, 30 Oct 2023 11:16:28 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id fy19-20020a170906b7d300b009cc6323fe5asm6340242ejb.134.2023.10.30.11.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 11:16:28 -0700 (PDT)
Message-ID: <db9dbd1f-2d49-4d31-9214-a4a2437f0fc7@gmail.com>
Date:   Mon, 30 Oct 2023 19:16:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] usb-storage,uas: use host helper to generate driver
 info
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        oneukum@suse.com
References: <20231026101615.395113-1-gmazyland@gmail.com>
 <20231028174145.691523-1-gmazyland@gmail.com>
 <f6b275d9-eeeb-47ee-bc0e-3fd491e62791@rowland.harvard.edu>
Content-Language: en-US
From:   Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <f6b275d9-eeeb-47ee-bc0e-3fd491e62791@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/30/23 18:40, Alan Stern wrote:
> On Sat, Oct 28, 2023 at 07:41:45PM +0200, Milan Broz wrote:
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
>> These files also contain a generated translation table for driver_info
>> to 64-bit values.
>>
>> The translation function is used only in usb-storage and uas modules; all
>> other USB storage modules store flags directly, using only 32-bit flags.
>>
>> For 64-bit platforms, where unsigned long is 64-bit, we do not need to
>> convert quirk flags to 32-bit index; the translation function there uses
>> flags directly.
>>
>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
>> ---
> 
>> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
>> index 46635fa4a340..b8c5daeb8ff3 100644
>> --- a/drivers/usb/storage/Makefile
>> +++ b/drivers/usb/storage/Makefile
>> @@ -45,3 +45,34 @@ ums-realtek-y		:= realtek_cr.o
>>   ums-sddr09-y		:= sddr09.o
>>   ums-sddr55-y		:= sddr55.o
>>   ums-usbat-y		:= shuttle_usbat.o
>> +
>> +# The mkflags host-compiled generator produces usb-ids.c (usb-storage)
>> +# and usb-ids-uas.c (uas) with USB device tables.
>> +# These tables include pre-computed 32-bit values, as USB driver_info
>> +# (where the value is stored) can be only 32-bit.
>> +# The most significant bit means it is index to 64-bit pre-computed table
>> +# generated by mkflags host-compiled program.
>> +# Currently used only by mass-storage and uas driver.
>> +
>> +$(obj)/usual-tables.o:	$(obj)/usb-ids.c
>> +$(obj)/uas.o:		$(obj)/usb-ids-uas.c
> 
> Quick test: After those two lines were commented out from the Makefile,
> the compiler still knew to rebuild unusual-tables.o and uas.o when
> usb-ids.c and usb-ids-uas.c were changed.  So these lines aren't needed.

ok, thx, this is perhaps relict of some previous try (I tried different
approaches) - will remove it.


> Apart from this, I tried running the patch through checkpatch.pl, and it
> flagged a bunch of issues.  Some of them were false positives, but
> others really should be changed to match the kernel's style:
> 
> 	The SPDX license line in .c files is supposed to be a
> 	C++-style comment, i.e., use // instead of /* ... */.

Perhaps just copied from header file, it is different format there.
(And my bad, I forget to run checkpatch after many last changes...)

> 
> 	We aren't supposed to add new typedefs.  Instead of writing:
> 
> 		typedef enum {...} dev_type;
> 
> 	write:
> 
> 		enum dev_type {...};
> 
> 	and the same for dev_flags_set.
> 
> 	checkpatch would like the FLAGS_END macro value to be enclosed
> 	in parentheses, since it's a complex expression.  Same for the
> 	HI32 macro.  These don't really matter, but you may as well do
> 	it just to get rid of the warnings.
> 
> 	Quoted strings (line 117 in mkflags.c) aren't supposed to be
> 	broken across lines.  It should just be one very long line.
> 
> 	Contrariwise, some other lines are longer than checkpatch likes
> 	to see (its maximum is 100 columns).  They should be wrapped.
> 
> These issues ought to be fixed.  But it's all stylistic stuff; I don't
> see any actual errors or things to improve in the patch.

ok, I'll send next version once I have time to do it.

Thanks,
Milan

