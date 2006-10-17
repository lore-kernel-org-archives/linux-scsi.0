From: Clem Pryke <pryke@focus.uchicago.edu>
Subject: mptsas driver
Date: Tue, 17 Oct 2006 10:55:00 -0500
Message-ID: <200610171555.k9HFt0sE029263@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from focus.uchicago.edu ([128.135.70.184]:7873 "EHLO
	focus.uchicago.edu") by vger.kernel.org with ESMTP id S1751164AbWJQPzC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 11:55:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
Cc: pryke@focus.uchicago.edu

I have an Xtore XJ-SA12-316R external SAS chassis housing 12 Seagate ST375064 
disks.

After an abortive attempt to get this setup using an Adaptec 58300 SAS 
controller card and their proprietary adp94xx driver I bought an LSI Logic 
SAS3800X card.

This is supported by module mptsas in RHEL4U4 kernel. As far as I can tell the 
fusion mpt driver is GPL and so I might not get told off for asking questions 
about it here? ;-)

I am slaving the disks together using md as raid5 (or raid6 array). Basically 
it works 99.999% but occasionally produces error during md re-sync:

kernel: mptbase: ioc0: LogInfo(0x31120400): Originator={PL}, Code={Abort}, 
SubCode(0x0400)

Most times things appear to proceed as normal but a few times it is followed 
by SCSI errors and the disk is dropped:

Oct 16 16:29:40 spt2 kernel: SCSI error : <2 0 9 0> return code = 0x10000
Oct 16 16:29:40 spt2 kernel: end_request: I/O error, dev sdd, sector 948164346
Oct 16 16:29:40 spt2 kernel: raid6: Disk failure on sdd1, disabling device. 
Operation continuing on 10 devices

I can't prove that the disks aren't really producing timeouts/errors. But I've 
seen several of them appear to do so and suspect it's the controller/driver. A 
complication is the chassis which has built in SAS port expander which might 
also be a factor.

Does anyone have any similar experience?

Thanks for any help.

Clem

More details:
Card is in Tyan dual AMD64 box. Kernel is RHEL4U4 2.6.9-42.0.2.ELsmp.

-- 
**********************************************************************
Clem Pryke - Assistant Professor - Astronomy and Astrophysics
University of Chicago,
Room 120, LASR, 933 East 56th Street, Chicago, Illinois 60637, USA
Tel: 773 702-7853  Fax: 773 702-6645  email: pryke@focus.uchicago.edu
**********************************************************************


