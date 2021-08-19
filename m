Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7C2C43216
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 17:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B196D6103A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 17:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhHSRFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 13:05:10 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:45713 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhHSRFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 13:05:09 -0400
Received: by mail-pg1-f178.google.com with SMTP id n18so6488226pgm.12
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 10:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4SJo8yzWwXXSkPMFCCRhHgVZYEdfE/ZuGu4frPe/Uw=;
        b=HMp8XkP0KhDuKK3nZDvA6oEn917DY7ie9t0UXlDhHQwkd+qE/3bwcdMNBNnSYwRzPE
         Um5DPyX3E3FKMamZlYdeIuN5NtPm4le9KWPLRX2aAAYUxAlfJymMl7UuiebQs5aDV2hd
         rJnTmW3PwI1Wv0EPs/YfIMnJbzTucGfjqjWlNYDyFMWaWlJfqWUMBXOGlokwoZ0GfTNz
         +K3QjQogn3SZvpOkvSbEZOsN/6voQE03f8erIDK/L4aj+Rp8UIuCeBpETW2M1403FRBa
         igNnpUok+rqdPPT4O3EsC8t5NxVAOnNRcAaq7TiJJ+N64Nhk/ViRY80Mg1Da4UJfwne/
         G4qA==
X-Gm-Message-State: AOAM531xWbS2cU3M9aNXuNtiaKWY83c3va2Sfp83Ajd8PRhd4fB3Z0dd
        DqKoyK5IT3lqKFJgc/el/h0=
X-Google-Smtp-Source: ABdhPJyPMYSWGAZnrNb3Qs8VYfIjiwMGeDrwo/ZKcxgqS59Rli05wpKitB/Q7zp9JUk9Nir43HihXg==
X-Received: by 2002:a05:6a00:aca:b029:392:9c79:3a39 with SMTP id c10-20020a056a000acab02903929c793a39mr15381341pfl.57.1629392672363;
        Thu, 19 Aug 2021 10:04:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8b47:c5d7:9562:9d96])
        by smtp.gmail.com with ESMTPSA id y12sm3961049pfa.25.2021.08.19.10.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 10:04:31 -0700 (PDT)
Subject: Re: [PATCH] scsi: fix scsi_mode_sense()
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210819073750.132601-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <54cc6af0-67c2-5427-9952-230a7fbf4a76@acm.org>
Date:   Thu, 19 Aug 2021 10:04:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819073750.132601-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 12:37 AM, Damien Le Moal wrote:
> The allocation length field of the MODE SENSE 10 command is 16-bits,
> occupying bytes 7 and 8 of the CDB. With this command, access to mode
> pages larger than 255 bytes is thus possible. Make sure that
> scsi_mode_sense() code reflects this by initializing the allocation
> length field using put_unaligned_be16() instead of directly setting
> only byte 8 of the CDB with the buffer length.
> 
> While at it, also fix the folowing:
> * use get_unaligned_be16() to retrieve the mode data length and block
>    descriptor length fields of the mode sense reply header instead of
>    using an open coded calculation.
> * Fix the kdoc dbd argument explanation: the DBD bit stands for
>    Disable Block Descriptor, which is the opposite of what the dbd
>    argument description was.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/scsi/scsi_lib.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7456a26aef51..92db00d81733 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2070,7 +2070,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
>   /**
>    *	scsi_mode_sense - issue a mode sense, falling back from 10 to six bytes if necessary.
>    *	@sdev:	SCSI device to be queried
> - *	@dbd:	set if mode sense will allow block descriptors to be returned
> + *	@dbd:	set to prevent mode sense from returning block descriptors
>    *	@modepage: mode page being requested
>    *	@buffer: request buffer (may not be smaller than eight bytes)
>    *	@len:	length of request buffer.
> @@ -2112,7 +2112,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>   			len = 8;
>   
>   		cmd[0] = MODE_SENSE_10;
> -		cmd[8] = len;
> +		put_unaligned_be16(len, &cmd[7]);
>   		header_length = 8;
>   	} else {
>   		if (len < 4)
> @@ -2166,12 +2166,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>   		data->longlba = 0;
>   		data->block_descriptor_length = 0;
>   	} else if (use_10_for_ms) {
> -		data->length = buffer[0]*256 + buffer[1] + 2;
> +		data->length = get_unaligned_be16(&buffer[0]) + 2;
>   		data->medium_type = buffer[2];
>   		data->device_specific = buffer[3];
>   		data->longlba = buffer[4] & 0x01;
> -		data->block_descriptor_length = buffer[6]*256
> -			+ buffer[7];
> +		data->block_descriptor_length = get_unaligned_be16(&buffer[6]);
>   	} else {
>   		data->length = buffer[0] + 1;
>   		data->medium_type = buffer[1];

If the type of the scsi_mode_sense() 'len' argument is changed from 
'int' into 'uint16_t', feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


