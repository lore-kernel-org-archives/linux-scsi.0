Return-Path: <SRS0=CnLx=YH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20720C4CECE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Oct 2019 15:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04B422133F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Oct 2019 15:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbfJNP6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Oct 2019 11:58:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44063 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfJNP6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2019 11:58:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so10615228pfn.11;
        Mon, 14 Oct 2019 08:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0z7F7bJ7/hu+WTeZGPgI6D7KPNJezuJIyaVC8SWKK1E=;
        b=YskcesWD2beDyuMKTK8N/YROcojIIBT8xID79EK5u2yBwQ76mqb5U2cGHTgEx8iQUS
         sLuYN2/xPZjoKByNVH2KotiL0DmDaoQVJujWIpIvCZ2cUM2Ele+O4a5DSno/0z/b8B3/
         rF9zd0p/qLe1pVM1fOQudcXxewRWCcc6jXeigZ+QMuDSsUnVl3NRV9eW8LdCkhVhCCQ2
         EpfE+qNJ6wDrbSukDHE7JGVlLZsPv9tjMOIbqETVhgE5482f+7cXAcGZcT0BNKFzYIlZ
         TRBY7kaVyHWp+Svkk3TDIPDZGaLZAyu4ljrKRWvZWTbkXowxnOPqeOnE9m96tweey2xi
         rrHw==
X-Gm-Message-State: APjAAAUGZ2xlZJoxglv9yioUtrS82g64635ucvtplS7DWz12lq0Efd6b
        uTmJBDQqJNrzjYveKIfQ95b462sg
X-Google-Smtp-Source: APXvYqzjcEd43LyeZWsfCYRMvopdQ15WkebUad1/EyHRqDoR7f0gEEzovBnFPtYbHY9dYzRCBsMWFw==
X-Received: by 2002:a65:6394:: with SMTP id h20mr33411699pgv.272.1571068685537;
        Mon, 14 Oct 2019 08:58:05 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 127sm16623066pfy.56.2019.10.14.08.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 08:58:04 -0700 (PDT)
Subject: Re: [PATCH] scsi: fix unintended sign extension on left shifts
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
        Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191014121613.21999-1-colin.king@canonical.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0e2a6d4c-b346-cb1b-7941-e247a0d0f8b2@acm.org>
Date:   Mon, 14 Oct 2019 08:58:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014121613.21999-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/19 5:16 AM, Colin King wrote:
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 0f17e7dac1b0..1d3a5a2dc229 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -38,7 +38,7 @@ scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
>   	const char *ret = trace_seq_buffer_ptr(p);
>   	sector_t lba = 0, txlen = 0;
>   
> -	lba |= (cdb[2] << 24);
> +	lba |= ((u64)cdb[2] << 24);
>   	lba |= (cdb[3] << 16);
>   	lba |= (cdb[4] << 8);
>   	lba |=  cdb[5];

Have you considered to use get/put_unaligned_be*() instead of making the 
above change?

Thanks,

Bart.
