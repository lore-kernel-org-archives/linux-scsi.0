Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C3AE95A82
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Oct 2023 10:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344569AbjJHK2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Oct 2023 06:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjJHK2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Oct 2023 06:28:06 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF725B9;
        Sun,  8 Oct 2023 03:28:04 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99c3c8adb27so605695766b.1;
        Sun, 08 Oct 2023 03:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696760883; x=1697365683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+dQ/foJ/DrtuVvzO4TaPDol4h8q7eiOGkS+VISQXOjo=;
        b=YFs9zItZ+YCaMvV1WpB8X5tShcxBoyktH2WLCxdE2IrJTr8XKGMqUGOQSV8XvbyMQo
         BoT/NurEQML+wNAdwjPmXAQ52DmJzyYS4Ij6HPmZmwpDY7AIVnTVse80oIK4dI3PyShZ
         Hmn1EE7iES7k7FcPefFHVhG/Kmqf5mTGZLZ7okLal1eCYTigIhN433fNUQ4pp7Zw7a7b
         7RLDN9xBnkA7wLX+8vyK0U+jIlibc85X0cAwvBvUNeaGSYkq1Md20mahxPXWG0bC2aIu
         TCTY/8dx4RwRiA22PTX4C/EScBIC2IXoF2BtShmDIbS99XQw7PZlget+D8VqKYaUSaEh
         UvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696760883; x=1697365683;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dQ/foJ/DrtuVvzO4TaPDol4h8q7eiOGkS+VISQXOjo=;
        b=kyT1P043odecx0OKQ/7TUfbNIj0DjiF3u+ise34ip5GKxUnq8x++aBt139wECM4VNe
         UrQKjcJ6AzoQlWCXtR7AmPlfbrBOdoRCkHvGWWGb/PQyzRGgL2tN08l5ulrw09Zd3W2N
         CXDcPra/zCSA5FiT6yJ70/SGEXdrvhS5bUcszbQJ1V+0jl/0ZY9Qnq8xk2iYFyhQxtjZ
         mRYot3TPURLZaxSmME0DyccHiqEXZu+w2Qm8FVeSx31yiaWNnyYWC9FlXP4jQGSetA4q
         ujCIb4mu097zIXey8j+ru+tcN0DKS15HkVAt3+kDCxPQ+O6IFFN7qhnGC/OwsVPJhG6y
         HJyQ==
X-Gm-Message-State: AOJu0YxcChORzNeystJX9qL8DdlTyhOQQelBZ/n7qhqscPpNCOWSPz5E
        ENWAxCoDUFgoyJAohQ4EFO1xbbXEl7Q=
X-Google-Smtp-Source: AGHT+IGJ4wS63bBEktCAwJAa5WSVIy4Jyp+YCGDfbWcuNlBL1Dtkr2QS5WKo+kP+9CH6Ajbadb99wQ==
X-Received: by 2002:a17:907:780d:b0:9b6:4df9:e5b5 with SMTP id la13-20020a170907780d00b009b64df9e5b5mr11509294ejc.61.1696760882666;
        Sun, 08 Oct 2023 03:28:02 -0700 (PDT)
Received: from [192.168.8.101] (78-80-112-174.customers.tmcz.cz. [78.80.112.174])
        by smtp.gmail.com with ESMTPSA id la18-20020a170906ad9200b0099cd008c1a4sm5388228ejb.136.2023.10.08.03.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Oct 2023 03:28:02 -0700 (PDT)
Message-ID: <49522775-fa90-438d-bf66-cc6cca6da738@gmail.com>
Date:   Sun, 8 Oct 2023 12:28:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] usb-storage: remove UNUSUAL_VENDOR_INTF macro
Content-Language: en-US
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-2-gmazyland@gmail.com>
 <691010ef-d388-4ce0-b6a0-427bf77bea95@rowland.harvard.edu>
From:   Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <691010ef-d388-4ce0-b6a0-427bf77bea95@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/23 19:16, Alan Stern wrote:
> On Fri, Oct 06, 2023 at 02:54:40PM +0200, Milan Broz wrote:
>> This patch removes macro that was used only
>> by commit that was reverted in
>>   commit ab4b71644a26d1ab92b987b2fd30e17c25e89f85
>>   USB: storage: fix Huawei mode switching regression
> 
> The standard format for referring to commits in patch descriptions is
> like this:
> 
> commit ab4b71644a26 ("USB: storage: fix Huawei mode switching regression")

Sure, I just forgot to put it here.

Thanks for review for this usb part!
I'll send a new version with fixed issues and your review line.

Milan

> 
> That is, the commit hash is abbreviated to its first 12 hex digits and
> is followed by the commit title enclosed in parentheses and quotation
> marks.
> 
> Apart from that minor issue,
> 
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Alan Stern
> 
>>
>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
>> ---
>>   drivers/usb/storage/usb.c          | 12 ------------
>>   drivers/usb/storage/usual-tables.c | 15 ---------------
>>   2 files changed, 27 deletions(-)
>>
>> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
>> index 7b36a3334fb3..bb1fbeddc5aa 100644
>> --- a/drivers/usb/storage/usb.c
>> +++ b/drivers/usb/storage/usb.c
>> @@ -110,17 +110,6 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
>>   	.useTransport = use_transport,	\
>>   }
>>   
>> -#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
>> -		vendor_name, product_name, use_protocol, use_transport, \
>> -		init_function, Flags) \
>> -{ \
>> -	.vendorName = vendor_name,	\
>> -	.productName = product_name,	\
>> -	.useProtocol = use_protocol,	\
>> -	.useTransport = use_transport,	\
>> -	.initFunction = init_function,	\
>> -}
>> -
>>   static const struct us_unusual_dev us_unusual_dev_list[] = {
>>   #	include "unusual_devs.h"
>>   	{ }		/* Terminating entry */
>> @@ -132,7 +121,6 @@ static const struct us_unusual_dev for_dynamic_ids =
>>   #undef UNUSUAL_DEV
>>   #undef COMPLIANT_DEV
>>   #undef USUAL_DEV
>> -#undef UNUSUAL_VENDOR_INTF
>>   
>>   #ifdef CONFIG_LOCKDEP
>>   
>> diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
>> index 529512827d8f..b3c3ea04c11c 100644
>> --- a/drivers/usb/storage/usual-tables.c
>> +++ b/drivers/usb/storage/usual-tables.c
>> @@ -26,20 +26,6 @@
>>   #define USUAL_DEV(useProto, useTrans) \
>>   { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
>>   
>> -/* Define the device is matched with Vendor ID and interface descriptors */
>> -#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
>> -			vendorName, productName, useProtocol, useTransport, \
>> -			initFunction, flags) \
>> -{ \
>> -	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
>> -				| USB_DEVICE_ID_MATCH_VENDOR, \
>> -	.idVendor    = (id_vendor), \
>> -	.bInterfaceClass = (cl), \
>> -	.bInterfaceSubClass = (sc), \
>> -	.bInterfaceProtocol = (pr), \
>> -	.driver_info = (flags) \
>> -}
>> -
>>   const struct usb_device_id usb_storage_usb_ids[] = {
>>   #	include "unusual_devs.h"
>>   	{ }		/* Terminating entry */
>> @@ -49,7 +35,6 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);
>>   #undef UNUSUAL_DEV
>>   #undef COMPLIANT_DEV
>>   #undef USUAL_DEV
>> -#undef UNUSUAL_VENDOR_INTF
>>   
>>   /*
>>    * The table of devices to ignore
>> -- 
>> 2.42.0
>>
