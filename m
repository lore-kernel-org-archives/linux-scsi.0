From: "Collins, Kevin" <kCollins@nesbittengineering.com>
Subject: Megaraid problems.
Date: Fri, 13 Jan 2006 09:04:51 -0500
Message-ID: <H000007300186318.1137161089.concorde.nesbitt.local@MHS>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.nesbittengineering.com ([64.191.130.42]:48005 "EHLO
	concorde.nesbitt.local") by vger.kernel.org with ESMTP
	id S1422675AbWAMOEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2006 09:04:52 -0500
Received: from concorde.nesbitt.local (localhost.localdomain [127.0.0.1])
	by concorde.nesbitt.local (8.13.1/8.13.1) with ESMTP id k0DE4pKk003816
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 09:04:52 -0500
Received: from concorde.nesbitt.local (root@localhost)
	by concorde.nesbitt.local (8.13.1/8.13.1/Submit) with ESMTP id k0DE4pFI003815
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 09:04:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi list,

I have a Dell PowerEdge 850 with their PERC4sc RAID card driving a Dell PowerVault 220s external drive enclosure running Ubuntu 5.10.  This machine and all the parts that make it up are less than 2 months old.  In that time, I have had both logical drives supplied by PV220s taken offline by the megaraid driver twice.  The only cure for this has been a reboot of the machine.  Luckily, with the exception of the process that was running at the time of the problem, nothing else was damaged or hurt; no loss of data has been experienced (yet).

Both times the failure has occurred, it happened while creating a gzipped tarball of some backup data.  The final tarball created is averaging about 92+ GB in size and the machine is under heavy disk I/O for more than 7 hours.  I have been able to grab this information from the syslog after the failure (gathered with LogWatch):

 1 Time(s): [5535381.561000] megaraid abort: 55592075:43[255:128], fw owner
 1 Time(s): [5535381.561000] megaraid abort: 55592077:62[255:128], fw owner
 1 Time(s): [5535381.561000] megaraid abort: 55592078[255:128], driver owner
 1 Time(s): [5535381.561000] megaraid mbox: Wait for 2 commands to complete:180
 1 Time(s): [5535381.561000] megaraid: 2 outstanding commands. Max wait 180 sec
 1 Time(s): [5535381.561000] megaraid: aborting-55592075 cmd=28 <c=1 t=0 l=0>
 1 Time(s): [5535381.561000] megaraid: aborting-55592077 cmd=28 <c=1 t=0 l=0>
 1 Time(s): [5535381.561000] megaraid: aborting-55592078 cmd=28 <c=1 t=0 l=0>
 1 Time(s): [5535381.561000] megaraid: reseting the host...
 1 Time(s): [5535386.566000] megaraid mbox: Wait for 2 commands to complete:175

[... The above line repeat every 5 seconds, counting down to 0 ...]

 1 Time(s): [5535556.736000] megaraid mbox: Wait for 2 commands to complete:5
 2 Time(s): [5535562.611000] scsi2 (0:0): rejecting I/O to offline device

The only difference in the two instances is the number of "commands" that are waiting to complete.  This snippet above is from the first instance, the second instance had 10 commands waiting.

The machine is running the default Ubuntu kernel, which is their patched version of 2.6.12.  In addition, both the megaraid_mbox and megaraid_mm modules are loaded.  Here is an output of 'modinfo' for both of those modules:

========================================================================================
megaraid_mbox
----------------------------------------------------------------------------------------
filename:       /lib/modules/2.6.12-10-386/kernel/drivers/scsi/megaraid/megaraid_mbox.ko
author:         LSI Logic Corporation
description:    LSI Logic MegaRAID Mailbox Driver
license:        GPL
version:        2.20.4.5
vermagic:       2.6.12-10-386 386 gcc-3.4
depends:        megaraid_mm,scsi_mod
alias:          pci:v00001028d0000000Esv00001028sd00000123bc*sc*i*
alias:          pci:v00001000d00001960sv00001028sd00000520bc*sc*i*
alias:          pci:v00001000d00001960sv00001028sd00000518bc*sc*i*
alias:          pci:v00001000d00000407sv00001028sd00000531bc*sc*i*
alias:          pci:v00001028d0000000Fsv00001028sd0000014Abc*sc*i*
alias:          pci:v00001028d00000013sv00001028sd0000016Cbc*sc*i*
alias:          pci:v00001028d00000013sv00001028sd0000016Dbc*sc*i*
alias:          pci:v00001028d00000013sv00001028sd0000016Ebc*sc*i*
alias:          pci:v00001028d00000013sv00001028sd0000016Fbc*sc*i*
alias:          pci:v00001028d00000013sv00001028sd00000170bc*sc*i*
alias:          pci:v00001000d00000408sv00001028sd00000002bc*sc*i*
alias:          pci:v00001000d00000408sv00001028sd00000001bc*sc*i*
alias:          pci:v0000101Ed00001960sv00001028sd00000471bc*sc*i*
alias:          pci:v0000101Ed00001960sv00001028sd00000493bc*sc*i*
alias:          pci:v0000101Ed00001960sv00001028sd00000475bc*sc*i*
alias:          pci:v0000101Ed00001960sv0000101Esd00000475bc*sc*i*
alias:          pci:v0000101Ed00001960sv0000101Esd00000493bc*sc*i*
alias:          pci:v00001000d00001960sv00001000sd0000A520bc*sc*i*
alias:          pci:v00001000d00001960sv00001000sd00000520bc*sc*i*
alias:          pci:v00001000d00001960sv00001000sd00000518bc*sc*i*
alias:          pci:v00001000d00000407sv00001000sd00000530bc*sc*i*
alias:          pci:v00001000d00000407sv00001000sd00000532bc*sc*i*
alias:          pci:v00001000d00000407sv00001000sd00000531bc*sc*i*
alias:          pci:v00001000d00000408sv00001000sd00000001bc*sc*i*
alias:          pci:v00001000d00000408sv00001000sd00000002bc*sc*i*
alias:          pci:v00001000d00001960sv00001000sd00000522bc*sc*i*
alias:          pci:v00001000d00001960sv00001000sd00004523bc*sc*i*
alias:          pci:v00001000d00001960sv00001000sd00000523bc*sc*i*
alias:          pci:v00001000d00000409sv00001000sd00003004bc*sc*i*
alias:          pci:v00001000d00000409sv00001000sd00003008bc*sc*i*
alias:          pci:v00001000d00000407sv00008086sd00000532bc*sc*i*
alias:          pci:v00001000d00001960sv00008086sd00000523bc*sc*i*
alias:          pci:v00001000d00000408sv00008086sd00000002bc*sc*i*
alias:          pci:v00001000d00000407sv00008086sd00000530bc*sc*i*
alias:          pci:v00001000d00000409sv00008086sd00003008bc*sc*i*
alias:          pci:v00001000d00000408sv00008086sd00003431bc*sc*i*
alias:          pci:v00001000d00000408sv00008086sd00003499bc*sc*i*
alias:          pci:v00001000d00001960sv00008086sd00000520bc*sc*i*
alias:          pci:v00001000d00000408sv00001734sd00001065bc*sc*i*
alias:          pci:v00001000d00000408sv00001025sd0000004Dbc*sc*i*
alias:          pci:v00001000d00000408sv00001033sd00008287bc*sc*i*
srcversion:     042A4371A952248BEF860F4
parm:           debug_level:Debug level for driver (default=0) (int)
parm:           fast_load:Faster loading of the driver, skips physical devices! (default=0) (int)
parm:           cmd_per_lun:Maximum number of commands per logical unit (default=64) (int)
parm:           max_sectors:Maximum number of sectors per IO command (default=128) (int)
parm:           busy_wait:Max wait for mailbox in microseconds if busy (default=10) (int)
parm:           unconf_disks:Set to expose unconfigured disks to kernel (default=0) (int)

----------------------------------------------------------------------------------------
megaraid_mm:
----------------------------------------------------------------------------------------
filename:       /lib/modules/2.6.12-10-386/kernel/drivers/scsi/megaraid/megaraid_mm.ko
author:         LSI Logic Corporation
description:    LSI Logic Management Module
license:        GPL
version:        2.20.2.5
vermagic:       2.6.12-10-386 386 gcc-3.4
depends:
srcversion:     D2DA33EA7F3FEA9EBE4A603
parm:           dlevel:Debug level (default=0) (int)
========================================================================================

I have contacted Dell - via their linux-poweredge mailing list - and have discovered that I am not the only one experiencing these problems.  What bothers me is that while this problem, apparently, has been around a while and no fix has yet been discovered by Dell or anyone else.

My research also leads me to believe that this is not just an Ubuntu thing either.  I have reports that this happens under Redhat, Debian and SuSE.  It also appears as though the problem started happening around kernel version 2.6.9.

So, I'm hoping that someone here:

a). Knows about the problem and is working on it.

- and, more importantly - 

b). Can lead me to a fix.

My machine is in production and I do not have any additional hardware to test with, but I can do limited testing with it as long as it is completely functional by 8:00 pm eastern time.  I'm using it as offsite backup machine and that's when my backup processes kick in.  If more information is needed, let me know how to get it, and I'll supply it.

I need to get this solved ASAP.

Thanks in advance,

--
Kevin L. Collins, MCSE
Systems Manager
Nesbitt Engineering, Inc. 
