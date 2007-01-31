From: "Matthias Urlichs" <matthias@urlichs.de>
Subject: Re: [PATCH] scsi: megaraid_{mm,mbox} init fix for kdump
Date: Wed, 31 Jan 2007 17:49:30 +0000 (UTC)
Message-ID: <epqkra$9bg$1@sea.gmane.org>
References: <1168009809.4188.10.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47522 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030519AbXAaSaO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 13:30:14 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HCKDa-0005RI-7O
	for linux-scsi@vger.kernel.org; Wed, 31 Jan 2007 19:30:02 +0100
Received: from smurf.noris.de ([192.109.102.42])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2007 19:30:02 +0100
Received: from matthias by smurf.noris.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2007 19:30:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On Fri, 05 Jan 2007 07:10:09 -0800, Sumant Patro wrote:

>         This command clears the pending commands in the adapter
>         and re-initialize its internal RAID structure.
>         Without this change, megaraid driver either panics or fails to
>         initialize the adapter during kdump's second kernel boot
>         if there are pending commands or interrupts from other devices
>         sharing the same IRQ.

Nice. Is there a chance that this patch will also fix the regression I've
noticed (today, unfortunately) on (at least one) Dell server?

FWIW, here's the relevant LSPCI output and kernel logs:

0d:0e.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID (rev 07)
        Subsystem: Dell Unknown device 0002
        Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 18
        Memory at d80f0000 (32-bit, prefetchable) [size=64K]
        Memory at fc4c0000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at fc500000 [disabled] [size=128K]
        Capabilities: [c0] Power Management version 2
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
        Capabilities: [e0] PCI-X non-bridge device

Jan 31 14:41:34 kernel: [ 232.873327] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
Jan 31 14:41:34 kernel: [ 232.877616] SCSI subsystem initialized
Jan 31 14:41:34 kernel: [ 232.888779] megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
Jan 31 14:41:34 kernel: [ 232.889835] megasas: 00.00.03.05 Mon Oct 02 11:21:32 PDT 2006
Jan 31 14:41:34 kernel: [ 233.513659] megasas: 0x1028:0x0015:0x1028:0x1f03: <6>megaraid: probe new device 0x1000:0x0408:0x1028:0x0002: bus 13:slot 14:func 0
Jan 31 14:41:34 kernel: [ 233.514770] megasas: FW now in Ready state
Jan 31 14:41:34 kernel: [ 233.528893] megaraid: fw version:[522A] bios version:[H430]
Jan 31 14:41:34 kernel: [ 233.554778] scsi2 : LSI Logic SAS based MegaRAID driver
Jan 31 14:41:34 kernel: [ 233.555536] scsi 2:0:0:0: Direct-Access MAXTOR ATLAS10K5_073SAS BP00 PQ: 0 ANSI: 5
Jan 31 14:41:34 kernel: [ 233.556173] scsi 2:0:1:0: Direct-Access MAXTOR ATLAS10K5_073SAS BP00 PQ: 0 ANSI: 5
Jan 31 14:41:34 kernel: [ 233.569337] scsi3 : LSI Logic MegaRAID driver
Jan 31 14:41:34 kernel: [ 233.569550] scsi[3]: scanning scsi channel 0 [Phy 0] for non-raid devices
Jan 31 14:41:34 kernel: [ 233.604522] scsi 2:0:8:0: Enclosure DP BACKPLANE 1.00 PQ: 0 ANSI: 5
Jan 31 14:41:41 kernel: [ 243.115199] megaraid: aborting-16 cmd=12 <c=0 t=12 l=0>
Jan 31 14:41:41 kernel: [ 243.115206] megaraid abort: 16:0[0:12], fw owner
Jan 31 14:41:41 kernel: [ 243.115217] megaraid: 1 outstanding commands. Max wait 300 sec
Jan 31 14:41:41 kernel: [ 243.115221] megaraid mbox: Wait for 1 commands to complete:300
Jan 31 14:41:46 kernel: [ 248.125812] megaraid mbox: Wait for 1 commands to complete:295
Jan 31 14:41:48 kernel: [ 250.134075] megaraid mbox: reset sequence completed sucessfully
Jan 31 14:41:58 kernel: [ 260.117201] megaraid: aborting-16 cmd=0 <c=0 t=12 l=0>Jan 31 14:41:58 kernel: [ 260.117207] megaraid abort: 16:0[0:12], fw owner
Jan 31 14:41:58 kernel: [ 260.117217] megaraid: 1 outstanding commands. Max wait 300 sec
Jan 31 14:41:58 kernel: [ 260.117223] megaraid mbox: Wait for 1 commands to complete:300
Jan 31 14:42:03 kernel: [ 265.127417] megaraid mbox: Wait for 1 commands to complete:295
Jan 31 14:42:08 kernel: [ 270.140211] megaraid mbox: Wait for 1 commands to complete:290
Jan 31 14:42:12 kernel: [ 274.146803] megaraid mbox: reset sequence completed sucessfully
[ nothing else that appears relevant ]


-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Those who welcome death have only tried it from the ears up.
					-- Wilson Mizner

