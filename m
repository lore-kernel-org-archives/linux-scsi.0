From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Mon, 16 Apr 2012 15:18:29 +0900 (JST)
Message-ID: <977284.68961.qm@web100019.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204122044390.10558-100000@netrider.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100019.mail.kks.yahoo.co.jp ([114.111.98.193]:36763 "HELO
	web100019.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751513Ab2DPGSc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2012 02:18:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204122044390.10558-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Today the hard drive is connected through eSATA with a SATA-PATA adapter.  ATA commands work.  As always, LBA 551562 has uncorrectable read errors.

echo 0>/sys/block/sdc/queue/read_ahead_kb
has been done.  sg_dd behaves.  dd should try to read 8 blocks at a time to match the memory controller's page size, right?  But it doesn't -- it tries to read 32 blocks at a time.

dd if=/dev/sdc of=/dev/null bs=512 count=8 skip=551540
tried to read 32 blocks (0x20) starting at LBA 551544 (0x0086a78).  I don't know how many earlier blocks it read too, but earlier blocks had no problem.  On stdout it reported 8 blocks successfully copied.  But it took a long time getting there, because readahead tried to include the bad block.  dmesg says there was an error in sector 551544.  Libata used a command 0xc8 (READ DMA), starting LBA 0x0086a78 and detected an uncorrectable error in LBA 0x0000007, which is impossible because it isn't in the range of LBAs being read.  Then the SCSI layer has the last 8 bytes of sense data (command specific information = LBA) as 0x0000000000000006, maybe because libata did a decrement that it shouldn't do.  But, just to add to the confusion, libata aborted the command after a timeout of 120 seconds
  instead of getting the drive's report... (now maybe this means that the hanging USB bridge of previous weeks was waiting for a hanged drive).

sg_dd gets an acceptable report from the drive, UNC + IDNF + obsolete error bits, in LBA 0x0086a8a.  dmesg doesn't show any logs at the SCSI layer from that one.

As an experiment, I tried:
echo 4>/sys/block/sdc/queue/read_ahead_kb
but dd still tried to readahead 32 blocks instead of 8, again starting at 551544.

Another experiment:
dd if=/dev/sdc of=/dev/null bs=512 count=8 skip=551544
might or might have tried to do readahead, but if it did, it did less than the previous test because it didn't reach the bad block.  No delay and no logs.  So why is dd better behaved sometimes than other times?
