Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EB1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 17:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhLNRpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 12:45:18 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:44769 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhLNRpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 12:45:17 -0500
Received: by mail-pg1-f182.google.com with SMTP id m15so17885192pgu.11
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 09:45:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z4DDSHz9TFLFqiYsJb52eLOQw68Il9LpLeCc+MHcz6k=;
        b=qYJ3b02YxkjgB9il9QYVqgqTwdG+inSMrmwdN6/Lm5TXEKYQIFvYbNoSatF4P/IXV9
         21GgaZ+M13ZWW714GWjHRzNTxo3SOh0yhYf4GG1JaaDccu7IaJRE63ePQSqhdlclWjiG
         DUS4LaYROYYdOrVruZzzPRCSmPD9nFZKwhpb09vATaIrifvkrVOXlznjCtaofC02VVom
         XwOCCuBgT8XyH3vg822yIbNkp8mGkcncIr5Zd0sfQQ1mYeKw7xHJQ/IQ06EzBvhxVHVD
         bgPFXlx8T+uHHnIF98Vb9AjKArB3Ejc1lUNZ0NH7krU6QVkSxpcIOgT/RsodP89fgSWz
         /KJQ==
X-Gm-Message-State: AOAM532Wj2cizDQ5rgVEV3HVjoDIc11kSg7ndDy3ewUry3/I9prJn3j7
        cS03Q9223A53cuLUd5+Yp0w=
X-Google-Smtp-Source: ABdhPJwX5lC14D9dSL2X1514yAclN03jOtKj4Emg9nb8kWPrBVqlCHah6FrE6ivFk4nd1YEUketd8w==
X-Received: by 2002:aa7:9a4e:0:b0:4a2:71f9:21e0 with SMTP id x14-20020aa79a4e000000b004a271f921e0mr5334318pfj.77.1639503917152;
        Tue, 14 Dec 2021 09:45:17 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:d051:c5f6:2f2a:19ae? ([2620:0:1000:2514:d051:c5f6:2f2a:19ae])
        by smtp.gmail.com with ESMTPSA id s24sm429625pfm.100.2021.12.14.09.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 09:45:16 -0800 (PST)
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Santosh Yaraganavi <santoshsy@gmail.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Vishak G <vishak.g@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Girish K S <girish.shivananjappa@linaro.org>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>
References: <20211104181059.4129537-1-bvanassche@acm.org>
 <163729506335.21244.1193812894951616835.b4-ty@oracle.com>
 <5a5cd1dde61e656e15df3767e1a6d2cc362d280d.camel@HansenPartnership.com>
 <1fed2928-a021-dcb9-18bb-3167fe23420a@acm.org>
 <acf65d27c844695118146aa34bc995780fd35b68.camel@HansenPartnership.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dc49c8f0-70ea-be5f-3df6-6f983c3e2695@acm.org>
Date:   Tue, 14 Dec 2021 09:45:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <acf65d27c844695118146aa34bc995780fd35b68.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/21 9:43 AM, James Bottomley wrote:
> I meant the effect of the fixes patch can be dropped in the merge
> commit.  So the sole surviving code is from the misc tree.  Like what I
> did at the top of the for-next branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?h=for-next&id=014adbc9a838772b265834a55cd7b13eb2665d7e

Thanks for the clarification. The ufshcd_abort() code at the above URL
looks good to me.

Thanks,

Bart.
