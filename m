From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scsi: ata: don't reset three times if device is offline
 for SAS host
Date: Mon, 12 Feb 2018 08:51:46 -0800
Message-ID: <20180212165146.GU695913@devbig577.frc2.facebook.com>
References: <1516800025-193614-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:46665 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbeBLQvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 11:51:49 -0500
Content-Disposition: inline
In-Reply-To: <1516800025-193614-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chenxiang <chenxiang66@hisilicon.com>
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com

Hello,

On Wed, Jan 24, 2018 at 09:20:25PM +0800, chenxiang wrote:
> In ata_eh_reset, it will reset three times at most for sata disk. For
> some drivers through libsas, it calls sas_ata_hard_reset at last. When
> device is gone, function sas_ata_hard_reset will return -ENODEV. But
> it will still try to reset three times for offline device. This process
> lasts a long time:
> 
> [11248.344323] ata13.00: status: { ERR }
> [11248.344324] ata13.00: error: { ABRT }
> [11248.344327] ata13: hard resetting link
> [11248.503557] sas: ata: ex 500e004aaaaaaa1f phy02:U:A attached:0000000000000000 (no device)
> [11249.359524] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta03d:19h:35m:17s]
> [11249.365692] ata13: reset failed (errno=-19), retrying in 9 secs
> [11258.451402] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops][eta 03d:22h:10m:48s]
> [11259.411508] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 03d:22h:28m:05s]
> [11259.417683] ata13: reset failed (errno=-19), retrying in 10 secs
> [11268.695401] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops] [eta 04d:01h:03m:37s]
> [11269.699513] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 04d:01h:20m:54s]
> [11269.705689] ata13: reset failed (errno=-19), retrying in 34 secs
> [11304.275393] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops] [eta 04d:11h:25m:43s]
> [11305.283516] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 04d:11h:43m:00s]
> [11305.289692] ata13: reset failed, giving up
> [11305.293785] ata13.00: disabled
> 
> Actually it is no need to reset three times for this scenario. So add
> a check to avoid it.

I'm a bit reluctant in changing this per-driver.  Does this actually
hurt something?

Thanks.

-- 
tejun
