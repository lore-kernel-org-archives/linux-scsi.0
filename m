From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: sym53c8xx_2 parity error on SuSE 9.1
Date: Tue, 17 Aug 2004 01:20:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3brha1xhx.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:49298 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268026AbUHPXUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 19:20:16 -0400
Received: from m2a2.dyndns.org (p5487C14D.dip.t-dialin.net [84.135.193.77])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 9124A39963
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 01:20:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by merlin.emma.line.org (Postfix) with ESMTP id 74317CD234
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 01:20:10 +0200 (CEST)
Received: from merlin.emma.line.org ([127.0.0.1])
 by localhost (m2a2.dyndns.org [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 04767-02-3 for <linux-scsi@vger.kernel.org>;
 Tue, 17 Aug 2004 01:20:10 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

On SuSE 9.1, I've seen annoying (as in wait one to two minutes before
machine becomes usable again) SCSI parity errors on two machines.

I have too few clues about the subsystems involved but I'll provide some
information that I hope will set the ball rolling.

Could someone translate the parity error (first line in syslog shown
below) to plain text please?

I'm willing to debug some more and have a serial console if that helps -
just send directions, I know C and GDB, patch and diff, I can compile
kernels and hack them a bit, but I'll just start with what information
I've found that might help:

Machines affected:

- Tekram DC-310U (SYM53C860) w/ Tandberg TDC3800 + Plextor PX-40TS
  (Asus P5A-B board)

- Tekram DC-390F (SYM53C875) w/ Tandberg TDC4222 (SLR4DC) + Tandberg
  SLR24 (SLR6) + Plextor PX-32TS + Fujitsu MAH3182MP
  (Asus A7V600-X board)

I've carried over a 2.6.7 kernel that was fine in SuSE 8.1 or 8.2 but
exhibits the problem in SuSE 9.1 - maybe sysfs related. The problem
persists in Linux 2.6.8.1.

I can reproduce the parity error with hwscan --scsi on SuSE, and the
parity error doesn't happen if I umount /sys. Don't know why.

Thanks in advance for any help.

strace of hwscan, with time:

4627  01:05:36.624621 open("/sys/devices/pci0000:00/0000:00:0d.0/host0/0:0:1:0/type", O_RDONLY) = 3
4627  01:05:36.624659 read(3, "0\n", 4096) = 2
4627  01:05:36.624686 close(3)          = 0
4627  01:05:36.624722 lstat64("/sys/devices/pci0000:00/0000:00:0d.0/host0/0:0:1:0/wwpn", 0xbfffe8ec) = -1 ENOENT (No such file or directory)
4627  01:05:36.624765 lstat64("/sys/devices/pci0000:00/0000:00:0d.0/host0/0:0:1:0/fcp_lun", 0xbfffe8ec) = -1 ENOENT (No such file or directory)
4627  01:05:36.624824 open("/dev/sda", O_RDONLY|O_NONBLOCK) = 3
4627  01:05:36.624888 ioctl(3, 0x301, 0xbfffeb20) = 0
4627  01:05:36.624944 ioctl(3, BLKSSZGET, 0xbfffeb1c) = 0
4627  01:05:36.624977 ioctl(3, 0x80041272, 0xbfffeb10) = 0
4627  01:05:36.625021 ioctl(3, FIBMAP, 0xbfffebc0) = 0
4627  01:07:26.617857 close(3)          = 0
4627  01:07:26.617930 lstat64("/sys/block/sr0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4627  01:07:26.618015 open("/sys/block/sr0", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
4627  01:07:26.618057 fstat64(3, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4627  01:07:26.618099 fcntl64(3, F_SETFD, FD_CLOEXEC) = 0
4627  01:07:26.618129 getdents(3, /* 9 entries */, 4096) = 164
4627  01:07:26.618183 lstat64("/sys/block/sr0/queue", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4627  01:07:26.618273 lstat64("/sys/block/sr0/device", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0

0000:00:0d.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
        Subsystem: Tekram Technology Co.,Ltd. DC390F Ultra Wide SCSI Controller
        Flags: bus master, medium devsel, latency 32, IRQ 16
        I/O ports at d000
        Memory at ec800000 (32-bit, non-prefetchable) [size=256]
        Memory at ec000000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 1

syslog:

Aug 17 00:57:00 merlin kernel: sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
Aug 17 00:57:04 merlin kernel: sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
Aug 17 00:57:34 merlin kernel: sym0:2:0: ABORT operation started.
Aug 17 00:57:39 merlin kernel: sym0:2:0: ABORT operation timed-out.
Aug 17 00:57:39 merlin kernel: sym0:1:0: ABORT operation started.
Aug 17 00:57:44 merlin kernel: sym0:1:0: ABORT operation timed-out.
Aug 17 00:57:44 merlin kernel: sym0:1:0: DEVICE RESET operation started.
Aug 17 00:57:44 merlin kernel: parport0: FIFO is stuck
Aug 17 00:57:44 merlin kernel: parport0: BUSY timeout (1) in compat_write_block_pio
Aug 17 00:57:49 merlin kernel: sym0:1:0: DEVICE RESET operation timed-out.
Aug 17 00:57:49 merlin kernel: sym0:2:0: DEVICE RESET operation started.
Aug 17 00:57:54 merlin kernel: sym0:2:0: DEVICE RESET operation timed-out.
Aug 17 00:57:54 merlin kernel: sym0:2:0: BUS RESET operation started.
Aug 17 00:57:54 merlin kernel: sym0: SCSI BUS reset detected.
Aug 17 00:57:54 merlin kernel: sym0: SCSI BUS has been reset.
Aug 17 00:57:54 merlin kernel: sym0:2:0: BUS RESET operation complete.
Aug 17 00:57:54 merlin kernel: DMA write timed out
Aug 17 00:58:04 merlin kernel: sym0:2:0: HOST RESET operation started.
Aug 17 00:58:04 merlin kernel: sym0: SCSI BUS has been reset.
Aug 17 00:58:04 merlin kernel: sym0:2:0: HOST RESET operation complete.
Aug 17 00:58:14 merlin kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 2 lun 0
Aug 17 00:58:14 merlin kernel: Device not ready.  Make sure there is a disc in the drive.
Aug 17 00:58:14 merlin kernel: scsi0 (2:0): rejecting I/O to offline device
Aug 17 00:58:14 merlin kernel: SCSI error: host 0 id 2 lun 0 return code = 4000000
Aug 17 00:58:14 merlin kernel:  Sense class 0, sense error 0, extended sense 0
Aug 17 00:58:14 merlin kernel: sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
Aug 17 00:58:14 merlin kernel: cdrom: open failed.

It's quite annoying that the machine blocks for well over a minute.  I
wonder why id 2 is offlined, the Plextor PX-32 is usually ready in well
under 10 s (and if it isn't because the CD is barely readable the drive
still shouldn't be disabled at first trespass... but that's a different
story and needn't be addressed here.)

-- 
Matthias Andree

NOTE YOU WILL NOT RECEIVE MY MAIL IF YOU'RE USING SPF!
Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
