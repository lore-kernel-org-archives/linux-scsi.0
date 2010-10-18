From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20712] New: mpt2sas and SATA drives
Date: Mon, 18 Oct 2010 19:37:55 GMT
Message-ID: <bug-20712-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:33657 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab0JRThz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2010 15:37:55 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9IJbt3B021396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2010 19:37:55 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20712

           Summary: mpt2sas and SATA drives
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.34.7-56.fc13.x86_64
          Platform: All
        OS/Version: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: zeuthen@gmail.com
        Regression: No


Occasionally /lib/udev/ata_id fails with EINVAL (see details below) and this
causes missing symlinks in the /dev/disk/ hierarchies. Surely this is a problem
with the driver right - e.g. ata_id is not supposed to retry.

For reference ata_id is located here


http://git.kernel.org/?p=linux/hotplug/udev.git;a=blob;f=extras/ata_id/ata_id.c;h=bf1debe028e97228e09d4bd5bfdd280bb32099f3;hb=HEAD

I'm seeing this with the mpt2sas driver in Fedora 13's 2.6.34.7-56.fc13.x86_64
mpt2sas driver. Details here:

Here's the script I use to reproduce it

 # cat hammer-ata.sh
 #!/bin/bash

 set -e

 ATA_ID=/lib/udev/ata_id

 while true ; do
     echo "----------------------------------------------------------------"
     strace -o /tmp/ata_id_out.txt $ATA_ID --export /dev/sdp
     sleep 0.1
 done

When /lib/udev/ata_id fails, the strace is

 execve("/lib/udev/ata_id", ["/lib/udev/ata_id", "--export", "/dev/sdp"], [/*
19 vars */]) = 0
 brk(0)                                  = 0x1cd9000
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f83e02e7000
 access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
 open("/etc/ld.so.cache", O_RDONLY)      = 3
 fstat(3, {st_mode=S_IFREG|0644, st_size=70476, ...}) = 0
 mmap(NULL, 70476, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f83e02d5000
 close(3)                                = 0
 open("/lib64/libc.so.6", O_RDONLY)      = 3
 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\355a\3637\0\0\0"...,
832) = 832
 fstat(3, {st_mode=S_IFREG|0755, st_size=1838304, ...}) = 0
 mmap(0x37f3600000, 3664040, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x37f3600000
 mprotect(0x37f3775000, 2097152, PROT_NONE) = 0
 mmap(0x37f3975000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x175000) = 0x37f3975000
 mmap(0x37f397a000, 18600, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x37f397a000
 close(3)                                = 0
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f83e02d4000
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f83e02d3000
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f83e02d2000
 arch_prctl(ARCH_SET_FS, 0x7f83e02d3700) = 0
 mprotect(0x37f3975000, 16384, PROT_READ) = 0
 mprotect(0x37f341e000, 4096, PROT_READ) = 0
 munmap(0x7f83e02d5000, 70476)           = 0
 brk(0)                                  = 0x1cd9000
 brk(0x1cfa000)                          = 0x1cfa000
 open("/etc/udev/udev.conf", O_RDONLY)   = 3
 fstat(3, {st_mode=S_IFREG|0644, st_size=218, ...}) = 0
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f83e02e6000
 read(3, "# The initial syslog(3) priority"..., 4096) = 218
 read(3, "", 4096)                       = 0
 close(3)                                = 0
 munmap(0x7f83e02e6000, 4096)            = 0
 open("/dev/sdp", O_RDONLY|O_NONBLOCK)   = 3
 fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 240), ...}) = 0
 ioctl(3, CDROM_GET_CAPABILITY, 0)       = -1 EINVAL (Invalid argument)
 ioctl(3, BLKGETSIZE64, 0x7fffe8b83e38)  = 0
 ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[12]=[a1, 08, 2e, 00, 01, 00, 00,
00, 00, ec, 00, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=2000,
flags=0, data[512]=["zB\377?7\310\20\0\0\0\0\0?\0\0\0\0\0\0\0    W -DCWWA"...],
status=00, masked_status=00, sb[0]=[], host_status=0x8, driver_status=0,
resid=0, duration=1122, info=0x1}) = 0
 ioctl(3, 0x30d, 0x7fffe8b84040)         = -1 EINVAL (Invalid argument)
 open("/etc/localtime", O_RDONLY)        = 4
 fstat(4, {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
 fstat(4, {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7f83e02e6000
 read(4, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\4\0\0\0\0"...,
4096) = 3519
 lseek(4, -2252, SEEK_CUR)               = 1267
 read(4, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\5\0\0\0\5\0\0\0\0"...,
4096) = 2252
 close(4)                                = 0
 munmap(0x7f83e02e6000, 4096)            = 0
 getpid()                                = 8026
 socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 4
 connect(4, {sa_family=AF_FILE, path="/dev/log"}, 110) = 0
 sendto(4, "<27>Oct 18 15:25:55 ata_id[8026]"..., 74, MSG_NOSIGNAL, NULL, 0) =
74
 close(3)                                = 0
 close(4)                                = 0
 exit_group(3) 

strace from a "healthy" run of ata_id is:

 # strace -o ata_id_out_works.txt /lib/udev/ata_id --export /dev/sdp 
 ID_ATA=1
 ID_TYPE=disk
 ID_BUS=ata
 ID_MODEL=WDC_WD1002FAEX-00Y9A0

ID_MODEL_ENC=WDC\x20WD1002FAEX-00Y9A0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
 ID_REVISION=01.01V10
 ID_SERIAL=WDC_WD1002FAEX-00Y9A0_WD-WCAW30039741
 ID_SERIAL_SHORT=WD-WCAW30039741
 ID_ATA_WRITE_CACHE=1
 ID_ATA_WRITE_CACHE_ENABLED=1
 ID_ATA_FEATURE_SET_HPA=1
 ID_ATA_FEATURE_SET_HPA_ENABLED=1
 ID_ATA_FEATURE_SET_PM=1
 ID_ATA_FEATURE_SET_PM_ENABLED=1
 ID_ATA_FEATURE_SET_SECURITY=1
 ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
 ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=162
 ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=162
 ID_ATA_FEATURE_SET_SMART=1
 ID_ATA_FEATURE_SET_SMART_ENABLED=1
 ID_ATA_FEATURE_SET_AAM=1
 ID_ATA_FEATURE_SET_AAM_ENABLED=0
 ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
 ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
 ID_ATA_FEATURE_SET_PUIS=1
 ID_ATA_FEATURE_SET_PUIS_ENABLED=0
 ID_ATA_DOWNLOAD_MICROCODE=1
 ID_ATA_SATA=1
 ID_ATA_SATA_SIGNAL_RATE_GEN2=1
 ID_ATA_SATA_SIGNAL_RATE_GEN1=1
 ID_WWN=0x50014ee2af4e8611
 ID_WWN_WITH_EXTENSION=0x50014ee2af4e8611

 execve("/lib/udev/ata_id", ["/lib/udev/ata_id", "--export", "/dev/sdp"], [/*
20 vars */]) = 0
 brk(0)                                  = 0x1120000
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7ff7ae236000
 access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
 open("/etc/ld.so.cache", O_RDONLY)      = 3
 fstat(3, {st_mode=S_IFREG|0644, st_size=70476, ...}) = 0
 mmap(NULL, 70476, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ff7ae224000
 close(3)                                = 0
 open("/lib64/libc.so.6", O_RDONLY)      = 3
 read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\355a\3637\0\0\0"...,
832) = 832
 fstat(3, {st_mode=S_IFREG|0755, st_size=1838304, ...}) = 0
 mmap(0x37f3600000, 3664040, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x37f3600000
 mprotect(0x37f3775000, 2097152, PROT_NONE) = 0
 mmap(0x37f3975000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x175000) = 0x37f3975000
 mmap(0x37f397a000, 18600, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x37f397a000
 close(3)                                = 0
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7ff7ae223000
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7ff7ae222000
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7ff7ae221000
 arch_prctl(ARCH_SET_FS, 0x7ff7ae222700) = 0
 mprotect(0x37f3975000, 16384, PROT_READ) = 0
 mprotect(0x37f341e000, 4096, PROT_READ) = 0
 munmap(0x7ff7ae224000, 70476)           = 0
 brk(0)                                  = 0x1120000
 brk(0x1141000)                          = 0x1141000
 open("/etc/udev/udev.conf", O_RDONLY)   = 3
 fstat(3, {st_mode=S_IFREG|0644, st_size=218, ...}) = 0
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7ff7ae235000
 read(3, "# The initial syslog(3) priority"..., 4096) = 218
 read(3, "", 4096)                       = 0
 close(3)                                = 0
 munmap(0x7ff7ae235000, 4096)            = 0
 open("/dev/sdp", O_RDONLY|O_NONBLOCK)   = 3
 fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 240), ...}) = 0
 ioctl(3, CDROM_GET_CAPABILITY, 0)       = -1 EINVAL (Invalid argument)
 ioctl(3, BLKGETSIZE64, 0x7fff1f8306f8)  = 0
 ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[12]=[a1, 08, 2e, 00, 01, 00, 00,
00, 00, ec, 00, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=2000,
flags=0, data[512]=["zB\377?7\310\20\0\0\0\0\0?\0\0\0\0\0\0\0    W -DCWWA"...],
status=02, masked_status=01, sb[22]=[72, 01, 00, 1d, 00, 00, 00, 0e, 09, 0c,
00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], host_status=0,
driver_status=0x8, resid=0, duration=248, info=0x1}) = 0
 fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7ff7ae235000
 write(1, "ID_ATA=1\n", 9)               = 9
 write(1, "ID_TYPE=disk\n", 13)          = 13
 write(1, "ID_BUS=ata\n", 11)            = 11
 write(1, "ID_MODEL=WDC_WD1002FAEX-00Y9A0\n", 31) = 31
 write(1, "ID_MODEL_ENC=WDC\\x20WD1002FAEX-0"..., 114) = 114
 write(1, "ID_REVISION=01.01V10\n", 21)  = 21
 write(1, "ID_SERIAL=WDC_WD1002FAEX-00Y9A0_"..., 48) = 48
 write(1, "ID_SERIAL_SHORT=WD-WCAW30039741\n", 32) = 32
 write(1, "ID_ATA_WRITE_CACHE=1\n", 21)  = 21
 write(1, "ID_ATA_WRITE_CACHE_ENABLED=1\n", 29) = 29
 write(1, "ID_ATA_FEATURE_SET_HPA=1\n", 25) = 25
 write(1, "ID_ATA_FEATURE_SET_HPA_ENABLED=1"..., 33) = 33
 write(1, "ID_ATA_FEATURE_SET_PM=1\n", 24) = 24
 write(1, "ID_ATA_FEATURE_SET_PM_ENABLED=1\n", 32) = 32
 write(1, "ID_ATA_FEATURE_SET_SECURITY=1\n", 30) = 30
 write(1, "ID_ATA_FEATURE_SET_SECURITY_ENAB"..., 38) = 38
 write(1, "ID_ATA_FEATURE_SET_SECURITY_ERAS"..., 47) = 47
 write(1, "ID_ATA_FEATURE_SET_SECURITY_ENHA"..., 56) = 56
 write(1, "ID_ATA_FEATURE_SET_SMART=1\n", 27) = 27
 write(1, "ID_ATA_FEATURE_SET_SMART_ENABLED"..., 35) = 35
 write(1, "ID_ATA_FEATURE_SET_AAM=1\n", 25) = 25
 write(1, "ID_ATA_FEATURE_SET_AAM_ENABLED=0"..., 33) = 33
 write(1, "ID_ATA_FEATURE_SET_AAM_VENDOR_RE"..., 52) = 52
 write(1, "ID_ATA_FEATURE_SET_AAM_CURRENT_V"..., 41) = 41
 write(1, "ID_ATA_FEATURE_SET_PUIS=1\n", 26) = 26
 write(1, "ID_ATA_FEATURE_SET_PUIS_ENABLED="..., 34) = 34
 write(1, "ID_ATA_DOWNLOAD_MICROCODE=1\n", 28) = 28
 write(1, "ID_ATA_SATA=1\n", 14)         = 14
 write(1, "ID_ATA_SATA_SIGNAL_RATE_GEN2=1\n", 31) = 31
 write(1, "ID_ATA_SATA_SIGNAL_RATE_GEN1=1\n", 31) = 31
 write(1, "ID_WWN=0x50014ee2af4e8611\n", 26) = 26
 write(1, "ID_WWN_WITH_EXTENSION=0x50014ee2"..., 41) = 41
 close(3)                                = 0
 exit_group(0)                           = ?

The kernel messages when seeing the failure is:

 Oct 18 15:25:54 rhea kernel: DRHD: handling fault status reg 502
 Oct 18 15:25:54 rhea kernel: DMAR:[DMA Read] Request device [0a:00.0] fault
addr 2e0000 
 Oct 18 15:25:54 rhea kernel: DMAR:[fault reason 06] PTE Read access is not set
 Oct 18 15:25:54 rhea kernel: mpt2sas0: fault_state(0x2665)!
 Oct 18 15:25:54 rhea kernel: mpt2sas0: sending diag reset !!
 Oct 18 15:25:55 rhea kernel: mpt2sas0: diag reset: SUCCESS
 Oct 18 15:25:55 rhea ata_id[8026]: HDIO_GET_IDENTITY failed for '/dev/sdp'
 Oct 18 15:25:55 rhea kernel: mpt2sas0: LSISAS2116: FWVersion(03.00.00.00),
ChipRevision(0x01), BiosVersion(07.01.00.00)
 Oct 18 15:25:55 rhea kernel: mpt2sas0: Protocol=(Initiator,Target),
Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
 Oct 18 15:25:55 rhea kernel: mpt2sas0: sending port enable !!
 Oct 18 15:26:04 rhea kernel: mpt2sas0: port enable: SUCCESS
 Oct 18 15:26:04 rhea kernel: mpt2sas0: _scsih_search_responding_sas_devices
 Oct 18 15:26:04 rhea kernel: scsi target0:0:0: handle(0x0012),
sas_addr(0x5000c50023bfb29a), enclosure logical id(0x5000155350e0133f), slot(0)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:1: handle(0x0013),
sas_addr(0x5000c50023c075d6), enclosure logical id(0x5000155350e0133f), slot(1)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:2: handle(0x0014),
sas_addr(0x5000c50023bad29e), enclosure logical id(0x5000155350e0133f), slot(2)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:3: handle(0x0015),
sas_addr(0x5000c50023c08492), enclosure logical id(0x5000155350e0133f), slot(3)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:4: handle(0x0016),
sas_addr(0x5000c50023bdbb7a), enclosure logical id(0x5000155350e0133f), slot(4)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:5: handle(0x0017),
sas_addr(0x5000c50023be7d72), enclosure logical id(0x5000155350e0133f), slot(5)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:6: handle(0x0018),
sas_addr(0x5000c50023bf9fbe), enclosure logical id(0x5000155350e0133f), slot(6)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:7: handle(0x0019),
sas_addr(0x5000c50023c1118e), enclosure logical id(0x5000155350e0133f), slot(7)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:8: handle(0x001a),
sas_addr(0x5000c50023bd83e6), enclosure logical id(0x5000155350e0133f), slot(8)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:9: handle(0x001b),
sas_addr(0x5000c50023bcdb6a), enclosure logical id(0x5000155350e0133f), slot(9)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:10: handle(0x001c),
sas_addr(0x5000c50023bddd9a), enclosure logical id(0x5000155350e0133f),
slot(10)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:11: handle(0x001d),
sas_addr(0x5000c50023c0c4f2), enclosure logical id(0x5000155350e0133f),
slot(11)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:12: handle(0x001e),
sas_addr(0x5000155350e0133e), enclosure logical id(0x5000155350e0133f),
slot(24)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:30: handle(0x0021),
sas_addr(0x5000c50023bfb299), enclosure logical id(0x5000155350e0123f), slot(0)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0029)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:13: handle(0x0022),
sas_addr(0x500015560011d200), enclosure logical id(0x500015560011d23f), slot(0)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0021)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:14: handle(0x0023),
sas_addr(0x500015560011d201), enclosure logical id(0x500015560011d23f), slot(1)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0022)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:15: handle(0x0024),
sas_addr(0x500015560011d202), enclosure logical id(0x500015560011d23f), slot(2)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0023)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:16: handle(0x0025),
sas_addr(0x500015560011d203), enclosure logical id(0x500015560011d23f), slot(3)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0024)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:17: handle(0x0026),
sas_addr(0x500015560011d204), enclosure logical id(0x500015560011d23f), slot(4)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0025)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:18: handle(0x0027),
sas_addr(0x500015560011d205), enclosure logical id(0x500015560011d23f), slot(5)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0026)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:19: handle(0x0028),
sas_addr(0x500015560011d206), enclosure logical id(0x500015560011d23f), slot(6)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0027)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:20: handle(0x0029),
sas_addr(0x500015560011d207), enclosure logical id(0x500015560011d23f), slot(7)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0028)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:31: handle(0x002a),
sas_addr(0x5000c50023c075d5), enclosure logical id(0x5000155350e0123f), slot(1)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0032)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:21: handle(0x002b),
sas_addr(0x500015560011d208), enclosure logical id(0x500015560011d23f), slot(8)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x002a)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:22: handle(0x002c),
sas_addr(0x500015560011d209), enclosure logical id(0x500015560011d23f), slot(9)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x002b)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:23: handle(0x002d),
sas_addr(0x500015560011d20a), enclosure logical id(0x500015560011d23f),
slot(10)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x002c)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:24: handle(0x002e),
sas_addr(0x500015560011d20b), enclosure logical id(0x500015560011d23f),
slot(11)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x002d)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:25: handle(0x002f),
sas_addr(0x500015560011d20c), enclosure logical id(0x500015560011d23f),
slot(12)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x002e)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:26: handle(0x0030),
sas_addr(0x500015560011d20d), enclosure logical id(0x500015560011d23f),
slot(13)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x002f)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:27: handle(0x0031),
sas_addr(0x500015560011d20e), enclosure logical id(0x500015560011d23f),
slot(14)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0030)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:28: handle(0x0032),
sas_addr(0x500015560011d20f), enclosure logical id(0x500015560011d23f),
slot(15)
 Oct 18 15:26:04 rhea kernel:     handle changed from(0x0031)!!!
 Oct 18 15:26:04 rhea kernel: scsi target0:0:32: handle(0x0033),
sas_addr(0x5000c50023bad29d), enclosure logical id(0x5000155350e0123f), slot(2)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:33: handle(0x0034),
sas_addr(0x5000c50023c08491), enclosure logical id(0x5000155350e0123f), slot(3)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:29: handle(0x0035),
sas_addr(0x500015560011d23e), enclosure logical id(0x500015560011d23f),
slot(36)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:34: handle(0x0036),
sas_addr(0x5000c50023bdbb79), enclosure logical id(0x5000155350e0123f), slot(4)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:35: handle(0x0037),
sas_addr(0x5000c50023be7d71), enclosure logical id(0x5000155350e0123f), slot(5)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:36: handle(0x0038),
sas_addr(0x5000c50023bf9fbd), enclosure logical id(0x5000155350e0123f), slot(6)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:37: handle(0x0039),
sas_addr(0x5000c50023c1118d), enclosure logical id(0x5000155350e0123f), slot(7)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:38: handle(0x003a),
sas_addr(0x5000c50023bd83e5), enclosure logical id(0x5000155350e0123f), slot(8)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:39: handle(0x003b),
sas_addr(0x5000c50023bcdb69), enclosure logical id(0x5000155350e0123f), slot(9)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:40: handle(0x003c),
sas_addr(0x5000c50023bddd99), enclosure logical id(0x5000155350e0123f),
slot(10)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:41: handle(0x003d),
sas_addr(0x5000c50023c0c4f1), enclosure logical id(0x5000155350e0123f),
slot(11)
 Oct 18 15:26:04 rhea kernel: scsi target0:0:42: handle(0x003e),
sas_addr(0x5000155350e0123e), enclosure logical id(0x5000155350e0123f),
slot(24)
 Oct 18 15:26:04 rhea kernel: mpt2sas0: _scsih_search_responding_raid_devices
 Oct 18 15:26:04 rhea kernel: mpt2sas0: _scsih_search_responding_expanders
 Oct 18 15:26:04 rhea kernel:     expander present: handle(0x0011),
sas_addr(0x5000155350e0133f)
 Oct 18 15:26:04 rhea kernel:     expander present: handle(0x001f),
sas_addr(0x5000155350e0123f)
 Oct 18 15:26:04 rhea kernel:     expander present: handle(0x0020),
sas_addr(0x500015560011d23f)
 Oct 18 15:26:04 rhea kernel: mpt2sas0: _base_fault_reset_work: hard reset:
success

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
