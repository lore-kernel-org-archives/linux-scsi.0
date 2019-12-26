Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94916C2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69A1820CC7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:17:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="KnrndgTb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLZLRL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:17:11 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45912 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfLZLRL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:17:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id j26so24468118ljc.12
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aH15/cT0heFYqB/O73b1ObuaExtcpJbzvHVltZDRg9o=;
        b=KnrndgTbgC+oNIE6XF0clvVLd8PM3LoikB+aKjySpuV+msB35GPNyBCGbGYwLvqX9H
         oGGE5ZuZmzM6NFQv2M6gOWgcp0SVHTAvQqeSrKu8KWO5rIwskN6Kic1yoJM/BBZjhYU0
         aVz+G0AGx0EWdQa/5tADzdl1m7OwkzcZ33tguhUul5kbWHlWHfwVz9wEJQgxAMyOK88Z
         LNm1HR76ofTD0vcEhtUimSRgCZnNbnqEEFP2YYxbz1BLCD8oitVnTMtjPuCp3jnIvONc
         YJOaumWRIAbQ2g1G6PXH+4E8mEL8Wfpil3le47jmgVaerjQivAULbX0KtC2WFTFW9N/b
         LRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aH15/cT0heFYqB/O73b1ObuaExtcpJbzvHVltZDRg9o=;
        b=mpWaYyBAIqmyZq1C4eGa+fym9tXodsLizMo6NElRQkVDjA3NZmA+93btk1K6r0KVed
         2YZwY2WF1K2xwPAkb6i7o/Im4OiqkDgOATdWs9gm0wPBP+MY8H1i7Z/1DSUK6DevNZpR
         tdjyB4gV7ZWbBcFGuLJMoy2y6mMfGbD6MbnJVe5QQVzo/UtpD4fbCIoSRd2Q7ntc7oUQ
         Az/e8inT29nl8qI7Bft/FF+xmRcvFnve3PGOCaCULu8D62CjnT6cqsl9qtkMKaEk60ym
         2eg0fcxRdPbdtR+79nZZW6P6E8SchZvXGq8Jx1oeka/Bj6WNU140pgtIZVXiryFuNFe3
         2s0g==
X-Gm-Message-State: APjAAAWDK+ZSepdbdbpSSPT5OfFQQGxcZbYMw65svrItKySWAxnoa43Y
        YE97/K8hLkhI1krYBjSu6BCzug==
X-Google-Smtp-Source: APXvYqzioTsPIZdItBjF2rkZ8V9K+a/TAmQhvWhQznPkKJqf7cfwwFOc0U6kjoSqHvWnMJgGXWznSA==
X-Received: by 2002:a2e:9b05:: with SMTP id u5mr25457606lji.59.1577359029381;
        Thu, 26 Dec 2019 03:17:09 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:867:b21c:a50d:bd68:cd46:4921? ([2a00:1fa0:867:b21c:a50d:bd68:cd46:4921])
        by smtp.gmail.com with ESMTPSA id c27sm12798426lfh.62.2019.12.26.03.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 03:17:08 -0800 (PST)
Subject: Re: [PATCH] scsi: don't memset to zero after dma_alloc_coherent
To:     "yukuai (C)" <yukuai3@huawei.com>, ysato@users.sourceforge.jp,
        dalias@libc.org, aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc:     linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        zhengbin13@huawei.com, yi.zhang@huawei.com
References: <20191225132327.7121-1-yukuai3@huawei.com>
 <a3b27b94-1ab6-c33f-611c-56143fd390f8@cogentembedded.com>
 <958ffbe5-f3da-da16-9f2b-05923d13485b@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <68771eb5-03c4-422b-9956-930a0e3c9de8@cogentembedded.com>
Date:   Thu, 26 Dec 2019 14:16:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <958ffbe5-f3da-da16-9f2b-05923d13485b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26.12.2019 14:13, yukuai (C) wrote:

>>> dma_alloc_coherent already zeros out memory, so memset to zero is not
>>> needed.
>>>
>>> Signed-off-by: yu kuai <yukuai3@huawei.com>
>>> ---
>>>   arch/sh/mm/consistent.c             | 2 --
>>
>>     How this one is related to SCSI?
>>
> Thank you for your response!
> I put them in the same patch because I thougt they are the same situation. I'm 
> sorry if it's not appropriate.

    I'd recommend to split such patch to (at least) different subsystems, e.g. 
arch/sh/ part, drivers/scsi/ part.

> Yu Kuai

MBR, Sergei
