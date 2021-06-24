Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57A0C49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 22:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 945B56138C
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 22:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhFXW2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 18:28:10 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:42570 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFXW2J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 18:28:09 -0400
Received: by mail-pf1-f171.google.com with SMTP id y4so6407457pfi.9;
        Thu, 24 Jun 2021 15:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=txsE4yW8fLSVaTRFZWvuwX16MY0QYTfH/BlvYlhRx3c=;
        b=qtrSlZHoMPbPW8UY+zHxo+CiU+b6ozjBG3dujSCqTzrl3JkKerq2Y5RVC+vZmcM8Ko
         KUBbMS0x7705BVZ0wfbzvxGQAJOWwgTuvo5siPIxvkV4Un+uxbk9xReyxbL4wST46IKS
         0fBWj8RRW2rQsZtZRHmW8SqHsTK1ji68rmakQs97QGlnIuVfS+pxD7cBboogXEtOjhZP
         br00xnKpD4QucrOX/diVjaL2GKT4bg9B70UgNnFjXMqXqNByywYgOTIBrZFPb85AgCVC
         4ktBnuafIeucHwn+dHRupdc+osaesEhihWD5UlaQzSM7oCeBKJB8pFLajvwFjxrFG7TZ
         OnuQ==
X-Gm-Message-State: AOAM530NOVcx+zfKrBi2zoQBIkDH7XCTGRS61RoEt03OhuaGyYC1jsoY
        XQAeljCEpw8ood30UK3ixRhZyNk4jgM=
X-Google-Smtp-Source: ABdhPJznjRBlthi5exphHW34zK6kQweD1W4S7z98al0RiKrGtXPy9f926UqlHDKGumqjM8Cr0yRD4w==
X-Received: by 2002:a05:6a00:168a:b029:2fb:6bb0:aba with SMTP id k10-20020a056a00168ab02902fb6bb00abamr7360923pfc.32.1624573549206;
        Thu, 24 Jun 2021 15:25:49 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id ml5sm8635680pjb.3.2021.06.24.15.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 15:25:47 -0700 (PDT)
Subject: Re: [PATCH v4 10/10] scsi: ufs: Apply more limitations to user access
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-12-git-send-email-cang@codeaurora.org>
 <89a3c8bf-bbfc-4a2a-73f0-a0db956fbf0e@acm.org>
 <d9db00ef6dd4b28d0ba2019dcf026479@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e803db99-947c-f217-e0c8-091241014086@acm.org>
Date:   Thu, 24 Jun 2021 15:25:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d9db00ef6dd4b28d0ba2019dcf026479@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 7:23 PM, Can Guo wrote:
> On 2021-06-24 05:51, Bart Van Assche wrote:
>> On 6/23/21 12:35 AM, Can Guo wrote:
>> - During system suspend, user space software is paused before the device
>>   driver freeze callbacks are invoked. Hence, the hba->is_sys_suspended
>>   check can be left out.
> 
> is_sys_suspended indicates that system resume failed (power/clk is OFF).
> 
>> - If a LUN is runtime suspended, it should be resumed if accessed from
>>   user space instead of failing user space accesses. In other words, the
>>   hba->is_wlu_sys_suspended check seems inappropriate to me.
> 
> hba->is_wlu_sys_suspended indicates that wl system resume failed, device
> is not operational.

Hi Can,

Thanks for the clarification. How about converting the above two answers
into comments inside ufshcd_is_user_access_allowed()?

Should ufshcd_is_user_access_allowed() perhaps be called after
ufshcd_rpm_get_sync() instead of before to prevent that the value of
hba->is_sys_suspended or hba->is_wlu_sys_suspended changes after having
been checked and before the UFS device is accessed?

Thanks,

Bart.
