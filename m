From: Oscar Pearce <oscar@pearceenterprises.com>
Subject: Dell PERC 4/di controller lock-up problems
Date: Wed, 21 Sep 2005 14:25:36 -0500
Message-ID: <1127330736.7528.119.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tatooine.pearceenterprises.com ([66.142.116.66]:17585 "HELO
	tatooine.pearceenterprises.com") by vger.kernel.org with SMTP
	id S1751391AbVIUTZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 15:25:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, all.  I apologize in advance for the long email - I've tried to
include all the pertinent information on my problem.  I have a Dell
PowerEdge 2650 that's been having stability issues ever since we got it
about a year ago, and I'm trying to figure out what might be wrong.  The
symptoms are that every once in a while (sometimes after a couple of
days of uptime, once after 4 months) that SCSI write commands to the
RAID array will not complete and the controller will be taken offline.
At that point the machine has to be rebooted, and everything is fine
until the next time the problem occurs.

Dell's diagnostics don't show anything wrong with the hardware.

The machine is a dual processor 2.8 Ghz Xeon with 4 GB RAM with a
PERC4/di RAID controller configured with RAID 5.  I started out with
Debian on it running a 2.4 series kernel, then tried several 2.6 series
kernels.  For the last 5 months or so it's been running Ubuntu 5.04 with
a custom built kernel (2.6.11.11) with the new megaraid driver, which
seemed to be stable (no lockups for a 4 month period), but then finally
crashed a few weeks ago.  It's been crashing more frequently recently,
probably because we're using it more heavily.

I've (finally!) successfully configured the machine to log kernel
messages over the network to another machine (using netconsole) and
here's what occurs immediately before the lockup:

Sep 21 00:11:29 192.168.0.198 megaraid: aborting-990472 cmd=2a <c=2 t=0
l=0> 
Sep 21 00:11:38 192.168.0.198 megaraid: aborting-990473 cmd=2a <c=2 t=0
l=0> 
Sep 21 00:11:41 192.168.0.198 megaraid abort: 990473:32[255:128], fw
owner 
Sep 21 00:11:50 192.168.0.198 megaraid abort: 990474:0[255:128], fw
owner 
Sep 21 00:11:55 192.168.0.198 megaraid: aborting-990475 cmd=2a <c=2 t=0
l=0> 
Sep 21 00:11:57 192.168.0.198 megaraid abort: 990475:52[255:128], fw
owner 
Sep 21 00:12:06 192.168.0.198 megaraid abort: 990476:54[255:128], fw
owner 
Sep 21 00:12:09 192.168.0.198 megaraid: aborting-990477 cmd=2a <c=2 t=0
l=0> 
Sep 21 00:12:18 192.168.0.198 megaraid: aborting-990478 cmd=2a <c=2 t=0
l=0> 

--- more of the same omitted ---

Sep 21 00:13:52 192.168.0.198 megaraid: aborting-990490 cmd=2a <c=2 t=0
l=0> 
Sep 21 00:13:54 192.168.0.198 megaraid abort: 990490:26[255:128], fw
owner 
Sep 21 00:14:03 192.168.0.198 megaraid mbox: Wait for 64 commands to
complete:175 
Sep 21 00:14:06 192.168.0.198 megaraid mbox: Wait for 64 commands to
complete:170 

--- countdown from 170 to 10 by 5's omitted ---

Sep 21 00:16:49 192.168.0.198 megaraid mbox: Wait for 64 commands to
complete:10 
Sep 21 00:16:54 192.168.0.198 megaraid mbox: Wait for 64 commands to
complete:5 
Sep 21 00:16:56 192.168.0.198 megaraid mbox: Wait for 64 commands to
complete:5 
Sep 21 00:17:05 192.168.0.198 scsi0 (0:0): rejecting I/O to offline
device 
Sep 21 00:17:10 192.168.0.198 printk: 17466 messages suppressed. 
Sep 21 00:17:12 192.168.0.198 scsi0 (0:0): rejecting I/O to offline
device 
Sep 21 00:17:21 192.168.0.198 lost page write due to I/O error on sda2 
Sep 21 00:17:26 192.168.0.198 scsi0 (0:0): rejecting I/O to offline
device 
Sep 21 00:17:35 192.168.0.198 scsi0 (0:0): rejecting I/O to offline
device 
Sep 21 00:17:40 192.168.0.198 scsi0 (0:0): rejecting I/O to offline
device 
Sep 21 00:17:42 192.168.0.198 scsi0 (0:0): rejecting I/O to offline
device 
Sep 21 00:17:51 192.168.0.198 SoftDog: Initiating system reboot.

The next thing in the logs is the initial boot messages.  Here are the
megaraid bits from dmesg:

megaraid cmm: 2.20.2.5 (Release Date: Fri Jan 21 00:01:03 EST 2005)
SCSI subsystem initialized
megaraid: 2.20.4.5 (Release Date: Thu Feb 03 12:27:22 EST 2005)
megaraid: probe new device 0x1028:0x000e:0x1028:0x0123: bus 8:slot
8:func 0
ACPI: PCI interrupt 0000:08:08.0[A] -> GSI 120 (level, low) -> IRQ 120
megaraid: fw version:[251S] bios version:[1.07]
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
  Vendor: PE/PV     Model: 1x6 SCSI BP       Rev: 1.1 
  Type:   Processor                          ANSI SCSI revision: 02
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[0]: scanning scsi channel 2 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD 0 RAID5  279G  Rev: 251S
  Type:   Direct-Access                      ANSI SCSI revision: 02

Anybody have any ideas?

Thanks,
Oscar

