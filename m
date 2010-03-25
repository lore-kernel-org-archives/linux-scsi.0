From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: missing alias(es) for eata driver
Date: Thu, 25 Mar 2010 11:06:55 +1030
Message-ID: <hqnq77-n35.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:48977 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0CYAiv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2010 20:38:51 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Nub61-0005gI-2a
	for linux-scsi@vger.kernel.org; Thu, 25 Mar 2010 01:38:49 +0100
Received: from ppp118-210-141-212.lns20.adl6.internode.on.net ([118.210.141.212])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2010 01:38:48 +0100
Received: from arthur.marsh by ppp118-210-141-212.lns20.adl6.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2010 01:38:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a DPT 2044W PCI SCSI card in this machine, identified by

lspci -nnv

as:

00:08.0 SCSI storage controller [0100]: Adaptec (formerly DPT) 
SmartCache/Raid I
-IV Controller [1044:a400] (rev 02)
         Flags: bus master, medium devsel, latency 160, IRQ 11
         BIST result: 00
         I/O ports at d400 [size=32]
         Expansion ROM at ee000000 [disabled] [size=32K]

This card uses the eata driver, but the driver is not automatically loaded.

I added the following /etc/modprobe.d/local:

alias pci:v00001044d0000A400* eata

and removed eata from /etc/initramfs-tools/modules and /etc/modules, 
re-ran update-initramfs and rebooted. This worked, with eata loading 
automatically:

[    4.795522] SCSI subsystem initialized
[    5.114277] libata version 3.00 loaded.
[    5.121469] PCI: setting IRQ 11 as level-triggered
[    5.121509] pci 0000:00:08.0: found PCI INT A -> IRQ 11
[    5.122854] IRQ 11/EATA: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.129523] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[    5.129664] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:n, ep:n,
  pp:y.
[    5.129815] EATA0: 2.0C, PCI 0xd410, IRQ 11, BMST, SG 122, MB 64.
[    5.129932] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[    5.130049] EATA0: SCSI channel 0 enabled, host target ID 7.
[    5.130183] scsi0 : EATA/DMA 2.0x rev. 8.10.00

Could this alias (and perhaps others for DPT SCSI adaptors) be added to 
the eata driver source?

Regards,

Arthur.

