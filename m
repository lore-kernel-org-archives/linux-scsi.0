Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C3AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 02:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 650FA61B5F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 02:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344609AbhKPCUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 21:20:22 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:43978 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbhKORi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 12:38:58 -0500
Received: by mail-pj1-f51.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso431458pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 09:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZMCJfRpQ/lg/rn7kyZz7WdfD0mAoyYnSLZkEod1czo=;
        b=eoGH79yi/gz54bv3o+kxv4du2OFSz6TH1TfQJQkIaINWRTausUOo592sbv9grceJAN
         oTe1P3VEi3JKwupVetQItByeecAEpZ7PW3UteXrJsnQ/XQt1rQ6TH1p0xSmqSMiEyJTT
         Zzjegnrfki7K+gxMvD5mfqZOGeh0HRPmueEPD7g54tq3gnNiJa+I6d6Cczc9/6ZOZo6D
         CVNYTtE/4Upb8IHzTEpVzW7/IncueUk8ucCYT0iBj9Ezn06rECfGE5wD55/z0x7itzOO
         btJbj9zZBwk/6GqqVOmyq1bg5vUes6pFFyVSR/f5NZx3llDYcVL7osH+/BWT8skSj9ku
         8N9A==
X-Gm-Message-State: AOAM530w7kATINxGgNBoZjgMzcdMt05p2rgF3U7vuwt+SsHtZosJCh/A
        B/nLJwNAPRJm0Rs6bHquFbc3/WAKdbE=
X-Google-Smtp-Source: ABdhPJxWZrosIvlBm49UwmTRC4HIVp+mXBCV8kPq5pmh4L1K36S2FfOEf6obMWG/9USaoGIMY7s1eQ==
X-Received: by 2002:a17:902:7616:b0:143:a8cd:ef0 with SMTP id k22-20020a170902761600b00143a8cd0ef0mr32101217pll.48.1636997762454;
        Mon, 15 Nov 2021 09:36:02 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:bd5e:539:872f:fca2? ([2620:0:1000:2514:bd5e:539:872f:fca2])
        by smtp.gmail.com with ESMTPSA id 14sm4399703pge.35.2021.11.15.09.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 09:36:01 -0800 (PST)
Subject: Re: [PATCH] scsi: simplify registration of scsi host sysfs attributes
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <52cea40c-1de2-9742-168a-c8ff0a29f0bf@acm.org>
Date:   Mon, 15 Nov 2021 09:36:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/21 1:29 AM, Damien Le Moal wrote:
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8049b00b6766..c3b6812aac5b 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -359,6 +359,7 @@ static void scsi_host_dev_release(struct device *dev)
>   static struct device_type scsi_host_type = {
>   	.name =		"scsi_host",
>   	.release =	scsi_host_dev_release,
> +	.groups =	scsi_sysfs_shost_attr_groups,
>   };

Many SCSI LLDs use class_to_shost() to convert a device pointer into a SCSI host
pointer. This patch makes the use of that macro very confusing since the SCSI
host class is no longer involved in attribute registration.

Thanks,

Bart.
