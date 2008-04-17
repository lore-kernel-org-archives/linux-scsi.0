From: "Petrakis, Peter" <Peter.Petrakis@stratus.com>
Subject: RE: aic94xx + ST3146855SS still failing under heavy load
Date: Thu, 17 Apr 2008 11:51:59 -0400
Message-ID: <4DF9D710A2BB344BAFDE19178756F58BD845E3@EXNA.corp.stratus.com>
References: <1208192617.10361.18.camel@lvk-nb.localdomain> 48062D6C.6070807@ipax.at   <4DF9D710A2BB344BAFDE19178756F58BD845DF@EXNA.corp.stratus.com> 1208444910.10371.56.camel@lvk-nb.localdomain
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:52380 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbYDQPwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 11:52:02 -0400
Received: from EXNAR.corp.stratus.com (exnar.corp.stratus.com [134.111.200.165])
	by mailhub5.stratus.com (8.12.11/8.12.11) with ESMTP id m3HFpvBN000844
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 11:51:57 -0400
Content-class: urn:content-classes:message
In-Reply-To: 1208444910.10371.56.camel@lvk-nb.localdomain
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Leonid,

Ignore the "A4" for a moment; it probably doesn't affect the bug you're
chasing anyways. The previous adp94xx driver uses V32 which is a more
than
a step up from what you're running now. If this improves your situation
(less REQ_TASK_ABORTs) I'll see about merging the firmware bits 
(it's stuck in a header file) into the RHEL-5.1 version of the aic94xx
driver and providing a patch for you, it's not hard.

http://www.adaptec.com/en-US/speed/sas/linux/adp94xx-1_0_8-12_src_tgz.ht
m

Peter

> -----Original Message-----
> From: Leonid Kalmankin [mailto:lvk@mashcenter.ru]
> Sent: Thursday, April 17, 2008 11:09 AM
> To: Petrakis, Peter
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: aic94xx + ST3146855SS still failing under heavy load
> 
> Hi Peter!
> 
> On Wed, 2008-04-16 at 13:34 -0400, Petrakis, Peter wrote:
> > Hi Raoul,
> >
> > We use the same disks with the same firmware here at Stratus and
have
> > never experienced the issue you're observing. Maybe it's due to the
fact
> > that the hardware raid on the AIC-9410W is enabled? If you're using
md
> 
> No, disabling hardware raid didn't help, got same errors.
> 
> > then there's no reason to keep it on. Our configurations as almost
> > identical except for:
> >
> > - hardware RAID disabled
> > - directly attached
> > - md level 1
> > - seq: V32A4
> 
> where did you get that? the lastest i have is V30
> 
> > - bios/firmware 2.0-2 1822/1021
> >
> > The bios and firmware revs may be specific to our implementation
since
> > the SAS chip is glued to our PCI-X riser. Are your disks directly
> > attached or are you using a SAS expander?
> >
> > Peter
> >
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > owner@vger.kernel.org] On Behalf Of Raoul Bhatia [IPAX]
> > > Sent: Wednesday, April 16, 2008 12:47 PM
> > > To: Leonid Kalmankin
> > > Cc: linux-scsi@vger.kernel.org
> > > Subject: Re: aic94xx + ST3146855SS still failing under heavy load
> > >
> > > hi,
> > >
> > > some others, like me, are struggeling with this problem.
> > > afaik, james bottomley (or someone else?) is working on a fix,
> > > but it will take some more time.
> > >
> > > please see [1] and [2].
> > >
> > > btw. i asked seagate and adaptec and both did not come up with a
> > decent
> > > solution. seagate asked me to verify this with a different
controller
> > > and said that they know of no issue and adaptec gave me a new
> > sequencer
> > > firmware - so at least the server is still responding properly -
and
> > > told me that all the fixes went into the recent 2.6.25rc6+ kernel.
> > >
> > > cheers,
> > > raoul
> > > [1] http://marc.info/?t=120603924200004
> > > [2] http://marc.info/?t=120757821700007
> > >
> > > Leonid Kalmankin wrote:
> > > > Hello!
> > > >
> > > > We have a system with:
> > > >
> > > > vanilla 2.6.25-rc8 (2.6.23, 2.6.24 have the same behaviour)
> > > >
> > > > Adaptec AIC-9410W SAS (Razor ASIC RAID) (rev 09)
> > > > aic94xx: Found sequencer Firmware version 1.1 (V30)
> > > >   (Firmware version 1.1 (V17/10c6) makes no difference)
> > > > scsi 2:0:0:0: Direct-Access  SEAGATE ST3146855SS 0002 PQ: 0
ANSI: 5
> 

