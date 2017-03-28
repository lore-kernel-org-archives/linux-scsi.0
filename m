From: Matthias Peter Walther <m_walt11@uni-muenster.de>
Subject: Delock 89384 Sata Controller Causes Lockups Under Heavy Load
Date: Tue, 28 Mar 2017 02:53:39 +0200
Message-ID: <b71c21b1-bb72-25cc-2528-bdee33eb4ca3@uni-muenster.de>
Reply-To: m.wa@wwu.de
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zivm-wwu2-1.uni-muenster.de ([128.176.192.5]:2681 "EHLO
        zivm-wwu2.uni-muenster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753639AbdC1Ay6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 20:54:58 -0400
Received: from [192.168.178.114] (dslb-178-006-169-206.178.006.pools.vodafone-ip.de [178.6.169.206])
        by SECMAIL.UNI-MUENSTER.DE (Postfix) with ESMTP id 99F27BF403
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 02:53:40 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm new to this list and I signed up, because I found an instability
with the following sata controller:

Product name: Delock 89384 10 Port PCIe 2.0 x2 Low Profile retail
Identifies as: 03:00.0 SATA controller: ASMedia Technology Inc. Device
0625 (rev 01)
(PCIe to 10x sata controller card)

Problem description: The controller works and recognizes all my drives.
But under heavy load, e. g. a mdadm raid-6 resync or just a dd to a
file, it keeps causing lockups and random device link resettings on
multiple devices.

I spend the last two weeks on replacing components in this server, the
controller is definitely the problem. Everything works fine with a
Marvell 9215 controller and I tried the controller with three different
mainboards and kernel versions 3.2, 4.4 and 4.10. The controller or its
kernel driver definitely cause these lock ups. I made sure, that all
drives were properly connected. [Syslog attached at the bottom of this
mail.]

As I am an experienced linux user, but new to this, first questions:

Is this the right place to seek for help?

If not so: Where might I get help with this?

If so: Does anybody have an idea, what might causes this problem.

My abilities: I can test patches on the mainline kernel. I can't code,
as I lack any kind of knowledge about the sata standard. I have the
controller card and an empty spare device here, to run any kind of tests.

Syslog of one of these resets: If the level of stress is high enough,
they happen on all connected devices (seemingly random) from different
manufacturers (WesternDigital and Seagate) and different types of
models. So this is probably not a bug in the firmware of one of the drives.

Log:
Mar 24 09:01:43 Server1 kernel: [ 1807.338347] ata3.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action
0x6 frozen
Mar 24 09:01:43 Server1 kernel: [ 1807.340701] ata3.00: failed command:
FLUSH CACHE EXT
Mar 24 09:01:43 Server1 kernel: [ 1807.343078] ata3.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Mar 24 09:01:43 Server1 kernel: [ 1807.343078]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask
 0x4 (timeout)
Mar 24 09:01:43 Server1 kernel: [ 1807.349717] ata3.00: status: { DRDY }
Mar 24 09:01:43 Server1 kernel: [ 1807.353029] ata3: hard resetting link
Mar 24 09:01:43 Server1 kernel: [ 1807.665533] ata3: SATA link up 6.0
Gbps (SStatus 133 SControl 300)
Mar 24 09:01:43 Server1 kernel: [ 1807.667000] ata3.00: configured for
UDMA/133
Mar 24 09:01:43 Server1 kernel: [ 1807.667007] ata3.00: retrying FLUSH
0xea Emask 0x4
Mar 24 09:01:43 Server1 kernel: [ 1807.667164] ata3.00: device reported
invalid CHS sector 0
Mar 24 09:01:43 Server1 kernel: [ 1807.667183] ata3: EH complete

Whenever such a lock up happens, the whole partition is not read or
writeable for at least 90 seconds and sometimes several minutes. But the
system never crashed. I tried to google the controller card, didn't find
much about it.

Any advice would be much appreciated :).

Greetings,
Matthias
