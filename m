From: Jeff Garzik <jeff@garzik.org>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 11:40:20 -0400
Message-ID: <49E4AE64.6070708@garzik.org>
References: <49E335BA.3020103@panasas.com> <200904140324.59657.bzolnier@gmail.com> <49E461E8.10106@garzik.org> <200904141654.24067.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34461 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZDNPke (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 11:40:34 -0400
In-Reply-To: <200904141654.24067.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux IDE mailing list <linux-ide@vger.kernel.org>

Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 14 April 2009 12:14:00 Jeff Garzik wrote:


> The SATA features that needed SCSI infrastructure came 2 years later.
> 
>> Moving libata out of SCSI is now a long term, far off goal.  A goal that 
>> implies many intermediate steps, cleanups to block, libata, IDE, SCSI 
>> and other block drivers.
> 
> "far off"?
> 
> The fact that it is much harder to do nowadays than in 2004-2005 (without
> ATAPI support, PATA support and heavy dependence on SCSI infrastructure)
> is only _your_ fault.

Of course it is.  Use of SCSI driver infrastructure was a sound 
technical decision, I'll happily defend.  Key reasons SCSI core was used:

* ATA-SCSI convergence was clear when libata began.  Time has proven 
this true:

ATAPI was always SCSI-like.  SAS is plug-compatible with SATA [for some 
SAS plugs], and SAS transmits SATA frames from SAS expanders and SATA 
port multipliers.  T10 and T13 standards committees actively 
collaborate.  SCSI even has a specification, SAT, that describes how to 
best co-mingle ATA with SCSI.

* SCSI driver infrastructure was the only one advanced enough to support 
controller hotplug, device hotplug, and all sorts of queueing contortions.

* SCSI was the only infrastructure that _guaranteed_ it would work with 
existing installers and distros.  For users, there is a clear level of 
difference in support between /dev/hdXX, /dev/sdXX, and every other 
block device in the kernel.

SCSI had a higher Just Works(tm) value at the time.

	Jeff



