Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D62C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 09:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE3761157
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 09:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhDSJyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 05:54:19 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2878 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhDSJyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 05:54:18 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FP27W1c3Rz688jm;
        Mon, 19 Apr 2021 17:48:23 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Apr 2021 11:53:47 +0200
Received: from [10.47.84.228] (10.47.84.228) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 19 Apr
 2021 10:53:46 +0100
To:     Ming Lei <ming.lei@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
CC:     chenxiang <chenxiang66@hisilicon.com>,
        "luojiaxing@huawei.com" <luojiaxing@huawei.com>
From:   John Garry <john.garry@huawei.com>
Subject: [bug report] scsi host hang when running fio
Message-ID: <0dda71da-4119-2e40-b8e9-ab2b3ee8e96a@huawei.com>
Date:   Mon, 19 Apr 2021 10:51:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.228]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi guys,

While investigating the performance issue reported by Ming [0], I am 
seeing this hang in certain scenarios:

tivated0KB /s] [0/0/0 iops] [eta 1158048815d:13h:31m:49s]
[ 740.499917] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:ops] 
[eta 34722d:05h:17m:25s]
[ 740.505994] rcu: Tasks blocked on level-1 rcu_node (CPUs 0-15):
[ 740.511982] (detected by 64, t=5255 jiffies, g=6105, q=6697)
[ 740.517703] rcu: All QSes seen, last rcu_preempt kthread activity 0 
(4295075897-4295075897), jiffies_till_next_fqs=1,
root ->qsmask 0x1
[ 740.723625] BUG: scheduling while atomic: swapper/64/0/0x00000008
[ 740.729692] Modules linked in:
[ 740.732737] CPU: 64 PID: 0 Comm: swapper/64 Tainted: G W 
5.12.0-rc7-g7589ed97c1da-dirty #322
[ 740.742432] Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 
2280-V2 CS V5.B133.01 03/25/2021
[ 740.751264] Call trace:
[ 740.753699] dump_backtrace+0x0/0x1b0
[ 740.757353] show_stack+0x18/0x68
[ 740.760654] dump_stack+0xd8/0x134
[ 740.764046] __schedule_bug+0x60/0x78
[ 740.767694] __schedule+0x620/0x6d8
[ 740.771168] schedule_idle+0x20/0x40
[ 740.774730] do_idle+0x19c/0x278
[ 740.777945] cpu_startup_entry+0x24/0x68
[ 740.781850] secondary_start_kernel+0x178/0x188
[ 740.786362] 0x0
^Cbs: 12 (f=12): [r(12)] [0.0% done] [1626MB/0KB/0KB /s] [416K/0/0 iops] 
[eta 34722d:05h:16m:28s]
fio: terminating on signal 2

I thought it merited a separate thread.

[ 740.723625] BUG: scheduling while atomic: swapper/64/0/0x00000008
Looks bad ...

The scenario to create seems to be running fio with rw=randread and 
mq-deadline IO scheduler. And heavily loading the system - running fio 
on a subset of available CPUs seems to help (recreate).

When it occurs, the system becomes totally unresponsive.

It could be a LLDD bug, but I am doubtful.

Has anyone else seen this or help try to recreate?

scsi debug or null_blk don't seem to load the system heavily enough to 
recreate.

I have seen it on 5.11 also. I see it on hisi_sas v2 and v3 hw drivers, 
And I don't think it's related to hostwide tags, as for hisi_sas v2 hw 
driver, I unset that flag and can still see it.

Thanks,
John

[0] 
https://lore.kernel.org/linux-scsi/89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com/T/#t
