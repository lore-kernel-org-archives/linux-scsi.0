From: lego_12239@rambler.ru
Subject: mptscsih dmesg messages
Date: Thu, 16 Apr 2009 08:20:20 +0400
Message-ID: <20090416042020.GA2894@debian>
Reply-To: lego_12239@rambler.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailc.rambler.ru ([81.19.66.27]:3531 "EHLO mailc.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZDPEU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2009 00:20:26 -0400
Received: from localhost (unknown [89.178.148.62])
	(Authenticated sender: lego_12239@rambler.ru)
	by mailc.rambler.ru (Postfix) with ESMTP id 3F509621C57
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 08:20:24 +0400 (MSD)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  Hi, again.

  Sorry, I forgot to write next additional info in the previous mail.

~$ cat /proc/mpt/summary 
ioc0: LSISAS1064E B1, FwRev=01100000h, Ports=1, MaxQ=511, IRQ=277

~$ cat /proc/mpt/version 
mptlinux-3.04.07
  Fusion MPT base driver
  Fusion MPT SAS host driver

~$ cat /sys/class/scsi_host/host8/version_fw 
01.16.00.00

~$ cat /sys/class/scsi_host/host8/version_bios 
06.10.00.00

  I have Debian 4.0r4a installation on a server with SAS1064E built-in 
controller:

~$ lspci | grep LSI
04:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)

Vanilla kernel with aufs2-base5 patch:

~$ uname -a
Linux ftp 2.6.28.7-aufs #10 Fri Mar 6 19:34:56 UTC 2009 i686 GNU/Linux

There are six sata hard disks connected through SAS HDD Hub box to the 
controller on the motherboard by two sata cables. Everything work all right, 
but dmesg shows many annoying lines like this:

[ 1876.212880] mptscsih: ioc0: attempting task abort! (sc=f6ff1c80)
[ 1876.212953] sd 8:0:5:0: [sdh] CDB: Write(10): 2a 00 17 42 ee 0f 00 04 00 00
[ 1876.213635] mptscsih: ioc0: task abort: SUCCESS (sc=f6ff1c80)
[ 1876.213973] mptscsih: ioc0: attempting task abort! (sc=d1fc18c0)
[ 1876.214046] sd 8:0:5:0: [sdh] CDB: Read(10): 28 00 17 10 c0 3f 00 00 08 00
[ 1876.214727] mptscsih: ioc0: task abort: SUCCESS (sc=d1fc18c0)
[ 1876.215081] mptscsih: ioc0: attempting target reset! (sc=d1fc1ec0)
[ 1876.215154] sd 8:0:5:0: [sdh] CDB: Write(10): 2a 00 17 42 b1 ff 00 04 00 00
[ 1877.735588] mptscsih: ioc0: target reset: SUCCESS (sc=d1fc1ec0)

sdh is a sata Western Digital disk, model WD10EADS.

Is this a firmware problem?

In the mailing list archive I saw similar problem, but I don't sure.

Thanks.
----- End forwarded message -----
