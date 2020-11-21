Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30885C5519F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 17:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E555E22206
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 17:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgKURcd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Nov 2020 12:32:33 -0500
Received: from netrider.rowland.org ([192.131.102.5]:42347 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726281AbgKURcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2020 12:32:33 -0500
Received: (qmail 658838 invoked by uid 1000); 21 Nov 2020 12:32:31 -0500
Date:   Sat, 21 Nov 2020 12:32:31 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH RFC v2 1/1] scsi: pm: Leave runtime PM status alone
 during system resume/thaw/restore
Message-ID: <20201121173231.GA657814@rowland.harvard.edu>
References: <1605861443-11459-1-git-send-email-cang@codeaurora.org>
 <20201120163524.GB619708@rowland.harvard.edu>
 <9df460a7-c7fc-4999-bfaa-076229b8a752@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9df460a7-c7fc-4999-bfaa-076229b8a752@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 21, 2020 at 09:00:02AM -0800, Bart Van Assche wrote:
> On 11/20/20 8:35 AM, Alan Stern wrote:
> > On Fri, Nov 20, 2020 at 12:37:22AM -0800, Can Guo wrote:
> >> Runtime resume is handled by runtime PM framework, no need to forcibly
> >> set runtime PM status to RPM_ACTIVE during system resume/thaw/restore.
> > 
> > Sorry, I don't understand this explanation at all.
> > 
> > Sure, runtime resume is handled by the runtime PM framework.  But this 
> > patch changes the code for system resume, which is completely different.
> > 
> > Following a system resume, the hardware will be at full power.  We don't 
> > want the kernel to think that the device is still in runtime suspend; 
> > otherwise is would never put the device back into low-power mode.
> 
> Hi Alan,
> 
> Does this mean that every driver needs similar code for handling runtime
> suspended devices upon system resume? If so, would it be possible to
> move that code into the power management core (drivers/base/power)?

That's a complicated story.

In short, many drivers need to do this, but not all.  There is a complex 
collection of settings available for subsystems or drivers that would 
like their devices to remain in runtime system across a system sleep.

For the subsystems/drivers that don't care to deal with this complexity 
or don't have any special requirements -- yes, they all need to include 
code like this in their system-resume paths.

I had a very long discussion with Rafael Wysocki about all this starting 
last March; you can find the relevant emails beginning roughly here:

	https://marc.info/?l=linux-pm&m=158516934924947&w=2

and continuing through a few different threads.

Rafael ended up making a large number of changes to the PM core and API 
to simplify things, straighten them out, and improve the documentation.  
But we never did try to add this automatic set-runtime-active thing into 
the core.  Probably we wanted all the other changes to settle down 
before trying to do it, and then just forgot about it.  In fact, I'm not 
certain that it is possible now, but we should look into it.

Alan Stern
