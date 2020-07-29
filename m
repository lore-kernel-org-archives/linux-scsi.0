Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7653DC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 589E720829
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="KaxddRhc";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="KaxddRhc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgG2Oxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 10:53:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34296 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726476AbgG2Oxz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 10:53:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 705CC8EE207;
        Wed, 29 Jul 2020 07:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596034434;
        bh=52QMwb7Jds0gQp46DIWjlg4uzDKqmp0+MN9kfbsWbYw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KaxddRhcrEATgtc3+DrhSJ4n0NFDWD+jQycTwDg09AbWbe/mSXbaq8HlO1hL4TQYm
         j8w03aVpW523vOV84ICUC+NZOgQV30n9x3L90GaIc52gNGLdqlPwddRqMGEeIPwX4K
         dw5s6o3o+2E3141yBGgNBZfVMHMkNxcOJaEnVwCk=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oXOLaPWPO5AT; Wed, 29 Jul 2020 07:53:54 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C87708EE100;
        Wed, 29 Jul 2020 07:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596034434;
        bh=52QMwb7Jds0gQp46DIWjlg4uzDKqmp0+MN9kfbsWbYw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KaxddRhcrEATgtc3+DrhSJ4n0NFDWD+jQycTwDg09AbWbe/mSXbaq8HlO1hL4TQYm
         j8w03aVpW523vOV84ICUC+NZOgQV30n9x3L90GaIc52gNGLdqlPwddRqMGEeIPwX4K
         dw5s6o3o+2E3141yBGgNBZfVMHMkNxcOJaEnVwCk=
Message-ID: <1596034432.4356.19.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Date:   Wed, 29 Jul 2020 07:53:52 -0700
In-Reply-To: <1596033995.4356.15.camel@linux.ibm.com>
References: <20200706164135.GE704149@rowland.harvard.edu>
         <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
         <20200728200243.GA1511887@rowland.harvard.edu>
         <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
         <20200729143213.GC1530967@rowland.harvard.edu>
         <1596033995.4356.15.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
> On Wed, 2020-07-29 at 10:32 -0400, Alan Stern wrote:
> > On Wed, Jul 29, 2020 at 04:12:22PM +0200, Martin Kepplinger wrote:
> > > On 28.07.20 22:02, Alan Stern wrote:
> > > > On Tue, Jul 28, 2020 at 09:02:44AM +0200, Martin Kepplinger
> > > > wrote:
> > > > > Hi Alan,
> > > > > 
> > > > > Any API cleanup is of course welcome. I just wanted to remind
> > > > > you that the underlying problem: broken block device runtime
> > > > > pm. Your initial proposed fix "almost" did it and mounting
> > > > > works but during file access, it still just looks like a
> > > > > runtime_resume is missing somewhere.
> > > > 
> > > > Well, I have tested that proposed fix several times, and on my
> > > > system it's working perfectly.  When I stop accessing a drive
> > > > it autosuspends, and when I access it again it gets resumed and
> > > > works -- as you would expect.
> > > 
> > > that's weird. when I mount, everything looks good, "sda1". But as
> > > soon as I cd to the mountpoint and do "ls" (on another SD card
> > > "ls" works but actual file reading leads to the exact same
> > > errors), I get:
> > > 
> > > [   77.474632] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
> > > hostbyte=0x00 driverbyte=0x08 cmd_age=0s
> > > [   77.474647] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
> > > [   77.474655] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
> > > [   77.474667] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00
> > > 00 60 40 00 00 01 00
> > 
> > This error report comes from the SCSI layer, not the block layer.
> 
> That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
> CHANGED" so it sounds like it something we should be
> ignoring.  Usually this signals a problem, like you changed the
> medium manually (ejected the CD).  But in this case you can tell us
> to expect this by setting
> 
> sdev->expecting_cc_ua
> 
> And we'll retry.  I think you need to set this on all resumed
> devices.

Actually, it's not quite that easy, we filter out this ASC/ASCQ
combination from the check because we should never ignore medium might
have changed events on running devices.  We could ignore it if we had a
flag to say the power has been yanked (perhaps an additional sdev flag
you set on resume) but we would still miss the case where you really
had powered off the drive and then changed the media ... if you can
regard this as the user's problem, then we might have a solution.

James
 
