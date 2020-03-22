Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65549C4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 19:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AAAB20719
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 19:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFem7Y9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCVTpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 15:45:34 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:40399 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCVTpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 15:45:34 -0400
Received: by mail-wm1-f51.google.com with SMTP id a81so6591516wmf.5
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 12:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YHrGFzzsOtst6yc/sBRhUb3pRpwcF9AlxtJsYrak3Ac=;
        b=RFem7Y9POtmFEHbrmqUURUW5CEx8KLKL0+ArklN7xIQ6BzjluleawaaPsWRrZKdSmC
         785npWIZyFJuoFVv3bK3SBzmwIPOVcxBWZdb/kRXyBQZh9SYY8XG/MVeePQbwohZYGDV
         4wl50ZHRh5JjzorgeMPamSjU5tNaw8KmEN4iXzsnxY/gHXEUVqFMlQmhE/XL7dWKgvOM
         jmguh7nsh60CE7X1Ql4oBI98FME5IZMZp1bhwcEC5eqeJP8nuFLgYOXFA1Qqwqap4GYQ
         rB3H6SIgYCRNszSUz/4ijr2ZhlP8cwd/wrIykzzQvk6fddZoNanJODzhfJbScXvU8NSe
         Hh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YHrGFzzsOtst6yc/sBRhUb3pRpwcF9AlxtJsYrak3Ac=;
        b=g4w5beJJ9Jka27oCtMHE2Vc+pzpMflfIzHP0xuLDMtQ5ig3meRtu08ISY9vWledkTx
         nK7oC88RvYyjXeugo81vg0+HIXrfc9hv3ASx/IrupkTRzvk5DAvO0FIn+J6VkZ4VRQL7
         kAeC/za5AKgUGvrAg03CCrc8r7mkJ27y1ZPfew9G6EKp9fJxUOMCTrtQWRaLS2gz8dfL
         KvkJkaue1WFbb7NmfbZcNRDdNYy2o+2ofEh/U1mhT3C/VeKwab+Pk/HowEzbV5aGHhDw
         v8ZMSL4zKBECQ3JRD0PzVYwatFTsHgcs3VeeE4mTZynablCdOytAhhS6UpfHmbMDnp00
         aLsA==
X-Gm-Message-State: ANhLgQ1wpmMY1WqkgzPwnZAWPJzz3BkZy5DZHg+txdtq9TAOwUuLj0wi
        l+KOQXBUUfL2w+VZdVaNmazTdFzV
X-Google-Smtp-Source: ADFU+vubEocEEhIWB+ihDaXgwD8AgeFPkohiBTK4BtSFHkkiOsCX985rf+lU6Bh4wUSa6rElbvDDbw==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr23731639wmc.171.1584906332623;
        Sun, 22 Mar 2020 12:45:32 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id t12sm3227651wrm.0.2020.03.22.12.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 12:45:31 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com>
Cc:     linux-scsi@vger.kernel.org
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
Date:   Sun, 22 Mar 2020 20:45:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq1pnd4tbxm.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>      # sg_readcap -l /dev/sdc
>>      Read Capacity results:
>>         Protection: prot_en=0, p_type=0, p_i_exponent=0
>>         Logical block provisioning: lbpme=0, lbprz=0
>>         Last LBA=15628053166 (0x3a3812aae), Number of logical
>> blocks=15628053167
>>         Logical block length=512 bytes
>>         Logical blocks per physical block exponent=3 [so physical block
>> length=4096 bytes]
>>         Lowest aligned LBA=0
>>      Hence:
>>         Device size: 8001563221504 bytes, 7630885.3 MiB, 8001.56 GB, 8.00 TB
> Please send me the output of:
>
> # sg_readcap /dev/sdc
>
> (i.e. without the -l from the previous run).
>
> I am very puzzled as to why we end up in the older capacity code for a
> device this big (8TB).
>

Here you go:

# sg_readcap /dev/sdc
READ CAPACITY (10) indicates device capacity too large
   now trying 16 byte cdb variant
Read Capacity results:
    Protection: prot_en=0, p_type=0, p_i_exponent=0
    Logical block provisioning: lbpme=0, lbprz=0
    Last LBA=15628053166 (0x3a3812aae), Number of logical blocks=15628053167
    Logical block length=512 bytes
    Logical blocks per physical block exponent=3 [so physical block 
length=4096 bytes]
    Lowest aligned LBA=0
Hence:
    Device size: 8001563221504 bytes, 7630885.3 MiB, 8001.56 GB, 8.00 TB

Hope this helps to solve it

