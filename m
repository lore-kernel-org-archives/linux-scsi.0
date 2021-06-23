Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25733C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 16:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B958611CB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 16:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFWQNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 12:13:14 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43797 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhFWQNM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 12:13:12 -0400
Received: by mail-pj1-f53.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso1682084pjp.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 09:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UDtXYWXBl+DT5ZV1/SGiaGvcDP1airAm5XyHtdYl/ns=;
        b=r3kIID8nfQalirH6I/+lvLERKTPcYGajHOQI4G0S5+2Ug5GmIT//S7189IHp8j6jAC
         QXW3/H6jpQI9UnYQp/TgQHVfn2VdoBWETJCflQiQ07Rq2zmasHH+F9D18TofMafDpwWu
         espTTpSw+j1WxMx/a2M4qZkFoQuWZJiht5cLbVqMNRpwwMACscTBGZuGRT6o9Bqd9XgQ
         Q2RLx5Zle83P2OVWhAXGin20TbS/BJwtlE2c/pDMFbRg1mRz6p0SZVGy7Tc09fvu8QUt
         KI1vgmP7KBzPWMgw/MIcL/IuHS0Z7QTwag6lbUTqku3A1v7dvvcvh7fIzAV2E2kZ6s+n
         h82w==
X-Gm-Message-State: AOAM531q8IhggShdausWgEpwmW+dtYY6JdqMXn3cr+Lv0z0d26+k376o
        qQBu6f7vK4Xx1uEqcJ4NvOU=
X-Google-Smtp-Source: ABdhPJzSIUaXd62Nnl5D1zKU4qAZ5tooRiS42GEb4rc/pzW6VSpQY8S61Zzc5QC4KmpLdyePNyfPMg==
X-Received: by 2002:a17:90a:ee88:: with SMTP id i8mr487142pjz.71.1624464654399;
        Wed, 23 Jun 2021 09:10:54 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y206sm350654pfb.3.2021.06.23.09.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 09:10:53 -0700 (PDT)
Subject: Re: [PATCH RFC 3/4] ufs: Improve static type checking for the host
 controller state
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-4-bvanassche@acm.org>
 <1b508ae21e3c81c690a8b875b8ed84b3@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8e040136-4d2f-6386-1fbb-3b9d825fa50c@acm.org>
Date:   Wed, 23 Jun 2021 09:10:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1b508ae21e3c81c690a8b875b8ed84b3@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:42 AM, Can Guo wrote:
> FYI, in my error handling update change series, I have one change
> (https://lore.kernel.org/patchwork/patch/1450656/) which moves the
> enumeration from ufshcd.c to ufshcd.h, which shall conflict with
> this one. What shall we do?

Hi Can,

Thanks for asking. I will rebase my patch series on top of yours.

Bart.
