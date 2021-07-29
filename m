Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB797C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 16:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F7760F5C
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 16:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhG2QNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 12:13:12 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:37867 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2QNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 12:13:11 -0400
Received: by mail-pj1-f43.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso16415408pjq.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 09:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgl5to4+5D05PZ0Bohqff8F4DJgwO18K8mRXqCAuzcQ=;
        b=C7k+3Nfdy+znPSq14wNn6bx452NqJux+J9h7pUFUFUZ55ZcAckU0usVSfiHYfCWR6Q
         3jTQ5S+LDVmMwQV4BKMmbK4xGANSW8EB5A1L3GN7HHu3+N24/lzcE4p+DyY85MgDt/Vr
         on6HUoIjQFy0+ZjDYVP04r/dQi9v05Vglcl6p2eZJrcGpW/X3C2p2bLLsThuAA6AslCL
         vuzcQvwOw/g9brUxglLeE924Y8PoROJTabDTH5KYpgdhOsmtuPRLPcXU92Fg6vEuA9qi
         nH5MRNUitjECRkgNGV3MKh5QcRNuJaH0Juaz6ZqKb8POJRnvSbf12hakkNgC//trVCuz
         C+/w==
X-Gm-Message-State: AOAM5316xj43TSuUwq7Po++Np5xfiSAR+oMT5ql8d8CkvuqmiW+83Cvo
        8UCnqHqzwBK5En/Gp5dCPik=
X-Google-Smtp-Source: ABdhPJwFxInCj/QGCLLYsMf+WcQASFMG4gJ/7dkM3+WXWIslxReJlOz0Ayycp74A2tXKRyHREgMvXw==
X-Received: by 2002:a17:902:da82:b029:12b:ac76:204a with SMTP id j2-20020a170902da82b029012bac76204amr5312382plx.56.1627575187104;
        Thu, 29 Jul 2021 09:13:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:3328:5f8d:f6e2:85ea])
        by smtp.gmail.com with ESMTPSA id y5sm4269454pfn.87.2021.07.29.09.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 09:13:06 -0700 (PDT)
Subject: Re: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request List
 Completion Notification Register"
From:   Bart Van Assche <bvanassche@acm.org>
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-12-bvanassche@acm.org>
 <d15377870057a6ff956a18910b2d0695b145d889.camel@gmail.com>
 <cd22192c-fd45-5c7e-d70d-0d787ba02ddf@acm.org>
Message-ID: <46e6aa0e-8845-317a-026e-86423969c2b6@acm.org>
Date:   Thu, 29 Jul 2021 09:13:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cd22192c-fd45-5c7e-d70d-0d787ba02ddf@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/29/21 9:10 AM, Bart Van Assche wrote:
> On 7/29/21 1:03 AM, Bean Huo wrote:
>> How did you compare the performance gain/loss after reverting this
>> commit?
> 
> I measured the performance impact of patches 11 and 12 combined. In a 4 
> KB read IOPS test I see that these two patches combined improve 
> performance by 1%. This illustrates that the two MMIO accesses of the 
> UTRLCNR register are slower than the single MMIO access of the doorbell 
> register.

A correction: I wanted to refer to the combination of patches 11 and 13 
instead of 11 and 12.

Bart.
