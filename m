Return-Path: <SRS0=D4W/=WL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2EFC3A589
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 15:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58384206C1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 15:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbfHOPkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Aug 2019 11:40:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40289 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730666AbfHOPkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Aug 2019 11:40:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so1510250pfn.7
        for <linux-scsi@vger.kernel.org>; Thu, 15 Aug 2019 08:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=41roc1+HHIoPiN0cCpBxFpS6UdILZTVvuMLXG6p/X+c=;
        b=Mpjxp4HDRAkrP41AaR5kXKsH9z+xowz7mS24G+l9FlmCFs/ct1MTpkwZeuU0rvpdVS
         +Xfsc7+vnYvS5fhb2I4nxbH18EqbR0h90LI8FOAJFM1Ocw7GmcbhW/tBNj1U6Ap+zNov
         tulfj2GjqXlWwucz7EouJBd1UdJ2c/rQyyMpNN1OrWDIVdxjOvBYFCz19AzdGsKBmqCg
         tDj80X4er+LFfUTO+7NtO5T1e05H3E4Fx4PNwSdpvVwXXSjz4pG3S+N7d3VBWD0ys8EU
         hTApAfgNRtfKrEURwJxFGqutrlJkq7rZkD0JaWlyWzU+VpW6zcvm+7ZCSPQ5lD/p8CYh
         Vn1Q==
X-Gm-Message-State: APjAAAV88VGQAROV6sho82xKYj4Anwx9VdgRCaNloMDwPgX+1MZ8j5zN
        FPUapgMS2GyG7HrCLvtSfoE=
X-Google-Smtp-Source: APXvYqxLaC9OdO14rwAaPZDivlOMz9yEUiSw1cmi1K9JSmL444hC55+QU/cNeBfI00yyKc5OwzTLIQ==
X-Received: by 2002:aa7:9210:: with SMTP id 16mr6232964pfo.11.1565883653027;
        Thu, 15 Aug 2019 08:40:53 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id y128sm2558979pgy.41.2019.08.15.08.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:40:51 -0700 (PDT)
Subject: Re: [PATCH v4] SCSI: fix queue cleanup race before
 scsi_requeue_run_queue is done
To:     "zhengbin (A)" <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org
Cc:     houtao1@huawei.com, yanaijie@huawei.com
References: <1565667334-22071-1-git-send-email-zhengbin13@huawei.com>
 <e79e0996-37e0-049c-7546-990b280424d0@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ca5e857f-472d-6849-6907-1f36879997dd@acm.org>
Date:   Thu, 15 Aug 2019 08:40:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e79e0996-37e0-049c-7546-990b280424d0@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/19 6:50 PM, zhengbin (A) wrote:
> ping

Sending a "ping" after 46 hours is way too soon and only causes 
irritation. What would help though is more information about how this 
patch has been tested. Does it e.g. survive the srp tests in blktests?

Thanks,

Bart.
