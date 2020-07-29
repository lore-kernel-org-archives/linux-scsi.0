Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF918C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 16:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EE620FC3
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 16:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgG2QRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 12:17:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56147 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726385AbgG2QRZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 12:17:25 -0400
Received: (qmail 1577145 invoked by uid 1000); 29 Jul 2020 12:17:23 -0400
Date:   Wed, 29 Jul 2020 12:17:23 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200729161723.GB1575761@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
 <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
 <20200728200243.GA1511887@rowland.harvard.edu>
 <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
 <20200729143213.GC1530967@rowland.harvard.edu>
 <1596033995.4356.15.camel@linux.ibm.com>
 <1596034432.4356.19.camel@HansenPartnership.com>
 <20200729154056.GA1575761@rowland.harvard.edu>
 <1596037774.4356.42.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596037774.4356.42.camel@HansenPartnership.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 29, 2020 at 08:49:34AM -0700, James Bottomley wrote:
> On Wed, 2020-07-29 at 11:40 -0400, Alan Stern wrote:
> > On Wed, Jul 29, 2020 at 07:53:52AM -0700, James Bottomley wrote:
> > > On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
> [...]
> > > > That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
> > > > CHANGED" so it sounds like it something we should be
> > > > ignoring.  Usually this signals a problem, like you changed the
> > > > medium manually (ejected the CD).  But in this case you can tell
> > > > us to expect this by setting
> > > > 
> > > > sdev->expecting_cc_ua
> > > > 
> > > > And we'll retry.  I think you need to set this on all resumed
> > > > devices.
> > > 
> > > Actually, it's not quite that easy, we filter out this ASC/ASCQ
> > > combination from the check because we should never ignore medium
> > > might have changed events on running devices.  We could ignore it
> > > if we had a flag to say the power has been yanked (perhaps an
> > > additional sdev flag you set on resume) but we would still miss the
> > > case where you really had powered off the drive and then changed
> > > the media ... if you can regard this as the user's problem, then we
> > > might have a solution.
> > 
> > Indeed, I was going to make the same point.
> > 
> > The only reasonable conclusion is that suspending these SD card
> > readers isn't safe unless they don't contain a card -- or maybe just
> > if the device file isn't open or mounted.
> 
> For standard removable media, I could see issuing an eject before
> suspend to emphasize the point.

That's not a workable approach in general.  For example, you wouldn't 
want to eject a CD just because it hadn't been used for a couple of 
minutes and the drive was therefore about to be suspended.

>  However, sd cards don't work like that
> ... they're not ejectable except manually and mostly used as the HDD of
> embedded, so the 99% use case is that the user will suspend and resume
> the device with the same sdd insert.  It does sound like a use case we
> should support.

Agreed.

> > Although support for this sort of thing could be added to the
> > kernel, for now it's best to rely on userspace doing the right
> > thing.  The kernel doesn't even know which devices suffer from this
> > problem.
> 
> Can we solve from userspace the case where the user hasn't changed the
> media and the resume fails because we don't know?

The difficulty is recognizing situations where the media really was 
changed while the device was suspended.  Most devices, AFAIK, don't have 
any problem with this, but card readers often do.

I suppose the kernel could just rely on users not to change media in 
drives while they are mounted.  Then any problems that arise would be 
the users' fault.  Yes, this is nothing more than passing the buck, but 
it's hard to come up with any better approach.  Doesn't Windows do 
something like this?

Alan Stern
