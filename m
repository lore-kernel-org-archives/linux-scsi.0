From: Grzegorz Nosek <root@localdomain.pl>
Subject: aic94xx woes
Date: Sun, 28 Dec 2008 19:19:30 +0100
Message-ID: <20081228181930.GA23802@megiteam.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e208.rev.megiteam.pl ([77.79.226.8]:44118 "EHLO
	vadmin.megiteam.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753347AbYL1Siz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Dec 2008 13:38:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: luben_tuikov@adaptec.com
Cc: linux-scsi@vger.kernel.org

Hi!

I have a rather nasty problem with a Supermicro board equipped with an
Adaptec 9410 SAS RAID controller (4x 500GB SATA drives configured as JBOD)
and running 2.6.27.x. The most interesting (AFAIK) log messages look
like this:

Dec 26 03:43:34 172.31.255.1 [965185.449170] Uhhuh. NMI received for unknown reason b1.
Dec 26 03:43:34 172.31.255.1 [965185.452789] You have some hardware problem, likely on the PCI bus.
Dec 26 03:43:34 172.31.255.1 [965185.452789] Dazed and confused, but trying to continue
Dec 26 03:43:34 172.31.255.1 [965185.466562] aic94xx: parity error for 0000:09:02.0
Dec 26 03:43:34 172.31.255.1 [965185.471640] aic94xx: chip reset for 0000:09:02.0
Dec 26 03:43:35 172.31.255.1 [965185.842897] EDAC i5000 MC0: FATAL ERRORS Found!!! 1st FATAL Err Reg= 0x2
Dec 26 03:43:35 172.31.255.1 [965185.849895] EDAC i5000 MC0: Northbound CRC error on non-redundant retry
Dec 26 03:43:35 172.31.255.1 [965185.856826] EDAC MC0: UE row 3, channel-a= 1 channel-b= 2 labels "-": (Branch=0 DRAM-Bank=6 RDWR=Read RAS=2937 CAS=0 FATAL Err=0x2)

Dec 26 03:44:04 172.31.255.1 [965215.441651] sas: command 0xffff88011bec4c80, task 0xffff88038063ec40, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.450855] sas: command 0xffff88011bec5540, task 0xffff88038063e1c0, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.451689] sas: command 0xffff88020d5a4780, task 0xffff88038063ee00, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.451692] sas: command 0xffff88042e97ac80, task 0xffff8802b6d24000, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.451695] sas: command 0xffff88042e97a140, task 0xffff8802b6d24700, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.451697] sas: command 0xffff88042e97b900, task 0xffff8802b6d248c0, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.451700] sas: command 0xffff88042e97ab40, task 0xffff8802b6d24a80, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.506066] sas: command 0xffff88011bec4640, task 0xffff88038063e700, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.515273] sas: command 0xffff88011bec5680, task 0xffff88038063fc00, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.524478] sas: command 0xffff88011bec4140, task 0xffff88038063f340, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.533690] sas: command 0xffff88011bec4a00, task 0xffff88038063e000, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.542895] sas: command 0xffff88011bec5b80, task 0xffff88038063e540, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.552106] sas: command 0xffff88011bec4780, task 0xffff88038063fdc0, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.561290] sas: command 0xffff8800cfa59040, task 0xffff8803f1f7e380, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.570514] sas: command 0xffff8800cfa58500, task 0xffff8803f1f7e540, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.579719] sas: command 0xffff8800cfa58780, task 0xffff8803f1f7e700, timed out: EH_NOT_HANDLED
Dec 26 03:44:04 172.31.255.1 [965215.588922] sas: command 0xffff8800cfa59680, task 0xffff8803f1f7e8c0, timed out: EH_NOT_HANDLED

Dec 26 03:44:15 172.31.255.1 [965226.061615] aic94xx: tmf timed out
Dec 26 03:44:15 172.31.255.1 [965226.065335] aic94xx: tmf came back
Dec 26 03:44:15 172.31.255.1 [965226.069038] aic94xx: task 0xffff88038063ec40 aborted, res: 0x5
Dec 26 03:44:20 172.31.255.1 [965231.091602] aic94xx: tmf timed out
Dec 26 03:44:20 172.31.255.1 [965231.095318] aic94xx: tmf came back
Dec 26 03:44:20 172.31.255.1 [965231.099026] aic94xx: task 0xffff88038063ec40 aborted, res: 0x5
Dec 26 03:44:25 172.31.255.1 [965236.121593] aic94xx: tmf timed out
Dec 26 03:44:25 172.31.255.1 [965236.125367] aic94xx: tmf came back
Dec 26 03:44:25 172.31.255.1 [965236.129064] aic94xx: task 0xffff88038063ec40 aborted, res: 0x5
Dec 26 03:44:30 172.31.255.1 [965241.151588] aic94xx: tmf timed out
Dec 26 03:44:30 172.31.255.1 [965241.155464] aic94xx: tmf came back
Dec 26 03:44:30 172.31.255.1 [965241.159165] aic94xx: task 0xffff88038063ec40 aborted, res: 0x5
Dec 26 03:44:35 172.31.255.1 [965246.181579] aic94xx: tmf timed out
Dec 26 03:44:35 172.31.255.1 [965246.185457] aic94xx: tmf came back
Dec 26 03:44:35 172.31.255.1 [965246.189153] aic94xx: task 0xffff88038063ec40 aborted, res: 0x5

The machine limped along for about half an hour, then lost all four
disks and died (I have 11M of kernel logs, mostly from the event and can
send that if you wish). The disks booted successfully in another machine
using some plain SATA controller with no SMART error reports (btw, does
smartctl even work on aic94xx?). A reboot didn't help the affected
machine (booted, detected all disks and promptly died just after
starting init), but it did start successfully after a few hours with a
different set of disks (I'd say thermal problems but IPMI says 35 deg. C
inside the case, so I'd guess it isn't too bad).

After ~2 days of bonnie++, cpuburn and memtest running concurrently, *I
think* we were able to reproduce the parity error, but don't quote me on
that (will confirm and update if we in fact couldn't).

The machine is currently out of production use and is available for
tests before we return it.

Could the driver be responsible for at least some of the problems (e.g.
a complete failure to recover from the errors)? I'd like to know what to
expect after I replace the motherboard and avoid future issues like this
(will switch to the onboard SATA controller, scrapping aic94xx entirely
if need be but would like to avoid it).

Best regards,
 Grzegorz Nosek
