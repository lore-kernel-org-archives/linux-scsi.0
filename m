From: "Andrey Dmitriev" <admitriev@mentora.com>
Subject: resizing LUN (not file system) while the file system (ext3) is online
Date: Thu, 25 May 2006 01:16:27 -0400
Message-ID: <043001c67fba$5ff05b70$6400a8c0@andreyT43>
Reply-To: <admitriev@mentora.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p78-65.acedsl.com ([66.114.78.65]:17863 "EHLO
	karlson.dmitriev.net") by vger.kernel.org with ESMTP
	id S965044AbWEYFRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 01:17:24 -0400
Received: from andreyT43 (IDENT:root@localhost [127.0.0.1])
	by karlson.dmitriev.net (8.11.0/8.11.0) with ESMTP id k4P5xFt24527
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 01:59:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear List,

Both EMC and NetApp claim that the file system needs to be unmounted while
the LUN is being resized (migrated and resized in our case). 

I understand that ext3 doesn't support online expansion (not in RedHat ES/AS
at least), however, does it really matter what you're doing to the actual
LUN in the background (as long as you're not reducing the LUN size)? The
operating system won't know the partitioning changed until you tell it to
reread the partition table. 

Not following EMC/NetApp 'overcautious' instructions could save a tremendous
amount of time during a LUN migration (instead of waiting for a LUN to
migrate while the file system is online, the only wait you really sustain is
how fast you type and re-partition)

I have just tried this with ext3 file system online, and it worked like I
expected it to work.

EMC specifically states in the emc122304 (from their knowledge base): 
" Step 3: Increase the size of the LUN using the backend array tools. In
some cases, like with CLARiiON MetaLUN, this can actually be performed
"online" in order to decrease the time that the file system is unavailable.
However, just because the disk array can be done online that does not mean
the application layer can handle online expansion (some file systems can
handle online expansion, currently ext3 cannot)."

Yeah, file system can't expand.. but I am resizing the file system offline,
why can't I resize the LUN online?

Am I missing something?

Below are my results.. I tried doing IO while migrating (and resizing) the
LUN, but I think IO seized before migration was complete. Also, the majority
of LUNs that usually need resizing are near capacity, mine obviously wasn't

B4 migration/growth

[root@ad-nfs1 kerberos]# df -k
/dev/emcpowerc1       20642412   5030932  14562908  26% /emc1

--after growth while the system was online

fdisk /dev/emcpowerc
Disk /dev/emcpowerc: 21.4 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes

         Device Boot      Start         End      Blocks   Id  System
/dev/emcpowerc1               1       20480    20971504   83  Linux

Command (m for help): q

[root@ad-nfs1 kerberos]# sfdisk -R /dev/emcpowerc
[root@ad-nfs1 kerberos]# fdisk /dev/emcpowerc

The number of cylinders for this disk is set to 30720.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): p

Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
64 heads, 32 sectors/track, 30720 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes

         Device Boot      Start         End      Blocks   Id  System
/dev/emcpowerc1               1       20480    20971504   83  Linux


[root@ad-nfs1 kerberos]# fdisk /dev/emcpowerc

The number of cylinders for this disk is set to 30720.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): p

Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
64 heads, 32 sectors/track, 30720 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes

         Device Boot      Start         End      Blocks   Id  System
/dev/emcpowerc1               1       20480    20971504   83  Linux

Command (m for help): d
Selected partition 1

Command (m for help): p

Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
64 heads, 32 sectors/track, 30720 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes

         Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
1
Invalid partition number for type `1'
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-30720, default 1):
Using default value 1
Last cylinder or +size or +sizeM or +sizeK (1-30720, default 30720):
Using default value 30720

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@ad-nfs1 kerberos]# fdisk -l /dev/emcpowerc

Disk /dev/emcpowerc: 32.2 GB, 32212254720 bytes
64 heads, 32 sectors/track, 30720 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes

         Device Boot      Start         End      Blocks   Id  System
/dev/emcpowerc1               1       30720    31457264   83  Linux


-- notice, w/o fsck it'll not resize.. w/o -f option

[root@ad-nfs1 kerberos]# time fsck -f /dev/emcpowerc1
fsck 1.35 (28-Feb-2004)
e2fsck 1.35 (28-Feb-2004)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/emcpowerc1: 254481/2621440 files (0.8% non-contiguous), 1410133/5242876
blocks

real    1m4.984s
user    0m1.348s
sys     0m1.617s
[root@ad-nfs1 kerberos]# resize2fs /dev/emcpowerc1
resize2fs 1.35 (28-Feb-2004)
Resizing the filesystem on /dev/emcpowerc1 to 7864316 (4k) blocks.
The filesystem on /dev/emcpowerc1 is now 7864316 blocks long.

[root@ad-nfs1 kerberos]# mount /dev/emcpowerc1 /emc1/
[root@ad-nfs1 kerberos]# df -k|grep emc
/dev/emcpowerc1       30963692   5311440  24393964  18% /emc1




