Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A06C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 15:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4079D20706
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 15:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgFZPom (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 11:44:42 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33263 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726895AbgFZPol (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 11:44:41 -0400
Received: (qmail 300652 invoked by uid 1000); 26 Jun 2020 11:44:41 -0400
Date:   Fri, 26 Jun 2020 11:44:41 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200626154441.GA296771@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 26, 2020 at 08:07:51AM -0700, Bart Van Assche wrote:
> On 2020-06-25 01:16, Martin Kepplinger wrote:
> > here's roughly what happens when enabling runtime PM in sysfs (again,
> > because sd_probe() calls autopm_put() and thus allows it:
> > 
> > [   27.384446] sd 0:0:0:0: scsi_runtime_suspend
> > [   27.432282] blk_pre_runtime_suspend
> > [   27.435783] sd_suspend_common
> > [   27.438782] blk_post_runtime_suspend
> > [   27.442427] scsi target0:0:0: scsi_runtime_suspend
> > [   27.447303] scsi host0: scsi_runtime_suspend
> > 
> > then I "mount /dev/sda1 /mnt" and none of the resume() functions get
> > called. To me it looks like the sd driver should initiate resuming, and
> > that's not implemented.
> > 
> > what am I doing wrong or overlooking? how exactly does (or should) the
> > block layer initiate resume here?
> 
> As far as I know runtime power management support in the sd driver is working
> fine and is being used intensively by the UFS driver. The following commit was
> submitted to fix a bug encountered by an UFS developer: 05d18ae1cc8a ("scsi:
> pm: Balance pm_only counter of request queue during system resume") # v5.7.

I just looked at that commit for the first time.

Instead of making the SCSI driver do the work of deciding what routine to 
call, why not redefine blk_set_runtime_active(q) to simply call 
blk_post_runtime_resume(q, 0)?  Or vice versa: if err == 0 have 
blk_post_runtime_resume call blk_set_runtime_active?

After all, the two routines do almost the same thing -- and the bug 
addressed by this commit was caused by the difference in their behaviors.

If the device was already runtime-active during the system suspend, doing 
an extra clear of the pm_only counter won't hurt anything.

> I'm not sure which bug is causing trouble on your setup but I think it's likely
> that the root cause is somewhere else than in the block layer, the SCSI core
> or the SCSI sd driver.
> 
> Bart.

Martin's best approach would be to add some debugging code to find out why 
blk_queue_enter() isn't calling bkl_pm_request_resume(), or why that call 
doesn't lead to pm_request_resume().

Alan Stern
