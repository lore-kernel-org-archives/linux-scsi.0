Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C719C47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE9261429
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhEYQqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 12:46:02 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:40764 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhEYQp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 12:45:59 -0400
Received: by mail-pl1-f169.google.com with SMTP id n8so11422963plf.7;
        Tue, 25 May 2021 09:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CaqjTqqmQT7xqCIFzdCE6BMUTxhsquiSo9yLIXmZo+s=;
        b=Brj0yWnZoRRO3oNCRnbdKC41F3+Bomb4Jf8xohEveftzYfdvqUOyIkIluD86V1Has0
         d8OoeO1P1eqBrMoWrOmKAjGPX70Ca0kMyA2VTtZy3LeEUlATKnSCce43FltmVe69o1qK
         NBNW6UiyHBOm1v+GwTQ8MluMiNas+m9wohTUkiXle1o93l0i0TLiP2l0db6yzrFBfyQM
         fF3vK54t38TWwwgca6iRinK0CyHExsqWz+mIrjSk0lonPmisp6uQ5ueFF6HfQu3ciC9z
         SoswlDbQcbytqpyh+fjfsXQYQfvPBofrnIH2GbqjW4GL9d3NwDdOxCS11FYOP5au+jwk
         cs7w==
X-Gm-Message-State: AOAM533ly/5NnjPPaKt5W0QT/GUejS0yhyS7s8Ju63cpJ/UJ2K5uCK4L
        Gxesij4/hmvQmyE7JOYR6bUsJS/laDo=
X-Google-Smtp-Source: ABdhPJxfSsWtNseKWam3FCFToUIuDzEzfbBQikWPI6eHDzWdhKPORb1DFGR0SMWyDQFFLOYVg+ONEg==
X-Received: by 2002:a17:90a:7601:: with SMTP id s1mr5747947pjk.66.1621961069389;
        Tue, 25 May 2021 09:44:29 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id lp13sm2504005pjb.0.2021.05.25.09.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 09:44:28 -0700 (PDT)
Subject: Re: 2463a604a8: netperf.Throughput_tps 12.8% improvement
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        ying.huang@intel.com, feng.tang@intel.com, zhengjun.xing@intel.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210525064427.GC7744@xsang-OptiPlex-9020>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f572997b-8979-26bb-cb3b-9926086c4cc7@acm.org>
Date:   Tue, 25 May 2021 09:44:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210525064427.GC7744@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 11:44 PM, kernel test robot wrote:
> FYI, we noticed a 12.8% improvement of netperf.Throughput_tps due to commit:
> 
> commit: 2463a604a86728777ce4284214a52de46a808c9e ("[PATCH v3 2/3] Introduce enums for the SAM, message, host and driver status codes")
> url: https://github.com/0day-ci/linux/commits/Bart-Van-Assche/Introduce-enums-for-SCSI-status-codes/20210524-105751
> base: https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git for-next
> 
> in testcase: netperf
> on test machine: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory
> with following parameters:
> 
> 	ip: ipv4
> 	runtime: 300s
> 	nr_threads: 16
> 	cluster: cs-localhost
> 	test: TCP_CRR
> 	cpufreq_governor: performance
> 	ucode: 0x5003006
> 
> test-description: Netperf is a benchmark that can be use to measure various aspect of networking performance.
> test-url: http://www.netperf.org/netperf/

The above email reports a performance improvement for the networking
subsystem while my patch only affects the SCSI subsystem and should not
have any performance impact. I'm confused by the above feedback ...

Bart.
