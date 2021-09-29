Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788D8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 18:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C23461465
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 18:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344266AbhI2SRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 14:17:03 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:40659 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhI2SRC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 14:17:02 -0400
Received: by mail-pg1-f173.google.com with SMTP id h3so3573642pgb.7;
        Wed, 29 Sep 2021 11:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qHhbFlZc6GWNDrVsz7/iKe9Me4ufngLpqsND1YltOzM=;
        b=UOPXV9/LYeO2n1N73OwWkI4bEVGuHx+/FuiyURBc1ycXQzMedrq43KWny7AAj+/5Cx
         SZFTaRx5dihaXUz7dTM0FIbDWfEWWpYGc7LD/69H8LRSi4D6tmKu5L1nl14Uekh5aC8E
         fpYS4kablVM3V2DHNxU1ziM5yzUeQ/br0sQUWleoH5Wi+VxJV7B6OLii41tFLd5RwBgP
         HL7kOZrQYAovgTbas5Qw2hlRdSV78RCxLdy4cyN1TBb9IVllAFHFS7ZhJJa82qcNJXD0
         /9CXtpcbPMtk2VxoWYKRRuo/V7gkELw/sbGHJlMoGwLjMUNoloAZAaqQ+8rp2Qo46RYX
         PB0w==
X-Gm-Message-State: AOAM532KqrgNC1sRcsV5MGmIDak7vA3m49WwkxQGhXzYGJXFCG1PjXL3
        oplwpYDFyWmTdgCK7rNN/oVucrRYvBM=
X-Google-Smtp-Source: ABdhPJyLyLHa6wGVqdVcHF8Eo7FMzmROjehCaN44Z2qGkC/h/n95Yl5YWtDj4Oayg3mlJANLcy91IA==
X-Received: by 2002:a63:f356:: with SMTP id t22mr1160846pgj.18.1632939320446;
        Wed, 29 Sep 2021 11:15:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f36:4e58:55a1:b506])
        by smtp.gmail.com with ESMTPSA id n26sm491703pfo.19.2021.09.29.11.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 11:15:19 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix a possible dead lock in clock scaling
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1631843521-2863-1-git-send-email-cang@codeaurora.org>
 <cc9cb9e7-68bd-3bfa-9310-5fbf99a86544@acm.org>
 <fbc4d03a07f03fe4fbe697813111471f@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <644dcd92-25ae-e951-d9f3-607306a02370@acm.org>
Date:   Wed, 29 Sep 2021 11:15:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <fbc4d03a07f03fe4fbe697813111471f@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 8:31 PM, Can Guo wrote:
> On 2021-09-18 01:27, Bart Van Assche wrote:
>> On 9/16/21 6:51 PM, Can Guo wrote:
>>> Assume a scenario where task A and B call ufshcd_devfreq_scale()
>>> simultaneously. After task B calls downgrade_write() [1], but before it
>>> calls down_read() [3], if task A calls down_write() [2], when task B calls
>>> down_read() [3], it will lead to dead lock.
>>
>> Something is wrong with the above description. The downgrade_write() call is
>> not followed by down_read() but by up_read(). Additionally, I don't see how
>> concurrent calls of ufshcd_devfreq_scale() could lead to a deadlock.
> 
> As mentioned in the commit msg, the down_read() [3] is from ufshcd_wb_ctrl().
> 
> Task A -
> down_write [2]
> ufshcd_clock_scaling_prepare
> ufshcd_devfreq_scale
> ufshcd_clkscale_enable_store
> 
> Task B -
> down_read [3]
> ufshcd_exec_dev_cmd
> ufshcd_query_flag
> ufshcd_wb_ctrl
> downgrade_write [1]
> ufshcd_devfreq_scale
> ufshcd_devfreq_target
> devfreq_set_target
> update_devfreq
> devfreq_performance_handler
> governor_store
> 
> 
>> If one thread calls downgrade_write() and another thread calls down_write()
>> immediately, that down_write() call will block until the other thread has called up_read()
>> without triggering a deadlock.
> 
> Since the down_write() caller is blocked, the down_read() caller, which comes after
> down_write(), is blocked too, no? downgrade_write() keeps lock owner as it is, but
> it does not change the fact that readers and writers can be blocked by each other.

Please use the upstream function names when posting upstream patches. I think that
ufshcd_wb_ctrl() has been renamed into ufshcd_wb_toggle().

So the deadlock is caused by nested locking - one task holding a reader lock, another
task calling down_write() and next the first task grabbing the reader lock recursively?
I prefer one of the following two solutions above the patch that has been posted since
I expect that both alternatives will result in easier to maintain UFS code:
- Fix the down_read() implementation. Making down_read() wait in case of nested locking
   seems wrong to me.
- Modify the UFS driver such that it does not lock hba->clk_scaling_lock recursively.

Thanks,

Bart.
