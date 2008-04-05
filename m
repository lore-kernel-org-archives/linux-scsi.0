From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10396] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
Date: Sat,  5 Apr 2008 09:43:08 -0700 (PDT)
Message-ID: <20080405164308.BCA85108060@picon.linux-foundation.org>
References: <bug-10396-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbYDEQnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2008 12:43:39 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m35Gh8Cm012938
	for <linux-scsi@vger.kernel.org>; Sat, 5 Apr 2008 09:43:09 -0700
In-Reply-To: <bug-10396-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10396





------- Comment #3 from linux@tjworld.net  2008-04-05 09:43 -------
I found a mailing list report of a similar problem where ACPI was the cause.

"kernel-2.6.23.1-30.fc8 problem with symbios scsi controllers"

http://www.redhat.com/archives/rhl-devel-list/2007-October/msg02035.html

That caused me try the boot option "pci=noacpi" and the kernel started. There
are numerous other issues as a result so it doesn't solve the regression since
v2.6.20 but it does narrow down the hunt for the culprit.

In part the v2.6.25-rc8 boot log reports:

[   16.207231] Adaptec aacraid driver 1.1-5[2455]-ms



[   47.074484] AAC0: kernel 2.8-1[6099]
[   47.074498] AAC0: monitor 2.8-1[6099]
[   47.078494] AAC0: bios 2.8-1[6099]
[   47.082496] AAC0: serial 8A0376
[   47.086509] scsi2 : percraid
[   47.091184] scsi 2:0:0:0: Direct-Access     DELL     Array1           V1.0
PQ: 0 ANSI: 2
[   46.643256] e100: eth0: e100_probe: addr 0xfe5ff000, irq 11, MAC addr
00:02:b3:bb:d7:8c
[   47.095591] scsi 2:0:1:0: Direct-Access     DELL     Archive          V1.0
PQ: 0 ANSI: 2
[   46.670604] e100: eth1: e100_probe: addr 0xfe5fe000, irq 14, MAC addr
00:02:b3:bb:d7:8d
[   47.113160] scsi 2:1:0:0: Direct-Access     IBM      DMVS09M          0220
PQ: 0 ANSI: 3
[   47.117449] scsi 2:1:1:0: Direct-Access     IBM      DMVS09M          0220
PQ: 0 ANSI: 3
[   47.122638] scsi 2:1:2:0: Direct-Access     IBM      DMVS09M          0220
PQ: 0 ANSI: 3
[   47.127812] scsi 2:1:3:0: Direct-Access     IBM      DMVS09M          0220
PQ: 0 ANSI: 3
[   47.133005] scsi 2:1:4:0: Direct-Access     IBM      DMVS09M          0220
PQ: 0 ANSI: 3
[   47.145724] scsi 2:1:5:0: Direct-Access     HITACHI  DK32DJ-18MC      D4D4
PQ: 0 ANSI: 3
[   46.749850] ata_piix 0000:00:10.0: no available native port
[   47.181601] scsi 2:1:6:0: Processor         DELL     1x6 U2W SCSI BP  5.39
PQ: 0 ANSI: 2
[   46.693844] PCI: Enabling device 0000:00:02.2 (0000 -> 0001)
[   46.693882] PCI: No IRQ known for interrupt pin D of device 0000:00:02.2.
Probably buggy MP table.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
