Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821C0CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5188620663
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZAciswf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfJYWbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 18:31:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40217 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfJYWbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 18:31:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so3517909wmm.5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gc+4LUhluKyvD1AIKy5unYqdrJUuX+mc/X56271wVak=;
        b=BZAciswfz+EsuGiZY9b28Wr4j7bOfQfDxz6ctqj9lv2lF+Q9prSucfhHYEwHq/Y90b
         nyIpCaMNGrVT0Wqvp0TtKxQSPSbViHaIG6w6QTcBS87ARhsSx+UAeC/fJ3CsxSo8aSJe
         3FG5jOwmc5FeBa1aAEfuHtHPGj8Zz+5dU9ngmGtJNkG0azcTfcHsf4no8ay09ccYBior
         hRUunXzxG5Ygd4BwBKRJxIY65g/WiMHMZT/aiouPIHHZsatmhSb4l9oCXGuDVq7JTUL+
         ywDvVqkSGLcrl8pwZ1lVhUHOhFqK+H1LqtS8iG8PMeQfAcd6bmtB++FXS1pTpKjlO3SC
         2Arw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gc+4LUhluKyvD1AIKy5unYqdrJUuX+mc/X56271wVak=;
        b=D3bnbF9vMVcCR2hHKK0YLiVjRs7N9/HF+MKY9eoN/EO86oRySO7akfY7RHBWtSbsta
         NEokyCF0BO7TM2ve9h44yqaTdo+uXltiZtNZ4EUNjOzEBGbja+IfPIkuXJe8jI9/aFEc
         b74u2Tg2zKUNmun5dnmGZScY6ye4vsfuQqM3r7kEqxnDgNxCezX930SQksgxkjsRCgSo
         aVNsizhRNNZtEYyTggGAtDDFr1A6pSsNkEYZX2HoVeKWRq5hpkiSebtVc3UVksHqXaAD
         c0aWb5bji7Bpxy5tJU/Dph6b66s+CPzRZT0HlEMZo0okvnbcbKWmRJcSF2M8m9hvT3Ss
         dBPQ==
X-Gm-Message-State: APjAAAUaKwcWa6ictnoLfODZ2ZYB8qCliZ7FOP6uCIziz2dmkktwYaI2
        StOD8rx9toJ1uxvAUJ8Q7+IQ2WiF
X-Google-Smtp-Source: APXvYqwNSJtPwPxdQQNEIi+YWk9XJhZ8WoRj/e7mUwNwWe/iFEGCUTJbAZrBqpUcSVcNfLo3BxCj3g==
X-Received: by 2002:a1c:2cc4:: with SMTP id s187mr5293149wms.168.1572042668347;
        Fri, 25 Oct 2019 15:31:08 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 65sm6005914wrs.9.2019.10.25.15.31.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 15:31:07 -0700 (PDT)
Subject: Re: [PATCH 00/32] [NEW] efct: Broadcom (Emulex) FC Target driver
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191025155634.eacbiyu5fo77ddet@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <ade13ac2-d165-58de-18f1-f15221eb449a@gmail.com>
Date:   Fri, 25 Oct 2019 15:31:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025155634.eacbiyu5fo77ddet@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/2019 8:56 AM, Daniel Wagner wrote:
> Hi James,
> 
>> Review comments welcome!
> 
> My compiler is complaining:
> 
> home/wagi/work/linux/drivers/scsi/elx/efct/efct_driver.c: In function ‘efct_request_firmware_update’:
> /home/wagi/work/linux/drivers/scsi/elx/efct/efct_driver.c:350:3: warning: ‘fw_change_status’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    350 |   switch (fw_change_status) {
>        |   ^~~~~~
>    CC      drivers/scsi/elx/libefc/efc_device.o
>    CC      drivers/scsi/elx/libefc/efc_lib.o
>    CC      drivers/scsi/elx/libefc/efc_sm.o
>    CC      drivers/scsi/elx/libefc_sli/sli4.o

Well, functionally it isn't an error as the way the code is written and 
the writes occur, it will always have a valid value when there was no 
call value. But, I can see how this is hard for the compiler to figure 
out.  We'll patch something to make the compiler happy.

> /home/wagi/work/linux/drivers/scsi/elx/libefc_sli/sli4.c: In function ‘sli_fc_rq_set_alloc’:
> /home/wagi/work/linux/drivers/scsi/elx/libefc_sli/sli4.c:818:12: warning: ‘offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    818 |  u32 i, p, offset;
>        |            ^~~~~~

Yep - we will fix.

-- james

