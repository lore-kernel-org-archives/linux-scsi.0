Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDC2CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 23:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B10121D7B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 23:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7xHbzag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfJYXAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 19:00:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41363 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfJYXAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 19:00:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id p4so4045037wrm.8
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 16:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O5BHDggI/APaVoJZMYrH1yl3LK2orjXBHUyETYz7L38=;
        b=W7xHbzagGrl49Li1aGX1G4jn3MVdPhMd8Bfve2FygI/n9eopXiSYaLPATha5VnBL/5
         rKSSInD4nujZLUCqqo8EmT317a5pQ59se4fZ5wwiPhLoz682Zjnd0QxFbvdOSj7GMtk/
         qbpiTL5UCiVmSwi1FNldo64jtDO30c+qNBMixcTc4I8u72SEERtWz/Yh0afwtUab2XE3
         9BV1msaTbESad2Lu8199UkAHjufiVjmDTwrCMxpAFDX0h1Iu/79j59S5V0/CdVevKmE9
         TpltVI9byKR1B9bkGCTIyupejiHHc4RO+xOTpxy71RJmGE8gkFJ5VnVbpuQkIHIZYcVN
         k8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O5BHDggI/APaVoJZMYrH1yl3LK2orjXBHUyETYz7L38=;
        b=Lv/o70J+frlypGa6fVFxnoFOjmUkYgES3PgzYEX592Xh5Wk8sI+A4dPErvGTHLerY+
         /BKvNIYEdShpBFjCg3j5/MnAqcPK1OHO6QIrKap6z+POK2jSDp/75Ceii5GZxc/Z5Ulh
         DPAN9CQd6cu90E4sHBGBAyo9wTLZIx75KnSiRvL81ypu9H80jdwNuvz8QCd+rJeSH0sX
         cUk7kUypRiOsVfoHnJWUHEmEEVBjeZTwz27dxf7PssBmqY2IGTHpr38Fdo314G6i7T8K
         2A3QzU1jvMX9fEl2K0iuISuK7MrP/Vq8kJ7KOoLPVH0hw9lmd/cMVmXWZUf4tyTc89Lu
         wiaQ==
X-Gm-Message-State: APjAAAWuitVjS711W2o42HZ5I3behLCNXXPRflDLREIRPWVpRnq65ltd
        mCyVaPkDqJMsqUutclumCG7cHI3N
X-Google-Smtp-Source: APXvYqzzMB6076KGghcEEYqaNtO62aRn0aezBZGCdtmwhBQKDkonZG/aKprQY8yoqxiJYARfM/fHNQ==
X-Received: by 2002:adf:aacc:: with SMTP id i12mr5010263wrc.15.1572044418407;
        Fri, 25 Oct 2019 16:00:18 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n22sm2976282wmk.19.2019.10.25.16.00.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 16:00:17 -0700 (PDT)
Subject: Re: [PATCH 02/32] elx: libefc_sli: SLI Descriptors and Queue entries
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-3-jsmart2021@gmail.com>
 <20191025095922.spyfsn5wlnou2xj2@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <8fcf4f62-3a81-532b-8670-8fba60ea8ab3@gmail.com>
Date:   Fri, 25 Oct 2019 16:00:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025095922.spyfsn5wlnou2xj2@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks. We mostly agree with the comment written and will work on the 
changes.

Exceptions or answers to questions are inline below.

-- james


On 10/25/2019 2:59 AM, Daniel Wagner wrote:

> I noticed sometimes there are also BIT() used. Wouldn't it make sense
> to the whole driver to use one or the other version of bit
> definitions?

We don't want to have BIT() used. Any references will be removed.


>> +
>> +/**
>> + * @brief Generic Common Create EQ/CQ/MQ/WQ/RQ Queue completion
>> + */
>> +struct sli4_rsp_cmn_create_queue_s {
>> +	struct sli4_rsp_hdr_s	hdr;
>> +	__le16	q_id;
>> +	u8	rsvd18;
>> +	u8	ulp;
>> +	__le32	db_offset;
>> +	__le16	db_rs;
>> +	__le16	db_fmt;
>> +};
> 
> Just wondering about all these definitions here: These structs
> describes the wire format, no? Shouldn't this marked with __packed? I
> keep forgetting the rules.

not wire format, but rather the endianness of the adapter interface.

yes, it's probably good practice to use __packed. The existing 
definitions should have been ok as the layouts should never have created 
a condition where pad would have been added. but... better safe than sorry.



> Picking up my question from patch #1, what's the idea about the enums
> and defines? Why are the last two ones not an enum?

Well, its a code volume issue. We migrated old code which was mostly 
defines. When close attention was made to properly code for endianness 
in register definitions and things at the lower interfaces, we used 
enums.  Some things changed while others didn't.  Upon conclusion, we 
saw a large amount of both and it is a lot of work for no technical gain 
and limited readability gain to make them all one way or the other.

I asked around as to whether we must be all one type or not and there's 
not a mandate to be one or the other or even specifically when to do 
what. So we've stuck with what we have.

> 
>> +/**
>> + * @brief WQ_CREATE
>> + *
>> + * Create a Work Queue for FC.
>> + */
>> +#define SLI4_WQ_CREATE_V0_MAX_PAGES	4
>> +struct sli4_rqst_wq_create_s {
>> +	struct sli4_rqst_hdr_s	hdr;
>> +	u8		num_pages;
>> +	u8		dua_byte;
>> +	__le16		cq_id;
>> +	struct sli4_dmaaddr_s page_phys_addr[SLI4_WQ_CREATE_V0_MAX_PAGES];
>> +	u8		bqu_byte;
>> +	u8		ulp;
>> +	__le16		rsvd;
>> +};
>> +
>> +struct sli4_rsp_wq_create_s {
>> +	struct sli4_rsp_cmn_create_queue_s q_rsp;
>> +};
>> +
>> +/**
>> + * @brief WQ_CREATE_V1
>> + *
>> + * Create a version 1 Work Queue for FC use.
>> + */
> 
> Why does the workqueue code encode a version? Isn't this pure driver
> code?

The same command can have multiple forms. yes, there's no need to be 
calling out the version if they are the same between versions. We'll fix 
this.



