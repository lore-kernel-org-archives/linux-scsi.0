From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: mptsas and ioc0: ERRORs
Date: Mon, 31 Mar 2008 15:04:34 +0200
Message-ID: <20080331150434.a3fb336b.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:60534 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYCaNXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 09:23:04 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 00E414A807F
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 15:04:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 357FE9374A
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 15:04:32 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 1A25D93749
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 15:04:32 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hallo,

my name is Lars and I'm working for the IT of a german academy.
We recently bought some expensive equipment to build up a SAN with Linux.

If this is the wrong address to ask excuse me please. (Where to ask instead?)

The hardware is the following:

monosan:~ # cat /etc/SuSE-release 
openSUSE 10.3 (X86-64)
VERSION = 10.3
monosan:~ # uname -a
Linux monosan 2.6.22.17-0.1-default #1 SMP 2008/02/10 20:01:04 UTC x86_64 x86_64 x86_64 GNU/Linux

2x Dual-Core AMD Opteron(tm) Processor 2216

03:04.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 02)

monosan:~ # ls -1 /lib/firmware/
ethp_z8e.dat
eth_z8e.dat
myri10ge_ethp_z8e.dat
myri10ge_eth_z8e.dat
myri10ge_rss_ethp_z8e.dat
myri10ge_rss_eth_z8e.dat
rss_ethp_z8e.dat
rss_eth_z8e.dat

The HBA has 2 external SFF-8088 connectors and each one is connected to one extender board of the same Promise VTrak VTJ610sD disc enclosure. This is meant to be for redundancy. Therefor I use multipathing.
The VTrak contains 16 SATA discs connected as sda-sdr (and sds-sdah).
There is one Software-RAID6 over 15 discs + one hot spare.

I get the following errors:
monosan:~ # fgrep "Mar 28" /var/log/messages | egrep "(scsi|mpt)"
Mar 28 21:45:37 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8100395bd1c0)
Mar 28 21:45:48 monosan kernel: mptbase: Initiating ioc0 recovery
Mar 28 21:45:48 monosan kernel: mptbase: ioc0: WARNING - IOC is in FAULT state!!!
Mar 28 21:45:51 monosan kernel: mptbase: ioc0: Recovered from IOC FAULT
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff8100395bd1c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810039654700)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff810039654700)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81003bb87d80)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81003bb87d80)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8100519cc5c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8100519cc5c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8100083504c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8100083504c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8100787ccd40)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8100787ccd40)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81006ee04240)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81006ee04240)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8100787cc100)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8100787cc100)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81007cbeb1c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81007cbeb1c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81003bb87a00)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81003bb87a00)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81011bb48300)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81011bb48300)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81011bb484c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81011bb484c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81007cbebc40)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81007cbebc40)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff81003976f0c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff81003976f0c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810051a7a1c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff810051a7a1c0)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810015f93880)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff810015f93880)
Mar 28 21:46:07 monosan kernel: mptscsih: ioc0: attempting target reset! (sc=ffff8100395bd1c0)
Mar 28 21:46:17 monosan kernel: mptbase: Initiating ioc0 recovery
Mar 28 21:46:17 monosan kernel: mptbase: ioc0: WARNING - IOC is in FAULT state!!!
Mar 28 21:46:21 monosan kernel: mptbase: ioc0: Recovered from IOC FAULT
Mar 28 21:46:36 monosan kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Mar 28 21:46:36 monosan kernel: mptscsih: ioc0: target reset: FAILED (sc=ffff8100395bd1c0)
Mar 28 21:46:36 monosan kernel: mptscsih: ioc0: attempting bus reset! (sc=ffff8100395bd1c0)
Mar 28 21:46:48 monosan kernel: mptbase: ioc0: ERROR - Doorbell INT timeout (count=4999), IntStatus=80000008!
Mar 28 21:46:48 monosan kernel: mptbase: Initiating ioc0 recovery
Mar 28 21:46:48 monosan kernel: mptbase: ioc0: WARNING - IOC is in FAULT state!!!
Mar 28 21:46:48 monosan kernel: mptbase: ioc0: ERROR - Doorbell INT timeout (count=4999), IntStatus=0!
Mar 28 21:46:49 monosan kernel: mptbase: ioc0: Recovered from IOC FAULT
Mar 28 21:47:05 monosan kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Mar 28 21:47:05 monosan kernel: mptscsih: ioc0: bus reset: FAILED (sc=ffff8100395bd1c0)
Mar 28 21:47:05 monosan kernel: mptscsih: ioc0: attempting host reset! (sc=ffff8100395bd1c0)
Mar 28 21:47:05 monosan kernel: mptbase: Initiating ioc0 recovery
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: host reset: SUCCESS (sc=ffff8100395bd1c0)
Mar 28 21:47:23 monosan kernel: sd 6:0:26:0: scsi: Device offlined - not ready after error recovery
Mar 28 21:47:23 monosan kernel: scsi 6:0:7:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:4:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:6:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:2:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:1:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:10:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=8380 req_idx_MR=8380 mf=ffff81007db02900 mr=0000000000000000 sc=0000000000000000
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=6680 req_idx_MR=6680 mf=ffff81007db0be80 mr=0000000000000000 sc=019724848808e8c1
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=ce00 req_idx_MR=ce00 mf=ffff81007db0ea00 mr=0000000000000000 sc=ffff81007da92000
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=2900 req_idx_MR=2900 mf=ffff81007db04900 mr=0000000000000000 sc=0000000000000000
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=4900 req_idx_MR=4900 mf=ffff81007db06680 mr=0000000000000000 sc=0000007800000018
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=be80 req_idx_MR=be80 mf=ffff81007db0ce00 mr=0000000000000000 sc=0000000000000000
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=ea00 req_idx_MR=ea00 mf=ffff81007db10b00 mr=0000000000000000 sc=0000000000000000
Mar 28 21:47:23 monosan kernel: scsi 6:0:12:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:11:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:13:0: rejecting I/O to dead device
Mar 28 21:47:23 monosan kernel: scsi 6:0:14:0: rejecting I/O to dead device

And 11 discs have just dissappeared simultaneously:
monosan:~ # cat /proc/mdstat 
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] 
md4 : active raid6 dm-9[15](S) dm-8[16](F) dm-7[13] dm-6[17](F) dm-5[18](F) dm-4[19](F) dm-3[20](F) dm-2[21](F) dm-15[22](F) dm-14[23](F) dm-13[5] dm-12[24](F) dm-11[3] dm-10[25](F) dm-1[26](F) dm-0[0]
      12697912448 blocks level 6, 64k chunk, algorithm 2 [15/4] [U__U_U_______U_]

This hasn't happened for the first time, but at first I thought I might have made a mistake somewhere. Now it has happened again and additionally on a second machine with same hardware for the third time too.
Has this something todo with the multipathing?
Is it strange to have multipathing through the same HBA?
How to debug this any further?

Thanks for any help.

Lars
