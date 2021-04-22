Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442F2C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2B161209
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhDVQ1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:27:54 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:39470 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236648AbhDVQ1x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:27:53 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id CD53292009C; Thu, 22 Apr 2021 18:27:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id C802A92009B;
        Thu, 22 Apr 2021 18:27:17 +0200 (CEST)
Date:   Thu, 22 Apr 2021 18:27:17 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>
cc:     Ondrej Zary <linux@zary.sk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
In-Reply-To: <b23c0a0e-d95b-b941-1cc2-1a8bcf44401a@gonehiking.org>
Message-ID: <alpine.DEB.2.21.2104221808170.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk> <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org> <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk> <202104182221.21533.linux@zary.sk> <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
 <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk> <d7dc08a6-92be-e524-1f11-cd9f7326a0fd@gonehiking.org> <alpine.DEB.2.21.2104200456100.44318@angie.orcam.me.uk> <b23c0a0e-d95b-b941-1cc2-1a8bcf44401a@gonehiking.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021, Khalid Aziz wrote:

> >  Verifying actual ISA operations (third-party DMA, etc.) cannot be made 
> > this way, but as I understand the issue there is merely with passing data 
> > structures around and that may not require too much attention beyond 
> > getting things syntactically correct, which I gather someone forgot to do 
> > with a change made a while ago.  So that should be doable as well.
> 
> In theory this sounds reasonable, but without being able to test with a
> real hardware I would be concerned about making this change.

 Sometimes you have little choice really and that would be less disruptive 
than dropping support altogether.  Even if there's a small issue somewhere 
it's easier to fix by a competent developer who actually gets the hands on 
a piece of hardware than bringing back old code that has been removed and 
consequently not updated according to internal API evolution, etc.

 I had this issue with the defxx driver with which for years I didn't have 
a specimen of the EISA variant of the hardware handled.  I did my best to 
maintain EISA support however and while indeed I made a few of mistakes on 
the way, they were easy to straighten out once I finally did get my hands 
on an EISA piece.

> >  NB as noted before I only have a BT-958 readily wired for operation.  I 
> > don't expect I have any other BusLogic hardware, but I may yet have to 
> > double-check a stash of hardware I have accumulated over the years.  But 
> > that is overseas, so I won't be able to get at it before we're at least 
> > somewhat closer to normality.  If all else fails I could possibly buy one.
> > 
> >  I have respun the series now as promised.  Does your BT-757 adapter avoid 
> > the issue with trailing allocation somehow?
> 
> Well, my only test machine with a legacy PCI slot died some time back. I
> have been working on putting together a replacement and have now been
> able to get a working machine with a BT-950 adapter. I have not seen
> issue with trailing allocation upto 5.12-rc8. I am going to try the top
> of tree as well to make sure I do not run into this issue.

 I guess you won't see the issue with a FlashPoint adapter as they work in 
a different manner.  I think your EISA MultiMaster device is more likely 
to have a problem here.

 And AFAICT most SCSI commands (or at least the older ones which used to 
be there when development was still active with the MultiMaster devices) 
return exactly as much data as requested, so I guess the issue may have 
gone unnoticed.  I'll see if I can find some time to investigate this 
further now that we have proper documentation available, but meanwhile I 
do hope the workaround I have come up with 18 years ago already is good 
enough to keep it.

  Maciej
