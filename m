Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DA3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB632083E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="B9wt8VX9";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="B9wt8VX9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgG2Pth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 11:49:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34926 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2Pth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 11:49:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 478D18EE207;
        Wed, 29 Jul 2020 08:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596037776;
        bh=gBu3zFOYSR4zGiNOEWmQCU6p4zT8YTvYTnY9Wyzgcc4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B9wt8VX9EKLgo0NaDdMMlFsXeCL0b3DRhOJDk3MuPe+/w7uu0yhC6nMZxzxPgVqhS
         buk5kTsVtdknXrOPKeuVun5vVc5+Er5Vhama8FPdEM1Zykx+L3Cn8D4Enc5F6qcoCq
         8IM+ahaqCjxc0acNQYg3C9Szvpd/8NbSZCVR16/k=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1BhnMLkRJrm0; Wed, 29 Jul 2020 08:49:36 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B58A38EE100;
        Wed, 29 Jul 2020 08:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596037776;
        bh=gBu3zFOYSR4zGiNOEWmQCU6p4zT8YTvYTnY9Wyzgcc4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B9wt8VX9EKLgo0NaDdMMlFsXeCL0b3DRhOJDk3MuPe+/w7uu0yhC6nMZxzxPgVqhS
         buk5kTsVtdknXrOPKeuVun5vVc5+Er5Vhama8FPdEM1Zykx+L3Cn8D4Enc5F6qcoCq
         8IM+ahaqCjxc0acNQYg3C9Szvpd/8NbSZCVR16/k=
Message-ID: <1596037774.4356.42.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Date:   Wed, 29 Jul 2020 08:49:34 -0700
In-Reply-To: <20200729154056.GA1575761@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
         <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
         <20200728200243.GA1511887@rowland.harvard.edu>
         <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
         <20200729143213.GC1530967@rowland.harvard.edu>
         <1596033995.4356.15.camel@linux.ibm.com>
         <1596034432.4356.19.camel@HansenPartnership.com>
         <20200729154056.GA1575761@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-29 at 11:40 -0400, Alan Stern wrote:
> On Wed, Jul 29, 2020 at 07:53:52AM -0700, James Bottomley wrote:
> > On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
[...]
> > > That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
> > > CHANGED" so it sounds like it something we should be
> > > ignoring.  Usually this signals a problem, like you changed the
> > > medium manually (ejected the CD).  But in this case you can tell
> > > us to expect this by setting
> > > 
> > > sdev->expecting_cc_ua
> > > 
> > > And we'll retry.  I think you need to set this on all resumed
> > > devices.
> > 
> > Actually, it's not quite that easy, we filter out this ASC/ASCQ
> > combination from the check because we should never ignore medium
> > might have changed events on running devices.  We could ignore it
> > if we had a flag to say the power has been yanked (perhaps an
> > additional sdev flag you set on resume) but we would still miss the
> > case where you really had powered off the drive and then changed
> > the media ... if you can regard this as the user's problem, then we
> > might have a solution.
> 
> Indeed, I was going to make the same point.
> 
> The only reasonable conclusion is that suspending these SD card
> readers isn't safe unless they don't contain a card -- or maybe just
> if the device file isn't open or mounted.

For standard removable media, I could see issuing an eject before
suspend to emphasize the point.  However, sd cards don't work like that
... they're not ejectable except manually and mostly used as the HDD of
embedded, so the 99% use case is that the user will suspend and resume
the device with the same sdd insert.  It does sound like a use case we
should support.

> Although support for this sort of thing could be added to the
> kernel, for now it's best to rely on userspace doing the right
> thing.  The kernel doesn't even know which devices suffer from this
> problem.

Can we solve from userspace the case where the user hasn't changed the
media and the resume fails because we don't know?

James

