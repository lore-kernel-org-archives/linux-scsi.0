From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Sat, 27 Mar 2004 09:57:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c444p3$b3v$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:30923 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S261766AbUC0PAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 10:00:12 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1B7FIA-0006WQ-00
	for <linux-scsi@vger.kernel.org>; Sat, 27 Mar 2004 16:00:10 +0100
Received: from pcp04415756pcs.nrockv01.md.comcast.net ([69.140.191.214])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 27 Mar 2004 16:00:10 +0100
Received: from andrex by pcp04415756pcs.nrockv01.md.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 27 Mar 2004 16:00:10 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a Tekram DC395UW card, running in Debian with kernel 2.6.3 and the
dc395x driver from the kernel source.  Attached to the card are a Seagate
Travan NS20 tape drive, and an HP 9200i CD writer:

Mar 27 09:50:53 helium kernel: dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.04, 2003/05/19
Mar 27 09:50:53 helium kernel: dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x77
Mar 27 09:50:53 helium kernel: dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
Mar 27 09:50:53 helium kernel: dc395x: (Wide) Connectors: int50  Termination: Auto Low High
Mar 27 09:50:53 helium kernel: dc395x: Performing initial SCSI bus reset
Mar 27 09:50:53 helium kernel: scsi2 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.04, 2003/05/19
Mar 27 09:50:55 helium kernel: dc395x: Target 02:  Sync: 100ns Offset 15 (10.0 MB/s)
Mar 27 09:50:55 helium kernel:   Vendor: Seagate   Model: STT20000N         Rev: 7A61
Mar 27 09:50:55 helium kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Mar 27 09:50:55 helium scsi.agent[2072]: tape at /devices/pci0000:00/0000:00:1e.0/0000:02:04.0/host2/2:0:2:0
Mar 27 09:50:55 helium kernel: st: Version 20040122, fixed bufsize 32768, s/g segs 256
Mar 27 09:50:55 helium kernel: Attached scsi tape st0 at scsi2, channel 0, id 2, lun 0
Mar 27 09:50:55 helium kernel: st0: try direct i/o: yes, max page reachable by HBA 1048575
Mar 27 09:50:56 helium kernel: dc395x: Target 06:  Sync: 100ns Offset 15 (10.0 MB/s)
Mar 27 09:50:56 helium kernel:   Vendor: HP        Model: CD-Writer+ 9200   Rev: 1.0e
Mar 27 09:50:56 helium kernel:   Type:   CD-ROM                             ANSI SCSI revision: 04
Mar 27 09:50:56 helium scsi.agent[2085]: cdrom at /devices/pci0000:00/0000:00:1e.0/0000:02:04.0/host2/2:0:6:0
Mar 27 09:51:03 helium kernel: sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray

The tape drive works normally.  But as soon as I try to use the CD drive--
by, for example, trying to mount or burn a CD-- my console and syslog
begin to fill up with "dc395x: sg_to_virt failed!" messages-- several
hundred per second.  I can't unload the driver, and my system becomes
sluggish.  Once this starts I've often had to force a case reboot in order
to restore normal operation.  As you can imagine, I'm not happy about
that.

I'm frustrated by this problem because the drive worked fine with earlier
kernels.  It definitely worked fine with 2.6.0-test4 and -test9.  I don't
want to go back to an earlier kernel, because of other security and
hardware issues.  My 2.6.3 kernel works perfectly, except that now my CD
writer is broken.

Any help would be much appreciated.  I'm willing to try any patches or
diagnostics.

Thanks,
Andrew.


