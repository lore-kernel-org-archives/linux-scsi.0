From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scsi: ata: don't reset three times if device is offline
 for SAS host
Date: Tue, 13 Feb 2018 06:27:38 -0800
Message-ID: <20180213142738.GJ695913@devbig577.frc2.facebook.com>
References: <1516800025-193614-1-git-send-email-chenxiang66@hisilicon.com>
 <20180212165146.GU695913@devbig577.frc2.facebook.com>
 <b3701a9b-3bf2-a979-cf75-c3dcdfaa1a89@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:45071 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933612AbeBMO1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 09:27:42 -0500
Content-Disposition: inline
In-Reply-To: <b3701a9b-3bf2-a979-cf75-c3dcdfaa1a89@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com

Hello,

On Tue, Feb 13, 2018 at 09:44:53AM +0800, chenxiang (M) wrote:
> For those drivers using libsas,  i think they have the same issue.
> It takes about 1 minute to
> recover but actually device is gone, so this recover is useless for
> this scenario (when enter EH,
> all normal IOs are blocked actually, so it will cause normal IOs are
> blocked one more minute which
> user doesn't want to).

Right, it'd block other devices sharing the port.  Doesn't sas map
each ata device to its own port tho?

> Actually in sas_ata_hard_reset, there are two situations returned
> -ENODEV which represent device is gone:
> - LLDD directly returns -ENODEV through lldd_I_T_nexus_reset;
> - It sends SMP DISCOVER to check local phy in smp_ata_check_ready,
> and find it is gone;

So, if there are real consequences, we can definitely add a way to
short-circuit the recovery logic but let's do that by adding proper
signaling rathr than testing for driver type.

Thanks.

-- 
tejun
