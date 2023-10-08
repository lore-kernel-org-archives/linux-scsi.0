Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9506CE95A82
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Oct 2023 10:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344621AbjJHKlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Oct 2023 06:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjJHKlr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Oct 2023 06:41:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB542B9;
        Sun,  8 Oct 2023 03:41:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9ba081173a3so236391866b.1;
        Sun, 08 Oct 2023 03:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696761704; x=1697366504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CiC3NzSUnd+p/8/8gXpqhqb7KWO/sfd50u//UyShD7U=;
        b=kGTjnBW6kXdeAUnMKQQDHba3UgJlrm3B+ZxLy6E69Gdi7pT4mYdfIMLrG7XPGWp9Rp
         l436/4kZugkasvFkN0DZnXCivFC8KiX3g4YzvU+bh9dORuv9pdcZLJi+qU/LtCFW/rb/
         qTBAnCzXeBgoLnXTzP1ufbwCmvhNTRM6+JCTT9ysIKnGB1CNagodR8Aj3edqaS5QK3Kt
         T6rNoy/aFAsreOD/MHHV6si52OAbfC5poVW/2Qq655Gcton1Fu1OlkxJ9m6fLYCfQPBN
         8wQo8xIp69YoNfR+E+qVBWuSMI2deaM6mXSCXqozX1opegeAnoVKablDAJKgT7R4UlaC
         QQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696761704; x=1697366504;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CiC3NzSUnd+p/8/8gXpqhqb7KWO/sfd50u//UyShD7U=;
        b=WALb+QrTj8/k2YXNE4dp7liTKUOWETcHwE5ASG0KJ6UMlJc0Wl8QrFshLz9S2qKSYE
         hizMkF+rfhZ5+mrtbNPLZRxNxorUqZzNX+g4yDTyVXC4g5rc3EXsw3fWJlxdQvEqo3QQ
         EH2zOUHzvXF9bOfkNx1fDEhFcV3UJq4+YW2micsazUIRKN8UBL7JlFumXeilbaSFZkAc
         Wtwt8d5sI9j86qv0qxJ9gHud+u0hB6/lMcVDP3fojdNH/2btOLmPA/4+AntuNSdGuK7V
         mEJHOQuxJ2IqY2o4wIQnHT5uyCbU+Aw1iS8XlSMGUYJGLhHHkeUxDJhA2ufrHKZuL2lO
         MZVA==
X-Gm-Message-State: AOJu0Yy100bx30vbLjjiqsRh6Gx4uwyyEOdVlyUrm0iLOYVwtkRK9Jk7
        MqbBK46est19T3KunFrUvD+d+aV5iP0=
X-Google-Smtp-Source: AGHT+IEWHr+LIGWqI/5zX5xx+HDdOKufhKOC5JGM5OUxr1ds+LImp06jiM2SgmoI3+L0asJo8oBWkA==
X-Received: by 2002:a17:906:23f2:b0:9b2:6db8:e0fa with SMTP id j18-20020a17090623f200b009b26db8e0famr10671341ejg.41.1696761703947;
        Sun, 08 Oct 2023 03:41:43 -0700 (PDT)
Received: from [192.168.8.101] (78-80-112-174.customers.tmcz.cz. [78.80.112.174])
        by smtp.gmail.com with ESMTPSA id y23-20020a1709064b1700b009aa292a2df2sm5314865eju.217.2023.10.08.03.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Oct 2023 03:41:43 -0700 (PDT)
Message-ID: <e71d958f-8954-465e-a296-c09763d0e3a1@gmail.com>
Date:   Sun, 8 Oct 2023 12:41:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/6] usb-storage,uas: use host helper to generate
 driver info
Content-Language: en-US
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-5-gmazyland@gmail.com>
 <65bd429f-6740-4aa6-af00-e72d27074115@rowland.harvard.edu>
From:   Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <65bd429f-6740-4aa6-af00-e72d27074115@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/23 20:44, Alan Stern wrote:
> Okay, this one is a bit of a mess.  Unavoidably so, I'm afraid.

yes. What I need to know if it is acceptable approach (I spent quite
a lot of time on it and still have no better idea...  At least with
a patch that is not too invasive).

Here I compared generated tables with old pre-processor generated
and it looks the same. (Also I keep it on kernel.org branch, so
0-day bot reports obvious mistakes.)

...

>> This translation is unnecessary for a 64-bit system, but I keep it
>> in place for simplicity.
>> (Also, I did not find a reliable way a host-compiled program can detect
>> that the target platform has 32-bit unsigned long (usual macros do not
>> work here!).
> 
> How about testing CONFIG_64BIT?  Would that not do what you want?

Yes, that was my last idea too, but I am not sure if it correct (and I have
no longer access to more exotic platforms to check it).
Also using kernel config defines in host-compiled code is tricky, but
it should be possible.
I will try to ask my former colleagues, though.

> However, I agree that it's better to keep things simple by using the
> same code base for 32-bit and 64-bit kernels.

Yes, that was my plan for now. So you want to keep it as it is?

We can add optimization for 64-bit with additional patch later, it should be
pretty easy once I know how to detect that target platform really has
64-bit unsigned long so no translation is needed.

Thanks,
Milan


> 
>>
>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
>> ---
>>
>>   drivers/usb/storage/Makefile       |  25 ++++
>>   drivers/usb/storage/mkflags.c      | 212 +++++++++++++++++++++++++++++
>>   drivers/usb/storage/uas-detect.h   |   2 +-
>>   drivers/usb/storage/uas.c          |  17 +--
>>   drivers/usb/storage/usb.c          |   7 +-
>>   drivers/usb/storage/usual-tables.c |  23 +---
>>   6 files changed, 248 insertions(+), 38 deletions(-)
>>   create mode 100644 drivers/usb/storage/mkflags.c
>>
>> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
>> index 46635fa4a340..1eacdbb387cd 100644
>> --- a/drivers/usb/storage/Makefile
>> +++ b/drivers/usb/storage/Makefile
>> @@ -45,3 +45,28 @@ ums-realtek-y		:= realtek_cr.o
>>   ums-sddr09-y		:= sddr09.o
>>   ums-sddr55-y		:= sddr55.o
>>   ums-usbat-y		:= shuttle_usbat.o
>> +
> 
> Suggestion: Add a comment here, explaining what the following code does
> and why it is necessary.
> 
>> +$(obj)/usb.o: $(obj)/unusual-flags.h
>> +$(obj)/usual-tables.o: $(obj)/unusual-flags.c
>> +$(obj)/uas.o: $(obj)/unusual-flags.h $(obj)/unusual-flags-uas.c
>> +clean-files		:= unusual-flags.h unusual-flags.c unusual-flags-uas.c
>> +HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
>> +hostprogs		+= mkflags
>> +
>> +quiet_cmd_mkflag_flags = FLAGS   $@
>> +      cmd_mkflag_flags = $(obj)/mkflags flags > $@
>> +
>> +quiet_cmd_mkflag_storage = FLAGS   $@
>> +      cmd_mkflag_storage = $(obj)/mkflags storage > $@
>> +
>> +quiet_cmd_mkflag_uas = FLAGS   $@
>> +      cmd_mkflag_uas = $(obj)/mkflags uas > $@
>> +
>> +$(obj)/unusual-flags.h: $(obj)/mkflags FORCE
>> +	$(call if_changed,mkflag_flags)
>> +
>> +$(obj)/unusual-flags.c: $(obj)/mkflags FORCE
>> +	$(call if_changed,mkflag_storage)
>> +
>> +$(obj)/unusual-flags-uas.c: $(obj)/mkflags FORCE
>> +	$(call if_changed,mkflag_uas)
> 
> My make-fu isn't so hot.  Do you really need to use this indirect way of
> specifying whether and how to rebuild the new files?
> 
>> diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
>> new file mode 100644
>> index 000000000000..11aa6579e7e1
>> --- /dev/null
>> +++ b/drivers/usb/storage/mkflags.c
>> @@ -0,0 +1,212 @@
>> +// SPDX-License-Identifier: GPL-2.0+
> 
> There needs to be a big comment here, explaining why this program is
> needed and exactly what it does.
> 
>> +
>> +#include <stdio.h>
>> +#include <string.h>
>> +
>> +/*
>> + * Cannot use userspace <inttypes.h> as code below
>> + * processes internal kernel headers
>> + */
>> +#include <linux/types.h>
>> +
>> +/*
>> + * Silence warning for definitions in headers we do not use
>> + */
>> +struct usb_device_id {};
>> +struct usb_interface;
>> +
>> +#include <linux/usb_usual.h>
>> +
>> +struct svals {
>> +	unsigned int type;
>> +
>> +	/*interface */
>> +	uint8_t bDeviceSubClass;
>> +	uint8_t bDeviceProtocol;
>> +
>> +	/* device */
>> +	uint16_t idVendor;
>> +	uint16_t idProduct;
>> +	uint16_t bcdDevice_lo;
>> +	uint16_t bcdDevice_hi;
>> +
>> +	uint64_t flags;
>> +	unsigned int set;
>> +	unsigned int idx;
>> +};
>> +
>> +enum { TYPE_DEVICE_STORAGE, TYPE_DEVICE_UAS, TYPE_CLASS };
>> +enum { FLAGS_NOT_SET, FLAGS_SET, FLAGS_DUPLICATE };
>> +#define FLAGS_END (uint64_t)-1
>> +
>> +#define IS_ENABLED(x) 0
>> +
>> +static struct svals vals[] = {
>> +#define USUAL_DEV(useProto, useTrans) \
>> +{ TYPE_CLASS, useProto, useTrans, 0, 0, 0, 0, 0, FLAGS_NOT_SET, 0 }
>> +
>> +#define COMPLIANT_DEV  UNUSUAL_DEV
>> +#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
>> +		    vendorName, productName, useProtocol, useTransport, \
>> +		    initFunction, flags) \
>> +{ TYPE_DEVICE_STORAGE, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
>> +
>> +#include "unusual_devs.h"
>> +
>> +/* UAS */
> 
> If you're going to put this comment line here, why isn't there a similar
> comment line "/* Mass-Storage */" at the start of the structure
> initializer?
> 
>> +#undef UNUSUAL_DEV
>> +#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
>> +		    vendorName, productName, useProtocol, useTransport, \
>> +		    initFunction, flags) \
>> +{ TYPE_DEVICE_UAS, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
>> +
>> +#include "unusual_uas.h"
>> +
>> +{ .flags = FLAGS_END }
>> +};
>> +#undef UNUSUAL_DEV
>> +#undef USUAL_DEV
>> +#undef COMPLIANT_DEV
>> +#undef IS_ENABLED
>> +
>> +#define HI32 (uint32_t)0x80000000
>> +
>> +static unsigned long get_device_info(uint64_t flags, unsigned int idx)
>> +{
>> +	if (flags < HI32)
>> +		return (unsigned long)flags;
>> +
>> +	/* Use index that will be processed in usb_stor_di2flags */
>> +	return HI32 + idx;
>> +}
>> +
>> +static void print_class(uint8_t bDeviceSubClass, uint8_t bDeviceProtocol)
>> +{
>> +	printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO, ");
>> +	printf(".bInterfaceClass = USB_CLASS_MASS_STORAGE, ");
>> +	printf(".bInterfaceSubClass = 0x%x, .bInterfaceProtocol = 0x%x },\n",
>> +		bDeviceSubClass, bDeviceProtocol);
>> +}
>> +static void print_type(unsigned int type)
>> +{
>> +	for (int i = 0; vals[i].flags != FLAGS_END; i++) {
>> +		if (vals[i].type != type)
>> +			continue;
>> +
>> +		if (type == TYPE_DEVICE_STORAGE || type == TYPE_DEVICE_UAS) {
>> +			printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION, ");
>> +			printf(".idVendor = 0x%x, .idProduct =0x%x, "
>> +				".bcdDevice_lo = 0x%x, .bcdDevice_hi = 0x%x, .driver_info = 0x%lx },\n",
>> +				vals[i].idVendor, vals[i].idProduct,
>> +				vals[i].bcdDevice_lo, vals[i].bcdDevice_hi,
>> +				get_device_info(vals[i].flags, vals[i].idx));
>> +		} else if (type == TYPE_CLASS)
>> +			print_class(vals[i].bDeviceSubClass, vals[i].bDeviceProtocol);
>> +	}
>> +}
>> +
>> +static void print_usb_flags(void)
>> +{
>> +	int i;
>> +
>> +	printf("#include <linux/types.h>\n\n");
>> +
>> +	/* usb_stor_di2flags */
>> +	printf("static u64 usb_stor_di2flags(unsigned long idx)\n{\n");
>> +	printf("\tu64 flags = 0;\n\n");
>> +	printf("\tif (idx < 0x%x) \n\t\treturn idx;\n\n", HI32);
>> +	printf("\tswitch(idx - 0x%x) {\n", HI32);
>> +	for (i = 0; vals[i].flags != FLAGS_END; i++) {
>> +		if (vals[i].set == FLAGS_SET)
>> +			printf("\tcase %u: flags = 0x%llx; break;\n", vals[i].idx, vals[i].flags);
>> +	}
>> +	printf("\t}\n\n");
>> +	printf("\treturn flags;\n");
>> +	printf("}\n");
>> +}
> 
> I suspect the usb_stor_di2flags() function doesn't have to be created by
> this preprocessor.  It ought to be possible to put a slightly altered
> version directly into uas-detect.h or some similar place (again, along
> with a comment explaining just what it does and why), and then generate
> here a simple array of 64-bit flags values which the function can index
> into rather than looking values up in a large "switch" statement.
> 
>> +static void print_usb_storage(void)
>> +{
>> +	printf("#include <linux/usb.h>\n\n");
>> +
>> +	/* usb_storage_usb_ids */
>> +	printf("const struct usb_device_id usb_storage_usb_ids[] = {\n");
>> +
>> +	/* USB storage devices */
>> +	print_type(TYPE_DEVICE_STORAGE);
>> +
>> +	/* UAS storage devices */
>> +	printf("#if IS_ENABLED(CONFIG_USB_UAS)\n");
>> +	print_type(TYPE_DEVICE_UAS);
>> +	printf("#endif\n");
>> +
>> +	/* transport subclasses */
>> +	print_type(TYPE_CLASS);
>> +
>> +	printf("\t{ }\t\t/* Terminating entry */\n};\n");
>> +	printf("MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);\n");
>> +}
>> +
>> +static void print_usb_uas(void)
>> +{
>> +	printf("#include <linux/usb.h>\n\n");
>> +
>> +	/* uas_usb_ids */
>> +	printf("const struct usb_device_id uas_usb_ids[] = {\n");
>> +
>> +	/* UAS storage devices */
>> +	print_type(TYPE_DEVICE_UAS);
>> +
>> +	/* transport subclasses */
>> +	print_class(USB_SC_SCSI, USB_PR_BULK);
>> +	print_class(USB_SC_SCSI, USB_PR_UAS);
>> +
>> +	printf("\t{ }\t\t/* Terminating entry */\n};\n");
>> +	printf("MODULE_DEVICE_TABLE(usb, uas_usb_ids);\n");
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	int i, j, idx = 0, idx_old, skip = 0;
>> +
>> +	if (argc != 2 || (strcmp(argv[1], "flags") &&
>> +	    strcmp(argv[1], "storage") && strcmp(argv[1], "uas"))) {
>> +		printf("Please specify type: storage, uas or flags.\n");
>> +		return 1;
>> +	}
>> +
>> +	for (i = 0; vals[i].flags != FLAGS_END; i++) {
>> +		if (vals[i].type == TYPE_CLASS)
>> +			continue;
>> +		skip = 0;
>> +		if (vals[i].flags >= HI32) {
>> +			for (j = 0; j < i; j++) {
>> +				if (vals[j].flags == vals[i].flags &&
>> +				    vals[j].set == FLAGS_SET) {
>> +					skip = 1;
>> +					idx_old = vals[j].idx;
>> +					break;
>> +				}
>> +			}
> 
> This de-duplication may be a little premature.  But I guess it doesn't
> hurt.
> 
>> +			if (skip) {
>> +				vals[i].idx = idx_old;
>> +				vals[i].set = FLAGS_DUPLICATE;
>> +			} else {
>> +				vals[i].idx = idx;
>> +				vals[i].set = FLAGS_SET;
>> +				idx++;
>> +			}
>> +		}
>> +	}
>> +
>> +	if (!strcmp(argv[1], "flags"))
>> +		print_usb_flags();
>> +	else if (!strcmp(argv[1], "storage"))
>> +		print_usb_storage();
>> +	else if (!strcmp(argv[1], "uas"))
>> +		print_usb_uas();
>> +	else
>> +		return 1;
>> +
>> +	return 0;
>> +}
> 
> The rest of the patch looks pretty straightforward.
> 
> Alan Stern
