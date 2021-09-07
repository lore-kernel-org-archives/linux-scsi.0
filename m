Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDC4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 16:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F0E60EBA
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 16:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhIGQ55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 12:57:57 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:41494 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345333AbhIGQ5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 12:57:55 -0400
Received: by mail-pg1-f174.google.com with SMTP id k24so10629353pgh.8
        for <linux-scsi@vger.kernel.org>; Tue, 07 Sep 2021 09:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bbjW+hUwr2cAe6zlj0babvulXm4qaAiDKwbBMEUWYC8=;
        b=Oy4dWDCUgBOUtKWiTBmL04xvsNHvC3bkNjw8fNrCM82qqfaJSmkfMvfpQZxeP/xfUb
         tTbgW75mM19f2MxCN+Bc+hRQ3AAVN/4Zmkfa5s2qh8yjolC5Pgzr1kXumHaNqi/2J9IP
         cortZH//qqaXMPOTERl52pm2tj50yB0xXnlCo2VIH7rBSI9upXaxPULwnfBGsSZw5Tt6
         HL+/nNzmneyipJDY6WXWt0JezdoN9Pvto9/R2om2q+4TqP8BN2JK2usg1V1pfZOmb9H+
         y+jjELRTiJjnlLqeSyDoNyFw0PiPidDP80caj7AJXuXdPH2ZM4DAf+IkgnYzMhaIGM39
         vB5g==
X-Gm-Message-State: AOAM530ITp5t+ukv1ul95Kmxci3Gne0CMCnXk+lCX/Z0q/QCcPcjgnqU
        Qnea3M45tdW65dr5xpIFIKURQ6lWOAc=
X-Google-Smtp-Source: ABdhPJxNFeFx6XAP4VaWlui8PuSqaBo2ZDJMQj28dMVIwYEb8ubpV92vzmCWvM3gzls6Qb4kHjQT1g==
X-Received: by 2002:a63:5413:: with SMTP id i19mr17856315pgb.297.1631033808783;
        Tue, 07 Sep 2021 09:56:48 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t15sm14277668pgi.80.2021.09.07.09.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 09:56:48 -0700 (PDT)
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
Date:   Tue, 7 Sep 2021 09:56:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/21 8:43 AM, Adrian Hunter wrote:
> No.  Requests cannot make progress when ufshcd_state is
> UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error handler can change that,
> so if the error handler is waiting to enter the queue and blk_mq_freeze_queue()
> is waiting for outstanding requests, they will deadlock.

How about adding the above text as a comment above ufshcd_clear_ua_wluns() such
that this information becomes available to those who have not followed this
conversation?

Thanks,

Bart.
