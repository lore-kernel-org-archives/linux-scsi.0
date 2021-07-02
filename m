Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C32C07E95
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 20:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4378161278
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 20:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhGBUeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:34:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44503 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230116AbhGBUeQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 16:34:16 -0400
Received: (qmail 49922 invoked by uid 1000); 2 Jul 2021 16:31:42 -0400
Date:   Fri, 2 Jul 2021 16:31:42 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     John Garry <john.garry@huawei.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
Subject: Re: SCSI layer RPM deadlock debug suggestion
Message-ID: <20210702203142.GA49307@rowland.harvard.edu>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 02, 2021 at 06:03:20PM +0100, John Garry wrote:
> Hi guys,
> 
> We're experiencing a deadlock between trying to remove a SATA device and
> doing a rescan in scsi_rescan_device().
> 
> I'm just looking for a suggestion on how to solve.
> 
> The background is that the host (hisi sas v3 hw) uses SAS SCSI transport and
> supports RPM. In the testcase, the host and disks are put to suspend. Then
> we run fio on the disk to make them active and then immediately hard reset
> the disk link, which causes the disk to be disconnected (please don't ask
> why ...).
> 
> We find that there is a conflict between the rescan and the device removal
> code, resulting in a deadlock:

> The rescan holds the sdev_gendev.device lock in scsi_rescan_device(), while
> the removal code in __scsi_remove_device() wants to grab it.
> 
> However the rescan will not release (the lock) until the blk_queue_enter()
> succeeds, above. That can happen 2x ways:
> 
> - the queue is dying, which would not happen until after the device_del() in
> __scsi_remove_device(), so not going to happen
> 
> - q->pm_only falls to 0. This would be when scsi_runtime_resume() ->
> sdev_runtime_resume() -> blk_post_runtime_resume(err = 0) ->
> blk_set_runtime_active() is called. However, I find that the err argument
> for me is -5, which comes from sdev_runtime_resume() -> pm->runtime_resume
> (=sd_resume()), which fails. That sd_resume() -> sd_start_stop_device()
> fails as the disk is not attached. So we go into error state:
> 
> $:more /sys/devices/pci0000:b4/0000:b4:04.0/host3/port-3:0/end_device-3:0/target3:0:0/3:0:0:0/power/runtime_status
> error
> 
> Removing commit e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
> solves this issue for me, but that is there for a reason.
> 
> Any suggestion on how to fix this deadlock?

This is indeed a tricky question.  It seems like we should allow a 
runtime resume to succeed if the only reason it failed was that the 
device has been removed.

More generally, perhaps we should always consider that a runtime 
resume succeeds.  Any remaining problems will be dealt with by the 
device's driver and subsystem once the device is marked as 
runtime-active again.

Suppose you try changing blk_post_runtime_resume() so that it always 
calls blk_set_runtime_active() regardless of the value of err.  Does 
that fix the problem?

And more importantly, will it cause any other problems...?

Alan Stern
