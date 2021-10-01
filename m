Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE055C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 16:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98649611C8
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 16:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhJAQV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 12:21:26 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:52158 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhJAQVY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 12:21:24 -0400
Received: by mail-pj1-f42.google.com with SMTP id oj16so3612925pjb.1;
        Fri, 01 Oct 2021 09:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vDagLVV0uf1V8Wt0ysVp3buB5AYx5/ItIRJCqG7qMBM=;
        b=IvqWdpT1SVB4lr4Rnnzxq4CR0frtmlPERGcFV4nwtx039p1eSNgN3XR0Ep1yQ4ipg7
         xjgkwOC4JLiqetBb8HpxMUQy/QI76hD7o1hfxxdpiBD5DLbVJhjAuUsM1RmaMxCEijH8
         T5y66oCLoUnGYFfToOU7RAtAV8u0irJjmhMAuuXuU4sKaqhSwp/PG74tstFw8rRVSr/5
         oBT6lmoM8mpLoir0OJth0j/ev3R58wk+kYnYlXG1ufGbdZYcjeDN1DpKUkJvCWFyEcgr
         mqfVYh1G6p0SZtMA8GGtZLTnaxczKmVliCwcP01oZAU++oVPDOpq5og528rLzBnsipI1
         vtQw==
X-Gm-Message-State: AOAM533ClzMXta9ukDicA67YeCFPgH1liTN6syoZLe66DYlFGjkmB0B5
        8azXFhHDU8fae0fnaekMATI=
X-Google-Smtp-Source: ABdhPJyE08Ssiatmu0EqQ4+2ucHOF7X2hPS+mxLGZrjw1YOTJWz/HJs68C6HTu5c+EKvlCzfN3YB2g==
X-Received: by 2002:a17:902:e80f:b0:13b:721d:f750 with SMTP id u15-20020a170902e80f00b0013b721df750mr10482685plg.18.1633105179309;
        Fri, 01 Oct 2021 09:19:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:82b7:f0a2:c63d:c44e])
        by smtp.gmail.com with ESMTPSA id q2sm8303614pjo.27.2021.10.01.09.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 09:19:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: ufs: Stop clearing unit attentions
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Bart Van Assche <bvanassche@google.com>
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
 <20210930195237.1521436-2-jaegeuk@kernel.org>
 <12ba3462-ac6b-ef35-4b5e-e0de6086ab51@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e60a9acc-f53e-83b4-8add-b7a53cfd6492@acm.org>
Date:   Fri, 1 Oct 2021 09:19:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <12ba3462-ac6b-ef35-4b5e-e0de6086ab51@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 9:58 PM, Adrian Hunter wrote:
> On 30/09/2021 22:52, Jaegeuk Kim wrote:
>> From: Bart Van Assche <bvanassche@google.com>
>>
>> Commit aa53f580e67b ("scsi: ufs: Minor adjustments to error handling")
>> introduced a ufshcd_clear_ua_wluns() call in
>> ufshcd_err_handling_unprepare(). As explained in detail by Adrian Hunter,
>> this can trigger a deadlock. Avoid that deadlock by removing the code that
>> clears the unit attention. This is safe because the only software that
>> relies on clearing unit attentions is the Android Trusty software and
> 
> Did you test this?

This patch series has been tested on an Android phone running the latest Trusty
software but with runtime power management disabled.

Bart.
