From: Orion Poplawski <orion@colorado-research.com>
Subject: Exabyte tape device hangs writing large file - sym53c8xxx driver
Date: Tue, 15 Oct 2002 16:33:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210152233.g9FMXAr05642@earth.colorado-research.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: groudier@free.fr

I have a working Exabyte 8505 8mm tape drive that was put in a new Linux box 
with a Symbios dual channel 53c1010-33 SCSI adapter.  Three external disk 
drives sit on the first bus, and the tape drive is by itself on the internal 
(second) bus.  Each bus is properly terminated, the internal tape drive is 
connected via a 50-pin ribbon cable.  

I'm using a custom SMP kernel, version 2.4.19, under redhat 7.2.

When writing to the device with tar, it hangs when it reaches a large file 
(44MB in this case):  Also, the source is an NFS mounted directory.  I haven't
tried yet with a local directory.  Any help at all with this would be greatly 
appreciated.  We have a number of similar/identical tape drives in other linux
system with Adaptec drivers that appear to be working perfectly.

./OpenOffice.org1.0/core.24251
tar: /dev/st0: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now

/var/log/messages reports:

Oct 14 17:01:06 moli kernel: sym1:0:0: ABORT operation started.
Oct 14 17:01:11 moli kernel: sym1:0:0: ABORT operation timed-out.
Oct 14 17:01:11 moli kernel: sym1:0:0: DEVICE RESET operation started.
Oct 14 17:01:16 moli kernel: sym1:0:0: DEVICE RESET operation timed-out.
Oct 14 17:01:16 moli kernel: sym1:0:0: BUS RESET operation started.
Oct 14 17:01:16 moli kernel: sym1: SCSI BUS reset detected.
Oct 14 17:01:16 moli kernel: sym1: SCSI BUS has been reset.
Oct 14 17:01:16 moli kernel: sym1:0:0: BUS RESET operation complete.
Oct 14 17:01:52 moli kernel: sym1:0:0: ABORT operation started.
Oct 14 17:01:57 moli kernel: sym1:0:0: ABORT operation timed-out.
Oct 14 17:01:57 moli kernel: scsi: device set offline - not ready or command 
retry failed after bus reset: host 1 channel 0 id 0 lun 0
Oct 14 17:01:57 moli kernel: st0: Error with sense data: Current st09:00: 
sense key Not Ready
Oct 14 17:01:57 moli kernel: Additional sense indicates Logical unit is in 
process of becoming ready

Oct 14 17:16:57 moli kernel: sym1:0:0: ABORT operation started.
Oct 14 17:16:57 moli kernel: sym1: SCSI BUS reset detected.
Oct 14 17:16:57 moli kernel: sym1: SCSI BUS has been reset.
Oct 14 17:16:57 moli kernel: sym1:0:0: ABORT operation complete.
Oct 14 17:17:00 moli kernel: st0: Error with sense data: Current st09:00: 
sense key Not Ready
Oct 14 17:17:00 moli kernel: Additional sense indicates Medium not present
Oct 14 17:17:00 moli kernel: st0: Error on write filemark.
Oct 14 17:17:00 moli kernel: st0: Error with sense data: Current st09:00: 
sense key Not Ready
Oct 14 17:17:00 moli kernel: Additional sense indicates Medium not present

I was able to eject the tape, but subsequent attempts to access the device 
result in No such device errors:

# mt -f /dev/st0 status
/dev/st0: No such device or address

ver_linux reports:
Linux moli 2.4.19 #2 SMP Mon Oct 14 15:46:15 GMT 2002 i686 unknown

Gnu C                  2.96
Gnu make               3.79.1
binutils               2.11.90.0.8
util-linux             2.11f
mount                  2.11g
modutils               2.4.13
e2fsprogs              1.26
reiserfsprogs          3.x.0j
Linux C Library        2.2.4
Dynamic linker (ldd)   2.2.4
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.3.3
Sh-utils               2.0.11
Modules Loaded         binfmt_misc nfs nfsd lockd sunrpc autofs 3c59x 
ide-scsi ide-cd cdrom st ext3 jbd
sym53c8xx sd_mod scsi_mod
