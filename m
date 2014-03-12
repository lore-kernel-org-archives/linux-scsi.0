From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71981] New: Writing session to CD does not update some
 important cached information
Date: Wed, 12 Mar 2014 19:01:01 +0000
Message-ID: <bug-71981-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaCLTBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 15:01:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 16CAF202A7
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2014 19:01:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E36B92025B
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2014 19:01:01 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D71981

            Bug ID: 71981
           Summary: Writing session to CD does not update some importan=
t
                    cached information
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.13.5-101
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: worley@alum.mit.edu
        Regression: No

(This is based on the bug report
https://bugzilla.redhat.com/show_bug.cgi?id=3D918200)

When I repartition a disk, when I exit the partitioning tool, it has
some method of ordering the kernel to re-read the partition table.
Thus, after repartitioning, the partitions I've created/changed are
available for use.

But when I burn a CD, when the CD-burning tool is done, it does not
seem to be able to tell the kernel about the data track that now
exists.  (Or so the people at bugzilla.redhat.com say.)  To gain
access to the new track, the CD has to be ejected and reloaded.

It seems to me that this is a deficiency that shouldn't be too hard to
fix.
----------------------------------------------------------------------
Here is a detailed example of the problem:

# # Determine version information.
# uname -a
Linux hobgoblin.ariadne.com 3.13.5-101.fc19.x86_64 #1 SMP Tue Feb 25 21=
:25:32
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux # cat /etc/redhat-release
=46edora release 19 (Schr=C3=83=C2=B6dinger=C3=A2=E2=82=AC=E2=84=A2s Ca=
t)
# rpm -qa | grep cdr
libcdr-0.0.14-1.fc19.x86_64
cdrdao-1.2.3-19.fc19.x86_64
# # Verify that the file contains a valid ISO filesystem.
# mount -o loop ~worley/temp/time-warp-iso /mnt/temp
mount: /dev/loop0 is write-protected, mounting read-only
# ls /mnt/temp
COMMIT_EDITMSG    ORIG_HEAD  config~    index  objects           refs
=46ETCH_HEAD    branches   description    info   packed-refs
HEAD        config       hooks    logs   qgit_cache.dat
# umount /mnt/temp
# # Burn the filesystem onto a new CD-R.
# wodim dev=3D/dev/sr0 -multi speed=3D32 fs=3D32m -v -data ~worley/temp=
/time-warp-iso
wodim: No write mode specified.
wodim: Assuming -tao mode.
wodim: Future versions of wodim may have different drive dependent defa=
ults.
TOC Type: 1 =3D CD-ROM
scsidev: '/dev/sr0'
devname: '/dev/sr0'
scsibus: -2 target: -2 lun: -2
Linux sg driver version: 3.5.27
Wodim version: 1.1.11
SCSI buffer size: 64512
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   :=20
Vendor_info    : 'TSSTcorp'
Identification : 'DVD+-RW TS-U633A'
Revision       : 'D300'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
[...]
Track 01:  625 of  625 MB written (fifo 100%) [buf 100%]  25.2x.
Track 01: Total bytes read/written: 656142336/656142336 (320382 sectors=
).
Writing  time:  255.813s
Average write speed  17.1x.
Min drive buffer fill was 99%
=46ixating...
=46ixating time:   43.895s
BURN-Free was never needed.
wodim: fifo had 10335 puts and 10335 gets.
wodim: fifo was 0 times empty and 9573 times full, min fill was 97%.
# # Attempt to mount the CD-R immediately after burning it.
# mount /dev/sr0 /mnt/temp
mount: /dev/sr0 is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/sr0,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
# dmesg | tail
[99045.625479] i801_smbus 0000:00:1f.3: using default PCI settings
[99045.649439] dell_wmi: Received unknown WMI event (0x11)
[100784.941616] loop: module loaded
[100785.165164] ISO 9660 Extensions: Microsoft Joliet Level 3
[100785.222074] ISO 9660 Extensions: RRIP_1991A
[100785.222207] SELinux: initialized (dev loop0, type iso9660), uses
genfs_contexts
[100931.369609] fuse init (API version 7.22)
[100931.711371] SELinux: initialized (dev fuse, type fuse), uses genfs_=
contexts
[100932.052892] SELinux: initialized (dev fusectl, type fusectl), uses
genfs_contexts
[101215.067563] isofs_fill_super: bread failed, dev=3Dsr0, iso_blknum=3D=
16,
block=3D16
# # Eject and reload the CD-R and then try to mount it.
# eject /dev/sr0
# mount /dev/sr0 /mnt/temp
mount: /dev/sr0 is write-protected, mounting read-only
# ll /mnt/temp
total 2493
-r--r--r--. 1 root root      34 Mar  8 03:45 COMMIT_EDITMSG
-r--r--r--. 1 root root      87 May 27  2013 FETCH_HEAD
-r--r--r--. 1 root root      26 Jun 12  2013 HEAD
-r--r--r--. 1 root root      41 Mar  8 02:45 ORIG_HEAD
dr-xr-xr-x. 2 root root    2048 May 11  2013 branches
-r--r--r--. 1 root root     234 Mar  6 12:55 config
-r--r--r--. 1 root root     233 Feb 26 14:34 config~
-r--r--r--. 1 root root      73 May 11  2013 description
dr-xr-xr-x. 2 root root    2048 May 11  2013 hooks
-r--r--r--. 1 root root 2350328 Mar  8 02:45 index
dr-xr-xr-x. 2 root root    2048 Mar  8 02:54 info
dr-xr-xr-x. 3 root root    2048 May 22  2013 logs
dr-xr-xr-x. 4 root root    2048 Mar  8 02:54 objects
-r--r--r--. 1 root root     302 Mar  8 02:45 packed-refs
-r--r--r--. 1 root root  185477 Jul 31  2013 qgit_cache.dat
dr-xr-xr-x. 6 root root    2048 Nov 15 11:52 refs
#

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
