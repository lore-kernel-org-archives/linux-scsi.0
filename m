From: Matej Kenda <matejkenda@REMOVE.volja.net.hermes.si>
Subject: 2.4.1[89]: SMP computer hangs when accessing tape drive via scsi
 generic
Date: Mon, 30 Sep 2002 14:52:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D9848FD.6040007@REMOVE.volja.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from primus.hermes.si (primus.hermes.si [193.77.5.98])
	by guardian.hermes.si (8.9.3/8.9.3) with ESMTP id OAA01329
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 14:52:16 +0200 (METDST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

We have experienced major problems dealing with tape drives via SCSI generic 
driver on RedHat ((null)) and SuSE Linux Enterprise Server 8 Beta3. The 
computer just hangs without logging anything to the /var/log/messages.

On RedHat ((null)) we got the stack trace on the screen and managed to get 
some more information.

Manually copied stack trace (last function on top):

sg_cmd_done_bh
sg_common_write
scsi_insert_special_req
scsi_insert_special
ahc_linux_run_device_queue (+offset 666)
pci_map_sg (asm-386/pci.h)

Macro BUG() is called in that function, because one of the parameters is not 
OK. We were not able to detect which parameter was not OK.

The application that we develop was writing one 64kB and one 32kB block of 
data via sg using direct IO flag at the time of the hang.

We have the following hardware configuration:

* Motherboard: Asus TR-DLS
    - SMP Pentium III
    - ServerWorks LE-T 3.0 chipset
    - on-board dual-channel LSI 53C1010R/1030 SCSI controller

* Two Adaptec AHA-2944UW High Voltage Differential SCSI controllers

The following SCSI devices are attached to the computer:

* Symbios/LSI channel 1: ACARD MirrorSmart 38G RAID disk
* Symbios/LSI channel 2: IFT IFT-7200 600GB RAID disk
* Adaptec card 1: two SONY SDX-500C (AIT-2)
* Adaptec card 2: two SONY SDX-500C (AIT-2)

We have checked termination, cabling, power supply, and tape drives one by one 
  but the problem persisted.

We speculated that the problems are somehow related to SMP. We tried to boot 
with "nosmp" option, but the system wouldn't boot.

One Adapted HVD card was then moved to another UP computer. Another Adapted SE 
card was added to connect the 600GB RAID disk. SuSE Linux Enterprise Server B3 
was installed and so far the system works OK.

Both RedHat (null) and SLES 8 B3 use the new gcc 3.2 compiler.

Do we have a configuration problem?
Is there a known problem with SCSI on SMP computers?

Thanks in advance for help.

Matej


