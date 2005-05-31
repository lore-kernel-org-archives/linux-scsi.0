From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...) (fwd)
Date: Tue, 31 May 2005 11:18:44 -0700
Message-ID: <OF6CB222A1.2DB6C410-ON88257012.0063AA82-88257012.00648FFF@us.ibm.com>
References: <1117307520.5192.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56498 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261167AbVEaSTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 14:19:36 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4VIJXLZ022544
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2005 14:19:33 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4VIJWBU117278
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2005 14:19:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4VIJWGb017275
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2005 14:19:32 -0400
Received: from d01ml604.pok.ibm.com (d01ml604.pok.ibm.com [9.56.227.90])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j4VIJVvh017195
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2005 14:19:31 -0400
In-Reply-To: <1117307520.5192.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>I suggest you think about what an ioctl is
>and why we're going through a process of trying to get rid of them in
>the kernel:  They're structured streams of information, where the
>structure is architecture and 64/32 bit dependent (look at all the
>issues over compat ioctls).

I think that's a poor characterization of an ioctl.  _Some_ ioctls have an 
architecture and 64/32 bit dependent structure, but it isn't inherent in 
an ioctl.  In fact, most ioctls don't have that problem.

What an ioctl is is something that's defined for a special case (e.g. a 
certain device type).  The lesson from the compat ioctl mess is that it 
hurts to have special cases.  Plenty of system calls are as 
architecture-dependent as any ioctl, but since they aren't defined 
separately in every device driver, they're easier to update for new 
architectures.

Incidentally, I'm reserving judgment on whether the disadvantages of 
ioctls outweigh their advantages.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems 
