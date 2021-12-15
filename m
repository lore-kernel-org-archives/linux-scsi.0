Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5C8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 18:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238826AbhLOSo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 13:44:28 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:45745 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhLOSo2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 13:44:28 -0500
Received: by mail-pj1-f53.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so20097044pjq.4
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 10:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YpcCaXSkNIumvZ89mgsCBK3Ixb1g/sXzswTeR5CXX24=;
        b=rbiAUU80LN0pcBxZtyfIbC0He7cPintPhgVcH0F2l+5Fa6vTzpcnl6lX43D1CYxY2q
         OdxT6ARxswIqUu551m6a6ueuomM0GRKPkzDqQBM9k4uiSi8SJnYVnFHDm3hsU6kTCFkZ
         vfV87yU1n5yF0QsNaxj3tktbesn9TFTLXWJem5Bvswcd5amhbDl6f2mKPo7MWWs+yDlH
         8B1QSVGcJkfuyALBsBw2OAiE9Fzyln7fAnGK7w+cyKPJa+vAHSf0ui592c9upVlGOE1t
         MwSccd1y+yXd1l1HzPjlpboqtnrBcHiioVLrB1HDg6rbu0ubmj9B7sS6y5NFP/sADqON
         lbuw==
X-Gm-Message-State: AOAM533tWfLbCpwQCcFO36cmTjsNbwXxfmrGZwUPoP8G6y+Fx6PInMCW
        spmsLkwnsn9hW3bI5KSoqOQ=
X-Google-Smtp-Source: ABdhPJw22zkNowgTHx8RNYJ4fdUWHCIpy5yDXGoc2klmjC6Lf5K9KgU/ce9hkG7N6zzAnaLKNnwWJQ==
X-Received: by 2002:a17:902:c40c:b0:148:aa84:ef51 with SMTP id k12-20020a170902c40c00b00148aa84ef51mr3578657plk.98.1639593867441;
        Wed, 15 Dec 2021 10:44:27 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:6f47:6f2c:fba9:e717? ([2620:0:1000:2514:6f47:6f2c:fba9:e717])
        by smtp.gmail.com with ESMTPSA id d10sm3501778pfl.139.2021.12.15.10.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 10:44:26 -0800 (PST)
Subject: Re: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <20211203231950.193369-17-bvanassche@acm.org> <YbgX5qZ4VFXPqnnr@ripper>
 <701e993f-0b74-204a-1b07-306c13820fa9@acm.org> <YblmfSDOrxHZ/aW8@yoga>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3ee8f362-1bed-6691-a292-ff2270888753@acm.org>
Date:   Wed, 15 Dec 2021 10:44:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YblmfSDOrxHZ/aW8@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/21 7:52 PM, Bjorn Andersson wrote:
> I can confirm that this resolves the issue I saw and allow me to boot my
> boards again. Can you please spin this in a patch?

Thanks for having tested this patch. Since Bean already posted this patch in the
proper form, please take a look at
https://lore.kernel.org/linux-scsi/20211214120537.531628-1-huobean@gmail.com/

Thanks,

Bart.
