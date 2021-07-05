Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02994C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D43076141C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhGENTu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 09:19:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51155 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230188AbhGENTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 09:19:50 -0400
Received: (qmail 116627 invoked by uid 1000); 5 Jul 2021 09:17:12 -0400
Date:   Mon, 5 Jul 2021 09:17:12 -0400
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
Message-ID: <20210705131712.GB116379@rowland.harvard.edu>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 05, 2021 at 01:00:39PM +0100, John Garry wrote:
> On 05/07/2021 00:45, Bart Van Assche wrote:
> 
> Hi Alan and Bart,
> 
> Thanks for the suggestions.
> 
> > > > Removing commit e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
> > > > solves this issue for me, but that is there for a reason.
> > > > 
> > > > Any suggestion on how to fix this deadlock?
> > > This is indeed a tricky question.  It seems like we should allow a
> > > runtime resume to succeed if the only reason it failed was that the
> > > device has been removed.
> > > 
> > > More generally, perhaps we should always consider that a runtime
> > > resume succeeds.  Any remaining problems will be dealt with by the
> > > device's driver and subsystem once the device is marked as
> > > runtime-active again.
> > > 
> > > Suppose you try changing blk_post_runtime_resume() so that it always
> > > calls blk_set_runtime_active() regardless of the value of err.  Does
> > > that fix the problem?
> > > 
> > > And more importantly, will it cause any other problems...?
> > That would cause trouble for the UFS driver and other drivers for which
> > runtime resume can fail due to e.g. the link between host and device
> > being in a bad state.

I don't understand how that could work.  If a device fails to resume 
from runtime suspend, no matter whether the reason is temporary or 
permanent, how can the system use it again?

And if the system can't use it again, what harm is there in pretending 
that the runtime resume succeeded?

> > How about checking the SCSI device state inside scsi_rescan_device() and
> > skipping the rescan if the SCSI device state is SDEV_CANCEL or SDEV_DEL?
> > 
> 
> I find that the device state is SDEV_RUNNING for me at that point (so it
> cannot work).
> 
> > Adding such a check inside __scsi_execute() would break sd_remove() and
> > sd_shutdown() since both use __scsi_execute() to submit a SYNCHRONIZE
> > CACHE command to the device.
> 
> Could we somehow signal from __scsi_remove_device() earlier that the request
> queue is dying or at least in some error state, so that blk_queue_enter() in
> the rescan can fail?
> 
> Currently we don't call blk_cleanup_queue() -> blk_set_queue_dying() until
> after the device_del(sdev_gendev) call in __scsi_remove_device().

I don't think that can be done.  device_del() calls the driver's 
remove routine, which may want to communicate with the device.  If the 
request queue is already in an error state, it won't be able to do so.

Alan Stern
