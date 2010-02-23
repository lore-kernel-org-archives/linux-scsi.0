From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15378] New: If packet writing is enabled it causes I/O errors.
Date: Tue, 23 Feb 2010 14:34:06 GMT
Message-ID: <bug-15378-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48302 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0BWOeH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 09:34:07 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1NEY6uB029293
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 14:34:06 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15378

               URL: ssenuta@dialup.cc
           Summary: If packet writing is enabled it causes I/O errors.
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32.8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: ssenuta@dialup.cc
                CC: ssenuta@dialup.cc
        Regression: No


When packet writing is enabled it conflicts with normal cdrom drive operations
on a "shared" device. A work around for this problem is to just dis-associate
my shared /dev/sr0 drive from /dev/pktcdvd/pktcdvd0 with one of the following
commands

    pktsetup -d 0
    /etc/rc.d/init.d/pktcdvd stop     ,..Mandriva script 

I first noticed the problem when I discovered I couldn't play back some
commercial movie dvds When packet writing was enabled. Running lsdvd on the
problem dvd disc, indicates that the disc could not be read. 

lsdvd -x /dev/sr0
    libdvdread: Using libdvdcss version 1.2.10 for DVD access
    libdvdread: Can't seek to block 3591534
    libdvdread: Can't seek to block 3591534
    libdvdread: Invalid IFO for title 2 (VTS_02_0.IFO).

Yesterday, while testing a rescue initramfs in (init s) single user mode, I had
problems reading a regular (iso9660) cdrom because packet writing was enabled
at boot. When I mounted the iso9660 filesystem, I got the following I/O errors:

mount -t auto /dev/sr0 /mnt/misc:
     SR 1:0:0:0: [sr0] Result: Hostbyte=DD_OK Driverbyte=Driver_Sense
                       Sense Key: Illegle Request [current]
                       ADD.Sense: Logical Block Address Out of Range
                       CDB: Read (10): 28 00 00 04 81 20 00 00 02 00
     End:Request: I/O ERROR, Dev sr0, sector 1180800
     Buffer I/O Error on Device sr0 Logical Block 295200
     Buffer I/O Error on Device sr0 Logical Block 295201

I both cases "disabling" packet write allowed my Asus Sata cd-combo drive to
operate normally.

This is a list of all modules loaded for my "non-udev" initramfs.
Things work well but having packet write enabled causes I/O errors
when using the common cd-combo drive for regular (non packet) use.

Module                  Size  Used by
sg                     18616  0 
isofs                  23985  0 
pktcdvd                19524  0 
sr_mod                  9994  0 
cdrom                  24775  2 pktcdvd,sr_mod
usb_storage            29209  0 
uhci_hcd               15455  0 
ohci_hcd               16452  0 
ehci_hcd               26139  0 
usbhid                 17965  0 
nls_iso8859_1           2925  0 
nls_cp437               4453  0 
nls_cp850               3685  0 
vfat                    6754  0 
msdos                   4850  0 
fat                    35867  2 vfat,msdos

Aside from I/O Errors, there is also a problem ejecting a problem iso9660 disc.
but again disabling packet write is the work-around. It can be unmounted but
you can't open the cd tray. 

I don't think these problems are specific to only kernel-2.6.32.8 as I noticed
similar problem with other kernels. 

I hope there is a better solution than my work-around or installing two
cd-drives. Thank you

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
