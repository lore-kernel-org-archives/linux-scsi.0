Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94058CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63CEE21D7F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jj3c3Z6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfJYWmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 18:42:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33345 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfJYWmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 18:42:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id 6so5238563wmf.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 15:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0ZD6BUGdPglt9aL2GFATz5XF2NVKRw+d/QxbPSEWhis=;
        b=Jj3c3Z6gxJhHO9NJST4/bt+HAL2J7P65filUjWOT5UTgX4RUZgxHWBEFo3/ipgNai0
         0gWVvaTH0xRg2R0bVVeAwwgF7o8hLNNwvr2X6FJ/wLq2Xth0JPPJGcly9x7iOuhg5yVl
         8KhyNyWfXSB3UtEk31ok+D1JtPO0Wtp7AEUtbYMxCoU7Ye7KNpiXCYq8VSTjRTpT4plz
         yDp/MWg+fMwpSXqIy7HE1x1JofYO2N2jn++HOUny8dk1QjCnoHVW07eA2JVZPOjqSdrp
         WE97lOdiD2SmZjalC6412EpR3BrIKvqBhgA3JMmSLwLzfYzNZlWGOBRPOUBhSodI26Oi
         9ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ZD6BUGdPglt9aL2GFATz5XF2NVKRw+d/QxbPSEWhis=;
        b=JPlSeo9JtTmsfMCvBMf3XG+0wV+tK48n+IGL98TlpJmOcg1xI4kX0dpt7dBYUwYNl3
         MC/oX/iYVi3w6OpoWlaw7fYqeFSd3mwiTVu7VvtD54bDbbZ48rhEArHpVp9+iPoo9h0U
         RNzqv4gN+qljzfpomdiGB3IfndPF/Zc5d3Tz0At1JorTliIJ38MZ477GQorpKeV4gbIl
         0S1lXt2QPi9hvrWwhD3esctk6u1HxOQod71zBuGJU2TiGfOeu4RjcLd9eTFkAfsR842U
         tV5UjjfcYntahs34mkPGodDUAiLCQHbh9kBI2oM9hNvIAk0+p9f0hPV46yLAU8Dp4gv8
         WYSA==
X-Gm-Message-State: APjAAAXlM6nGcMYudXRlE6b7jU/v3rLoy0M+yc89dH49bGqOWVLu0Tj9
        sGLuD4vZYDh0eCvkhFsUZpk=
X-Google-Smtp-Source: APXvYqwaxSAbAbWjE4y71aYSjqPnwb9SCn+/lZ6Ezk4o1ioy8f2tG9f9n3bFt6LfnbmhQZ0rgiMBtg==
X-Received: by 2002:a7b:c10f:: with SMTP id w15mr5392596wmi.171.1572043336710;
        Fri, 25 Oct 2019 15:42:16 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b3sm2847893wrv.40.2019.10.25.15.42.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 15:42:16 -0700 (PDT)
Subject: Re: [PATCH 03/32] elx: libefc_sli: Data structures and defines for
 mbox commands
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-4-jsmart2021@gmail.com>
 <20191025111944.hdgfnslk57njngfi@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <28e21557-33d4-d99d-e2c7-e353ef74ece4@gmail.com>
Date:   Fri, 25 Oct 2019 15:42:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025111944.hdgfnslk57njngfi@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks. We mostly agree with the comment written and will work on the 
changes. Agreed that consistency and uniformity helps.

Exceptions or answers to questions are inline below.

-- james


On 10/25/2019 4:19 AM, Daniel Wagner wrote:

>> +#define SLI_PAGE_SIZE		(1 << 12)	/* 4096 */
> 
> So SLI_PAGE_SIZE is fixed and can't be changed...

For how the driver uses the SLI interface in this current 
implementation, yes. The interface's page size is independent from what 
the OS's pagesize is.


> ... and callers of this function pass in SLI_PAGE_SIZE.

>> +{
>> +	u32	mask = page_size - 1;
>> +	u32	shift = 0;
>> +
>> +	switch (page_size) {
>> +	case 4096:
>> +		shift = 12;
>> +		break;
>> +	case 8192:
>> +		shift = 13;
>> +		break;
>> +	case 16384:
>> +		shift = 14;
>> +		break;
>> +	case 32768:
>> +		shift = 15;
>> +		break;
>> +	case 65536:
>> +		shift = 16;
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
> 
> What about using __ffs(page_size)? But...

will look into it...

> 
>> +
>> +	return (bytes + mask) >> shift;
> 
> ... mask and shift could just be defined like SLI_PAGE_SIZE and we
> safe a few instructions. Unless SLI_PAGE_SIZE will be dynamic in future.

desire is to keep it easily adapted. There's actually some conditions 
that could have us use different page sizes for different structures.


