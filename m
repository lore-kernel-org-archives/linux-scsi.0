Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135CDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346161AbiEFD2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388547AbiEFD2Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:28:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6EB644C9
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:24:32 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KvbWh3XjWzhYlC;
        Fri,  6 May 2022 11:24:00 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 11:24:22 +0800
Subject: Re: [PATCH 0/7] scsi: EH rework main part
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220502215953.5463-1-hare@suse.de>
 <4d4586e1-c25c-5452-2252-cf533842250d@hisilicon.com>
 <d0e5679c-a5e7-71db-22f1-66d34798c4d8@suse.de>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <2f06d11c-d58c-f498-42d8-246aadae2f00@hisilicon.com>
Date:   Fri, 6 May 2022 11:24:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <d0e5679c-a5e7-71db-22f1-66d34798c4d8@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,


Thanks your detailed comments.

在 2022/5/6 0:19, Hannes Reinecke 写道:
> On 5/4/22 19:27, chenxiang (M) wrote:
>> Hi Hannes and other guys,
>>
>> For SCSI EH, i have a question (sorry, it is not related to this 
>> patchset): for current flow of SCSI EH, if IOs of one disk is failed
>>
>> (if there are many disks under the same scsi host), it will block all 
>> the IOs of total scsi host.
>>
>> So during SCSI EH, all IOs are blocked even if some disks are normal. 
>> That's the place product line sometimes complain about
>>
>> as it blocks IO bussiness of some normal disks because of just one 
>> bad disk during SCSI EH.
>>
>> Is it possible to split the SCSI EH into two parts, the process of 
>> recovering the disk and the process of recovering scsi host, at the 
>> beginning
>>
> If it were so easy.
> The biggest problem we're facing in SCSI EH is that basically _all_ 
> instances I've seen where EH got engaged were due to a command timeout.

Right, currently it is always a command timeout which makes EH got 
engaged. The worse situation is that some IOs are failed with response 
while other IOs
are timeout. Then when the first IO with response complete, it tries to 
enter EH (just mark host SHOST_RECOVERY), then it begins to block IOs. 
Normally maybe
after almost 30s, all those IOs are completed (timeout or failed)，then 
it enters EH. So the blocking time of this situation is waiting for EH 
(max 30s) + EH (serval seconds ~ 10+seconds).

>
> Which means that we've sent a command to the HBA, and never heard from 
> it again. Now, it were easy if it would just be the command which has 
> vanished, but the problem is that we don't know what happened.
> It might be the command being ln transit, the drive might be 
> unresponsive, or the HBA has gone off the rails altogether.
> So until we've established where the command got lost, we have to 
> assume the worst and _have_ to treat the HBA as unreliable.
> So initially we shouldn't isolate the device, and hope the failure is 
> restricted to the device.
> Instead we have to stop I/O to the HBA, establish communication 
> (typically by sending a TMF), and only restart operations once we get 
> a response back from the HBA.

Ok, but what we see is that hard disk is more easily broken than HBA, 
and usually error handling is due to a bad disk though the other disks 
are normal.
Current SCSI EH is based on scsi host (there is a EH thread for every 
scsi host), I think if SCSI EH is based on scsi device (there is a EH 
thread for every scsi device),
when one IO of one disk is failed or timeout, we just mark the disk as 
RECOVERY and trigger EH of the disk. Only when recovery operation of the 
device also is failed, then
trigger EH of scsi host.  Maybe it can alleviate the issue.
Even if there is something wrong with HBA, once IO of a disk is fialed 
or timeout, it will also stop IOs of the disk immediately and 
separately, and i think maybe it doesn't make much difference.
(In current SCSI EH, i think it also the situation that many IOs are 
still sent to broken HBA, if previous IOs are all timeout).


>
> This is especially true for old SCSI parallel HBA, where quite some 
> state is being kept in the HBA structure itself. So if we were to send 
> another command we would loas the state of the failed command, and 
> wouldn't be able to figure out the root cause on why the command had 
> failed.
>
> Cheers,
>
> Hannes

