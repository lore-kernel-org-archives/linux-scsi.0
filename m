Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB98C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 04:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10383223E8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 04:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbhAUE5F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:57:05 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:43935 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbhAUEzt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 23:55:49 -0500
Received: by mail-pf1-f180.google.com with SMTP id q131so773748pfq.10;
        Wed, 20 Jan 2021 20:55:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PBIzSn5Y6foZ7Tj9M6MKSIos+ef1dkG6dprinExElvI=;
        b=Otys6HvmLSsifO5cFMrfGKZm1HDTwdgPPP3URXjwXcop0BTwSo/zAJ8J5LtXUvuKg5
         45kqf0h43sK1vzkFUDbFlhW85g633z/qJCC/4jCuufAz9KVcn1qhJYb/sC14bq2srd6S
         OKRDQ4O1mp/DzY5MHTaUGWZCP0ZujTHOEi1ATVNqcElJDZzGATlOwV9QoTmwU+qNqGG2
         ahUpnfLQoC+f/WRQ1zX84XjQUiAvn/cLZhNnUnYIf41RFMirz1gUcMebzATGMtjkp7dT
         ZE7hZnXVsKsXZN+Md9EhJlnp4i1TnikN1+nDGuFYRhLeZSE4n9X3vUr2Dpz/hGucw/yc
         RWJA==
X-Gm-Message-State: AOAM5305zPLfUxKPiOMOouH5CV3MejQ0MBTaEGDgJmVFUU842+ALgQNI
        VS97gnbmTGn04LqENdRnL251Ym9jIto=
X-Google-Smtp-Source: ABdhPJwLBbh9u2kcoS9CMW/M27MDUr3Du3tURIRWHdLf1+MPNb8nb6g0zMF8G0BWogzuMwPlMBp1iQ==
X-Received: by 2002:a63:d814:: with SMTP id b20mr12628905pgh.202.1611204907616;
        Wed, 20 Jan 2021 20:55:07 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:b5ed:474a:81d5:2e31? ([2601:647:4000:d7:b5ed:474a:81d5:2e31])
        by smtp.gmail.com with ESMTPSA id y22sm3646907pfb.132.2021.01.20.20.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:55:06 -0800 (PST)
Subject: Re: [PATCH v2] scsi/qla4xxx: convert sysfs sprintf/snprintf family to
 sysfs_emit/sysfs_emit_at
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>, njavali@marvell.com
Cc:     mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611201437-111938-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9d745731-f8a3-98bf-3ca8-6367ef53aa8d@acm.org>
Date:   Wed, 20 Jan 2021 20:55:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611201437-111938-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/20/21 7:57 PM, Jiapeng Zhong wrote:
> -		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
> +		return sysfs_emit_at(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
>  				ha->fw_info.fw_major, ha->fw_info.fw_minor,
>  				ha->fw_info.fw_patch, ha->fw_info.fw_build);

From the sysfs_emit_at() source code:

WARN(... || at >= PAGE_SIZE, "invalid sysfs_emit_at: buf:%p at:%d\n",
buf, at)

In other words, this patch is wrong. sysfs_emit() should have been used
instead of sysfs_emit_at().

Bart.
