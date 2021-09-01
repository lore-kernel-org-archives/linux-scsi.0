Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8BAC432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 16:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DD136108E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 16:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbhIAQka (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 12:40:30 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:44654 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhIAQk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 12:40:29 -0400
Received: by mail-pf1-f180.google.com with SMTP id v123so238242pfb.11;
        Wed, 01 Sep 2021 09:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SeBfV9dk3XO6MIAnJY4uNUm7ScqgWOiOwMwqX1+HqBU=;
        b=ikQY+xjlDccr+2YrV6tvaX3zzoc97DHLjWeQJVqoEcbfeAhYS8LbMDR+49/k7BTnP/
         ZwnzTIynJAWDoQjLxl1K5FOKiMbjZEM1WtH+1AI5e3EpaVQ0y6qZcyOLX076Nf/IgX6y
         3Z99FPuqoRLiepS0PVHcn4ak6QetE84Fx9ioUB4mA7Otvofyd/s4rJAacsEtw3Xlw2eL
         3+4f0TeZS7loDDcjAD7PTvs/RdtYrs2D0TDy2oc8KrYOo8YLPnAp/N79zZt1E0gHmtLF
         rjoXajrG2y7Ai9nFOI1OscTY/1hLK23uSIqIe5oCdwZwwAe9vE09pmTIA025b0mAiZ6Z
         Q6Ug==
X-Gm-Message-State: AOAM53163DhJsjF1/12/IPcbIEkZ0NZIorHC5YCmNgcqkRNXtnD/mKYa
        kB4p+vGFgWz/WRJ5lm/Bq0c=
X-Google-Smtp-Source: ABdhPJzKqCYZh4OZKp/fpRL4Yl5mSHnt0YSZfd+Uo66BPF+zlxjfnHwyj2Js4kQyl/EoSlcS+QgsEA==
X-Received: by 2002:a63:4a55:: with SMTP id j21mr298322pgl.187.1630514372686;
        Wed, 01 Sep 2021 09:39:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8a3b:44ab:b62:3ce2])
        by smtp.gmail.com with ESMTPSA id i10sm30438pfk.151.2021.09.01.09.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:39:31 -0700 (PDT)
Subject: Re: [PATCH 2/3] scsi: ufs: Add temperature notification exception
 handling
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-3-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <46a7ea4f-2c6b-7798-5845-ad47c64617dd@acm.org>
Date:   Wed, 1 Sep 2021 09:39:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210901123707.5014-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/21 5:37 AM, Avri Altman wrote:
> It is essentially up to the platform to decide what further actions need
> to be taken. So add a designated vop for that.  Each chipset vendor can
> decide if it wants to use the thermal subsystem, hw monitor, or some
> Privet implementation.

Why to make chipset vendors define what to do in case of extreme 
temperatures? I'd prefer a single implementation in ufshcd.c instead of 
making each vendor come up with a different implementation.

> +	void	(*temp_notify)(struct ufs_hba *hba, u16 status);

Please do not add new vops without adding at least one implementation of 
that vop.

Thanks,

Bart.
