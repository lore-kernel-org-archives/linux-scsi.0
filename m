From: Adam Thomas <athomas-promo@dbtoolshed.com>
Subject: S-AIT Tape library scsi problems
Date: Mon, 6 Oct 2003 16:14:59 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310061611110.13454-100000@edamame.homelinux.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.mrf.mail.rcn.net ([207.172.4.62]:58005 "EHLO
	smtp03.mrf.mail.rcn.net") by vger.kernel.org with ESMTP
	id S261299AbTJFUUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 16:20:05 -0400
Received: from 207-172-84-55.c3-0.bth-ubr2.lnh-bth.md.cable.rcn.com ([207.172.84.55] helo=edamame.homelinux.net)
	by smtp03.mrf.mail.rcn.net with esmtp (Exim 3.35 #4)
	id 1A6bps-0006cV-00
	for linux-scsi@vger.kernel.org; Mon, 06 Oct 2003 16:20:04 -0400
Received: from edamame.homelinux.net (edamame.homelinux.net [127.0.0.1])
	by edamame.homelinux.net (8.12.8/8.12.5) with ESMTP id h96KExqB013608
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2003 16:14:59 -0400
Received: from localhost (adamt@localhost)
	by edamame.homelinux.net (8.12.8/8.12.5/Submit) with ESMTP id h96KExZd013604
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2003 16:14:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


We've just purchased a Qualstar 5433 Tape Library System:
http://www.qualstar.com/146074.htm

There are three scsi devices total: 2 Sony SAIT drives and a robot.
Our server is running Redhat Linux 7.3 with kernel 2.4.20-20.7. The
SCSI HBA is an adaptec 39160. The end goal is to use the library for
backups using legato networker 7.0.

We've had a lot of problems with scsi errors. They crop up somewhat
randomly during tape drive use. But I can produce them readily by
doing a warm reboot of the system (shutdown -r now) with more than one
of the three scsi device attached to a given bus. On boot one or more
devices will fail to appear in SCSI Select and as the kernel boots I
see things like this in /var/log/messages

Oct  3 17:01:17 sulfur kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI
SCSI HBA DRIVER, Rev 6.2.8
Oct  3 17:01:17 sulfur kernel:         <Adaptec 3960D Ultra160 SCSI
adapter>
Oct  3 17:01:17 sulfur kernel:         aic7899: Ultra160 Wide Channel
A, SCSI Id=7, 32/253 SCBs
Oct  3 17:01:17 sulfur kernel:
Oct  3 17:01:17 sulfur kernel: scsi1 : Adaptec AIC7XXX EISA/VLB/PCI
SCSI HBA DRIVER, Rev 6.2.8
Oct  3 17:01:17 sulfur kernel:         <Adaptec 3960D Ultra160 SCSI
adapter>
Oct  3 17:01:17 sulfur kernel:         aic7899: Ultra160 Wide Channel
B, SCSI Id=7, 32/253 SCBs
Oct  3 17:01:17 sulfur kernel:
Oct  3 17:01:17 sulfur kernel: blk: queue f7fd4014, I/O limit 4095Mb
(mask 0xffffffff)
Oct  3 17:01:17 sulfur kernel: (scsi1:A:0:0): parity error detected in
Data-in phase. SEQADDR(0x1a3) SCSIRATE(0x0)
Oct  3 17:01:17 sulfur kernel: (scsi1:A:0:0): parity error detected in
Data-in phase. SEQADDR(0x1a3) SCSIRATE(0x0)
Oct  3 17:01:17 sulfur kernel: (scsi1:A:0:0): Unexpected busfree in
Message-in phase
Oct  3 17:01:17 sulfur kernel: SEQADDR == 0x168
Oct  3 17:01:17 sulfur kernel:   Vendor: SOOY!!!!  Model:
SE[-111!!!!!!!!!  Rev: 1111
Oct  3 17:01:17 sulfur kernel:   Type:   Sequential-Access            
     ANSI SCSI revision: 05
Oct  3 17:01:17 sulfur kernel: blk: queue f7fd4214, I/O limit 4095Mb
(mask 0xffffffff)
Oct  3 17:01:17 sulfur kernel: scsi1:A:0: Missed busfree. Lastphase =
0xe0, Curphase = 0xc6
Oct  3 17:01:17 sulfur kernel: scsi1:0:1:0: Attempting to queue an
ABORT message
Oct  3 17:01:17 sulfur kernel: scsi1: Dumping Card State while idle,
at SEQADDR 0x18
Oct  3 17:01:17 sulfur kernel: ACCUM = 0x3, SINDEX = 0x48, DINDEX =
0xe4, ARG_2 = 0x0
<snip further errors>


Note that if I put only one device on a bus, things seem to work just
fine.

I've now swapped out every cable and every terminator, even the
adaptec HBA... but nothing changes.

Does anyone have any clues as to what might be the problem? I'm ready
to RMA the library but I'm afraid the one I get back may do the same
thing.

thanks,
-Adam



