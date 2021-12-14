Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E30C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 17:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbhLNRh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 12:37:58 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:44684 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236630AbhLNRh4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 12:37:56 -0500
Received: by mail-pl1-f178.google.com with SMTP id q17so14078884plr.11
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 09:37:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ruVFSehlHHaWgdE6NgUtJR97Cm3+qtSetit6/cbIvyw=;
        b=KCMycmtktIqPzqL5hv6M5G8pz743khnNkbUiWRiV4y+Fi067JGYq0kV9xfoGwR3ViW
         JTiUOA0uel/bqxQ7pTx9oCb9cOf13+C2BrRABOAnFQoLFYs8+OiWtfpUE2JoHaXgTNDa
         FWna9/N0iAQMzE6Wpiwsj39LU0OeyEjLjaL5mKOMIVfNKBLejI4DeUF/fRiEyDv+bmbF
         2M/Bl0FwmIUaDZ9wDl9b5E8cxUpRi3/YiIq+mI3Jh9uwaHdGjp57/KniUH0BpN0gD0fc
         PV0u1Ps0q3zVk7U441RwoHsQkxIJyVHRwbYgux1Y34Vucf4n6tQp7F388wTPfyNZngbK
         4zSA==
X-Gm-Message-State: AOAM530CWvxRheHUv1pnloz2d4OiTPHYu2kbW/934hStAwUE0FwcSlQC
        2MQqrADqzSpu+GUDIo9tBwo=
X-Google-Smtp-Source: ABdhPJwb9d0giPpgsNTCo/eEtwlydmCqH1nPM1PcF5DEpuywiIvQ1ROwckQMAdyDh2GiK2Xkx6vAew==
X-Received: by 2002:a17:902:ecc4:b0:148:8e76:295c with SMTP id a4-20020a170902ecc400b001488e76295cmr5558287plh.26.1639503476276;
        Tue, 14 Dec 2021 09:37:56 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:d051:c5f6:2f2a:19ae? ([2620:0:1000:2514:d051:c5f6:2f2a:19ae])
        by smtp.gmail.com with ESMTPSA id o2sm408888pfu.206.2021.12.14.09.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 09:37:55 -0800 (PST)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1fed2928-a021-dcb9-18bb-3167fe23420a@acm.org>
Date:   Tue, 14 Dec 2021 09:37:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5a5cd1dde61e656e15df3767e1a6d2cc362d280d.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/21 8:35 AM, James Bottomley wrote:
> On Thu, 2021-11-18 at 23:16 -0500, Martin K. Petersen wrote:
>> Applied to 5.16/scsi-fixes, thanks!
>>
>> [1/1] scsi: ufs: Improve SCSI abort handling
>>        https://git.kernel.org/mkp/scsi/c/3ff1f6b6ba6f
> 
> OK, so now we have a conflict between fixes and queue.  My impression
> is that the patch causing the conflict:
> 
> https://lore.kernel.org/all/20211203231950.193369-14-bvanassche@acm.org/
> 
> Actually supersedes this one, so I can simply drop the entirety of this
> patch in fixes, is that correct?

Hi James,

Commit 1fbaa02dfd05 ("scsi: ufs: Improve SCSI abort handling further") is
intended as an improvement for commit 3ff1f6b6ba6f ("scsi: ufs: core:
Improve SCSI abort handling"). Since commit 3ff1f6b6ba6f is already in
Linus' tree I don't think that it can be dropped? A possible approach is
to revert commit 3ff1f6b6ba6f before merging the mkp-scsi/for-next branch.

Thanks,

Bart.





