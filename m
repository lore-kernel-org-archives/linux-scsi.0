Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5029EC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 13:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2F520708
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 13:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgF1NK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 09:10:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41715 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726316AbgF1NK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 09:10:58 -0400
Received: (qmail 367302 invoked by uid 1000); 28 Jun 2020 09:10:56 -0400
Date:   Sun, 28 Jun 2020 09:10:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200628131056.GA366822@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <5c10d65c-14ba-d2d5-ee7f-c4579432823e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c10d65c-14ba-d2d5-ee7f-c4579432823e@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jun 27, 2020 at 07:37:54PM -0700, Bart Van Assche wrote:
> On 2020-06-26 08:44, Alan Stern wrote:
> > On Fri, Jun 26, 2020 at 08:07:51AM -0700, Bart Van Assche wrote:
> >> As far as I know runtime power management support in the sd driver is working
> >> fine and is being used intensively by the UFS driver. The following commit was
> >> submitted to fix a bug encountered by an UFS developer: 05d18ae1cc8a ("scsi:
> >> pm: Balance pm_only counter of request queue during system resume") # v5.7.
> > 
> > I just looked at that commit for the first time.
> > 
> > Instead of making the SCSI driver do the work of deciding what routine to 
> > call, why not redefine blk_set_runtime_active(q) to simply call 
> > blk_post_runtime_resume(q, 0)?  Or vice versa: if err == 0 have 
> > blk_post_runtime_resume call blk_set_runtime_active?
> > 
> > After all, the two routines do almost the same thing -- and the bug 
> > addressed by this commit was caused by the difference in their behaviors.
> > 
> > If the device was already runtime-active during the system suspend, doing 
> > an extra clear of the pm_only counter won't hurt anything.
> 
> Hi Alan,
> 
> Do you want to submit a patch that implements this change or do you
> perhaps expect me to do that?

I'll submit a patch in a few days.  I just wanted to check first that the 
idea was sound.

Alan Stern
