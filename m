Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6EBC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FAC9613C0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhD0JqB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:46:01 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2923 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbhD0Jph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 05:45:37 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FTxRc46BVz686GP;
        Tue, 27 Apr 2021 17:34:20 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 11:44:52 +0200
Received: from [10.47.94.234] (10.47.94.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 27 Apr
 2021 10:44:51 +0100
Subject: Re: [bug report] scsi host hang when running fio
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
CC:     chenxiang <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
References: <0dda71da-4119-2e40-b8e9-ab2b3ee8e96a@huawei.com>
 <f934ca65fa55345c360c944dd0fc2239@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3d72d64d-314f-9d34-e039-7e508b2abe1b@huawei.com>
Date:   Tue, 27 Apr 2021 10:41:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <f934ca65fa55345c360c944dd0fc2239@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.94.234]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/04/2021 12:43, Kashyap Desai wrote:
>> Hi guys,
>>
>> While investigating the performance issue reported by Ming [0], I am
>> seeing
>> this hang in certain scenarios:
>>
>> tivated0KB /s] [0/0/0 iops] [eta 1158048815d:13h:31m:49s] [ 740.499917]
>> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:ops] [eta
>> 34722d:05h:17m:25s] [ 740.505994] rcu: Tasks blocked on level-1 rcu_node
>> (CPUs 0-15):
>> [ 740.511982] (detected by 64, t=5255 jiffies, g=6105, q=6697) [
>> 740.517703]
>> rcu: All QSes seen, last rcu_preempt kthread activity 0 (4295075897-
>> 4295075897), jiffies_till_next_fqs=1, root ->qsmask 0x1 [ 740.723625] BUG:
>> scheduling while atomic: swapper/64/0/0x00000008 [ 740.729692] Modules
>> linked in:
>> [ 740.732737] CPU: 64 PID: 0 Comm: swapper/64 Tainted: G W 5.12.0-rc7-
>> g7589ed97c1da-dirty #322 [ 740.742432] Hardware name: Huawei TaiShan
>> 2280 V2/BC82AMDC, BIOS
>> 2280-V2 CS V5.B133.01 03/25/2021
>> [ 740.751264] Call trace:
>> [ 740.753699] dump_backtrace+0x0/0x1b0
>> [ 740.757353] show_stack+0x18/0x68
>> [ 740.760654] dump_stack+0xd8/0x134
>> [ 740.764046] __schedule_bug+0x60/0x78
>> [ 740.767694] __schedule+0x620/0x6d8
>> [ 740.771168] schedule_idle+0x20/0x40
>> [ 740.774730] do_idle+0x19c/0x278
>> [ 740.777945] cpu_startup_entry+0x24/0x68 [ 740.781850]
>> secondary_start_kernel+0x178/0x188
>> [ 740.786362] 0x0
>> ^Cbs: 12 (f=12): [r(12)] [0.0% done] [1626MB/0KB/0KB /s] [416K/0/0 iops]
>> [eta
>> 34722d:05h:16m:28s]
>> fio: terminating on signal 2
>>
>> I thought it merited a separate thread.
>>
>> [ 740.723625] BUG: scheduling while atomic: swapper/64/0/0x00000008
>> Looks bad ...
>>
>> The scenario to create seems to be running fio with rw=randread and mq-
>> deadline IO scheduler. And heavily loading the system - running fio on a
>> subset of available CPUs seems to help (recreate).
>>
>> When it occurs, the system becomes totally unresponsive.
>>
>> It could be a LLDD bug, but I am doubtful.
>>
>> Has anyone else seen this or help try to recreate?
> John - I have not seen such issue on megaraid_sas driver. Is this something
> to do with CPU lock up ?

JFYI, this appears to be an issue of combination of threaded irq handler 
and managed interrupts. I raised the issue with Thomas:

https://lore.kernel.org/lkml/874kfxw9zv.ffs@nanos.tec.linutronix.de/

Maybe NVMe PCI could have the same issue.

Thanks,
John


