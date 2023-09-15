Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D7CCD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbjIOWYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237930AbjIOWYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:24:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F3F2708
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:21:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0176EC433CA;
        Fri, 15 Sep 2023 22:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694816478;
        bh=sLn9hHIrIWk6k4hK6xavMhXTWqZ0CC3IlBkaWAla5VA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=f4iqFCghSF/i4achX/jkJNZHerR4ty2Soo372OSg62/3SIeyZR5qILZlicka0LF2l
         jGB06B9hRLim+Auk2sdXqwNGqfk3EZT8SGcRRlQ4/uA/oV2eGjHNvcfexoO2KRJqD/
         ZDwU2C7LxKpsO/YEPxymR4XtXRDQ7Y8fl2CcZYOua/H/25qL+/rpu2wdiVNfrKawd9
         1+Id6zB+4Dsv0Zb2AN0KWhSgOthrPBkwnlRycKKJRZwyY4wVTvl44vbj919etWQYa+
         fQCy/HegiTACEunfxx3/FL1GdrKfGTqfeWc1r1baBRNfU/XGfYfvOK2j6onIfcgsEu
         FMTu0ry492Mlg==
Message-ID: <4cb46bbe-3b42-d8a0-d9a0-d40567633c44@kernel.org>
Date:   Sat, 16 Sep 2023 07:21:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: Do no try to probe for CDL on old drives
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>
References: <20230915022034.678121-1-dlemoal@kernel.org>
 <5b0c1aa5-b41b-46f9-af5a-9cf2a325ae95@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5b0c1aa5-b41b-46f9-af5a-9cf2a325ae95@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/23 00:06, Bart Van Assche wrote:
> On 9/14/23 19:20, Damien Le Moal wrote:
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 92ae4b4f30ac..7aa70af1fc07 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1828,6 +1828,9 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>>   		hdr[2] = 0x7; /* claim SPC-5 version compatibility */
>>   	}
>>   
>> +	if (args->dev->flags & ATA_DFLAG_CDL)
>> +		hdr[2] = 0xd; /* claim SPC-6 version compatibility */
> 
> How about using the symbolic name SCSI_SPC_6 - 1 instead of the literal 
> constant 0xd?

I tried to stay consistent with the code in that function which has all the
versions hard coded. I can do a cleanup with a followup patch to replace the
version values with the "macro - 1" names. I would not want this to block this
patch as it is a regression fix confirmed to solve issues for several (and
growing number of) users.

> 
>> -	sdev->scsi_level = inq_result[2] & 0x07;
>> +	sdev->scsi_level = inq_result[2] & 0x0f;
>>   	if (sdev->scsi_level >= 2 ||
>>   	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
>>   		sdev->scsi_level++;
> 
> Can support for inq_result[3] & 0x0f == 1 be dropped? From an SPC-2
> draft from 2001: "A RESPONSE DATA FORMAT field value of two indicates 
> that the data shall be in the format specified in this standard.
> Response data format values less than two are obsolete. Response data 
> format values greater than two are reserved."

I did not check. But that is a change outside of the scope of this fix patch.

> 
>> @@ -157,6 +157,9 @@ enum scsi_disposition {
>>   #define SCSI_3          4        /* SPC */
>>   #define SCSI_SPC_2      5
>>   #define SCSI_SPC_3      6
>> +#define SCSI_SPC_4	7
>> +#define SCSI_SPC_5	8
>> +#define SCSI_SPC_6	14
> 
> Please consider changing the SCSI_SPC_* constants such that these match 
> the SPC standard. Having numerical values that do not match the standard 
> is confusing.

I agree. I do not know why this was done like this. This has been around as is
for a long time. The problem though with changing this is that scsi_level is
exposed in sysfs, so if we change that now, that could break some user things
unless we keep exposing sysfs value as scsi_level + 1. We could also add a
scsi_level_name attribute which gives the name, e.g. "spc-6" to be clear. In any
case, such a change is outside the scope of this patch and should be a followup.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

