From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: SG_IO ioctl (was: mode sense blacklist how)
Date: 21 Nov 2003 14:29:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069450179.15688.35.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
	 <1068838908.2852.34.camel@patrh9>
	 <1069246502.3fbb6826955dd@webmail.netregistry.net>
	 <1069261377.2867.37.camel@patrh9>  <3FBBFDFB.9010406@torque.net>
	 <1069345927.6663.27.camel@patrh9>  <3FBD679C.5010405@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:2813 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261752AbTKUVaK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 16:30:10 -0500
In-Reply-To: <3FBD679C.5010405@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Offline kindly I'm reminded to distinguish a compelling third "pro" for
SG_IO via block/scsi_ioctl.c:

> > Designing an lk 2.6 user app to recommend more prominent device names
> > like /dev/hdd and /dev/scd0 in place of less prominent /dev/sg$n names
> > thereby steers people into using the less robust pass thru of SG_IO via
> > block/scsi_ioctl.c.
> 
> Pat,
> Well it's a trade-off. If you use the SG_IO in
> the block layer then:
> 
> Pros:
+ -- - works with ide-cd kernels, not just with ide-scsi kernels
>    - convenience (for block devices)
>    - no device mapping problems (sd <-> sg) **
> Cons:
>    - no help for "non-block" devices: tapes, enclosures,
>      OSD, etc
>    - inherit block layer policy (e.g. 128 KB xfer limit,
>      direct IO alignment)
>    - unable to interrupt a SCSI command in progress with
>      a signal
>    - associated ioctls are dummies or not there, hence unable
>      to reset device/bus/host (for example)
>    - no driver or host error reporting (only SCSI status)
> 
> I'm sure more "cons" will come to light and some will be
> addressed. There is probably enough there already to give
> the cdrecord author pause for thought.

Pat LaVarre


