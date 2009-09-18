From: Simon Jackson <sjackson@bluearc.com>
Subject: Modifying retry count for devices in RAID.
Date: Fri, 18 Sep 2009 11:58:36 +0100
Message-ID: <ABFC24E4C13D81489F7F624E14891C864EF8AA99@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:48105 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZIRLHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 07:07:00 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I asked the question below in the linux-raid forum and have not received any reply.  Hopefully members of this forum might be able to assist.

I am interested in whether the retry algorithm can be modified for SATA drives running in RAID 1 configurations when a read error occurs.

It seems that by default the sd driver try hard to recover the data from the original member before kicking off the recovery read from the alternate member.  In a RAID 1 volume I would like to reduce these retries.

I used hdparm --make-bad-sector to flag a sector of a specific file on a RAID 1 member drive as corrupt then read the file.  Luckily (well I had a 50 50 chance) the first time I tried to read the file, the driver chose the corrupted member and there was a long (40 second) delay before the file was read.

I looked at kern.log and saw repeated retires before the ata and sd drivers drivers gave up and md recovered using the alternate member.

How can I get tell the drivers to give up after less retries and have the RAID recovery occur more quickly?


Thanks Simon.
