Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E57C56201
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 11:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A303E2075A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 11:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgKKLvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 06:51:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2093 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgKKLvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 06:51:43 -0500
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CWNMC6QRVz67HXV;
        Wed, 11 Nov 2020 19:49:59 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 11 Nov 2020 12:51:35 +0100
Received: from [10.47.86.246] (10.47.86.246) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 11 Nov
 2020 11:51:33 +0000
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     Qian Cai <cai@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "don.brace@microsemi.com" <don.brace@microsemi.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "paolo.valente@linaro.org" <paolo.valente@linaro.org>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux SCSI List" <linux-scsi@vger.kernel.org>,
        "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        luojiaxing <luojiaxing@huawei.com>,
        "Hannes Reinecke" <hare@suse.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <1597850436-116171-18-git-send-email-john.garry@huawei.com>
 <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
 <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com>
 <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
 <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com>
 <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
 <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
 <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
 <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
 <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
 <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
 <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
 <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com>
 <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
 <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e4d2031e-63f7-4c9a-daf5-4cb2b1ff3052@huawei.com>
Date:   Wed, 11 Nov 2020 11:51:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.86.246]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> In Qian's kernel .config, async scsi scan is disabled so in failure
> case SCSI scan type is synchronous.
> Below is the stack trace when scsi_scan_host() hangs:
> 
> [<0>] __wait_rcu_gp+0x134/0x170
> [<0>] synchronize_rcu.part.80+0x53/0x60
> [<0>] blk_free_flush_queue+0x12/0x30
> [<0>] blk_mq_hw_sysfs_release+0x21/0x70

this is per blk_mq_hw_ctx

> [<0>] kobject_release+0x46/0x150
> [<0>] blk_mq_release+0xb4/0xf0
> [<0>] blk_release_queue+0xc4/0x130
> [<0>] kobject_release+0x46/0x150
> [<0>] scsi_device_dev_release_usercontext+0x194/0x3f0
> [<0>] execute_in_process_context+0x22/0xa0
> [<0>] device_release+0x2e/0x80
> [<0>] kobject_release+0x46/0x150
> [<0>] scsi_alloc_sdev+0x2e7/0x310
> [<0>] scsi_probe_and_add_lun+0x410/0xbd0
> [<0>] __scsi_scan_target+0xf2/0x530
> [<0>] scsi_scan_channel.part.7+0x51/0x70
> [<0>] scsi_scan_host_selected+0xd4/0x140
> [<0>] scsi_scan_host+0x198/0x1c0
> 
> This issue hits when lock related debugging is enabled in kernel config.
> kernel .config parameters(may be subset of this list) are required to
> hit the issue:
> 
> CONFIG_PREEMPT_COUNT=y *
> CONFIG_UNINLINE_SPIN_UNLOCK=y *
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_RT_MUTEXES=y *
> CONFIG_DEBUG_SPINLOCK=y *
> CONFIG_DEBUG_MUTEXES=y *
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y *
> CONFIG_DEBUG_RWSEMS=y *
> CONFIG_DEBUG_LOCK_ALLOC=y *
> CONFIG_LOCKDEP=y *
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y *
> CONFIG_TRACE_IRQFLAGS_NMI=y
> CONFIG_DEBUG_KOBJECT=y 
> CONFIG_PROVE_RCU=y *
> CONFIG_PREEMPTIRQ_TRACEPOINTS=y *

(* means that I enabled)

> 
> When scsi_scan_host() hangs, there are no outstanding IOs with
> megaraid_sas driver-firmware stack as SCSI "host_busy" counter and
> megaraid_sas driver's internal counter are "0".
> Key takeaways:
> 1. Issue is observed when lock related debugging is enabled so issue
> is seen in debug environment.
> 2. Issue seems to be related to generic shared "host_tagset" code
> whenever some kind of kernel debugging is enabled. We do not see an
> immediate reason to hide this issue through disabling the
> "host_tagset" feature.
> 
> John,
> Issue may hit on ARM platform too using Qian's .config file with other
> adapters (e.g. hisi_sas) as well. So I feel disabling “host_tagset” in
> megaraid_sas driver will not help.  It requires debugging from the
> “Entire Shared host tag feature” perspective as scsi_scan_host()
> waittime aggravates when "host_tagset" is enabled. Also, I am doing
> parallel debugging and if I find anything useful, I will share.

So isn't this then really related to how many HW queues we expose there 
is just scaling up the time? For megaraid sas, it's 1->128 for my arm64 
platform when host_tagset_enable=1.

As a hack, I tried this (while keeping host_tagset_enable=1):

@@ -6162,11 +6168,15 @@ static int megasas_init_fw(struct 
megasas_instance *instance)
                else
                        instance->low_latency_index_start = 1;

-               num_msix_req = num_online_cpus() + 
instance->low_latency_index_start;
+               num_msix_req = 6 + instance->low_latency_index_start;

(6 is an arbitrary small number)

And boot time is nearly same as with host_tagset_enable=0.

For hisi_sas, max HW queue number ever is 16. In addition, we don't scan 
each channel/id/lun for hisi_sas, as it has a scan handler.

> 
> Qian,
> I need full dmesg logs from your setup with
> megaraid_sas.host_tagset_enable=1 and
> megaraid_sas.host_tagset_enable=0. Please wait for a long time. I just
> want to make sure that whatever you observe is the same as mine.
> 

Thanks,
John

