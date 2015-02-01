From: Ondrej Zary <linux@rainbow-software.org>
Subject: New am53c974 driver spamming syslog
Date: Sun, 1 Feb 2015 21:07:13 +0100
Message-ID: <201502012107.13890.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:43788 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbbBAUHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2015 15:07:40 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Hello,
just got a Dawicontrol DC-2964 card (AM53C9AKC chip) and tested the new
am53c974 driver. It seems to work but it's spamming the log with
"FIFO not cleared, 15 bytes left" messages:

[    8.787282] am53c974 0000:00:0b.0: No valid Tekram EEprom found
[    8.787958] am53c974 0000:00:0b.0: esp0: regs[1e800:1e800] irq[11]
[    8.788225] am53c974 0000:00:0b.0: esp0: is a AM53C974, 40 MHz (ccf=0), SCSI ID 7
[   11.792268] scsi host2: esp
[   11.804706] scsi 2:0:0:0: Direct-Access     IBM      DORS-32160       WA0A PQ: 0 ANSI: 2
[   11.804944] scsi target2:0:0: Beginning Domain Validation
[   11.821786] scsi target2:0:0: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   11.833829] scsi target2:0:0: Domain Validation skipping write tests
[   11.833962] scsi target2:0:0: Ending Domain Validation
[   13.279133] sd 2:0:0:0: [sdb] 4226725 512-byte logical blocks: (2.16 GB/2.01 GiB)
[   13.310822] sd 2:0:0:0: [sdb] Write Protect is off
[   13.310956] sd 2:0:0:0: [sdb] Mode Sense: b3 00 00 08
[   13.331969] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.447963] scsi host2: FIFO not cleared, 15 bytes left
[   13.450064] scsi host2: FIFO not cleared, 15 bytes left
[   13.451915] scsi host2: FIFO not cleared, 15 bytes left
[   13.453692] scsi host2: FIFO not cleared, 15 bytes left
[   13.455496] scsi host2: FIFO not cleared, 15 bytes left
[   13.457330] scsi host2: FIFO not cleared, 15 bytes left
[   13.459059] scsi host2: FIFO not cleared, 15 bytes left
[   13.460842] scsi host2: FIFO not cleared, 15 bytes left
[   13.462264]  sdb: sdb1
[   13.566346] sd 2:0:0:0: [sdb] Attached SCSI disk
[   13.705929] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   13.844777] scsi host2: FIFO not cleared, 15 bytes left
...

Also got this error once but was unable to reproduce it. No SCSI devices were
detected (the reset probably didn't happen). rmmod and modprobe fixed it.
[    8.728312] am53c974 0000:00:0b.0: No valid Tekram EEprom found
[    8.728987] am53c974 0000:00:0b.0: esp0: regs[1e800:1e800] irq[11]
[    8.729098] am53c974 0000:00:0b.0: esp0: is a AM53C974, 40 MHz (ccf=0), SCSI ID 7
[   11.732390] scsi host2: esp
[   11.739919] scsi host2: data done, DMA error, resetting


-- 
Ondrej Zary
