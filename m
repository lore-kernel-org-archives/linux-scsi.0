Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203F0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041FC207E8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgG2Pk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 11:40:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54111 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726365AbgG2Pk5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 11:40:57 -0400
Received: (qmail 1575934 invoked by uid 1000); 29 Jul 2020 11:40:56 -0400
Date:   Wed, 29 Jul 2020 11:40:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200729154056.GA1575761@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
 <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
 <20200728200243.GA1511887@rowland.harvard.edu>
 <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
 <20200729143213.GC1530967@rowland.harvard.edu>
 <1596033995.4356.15.camel@linux.ibm.com>
 <1596034432.4356.19.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596034432.4356.19.camel@HansenPartnership.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 29, 2020 at 07:53:52AM -0700, James Bottomley wrote:
> On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
> > On Wed, 2020-07-29 at 10:32 -0400, Alan Stern wrote:
> > > On Wed, Jul 29, 2020 at 04:12:22PM +0200, Martin Kepplinger wrote:
> > > > On 28.07.20 22:02, Alan Stern wrote:
> > > > > On Tue, Jul 28, 2020 at 09:02:44AM +0200, Martin Kepplinger
> > > > > wrote:
> > > > > > Hi Alan,
> > > > > > 
> > > > > > Any API cleanup is of course welcome. I just wanted to remind
> > > > > > you that the underlying problem: broken block device runtime
> > > > > > pm. Your initial proposed fix "almost" did it and mounting
> > > > > > works but during file access, it still just looks like a
> > > > > > runtime_resume is missing somewhere.
> > > > > 
> > > > > Well, I have tested that proposed fix several times, and on my
> > > > > system it's working perfectly.  When I stop accessing a drive
> > > > > it autosuspends, and when I access it again it gets resumed and
> > > > > works -- as you would expect.
> > > > 
> > > > that's weird. when I mount, everything looks good, "sda1". But as
> > > > soon as I cd to the mountpoint and do "ls" (on another SD card
> > > > "ls" works but actual file reading leads to the exact same
> > > > errors), I get:
> > > > 
> > > > [   77.474632] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
> > > > hostbyte=0x00 driverbyte=0x08 cmd_age=0s
> > > > [   77.474647] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
> > > > [   77.474655] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
> > > > [   77.474667] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00
> > > > 00 60 40 00 00 01 00
> > > 
> > > This error report comes from the SCSI layer, not the block layer.
> > 
> > That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
> > CHANGED" so it sounds like it something we should be
> > ignoring.  Usually this signals a problem, like you changed the
> > medium manually (ejected the CD).  But in this case you can tell us
> > to expect this by setting
> > 
> > sdev->expecting_cc_ua
> > 
> > And we'll retry.  I think you need to set this on all resumed
> > devices.
> 
> Actually, it's not quite that easy, we filter out this ASC/ASCQ
> combination from the check because we should never ignore medium might
> have changed events on running devices.  We could ignore it if we had a
> flag to say the power has been yanked (perhaps an additional sdev flag
> you set on resume) but we would still miss the case where you really
> had powered off the drive and then changed the media ... if you can
> regard this as the user's problem, then we might have a solution.

Indeed, I was going to make the same point.

The only reasonable conclusion is that suspending these SD card readers 
isn't safe unless they don't contain a card -- or maybe just if the 
device file isn't open or mounted.

Although support for this sort of thing could be added to the kernel, 
for now it's best to rely on userspace doing the right thing.  The 
kernel doesn't even know which devices suffer from this problem.

Alan Stern
