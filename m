From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: eata fails to load on post 4.2 kernels
Date: Sun, 06 Sep 2015 18:34:31 +0930
Message-ID: <55EC019F.4010209@internode.on.net>
References: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:20574 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbbIFJEl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Sep 2015 05:04:41 -0400
In-Reply-To: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Arthur Marsh wrote on 06/09/15 15:58:
> Hi, I'm seeing the following on post 4.2 kernels, am currently bisecting
> to find where it started:

an error message suggested trying setting irqpoll on the kernel command 
line, which worked:

[   85.230148] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[   85.255929] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:n, ep:n, pp:y.
[   85.282472] EATA0: 2.0C, PCI 0xd890, IRQ 10, BMST, SG 122, MB 64.
[   85.308281] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[   85.333237] EATA0: SCSI channel 0 enabled, host target ID 7.
[   85.358097] scsi host3: EATA/DMA 2.0x rev. 8.10.00
[   86.950246] scsi 3:0:6:0: Direct-Access     IBM      DCAS-34330W 
  S65A PQ: 0 ANSI: 2
[   86.975531] scsi 3:0:6:0: cmds/lun 16, sorted, simple tags.
[   89.075921] sd 3:0:6:0: Attached scsi generic sg4 type 0
[   89.101628] sd 3:0:6:0: [sdd] 8466688 512-byte logical blocks: (4.33 
GB/4.03 GiB)
[   89.166331] sd 3:0:6:0: [sdd] Write Protect is off
[   89.192023] sd 3:0:6:0: [sdd] Mode Sense: b3 00 00 08
[   89.209400] sd 3:0:6:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   89.312977]  sdd: sdd1 sdd2 < sdd5 >
[   89.402386] sd 3:0:6:0: [sdd] Attached SCSI disk

