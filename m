From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153241] Kernel (unconditionally?) repeatedly attempts to issue
 SMART commands via ATA pass-through
Date: Thu, 22 Sep 2016 00:44:54 +0000
Message-ID: <bug-153241-11613-2F1iSmyIYR@https.bugzilla.kernel.org/>
References: <bug-153241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753341AbcIVApE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Sep 2016 20:45:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0602E2035D
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2016 00:44:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 764C5203FB
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2016 00:44:55 +0000 (UTC)
In-Reply-To: <bug-153241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153241

Arno Moeller <arno@d-tor.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |arno@d-tor.org

--- Comment #1 from Arno Moeller <arno@d-tor.org> ---

I'm seeing this too on an USB-Disk (/dev/sdj) every 10 minutes:

Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x07 driverbyte=0x08
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 Sense Key : 0x4
[current] [descriptor] 
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 ASC=0x0 ASCQ=0x0 
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 CDB: opcode=0x85 85 06
20 00 00 00 00 00 00 00 00 00 00 00 e5 00
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x07 driverbyte=0x08
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 Sense Key : 0x4
[current] [descriptor] 
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 ASC=0x0 ASCQ=0x0 
Sep 22 01:47:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 CDB: opcode=0xa1 a1 06
20 da 00 00 4f c2 00 b0 00 00
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x07 driverbyte=0x08
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 Sense Key : 0x4
[current] [descriptor] 
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 ASC=0x0 ASCQ=0x0 
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 CDB: opcode=0x85 85 06
20 00 00 00 00 00 00 00 00 00 00 00 e5 00
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x07 driverbyte=0x08
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 Sense Key : 0x4
[current] [descriptor] 
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 ASC=0x0 ASCQ=0x0 
Sep 22 01:57:05 hadante kernel: sd 7:0:0:0: [sdj] tag#0 CDB: opcode=0xa1 a1 06
20 da 00 00 4f c2 00 b0 00 00
[...]

I *think* this is caused by udisks2 v2.1.7 (source:
https://udisks.freedesktop.org/releases/).

It's doing this in src/udiskslinuxdrive.c (line 1212ff.):
  io_v4.guard = 'Q';
  io_v4.protocol = BSG_PROTOCOL_SCSI;
  io_v4.subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD;
  io_v4.request_len = cdb_len;
  io_v4.request = (uintptr_t) cdb;
  io_v4.max_response_len = sizeof (sense);
  io_v4.response = (uintptr_t) sense;
  io_v4.timeout = timeout_msec;

  rc = ioctl (fd, SG_IO, &io_v4);
  if (rc != 0)
    {
      /* could be that the driver doesn't do version 4, try version 3 */
      if (errno == EINVAL)
        {
          struct sg_io_hdr io_hdr;
          memset (&io_hdr, 0, sizeof (struct sg_io_hdr));
          io_hdr.interface_id = 'S';
          io_hdr.cmdp = (unsigned char*) cdb;
          io_hdr.cmd_len = cdb_len;
          io_hdr.dxfer_direction = SG_DXFER_NONE;
          io_hdr.sbp = sense;
          io_hdr.mx_sb_len = sizeof (sense);
          io_hdr.timeout = timeout_msec;

stracing udisksd gives:

[pid 27993] open("/dev/sdj", O_RDONLY|O_NONBLOCK) = 16
[pid 27993] ioctl(16, SG_IO, {'Q', BSG_PROTOCOL_SCSI,
BSG_SUB_PROTOCOL_SCSI_CMD, request[16]=[85, 06, 20, 00, 00, 00, 00, 00, 00, 00,
00, 00, 00, 00, e5, 00], request_tag=0, request_attr=0, request_priority=0,
request_extra=0, max_response_len=32, dout_iovec_count=0, dout_xfer_len=0,
din_iovec_count=0, din_xfer_len=0, timeout=5000, flags=0, usr_ptr=0,
spare_in=0, dout[0]=NULL}) = -1 EINVAL (Invalid argument)
^^^^ this is the culprit???
[pid 27993] ioctl(16, SG_IO, {'S', SG_DXFER_NONE, cmd[16]=[85, 06, 20, 00, 00,
00, 00, 00, 00, 00, 00, 00, 00, 00, e5, 00], mx_sb_len=32, iovec_count=0,
dxfer_len=0, timeout=5000, flags=0, status=00, masked_status=00, sb[22]=[72,
04, 00, 00, 00, 00, 00, 0e, 09, 0c, 00, 00, 00, ff, 00, 00, 00, 00, 00, 00, 00,
50], host_status=0x7, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
[pid 27993] close(16)

It's really annoying and spamming the kernel log. At first I thought the drive
is defective, because google told me that Sense Key 0x4 is a Hardware Error
(http://www.t10.org/lists/2sensekey.htm), but since the drive is working fine,
I dug deeper...

Further information:

# smartctl -a /dev/sdj
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.7.2-1-ARCH] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Green
Device Model:     WDC WD20EZRX-00D8PB0
Serial Number:    WD-WMC4M1418198
LU WWN Device Id: 5 0014ee 603ddaee2
Firmware Version: 80.00A80
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical                        
Rotation Rate:    5400 rpm                                                      
Device is:        In smartctl database [for details use: -P show]               
ATA Version is:   ACS-2 (minor revision not indicated)                          
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)                        
Local Time is:    Thu Sep 22 02:21:33 2016 CEST                                 
SMART support is: Available - device has SMART capability.                      
SMART support is: Enabled
...

# uname -a
Linux hadante 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016 x86_64
GNU/Linux

kernel config:
https://git.archlinux.org/svntogit/packages.git/tree/trunk/config?h=packages/linux

-- 
You are receiving this mail because:
You are the assignee for the bug.
