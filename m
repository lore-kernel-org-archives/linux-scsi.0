From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptspi :
	min_period,max_offset,max_width,incorrectlyset, resulting domain validation
	failing
Date: Thu, 21 Sep 2006 19:13:48 -0400
Message-ID: <1158880428.14329.50.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7032D3D1@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19136 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932104AbWIUXN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 19:13:58 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032D3D1@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-09-21 at 16:32 -0600, Moore, Eric wrote:
> On Wednesday, September 20, 2006 10:00 AM, James Bottomley wrote: 
> 
> > 
> > Heh, Quantum Atlas ... I should have known ...
> > 
> > OK, try the attached (it's a rollup of all the heuristics 
> > changes we've
> > been discussing).
> > 
> 
> Thanks so much
> That appears to fix both issues I reported on U160 and U80 drives.
> Can you pls apply this to your tree for 2.6.19 push. 

Yes ... but I need to get back home to sort out my tree and the pending
patch pile first.

> > Actually, there are: there are some fujitsu devices that do 
> > QAS at u160.
> 
> Didn't know.  Can you verify that it works with fusion with QAS enabled?

I don't have one ... I actually only have 2 u80 (Quantum Atlas) and
2xu320 (Seagate Cheetah) SPI devices.

I know there's a problem because I enabled QAS in the aic7xxx (u160)
driver and it failed miserably on a Fujitsu when the drive tried to
negotiate for it.  I believe Matthew Wilcox was going to get one to try
out QAS and IU on the 53c1010.

> > This is a user policy thing.  Usually you want QAS set where 
> > possible to
> > speed up the transport ... if you're getting starvation problems, you
> > can disable it using the parameters.
> > 
> 
> I just don't think that is a good idea.
> I forsee support calls, for users that don't know they
> can't run QAS in mixed mode, and don't know this work around
> that your suggesting.   Its going happen.  
> I still think back to Andrew Patterson's request that we 
> have a mechnism to turn one knob to shut off QAS for entire host, 
> instead of traversing each and every target.

It's hard to come up with an actual user scenario where fairness would
be an issue.  Most users won't mix QAS and non-QAS disk devices, except
for limited periods where they're upgrading or something ... I suppose
there could be an issue with a tape drive on the same bus, but usually
people are canny enough not to mix disk and tape either.

There's really only one known field issue where QAS was a suspect ...
and no-one's been able to reproduce it.

James


