From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 03 Mar 2009 15:21:58 +0000
Message-ID: <1236093718.3263.3.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42864 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754794AbZCCPWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 10:22:04 -0500
In-Reply-To: <49ACF8FE.2020904@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, 2009-03-03 at 11:31 +0200, Boaz Harrosh wrote:
> Jan Engelhardt wrote:
> > Hi,
> > 
> > 
> > I am noticing that there are a lot of objects active after a few tens 
> > minutes of running xfs_fsr.
> > 
> > $ slabtop
> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
> > 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
> >  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
> >  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
> >   8927   8574  96%    0.03K     79      113       316K size-32
> > 
> 
> Looks like a leak, by failing to call scsi_release_buffers()
> somehow. (Which was changed recently)

Firstly, I have to say I don't see this in the mainline tree, so could
you try that with your setup just to verify (git head at 2.6.29-rc6).

If this holds true, there must be a bad patch in the -rt tree.  You
should be able to diff scsi_lib.c to see if there's something missing.

Finally, there are one or two drivers (SCSI target) that do their own
buffer management, so what drivers are you using?

James


