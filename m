From: "Russell Johnson" <rjohnson@rtlogic.com>
Subject: RE: Megaraid corruption?
Date: Thu, 9 Dec 2004 10:26:30 -0700
Message-ID: <003301c4de14$38f885e0$1e01a8c0@rtlogic.com>
References: <1102604627.8512.27.camel@TroysLinux.verari.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eagle.rtlogic.com ([216.87.68.236]:3815 "EHLO eagle.rtlogic.com")
	by vger.kernel.org with ESMTP id S261488AbULIR0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 12:26:34 -0500
In-Reply-To: <1102604627.8512.27.camel@TroysLinux.verari.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: res1uo0c@verizon.net, 'Tom Coughlan' <coughlan@redhat.com>
Cc: linux-scsi@vger.kernel.org

There was a recent patch to the megaraid2 driver that fixed corruption while
some ioctl's were executing during file operations.  You mentioned using
megamgr.  If that is running in the background while you are performing the
file copies, it could be causing the bug that was fixed in the most recent
megaraid2 driver.

Try disabling megamgr and run your test...

Or try updating megaraid2 to the latest version.  I'm using 
megaraid cmm: 2.20.2.0 (Release Date: Thu Aug 19 09:58:33 EDT 2004)
megaraid: 2.20.4.0 (Release Date: Mon Sep 27 22:15:07 EDT)

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Troy Klein
> Sent: Thursday, December 09, 2004 8:04 AM
> To: Tom Coughlan
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Megaraid corruption?
> 
> 
> No that is the thing I am getting no entry in logs.  
> 
> I do have some questions as to the differences between 
> megaraid version 1.18f capabilities and megaraid2 2.00.9 
> capabilities.  Is the megaraid2 capable of addressing faster 
> drive buses?  What are the major differences and major 
> features added to version 2?
> 
> The following is a more detailed descrtiption and some background:
> 
> My "test case" has been a user home dir with about 12GB of 
> data.  I use 
> "rsync" to copy the files, and then use "diff" to compare the 
> two dirs for differences.  The server has two Xeon 2.4 GHz 
> processors, 4GB RAM, and 3 Maxtor 250GB SATA disks in a RAID 
> 5 configuration behind a 6-port LSI Logic MegaRAID card.  I 
> have RedHat Enterprise Advanced Server 3 installed as the OS, 
> with ext3 filesystems on all partitions.
> 
> First I upgraded the kernel to version 2.4.21-20.ELsmp which 
> contained the recent megaraid2 driver (version 2.10.6).  This 
> did not help. I suspected possible bad RAM.  I ran memtest86 
> for over 100 hours without a single error being reported.
> 
> During the deletion of the some files, I ran across some errors like
> this: critical hardware error aborting-43441 cmd=2a <c=0 t=0 
> l=0> waiting for 24 commands to flush: iter: 30000
> 
> The RAID utility (megamgr) did not report any errors.  I 
> upgraded the RAID card's firmware to the latest version 
> (713G).  This did not have any affect.  The corruption takes 
> place whether I copy files between dirs on the same partition 
> or across different partitions.  The odd thing about the 
> corrupted files was that the copy had the exact same size as 
> the original, but a different md5 checksum.  Upon closer 
> inspection, I found that chunks of the copied file contained 
> null bytes.
> 
> This allowed the size to remain the same, but caused the 
> different checksum.  Some of the files were definitely 
> corrupted on the disk (ie - these null bytes were written to 
> the disk media) but others were not.  I used the "debugfs" 
> utility to walk through the filesystem directly. When I would 
> use this to dump the "corrupted" file, I often found that 
> this dumped copy matched the original file exactly.  This 
> means that the bits were written correctly to disk, but that 
> normal access to the file via tools like "cat" was returning 
> the wrong info Below are my original notes on the file 
> corruption problem.  I have done a few other tests since then 
> and wanted to pass on the results to you:
> 
> 1) Problem still occurs even when copying data between different 
> partitions in the RAID array.
> 
> 2) I tried remounting the ext3 filesystem as ext2.  Problem still 
> remained.
> 
> 3) Tried Disabling hyperthreading and nptl.  No effect.
> 
> 4) Disabled as much caching on the RAID card as I could.  No effect.
> 
> 5) Reformatted one of the partitions as jfs instead of ext3, and then 
> tried copying data to this newly formatted partition.  The 
> problem still occurred.
> 
> However, I found that if I unmounted the filesystem and then 
> remounted it, some of these files would now appear to be OK 
> (they matched the 
> originals).  But then others that had matched before would 
> now appear to be corrupt.
> 
> The megaserv.log file for the RAID card showed media errors 
> on port #2. I replaced that disk and then rebuilt the RAID 
> array.  This stopped the I/O errors, but another test showed 
> that the file corruption problem remained.
> 
> Troy
> 
> On Thu, 2004-12-09 at 09:14 -0500, Tom Coughlan wrote:
> > On Wed, 2004-12-08 at 21:17, Troy Klein wrote:
> > > I am attempting to find out why I am having data 
> corruption problems 
> > > on my megaraid2 driver and not on megaraid.  The system 
> is a 32-bit 
> > > Xeon with a LSI 150-6 SATA controller running Redhat EL 
> 3.0AS.  When 
> > > I am running megaraid I can write data, read data, and 
> modify data 
> > > and get NO corruption.  With megaraid2 I get data corruption with 
> > > tar, rsync, and scp.
> > 
> > Are there messages in /var/log/messages that correspond to the 
> > timeframe of the corruption?
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 



