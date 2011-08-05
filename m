From: Matt Turner <mattst88@gmail.com>
Subject: 3Ware 9550SX on MIPS
Date: Fri, 5 Aug 2011 17:34:58 -0400
Message-ID: <CAEdQ38FKHh2+QdEz=e9HUEUg-miRYuRe730QEwsjbZYzUF28zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35922 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1HEVfT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2011 17:35:19 -0400
Received: by vws1 with SMTP id 1so2206285vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2011 14:35:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aradford@gmail.com

Hi,

I'm trying to use a 3Ware 9550SX SATA controller on a MIPS system.

The driver loads, but no disk is detected. I presume this is because
the card need to be configured (normally in the BIOS-type menu before
booting the kernel, on an x86 system) to export the disk to the
operating system.

3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
scsi3 : 3ware 9000 Storage Controller
3w-9xxx: scsi3: Found a 3ware 9000 Storage Controller at 0x44020000, IRQ: 58.
3w-9xxx: scsi3: Firmware FE9X 3.08.02.007, BIOS BE9X 3.08.00.002, Ports: 4.

The card is 3.3V PCI(-X) only, and this MIPS box is the only system
the card will fit in. I've tried 3Ware's tw_cli utility under qemu:

---
Unsupported ioctl: cmd=0x0108
//bcm91250a-be> show
(0x09:0x0026): (0x09:0x0026): Function not implemented

No controller found.
Make sure appropriate LSI/3ware device driver(s) are loaded.
---

strace shows

stat64("/proc/scsi/3w-sas_vm40",0x4080302c) = -1 errno=2 (No such file
or directory)
open("/dev/twa0",O_RDONLY|0x2) = 3
uname(0x407f7350) = 0
ioctl(3,264,137249696,1082094992,0,1082094744) = -1 errno=38 (Function
not implemented)

Are there any ways to configure this card through /proc or /sys? I
simply want to get the card to export the single disk to the OS.

Thanks,
Matt
