Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCA6C4707F
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 01:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FA96128B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 01:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhEZBvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 21:51:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:25828 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhEZBvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 21:51:42 -0400
IronPort-SDR: z8aWKyBeMhBimhOTDgzMzG/TK+95W4ZbMAv3tfrHgG260iCQqrTt++li/OsUmuQXwYIAPqsPgi
 i+D1bK3MvpUQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="189729476"
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="189729476"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 18:50:11 -0700
IronPort-SDR: nyA9quQLu82kgtjugpD+ctBZqdQgKaIoN/n0LYx7gIQb7mmIxboZ3bzAs7oxGTQJrb/HrjYc/p
 rDAigRoE4M9w==
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="476697412"
Received: from xingzhen-mobl.ccr.corp.intel.com (HELO [10.238.5.220]) ([10.238.5.220])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 18:50:08 -0700
Subject: Re: [LKP] Re: 2463a604a8: netperf.Throughput_tps 12.8% improvement
To:     Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210525064427.GC7744@xsang-OptiPlex-9020>
 <f572997b-8979-26bb-cb3b-9926086c4cc7@acm.org>
From:   Xing Zhengjun <zhengjun.xing@linux.intel.com>
Message-ID: <0c2d909a-d307-548b-473c-0c85d479573e@linux.intel.com>
Date:   Wed, 26 May 2021 09:50:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <f572997b-8979-26bb-cb3b-9926086c4cc7@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/26/2021 12:44 AM, Bart Van Assche wrote:
> On 5/24/21 11:44 PM, kernel test robot wrote:
>> FYI, we noticed a 12.8% improvement of netperf.Throughput_tps due to commit:
>>
>> commit: 2463a604a86728777ce4284214a52de46a808c9e ("[PATCH v3 2/3] Introduce enums for the SAM, message, host and driver status codes")
>> url: https://github.com/0day-ci/linux/commits/Bart-Van-Assche/Introduce-enums-for-SCSI-status-codes/20210524-105751
>> base: https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git for-next
>>
>> in testcase: netperf
>> on test machine: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory
>> with following parameters:
>>
>> 	ip: ipv4
>> 	runtime: 300s
>> 	nr_threads: 16
>> 	cluster: cs-localhost
>> 	test: TCP_CRR
>> 	cpufreq_governor: performance
>> 	ucode: 0x5003006
>>
>> test-description: Netperf is a benchmark that can be use to measure various aspect of networking performance.
>> test-url: http://www.netperf.org/netperf/
> The above email reports a performance improvement for the networking
> subsystem while my patch only affects the SCSI subsystem and should not
> have any performance impact. I'm confused by the above feedback ...

I suspect it related with cache alignment, 2463a604a8 changes "u8" 
(size:1) to "enum xxx_status" (size: 4),  the cache alignment is better 
than before , so cause the improvement.
>
> Bart.
> _______________________________________________
> LKP mailing list -- lkp@lists.01.org
> To unsubscribe send an email to lkp-leave@lists.01.org

-- 
Zhengjun Xing

