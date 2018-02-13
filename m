From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] scsi: ata: don't reset three times if device is offline
 for SAS host
Date: Tue, 13 Feb 2018 09:44:53 +0800
Message-ID: <b3701a9b-3bf2-a979-cf75-c3dcdfaa1a89@hisilicon.com>
References: <1516800025-193614-1-git-send-email-chenxiang66@hisilicon.com>
 <20180212165146.GU695913@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933102AbeBMBpX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Feb 2018 20:45:23 -0500
In-Reply-To: <20180212165146.GU695913@devbig577.frc2.facebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com

Hi Tejun,

在 2018/2/13 0:51, Tejun Heo 写道:
> Hello,
>
> On Wed, Jan 24, 2018 at 09:20:25PM +0800, chenxiang wrote:
>> In ata_eh_reset, it will reset three times at most for sata disk. For
>> some drivers through libsas, it calls sas_ata_hard_reset at last. When
>> device is gone, function sas_ata_hard_reset will return -ENODEV. But
>> it will still try to reset three times for offline device. This process
>> lasts a long time:
>>
>> [11248.344323] ata13.00: status: { ERR }
>> [11248.344324] ata13.00: error: { ABRT }
>> [11248.344327] ata13: hard resetting link
>> [11248.503557] sas: ata: ex 500e004aaaaaaa1f phy02:U:A attached:0000000000000000 (no device)
>> [11249.359524] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta03d:19h:35m:17s]
>> [11249.365692] ata13: reset failed (errno=-19), retrying in 9 secs
>> [11258.451402] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops][eta 03d:22h:10m:48s]
>> [11259.411508] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 03d:22h:28m:05s]
>> [11259.417683] ata13: reset failed (errno=-19), retrying in 10 secs
>> [11268.695401] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops] [eta 04d:01h:03m:37s]
>> [11269.699513] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 04d:01h:20m:54s]
>> [11269.705689] ata13: reset failed (errno=-19), retrying in 34 secs
>> [11304.275393] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops] [eta 04d:11h:25m:43s]
>> [11305.283516] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 04d:11h:43m:00s]
>> [11305.289692] ata13: reset failed, giving up
>> [11305.293785] ata13.00: disabled
>>
>> Actually it is no need to reset three times for this scenario. So add
>> a check to avoid it.
> I'm a bit reluctant in changing this per-driver.  Does this actually
> hurt something?

For those drivers using libsas,  i think they have the same issue. It 
takes about 1 minute to
recover but actually device is gone, so this recover is useless for this 
scenario (when enter EH,
all normal IOs are blocked actually, so it will cause normal IOs are 
blocked one more minute which
user doesn't want to).
Actually in sas_ata_hard_reset, there are two situations returned 
-ENODEV which represent device is gone:
- LLDD directly returns -ENODEV through lldd_I_T_nexus_reset;
- It sends SMP DISCOVER to check local phy in smp_ata_check_ready, and 
find it is gone;

> Thanks.
>
