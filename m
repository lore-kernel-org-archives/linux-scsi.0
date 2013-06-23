From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: JMicron JMB363 PCI SATA/IDE Card Support
Date: Sun, 23 Jun 2013 16:28:50 +0200
Message-ID: <51C70622.9070303@matthiasprager.de>
References: <51C1AE53.4030206@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:45654 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3FWO2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jun 2013 10:28:54 -0400
In-Reply-To: <51C1AE53.4030206@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Matthias Prager <linux@matthiasprager.de>

I did some more digging and came up with a partial
workaround:
After adding the line:
>	{ PCI_VDEVICE(JMICRON, 0x236f), board_ahci_ign_iferr },
(at line 301 of drivers/ata/ahci.c)
The the sata ports of my two cards get detected and lspci -k shows
they are using the ahci driver.

My guess is the 'RAID bus controller [0104]' mode/class is keeping
my cards from beeing detected (they probably would be if they were
in PCI_CLASS_STORAGE_SATA_AHCI mode). Which would mean line 297
is just plain buggy.

This still leaves the problem of the missing IDE Ports (one master+slave
port per card are still not detected). I'm trying to
understand how the pata_jmicron driver is supposed to work
but haven't wrapped my head around it yet.

- Matthias

Am 19.06.2013 15:12, schrieb Matthias Prager:
> Hello everyone,
> 
> I'm having a hard time getting my JMicron JMB363 PCI SATA/IDE Card
> to work under linux.
> The 'lspci -nn' output reads as follows:
>> RAID bus controller [0104]: JMicron Technology Corp. JMB363 SATA/IDE
>> Controller [197b:2363] (rev 03)
> 
> I tried my own kernel (3.9.6) under gentoo with CONFIG_PATA_JMICRON and
> CONFIG_SATA_AHCI enabled. And I tried using
> the latest SystemrescueCD (with kernel 3.4.47) which has pretty much
> everything compiled into it.
> 
> FreeBSD is recognizing the devices just fine. How do I get them
> to run on linux?
> 
> - Matthias
> 
> P.S. a side note: this is in an virtualized environment (VMWare ESXi)
> with pass-through.
> 

