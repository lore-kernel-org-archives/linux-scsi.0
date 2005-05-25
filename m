From: "COMBES Julien - CETE Lyon/DI/ET/PAMELA" <julien.combes@i-carre.net>
Subject: megaraid irq disable after days
Date: Wed, 25 May 2005 14:05:23 +0200
Message-ID: <42946A03.4070305@i-carre.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from grivedraine.passereaux.jmsp.net ([212.23.162.45]:49341 "EHLO
	grivedraine.passereaux.jmsp.net") by vger.kernel.org with ESMTP
	id S262279AbVEYMGx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 08:06:53 -0400
Received: from relternet-01.csac.melanie2.i2 (unknown [10.167.126.113])
	by grivedraine.passereaux.jmsp.net (Postfix) with ESMTP id 2F6D61BF63
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2005 14:06:52 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Here a mail, which I have posted to linux-kernel yesterday, which
describe a problem with a kernel 2.6.10 which disable IRQ of my megraid
after days of work. A very good friend advise me to forward this mail here.

Sorry for the cross-posting, but I don't know neither how to solve the
problem, nor even if it's a problem of my configuration or of the kernel.

Regards,
Julien

-------- Message original --------
Sujet: megaraid irq disable after days
Date: Tue, 24 May 2005 16:13:31 +0200
De: julien.combes.i-carre.net <julien.combes@i-carre.net>
Pour: linux-kernel@vger.kernel.org

Hello,

I have a problem with a kernel 2.6.10 (sources from debian) which
disable IRQ of my megraid (driver megaraid_mbox) on several servers
after days of work and several millions of interuptions.
When the IRQ is disable, the servers do that :

May 22 03:02:20 relternet-01 kernel: irq 17: nobody cared!
May 22 03:02:20 relternet-01 kernel:  [__report_bad_irq+42/160]
__report_bad_irq+0x2a/0xa0
May 22 03:02:20 relternet-01 kernel:  [handle_IRQ_event+48/112]
handle_IRQ_event+0x30/0x70
May 22 03:02:20 relternet-01 kernel:  [note_interrupt+112/176]
note_interrupt+0x70/0xb0
May 22 03:02:20 relternet-01 kernel:  [__do_IRQ+304/320]
__do_IRQ+0x130/0x140
May 22 03:02:20 relternet-01 kernel:  [do_IRQ+25/48] do_IRQ+0x19/0x30
May 22 03:02:20 relternet-01 kernel:  [common_interrupt+26/32]
common_interrupt+0x1a/0x20
May 22 03:02:20 relternet-01 kernel:  [mwait_idle+51/80]
mwait_idle+0x33/0x50
May 22 03:02:20 relternet-01 kernel:  [cpu_idle+59/80] cpu_idle+0x3b/0x50
May 22 03:02:20 relternet-01 kernel: handlers:
May 22 03:02:20 relternet-01 kernel: [pg0+944120576/1069794304]
(megaraid_isr+0x0/0x1e0 [megaraid_mbox])
May 22 03:02:20 relternet-01 kernel: Disabling IRQ #17

I haven't noticed something else curious on the servers.

hardware of these servers :
 - bi Intel Xeon 2.4Ghz
 - 4.5 GB of RAM
 - MegaRaid SCSI 320-2 [1]

The kernel use  SMP, HT, high memory support 64GB, megaraid_mbox driver
(v2.20.4.1, in module with initrd until yesterday) and don't use preempt.

As I didn't find anything that match IRQ disable and megaraid under
internet, I have tried several ways :
 - at the beginning, the IRQ of eth0 and megaraid was shared. I have
corrected this [2] but the problem is staying.
 - I have try newer version of the kernel 2.6.9 to 2.6.10. No benefic
result.
 - I have try the boot option "acpi=ht". No benefic result.
 - the firmeware of the megaraid has been upgraded (to the 1L37
version). No benefic result.

Since yesterday, I am trying, on all server which have the problem,
kernel  2.6.11.10 (source take kernel.org) with megaraid_mbox built-in
(v2.20.4.5) and with differents boot options on servers :
 - "noirqdebug" and "acpi=ht"
 - "noirqdebug" and "acpi=off"
 - "acpi=off"
 - "acpi=ht"

I have this problem  since I installed them few weeks ago with my new
FAI (Debian Fully autmatic Installation). I have a lot of difficulty for
solving the probleme because servers can run without problem one or two
weeks. These servers are not yet in production but still in tests of
charge; they should be in production in one or two weeks... if I find a
way to correct this problem !

Do you have any ideas of which way I can search ?

Regards,
Julien

[1] 0000:03:08.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID
(rev 01)
        Subsystem: LSI Logic / Symbios Logic MegaRAID 518 SCSI 320-2
Controller
        Flags: bus master, fast Back2Back, 66MHz, slow devsel, latency
32, IRQ 17
        Memory at d0500000 (32-bit, prefetchable) [size=64K]
        Capabilities: [80] Power Management version 2

[2]
irq  0:  88018734 timer                 irq 16:  21659113 eth0
irq  1:         9 i8042                 irq 17:  12532775 megaraid
irq  2:         0 cascade [4]           irq 18:        30 aic79xx
irq 12:         3                       irq 19:        30 aic79xx
irq 14:         1 ide0                  irq 23:         0 ehci_hcd

