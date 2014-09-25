From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Thu, 25 Sep 2014 15:33:12 +0000
Message-ID: <bug-85151-11613-AlbLsq6AZI@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52573 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaIYPdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 11:33:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 847842027D
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 15:33:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4AAE620204
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 15:33:12 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #3 from linux-ide@crashplan.pro ---
Regression #2: firmware upgrade for Adaptec PMC-Sierra PM8018 SAS HBA [Series
7H] [9005:8088]:

old:
Number of controllers = 1
CONTROLLER_ADDRESS | VENDOR_ID | DEVICE_ID | FIRMWARE_REVISION | BIOS_VERSION
0000:01:00.0            0x9005        0x8088       02.08.59.01    1.2.0.0234

new:
Number of controllers = 1
CONTROLLER_ADDRESS | VENDOR_ID | DEVICE_ID | FIRMWARE_REVISION | BIOS_VERSION
0000:01:00.0            0x9005        0x8088       02.08.60.01    1.2.0.10624

Resulting output on modprobe pm80xx:
[   90.510311] pm80xx 0000:01:00.0: pm80xx: driver version 0.1.37
[   90.510383] pm80xx 0000:01:00.0: enabling device (0000 -> 0002)
[   91.371537] scsi host4: pm80xx
[   91.371787] pm80xx 0000:01:00.0: irq 30 for MSI/MSI-X
...
[   91.374906] pm80xx 0000:01:00.0: irq 93 for MSI/MSI-X
[   91.869604] sas: phy-4:0 added to port-4:0, phy_mask:0x1 (5001438023aad066)
[   91.870157] sas: phy-4:1 added to port-4:1, phy_mask:0x2 (5001438023aad066)
[   91.870683] sas: phy-4:2 added to port-4:2, phy_mask:0x4 (5001438023aad066)
[   91.871211] sas: phy-4:3 added to port-4:3, phy_mask:0x8 (5001438023aad066)
[   91.871688] sas: DOING DISCOVERY on port 0, pid:137
[   91.875186] pm80xx mpi_smp_completion 2604:smp IO status 0x2
[   91.875770] sas: expander 5001438023aad066 discovery failed(0xffffffa6)
[   91.876491] sas: DONE DISCOVERY on port 0, pid:137, result:-90
[   91.877029] sas: DOING DISCOVERY on port 1, pid:137
[   91.878057] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.878675] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.879282] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.879883] sas: RG to ex 5001438023aad066 failed:0xffffffba
[   91.880794] sas: DONE DISCOVERY on port 1, pid:137, result:-70
[   91.881465] sas: DOING DISCOVERY on port 2, pid:137
[   91.882664] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.883413] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.884154] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.884861] sas: RG to ex 5001438023aad066 failed:0xffffffba
[   91.886227] sas: DONE DISCOVERY on port 2, pid:137, result:-70
[   91.886957] sas: DOING DISCOVERY on port 3, pid:137
[   91.888161] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.889470] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.890270] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   91.891055] sas: RG to ex 5001438023aad066 failed:0xffffffba
[   91.892008] sas: DONE DISCOVERY on port 3, pid:137, result:-70

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
