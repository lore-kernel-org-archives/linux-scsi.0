From: Marc Bejarano <beej@alum.mit.edu>
Subject: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Thu, 06 Mar 2008 16:08:39 -0500
Message-ID: <200803062108.m26L8e4i020882@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colby.verdasys.com ([69.20.67.85]:60789 "EHLO
	colby.verdasys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbYCFVIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 16:08:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

i've been doing burn-in on a new server i had hoped to deploy months 
ago and can't seem to figure out the cause of data corruption i've 
been seeing.  the SAS controller is an LSI SAS3801E connected to an 
xTore XJ-SA12-316 SAS enclosures (vitesses expanders) full of seagate 
7200.10 750-GB SATA drives.

the corruption is occurring in ext3 filesystems that live on top of 
an lvm2 RAID 0 stripe composed of 16 2-drive md RAID 1 sets.  the 
corruption has been detected both by MySQL noticing bad checksums and 
also by using md's "check" (sync_action) for RAID 1 consistency.

most recently we got two cases of the storage stack apparently 
writing a mysql 16K page starting at the wrong 512-byte (sector) 
boundary.  in both cases it was at too low a sector.  one page was 13 
sectors too early, the other 34 too early.  in both cases, one disk 
in each mirror set had the correct data and the other incorrect 
(apparently ruling out everything above md). unfortunately, the 
problem is not easily repeatable.  the system can run for days with 
terabytes of writes before we notice any corruption.

we're running RHEL 5.1's kernel and drivers and i understand that 
these lists are for vanilla kernel support.  i've already engaged 
redhat support, but i just wanted to see if anybody else has seen 
something similar or anybody has any brilliant troubleshooting 
ideas.  swapping drives, enclosures, HBA's, cables, and sacrifices of 
animals to gods have so far not been able to make the world right.

tia,
marc

