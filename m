From: Troy Klein <res1uo0c@verizon.net>
Subject: RE: Megaraid corruption?
Date: Thu, 09 Dec 2004 06:54:45 -0800
Message-ID: <1102604085.8512.17.camel@TroysLinux.verari.com>
References: <0E3FA95632D6D047BA649F95DAB60E57057A1AF3@exa-atlanta>
Reply-To: res1uo0c@verizon.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out004pub.verizon.net ([206.46.170.142]:40190 "EHLO
	out004.verizon.net") by vger.kernel.org with ESMTP id S261518AbULIOyr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 09:54:47 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57057A1AF3@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

description:

Recently during the migration of users to our two new servers, people 
started noticing that files were being corrupted. This happened on both 
servers (one of which also experienced a major filesystem corruption).
I removed the users from one server and have been using this as a
testbed to try and pinpoint the problem.

I was using "rsync" to transfer files, and thought this might be the
problem.  I upgraded the software, but the problem still occurred.  I
then used "tar" to try and copy a user's home dir to another dri on the
server.  
This had problems also, so that eliminated rsync as the cause.  I then 
used rsync to copy files locally on the same machine.  The corruption 
still occurred, so this eliminates the network itself as a source of 
errors.

Some Background:

My "test case" has been a user home dir with about 12GB of data.  I use 
"rsync" to copy the files, and then use "diff" to compare the two dirs
for differences.  The server has two Xeon 2.4 GHz processors, 4GB RAM,
and 3 Maxtor 250GB SATA disks in a RAID 5 configuration behind a 6-port
LSI Logic MegaRAID card.  I have RedHat Enterprise Advanced Server 3
installed as the OS, with ext3 filesystems on all partitions.

First I upgraded the kernel to version 2.4.21-20.ELsmp which contained
the recent megaraid2 driver (version 2.10.6).  This did not help. I
suspected possible bad RAM.  I ran memtest86 for over 100 hours without
a single error being reported.

During the deletion of the some files, I ran across some errors like
this: critical hardware error aborting-43441 cmd=2a <c=0 t=0 l=0>
waiting for 24 commands to flush: iter: 30000

The RAID utility (megamgr) did not report any errors.  I upgraded the
RAID card's firmware to the latest version (713G).  This did not have
any affect.  The corruption takes place whether I copy files between
dirs on the same partition or across different partitions.  The odd
thing about the corrupted files was that the copy had the exact same
size as the original, but a different md5 checksum.  Upon closer
inspection, I found that chunks of the copied file contained null bytes.

This allowed the size to remain the same, but caused the different
checksum.  Some of the files were definitely corrupted on the disk (ie -
these null bytes were written to the disk media) but others were not.  I
used the "debugfs" utility to walk through the filesystem directly.
When I would use this to dump the "corrupted" file, I often found that
this dumped copy matched the original file exactly.  This means that the
bits were written correctly to disk, but that normal access to the file
via tools like "cat" was returning the wrong info Below are my original
notes on the file corruption problem.  I have done a few other tests
since then and wanted to pass on the results to you:

1) Problem still occurs even when copying data between different 
partitions in the RAID array.

2) I tried remounting the ext3 filesystem as ext2.  Problem still 
remained.

3) Tried Disabling hyperthreading and nptl.  No effect.

4) Disabled as much caching on the RAID card as I could.  No effect.

5) Reformatted one of the partitions as jfs instead of ext3, and then 
tried copying data to this newly formatted partition.  The problem still
occurred.

However, I found that if I unmounted the filesystem and then remounted
it, some of these files would now appear to be OK (they matched the 
originals).  But then others that had matched before would now appear to
be corrupt.

The megaserv.log file for the RAID card showed media errors on port #2.
I replaced that disk and then rebuilt the RAID array.  This stopped the
I/O errors, but another test showed that the file corruption problem
remained.


On Thu, 2004-12-09 at 09:18 -0500, Mukker, Atul wrote:
> We would need more details before speculating for the cause. What kind of
> corruption is happening, mismatch data? How many bytes? Kernel messages when
> the corruption is seen?
> 
> Thanks
> -Atul Mukker 
> 
> > -----Original Message-----
> > From: Troy Klein [mailto:res1uo0c@verizon.net] 
> > Sent: Wednesday, December 08, 2004 9:18 PM
> > To: linux-scsi@vger.kernel.org
> > Subject: Megaraid corruption?
> > 
> > I am attempting to find out why I am having data corruption 
> > problems on my megaraid2 driver and not on megaraid.  The 
> > system is a 32-bit Xeon with a LSI 150-6 SATA controller 
> > running Redhat EL 3.0AS.  When I am running megaraid I can 
> > write data, read data, and modify data and get NO corruption. 
> >  With megaraid2 I get data corruption with tar, rsync, and scp.
> > 
> > Can anyone help?
> > 
> > Troy Perplexed
> > 
> > 
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-scsi" in the body of a message to 
> > majordomo@vger.kernel.org More majordomo info at  
> > http://vger.kernel.org/majordomo-info.html
> > 

