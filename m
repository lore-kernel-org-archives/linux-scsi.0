From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 10 Dec 2003 17:12:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071101529.28943.48.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:32488 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263537AbTLKAM3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 19:12:29 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net, patmans@us.ibm.com

> Date: 2003-11-07 8:55:01
> From: Doug Gilbert ...
> ....
> ** There is also the Power Condition mode
> page that all SCSI devices may optionally
> support. Trouble is with my SCSI-3 disks they
> either don't support it or the one that does
> gives ASC/ASCQ=04/02 when the disk is spun
> down (violating SPC-3).

We have a specific spc 3 rev and clause in mind?

> Date: 2003-11-10 17:43:22
> From: Patrick Mansfield
> ...
> whoever spun down the drive should spin it up.
> ...
> Whatever caused the spin down should spin it back up.

Auto spin up doesn't work with much direct-attached Windows.

For example, people say Win ME/9X in particular limit ATA/PI read to
7.5+0.5s.  For a device whose spinup exceeds 7s, the only scheme I've
ever seen work there is to notify the host e.g. via SK ASC ASCQ x 2 04
02 that some other thread spun down the drive.  I hear XP/ 2K/ NT need
ASCQ x02 whereas ME/ 9X properly understood that x00 in SCSI ASCQ by
definition means x00..FF and thus ME/ 9X do match x00 with x02.

> Date: 2003-12-03 22:57:58
> From: Scott M. Ferris ...
> ...
> Somebody really needs to come up with a cache
> design that doesn't silently discard unwritten
> data when block writes start failing ...

Aye.

> especially problematic on network SCSI
> transports like Fibre Channel and iSCSI, where
> network problems can cause all sorts of
> failures not commonly seen with parallel
> SCSI, USB, or any other direct-attached storage.

Loss of write-behind also occurs perceptibly often in direct-attached
storage.

dvd+rw/ cd-rw in particular often round up 2 KiB write requests to 32 or
64 KiB read-modify-write, and thus destroy blocks not even addressed
(e.g. parts of other udf.ko files allotted in 2 KiB blocks) when writes
fail.

Pat LaVarre


