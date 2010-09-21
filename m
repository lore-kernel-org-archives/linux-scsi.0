From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] mptscsih: ioc0: attempting task abort, raid array LUNs
 not detected properly on some boots
Date: Tue, 21 Sep 2010 08:12:10 GMT
Message-ID: <201009210812.o8L8CA7s002044@demeter1.kernel.org>
References: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41127 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0IUIML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 04:12:11 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8L8CAXP002045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 08:12:10 GMT
In-Reply-To: <bug-16547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547





--- Comment #7 from Martin Steigerwald <ms@teamix.de>  2010-09-21 08:12:01 ---
(In reply to comment #5)
> (In reply to comment #3)
> > Some additional information on the MPT driver version and controller:
> > 
> > backend01:~# grep -r "" /proc/mpt/*
> > /proc/mpt/ioc0/summary:ioc0: LSIFC949E A1, FwRev=01030e00h, Ports=1, MaxQ=1023,
> > LanAddr=00:06:[...], IRQ=33
> > /proc/mpt/ioc0/info:ioc0:
> > /proc/mpt/ioc0/info:  ProductID = 0x1005 (LSIFC949E A1)
> > /proc/mpt/ioc0/info:  FWVersion = 0x01030e00 (fw_size=190556)
[...]
> Your bug is completely different issue. Whatever you are point to redhat
> bugzilla is with respect to SAS controller.

I thought it might be related nevertheless. I don't know the inner structure of
the MPT driver. It also sounded similar, cause in that bug report there is also
the mention that it worked with 2.6.26, but I AFAIR not with 2.6.27. Maybe its
a general change in the SCSI layer that triggers the issue.

> In your case it is FC controller.

Yes, I know.

> You have mentioned that 
> "Latest kernel known to work: 2.6.26 from Debian Backports"
> 
> Can you provide me driver version where things are working fine. 

Here is the version from a 2.6.26 lenny kernel, which should be the one that
has been backported to Etch:

pasta:~# modinfo
/lib/modules/2.6.26-2-amd64/kernel/drivers/message/fusion/mptfc.ko 
filename:      
/lib/modules/2.6.26-2-amd64/kernel/drivers/message/fusion/mptfc.ko
version:        3.04.06
license:        GPL
description:    Fusion MPT FC Host driver
author:         LSI Corporation
srcversion:     F3D99FE0544BDDD1455BAAA
alias:          pci:v00001657d00000646sv*sd*bc*sc*i*
alias:          pci:v00001000d00000646sv*sd*bc*sc*i*
alias:          pci:v00001000d00000640sv*sd*bc*sc*i*
alias:          pci:v00001000d00000642sv*sd*bc*sc*i*
alias:          pci:v00001000d00000626sv*sd*bc*sc*i*
alias:          pci:v00001000d00000628sv*sd*bc*sc*i*
alias:          pci:v00001000d00000622sv*sd*bc*sc*i*
alias:          pci:v00001000d00000624sv*sd*bc*sc*i*
alias:          pci:v00001000d00000621sv*sd*bc*sc*i*
depends:        mptscsih,scsi_transport_fc,scsi_mod,mptbase
vermagic:       2.6.26-2-amd64 SMP mod_unload modversions 
parm:           mptfc_dev_loss_tmo: Initial time the driver programs the 
transport to wait for an rport to  return following a device loss event. 
Default=60. (int)
parm:           max_lun: max lun, default=16895  (int)

The 2.6.32 kernel, where we see described issues has:

backend01:~# modinfo mptfc
filename:      
/lib/modules/2.6.32-bpo.5-amd64/kernel/drivers/message/fusion/mptfc.ko
version:        3.04.12
license:        GPL
description:    Fusion MPT FC Host driver
author:         LSI Corporation
srcversion:     92E350C096B75A9714B8B0E
alias:          pci:v00001657d00000646sv*sd*bc*sc*i*
alias:          pci:v00001000d00000646sv*sd*bc*sc*i*
alias:          pci:v00001000d00000640sv*sd*bc*sc*i*
alias:          pci:v00001000d00000642sv*sd*bc*sc*i*
alias:          pci:v00001000d00000626sv*sd*bc*sc*i*
alias:          pci:v00001000d00000628sv*sd*bc*sc*i*
alias:          pci:v00001000d00000622sv*sd*bc*sc*i*
alias:          pci:v00001000d00000624sv*sd*bc*sc*i*
alias:          pci:v00001000d00000621sv*sd*bc*sc*i*
depends:        mptscsih,mptbase,scsi_transport_fc,scsi_mod
vermagic:       2.6.32-bpo.5-amd64 SMP mod_unload modversions 
parm:           mptfc_dev_loss_tmo: Initial time the driver programs the 
transport to wait for an rport to  return following a device loss event. 
Default=60. (int)
parm:           max_lun: max lun, default=16895  (int)
backend01:~#

> In case of
> some working kernel is there, I would like to simply upgrade MPTFUSION driver
> (do not upgrade a whole kernel). This way I would like to change only one
> component of the system at a time...

Well the old 2.6.26 kernel worked. But actually it does not boot on the new
servers, cause the old version ata_piix does not talk to the newer onboard SATA
controller. Thus it would be required to use a newer ata_piix and a newer MPT
FUSION FC driver with 2.6.26 kernel. I don't know whether thats feasible.

Its a production machine and I need to be careful with testing. I can only test
with agreement of the customer. But for a defined test case it might be
workable. Would it be as easy as to replace the directories with the driver
source with a newer version? From 2.6.26 to 2.6.32 is quite a step.

> This will help to understand where things are broken.

I understand.

> FYI,
> MPTFC drive is highly in mentionation mode. There are very very minimal changes
> happened to MPTFC driver since 2008.
> 
> Last change went to upstream for MPTFC is 
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=03cb3829e0e5650518ce37e2b4420a35e034dc9e

I don't think that commit has landed in 2.6.32, since Linus released it on 3rd
december 2009. It also does not seem to be in one of the stable patches:

ms@mango:~/Linux/Kernel/Mainline> ls ChangeLog-2.6.32*
ChangeLog-2.6.32     ChangeLog-2.6.32.16  ChangeLog-2.6.32.3
ChangeLog-2.6.32.1   ChangeLog-2.6.32.17  ChangeLog-2.6.32.4
ChangeLog-2.6.32.10  ChangeLog-2.6.32.18  ChangeLog-2.6.32.5
ChangeLog-2.6.32.11  ChangeLog-2.6.32.19  ChangeLog-2.6.32.6
ChangeLog-2.6.32.12  ChangeLog-2.6.32.2   ChangeLog-2.6.32.7
ChangeLog-2.6.32.13  ChangeLog-2.6.32.20  ChangeLog-2.6.32.8
ChangeLog-2.6.32.14  ChangeLog-2.6.32.21  ChangeLog-2.6.32.9
ChangeLog-2.6.32.15  ChangeLog-2.6.32.22
ms@mango:~/Linux/Kernel/Mainline> grep 03cb3829e0e5650518ce37e2b4420a35e034dc9e
ChangeLog-2.6.32*
ms@mango:~/Linux/Kernel/Mainline#1>

Thanks,
Martin

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
