From: tomm <tomm@lime-technology.com>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 25 Jul 2012 22:35:41 +0000 (UTC)
Message-ID: <loom.20120726T003312-580@post.gmane.org>
References: <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org> <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de> <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com> <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com> <500A9D7C.8080801@matthiasprager.de> <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40407 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2GYWkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jul 2012 18:40:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1SuAFR-0003zp-TZ
	for linux-scsi@vger.kernel.org; Thu, 26 Jul 2012 00:40:06 +0200
Received: from adsl-71-136-234-247.dsl.sndg02.pacbell.net ([71.136.234.247])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2012 00:40:05 +0200
Received: from tomm by adsl-71-136-234-247.dsl.sndg02.pacbell.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2012 00:40:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tejun Heo <tj <at> kernel.org> writes:

> 
> Hello,
> 
> On Sat, Jul 21, 2012 at 02:15:56PM +0200, Matthias Prager wrote:
> > Now I'm not sure this isn't taping over another bug. Which leads me to
> > my question: What is the correct behavior?
> > 
> > #1 Issuing a separate spin-up command (START UNIT?) prior to sending i/o
> > by setting allow_restart=1 for sata disks on sas controllers
> > 
> > or
> > 
> > #2 Teaching the sas drivers they do not need spin-up commands and can
> > simply start issuing i/o to sata disks
> 
> I haven't consulted SAT but it seems like a bug in SAS driver or
> firmware.  If it's a driver bug, we better fix it there.  If a
> firmware bug, working around those is one of major roles of drivers,
> so I think setting allow_restart is fine.
> 
> Thanks.
> 
If this is a driver or firmware bug, then why would commit
85ef06d1d252f6a2e73b678591ab71caad4667bb 
cause this to happen?  What is the interaction between this issue
and this commit which just flushes events?

Also this issue does not happen with mvsas, only with mpt2sas.




