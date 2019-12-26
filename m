Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282DCC2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F188820828
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="Mfvwn7FJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLZLEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:04:07 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38396 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfLZLEH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:04:07 -0500
Received: by mail-lf1-f68.google.com with SMTP id r14so18312839lfm.5
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dMuzKwiDG9erY21rvfOIFhgZeA3agNAcCiJiS61PwtU=;
        b=Mfvwn7FJa6uuSnyUZWdsYRK1BPLGVGTda71DdZ00VryPu2xgB1/ctUYu/DTy7RZEBi
         7WN5JGj/upLjqTsuPs4V2T5acL2Zq1Bq/vuEPKVQbbgH1aMu830hXCyMWfgHiq9oauTF
         I715D1xkH6jylQT3zBZwRcthpgW4qDU2EyRBgX/PCTxGjqPupcuIkgI2RXIphW6imggK
         El2LjR1GV1WNIkf8sTYlEXQo5vADwL3h4p2TKvk386Sqh4hdQTUVzLSL6bsopQgqA1C/
         gMd5LoepahntJyZCkTAktCFj5X1/ob6G5iwqU+NSTXF2RErppyu1h+6fHPSqflHPXHNL
         r/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dMuzKwiDG9erY21rvfOIFhgZeA3agNAcCiJiS61PwtU=;
        b=io04HTSQfEQzyeHpMXMKdqpv/iTYhFbae+9F4oOiRBVXuwQhAEVSMYzIuHnnZHZGAk
         RZG+K6tELgjTop/6+Hh0Wjd5mE4L7dkSYAWMxsPJpIeG5xsTjHMQXdi5rKQtJIAeaaMI
         tDQMo44wEGuffi+2IJt6KgCMJ1j1IAzxASsqBuehuoeWW1MCizz/5BK/+s3qMJw1mFS6
         r8PpeNc+68wh3r8Gkh/Zpvh8URsKMBV+Hn8djplbQYsl9lP9EHBnj6kRFZoMLW/NlGSG
         EwR4tWG26/vWFWHvCc2vtQouExRv4SvUnKCXcBPjKN+55ahSgqvPK2LimyFsF7WI1b+/
         97ZA==
X-Gm-Message-State: APjAAAWxE/Y5i1jXe+mFJRu6vWZGsPvWK6rYX6yP8SixSElCasGJsTnL
        T8g8lPsstdrOv35JOBvgH9HRwQ==
X-Google-Smtp-Source: APXvYqxyty1Ur5C7kdZ8TaFQIOjjXKTBfsFDaeaWxLUho5PXnAcZgwjh39AF42C5Amhhl1+IARuWYQ==
X-Received: by 2002:ac2:5605:: with SMTP id v5mr26169631lfd.136.1577358245281;
        Thu, 26 Dec 2019 03:04:05 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:867:b21c:a50d:bd68:cd46:4921? ([2a00:1fa0:867:b21c:a50d:bd68:cd46:4921])
        by smtp.gmail.com with ESMTPSA id d24sm12128249lja.82.2019.12.26.03.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 03:04:04 -0800 (PST)
Subject: Re: [PATCH] scsi: don't memset to zero after dma_alloc_coherent
To:     yu kuai <yukuai3@huawei.com>, ysato@users.sourceforge.jp,
        dalias@libc.org, aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc:     linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        zhengbin13@huawei.com, yi.zhang@huawei.com
References: <20191225132327.7121-1-yukuai3@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <a3b27b94-1ab6-c33f-611c-56143fd390f8@cogentembedded.com>
Date:   Thu, 26 Dec 2019 14:03:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191225132327.7121-1-yukuai3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 25.12.2019 16:23, yu kuai wrote:

> dma_alloc_coherent already zeros out memory, so memset to zero is not
> needed.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>   arch/sh/mm/consistent.c             | 2 --

    How this one is related to SCSI?

>   drivers/scsi/dpt_i2o.c              | 4 ----
>   drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
>   drivers/scsi/mvsas/mv_init.c        | 4 ----
>   drivers/scsi/pmcraid.c              | 1 -
>   5 files changed, 12 deletions(-)
[...]

MBR, Sergei
