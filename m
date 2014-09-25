From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] New: pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Thu, 25 Sep 2014 14:44:58 +0000
Message-ID: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49516 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaIYOpJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 10:45:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DDE8920295
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 14:45:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 795EA20279
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 14:44:59 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

            Bug ID: 85151
           Summary: pm80xx + 7805H + HP SAS port expander =
                    mpi_smp_completion 2604:smp IO status 0x2 and sas:
                    expander ... discovery failed(0xffffffa6)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.17
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: linux-ide@crashplan.pro
        Regression: No

ASRock H81 + Intel Celeron G1840
 Adaptec 7805H
  HP SAS Expander, firmware 2.08

Steps to reproduce:
1. blacklist pm80xx
2. reboot
3. modprobe -v pm80xx
insmod
/lib/modules/3.17.0-999-generic/kernel/drivers/scsi/scsi_transport_sas.ko
insmod /lib/modules/3.17.0-999-generic/kernel/drivers/scsi/libsas/libsas.ko
insmod /lib/modules/3.17.0-999-generic/kernel/drivers/scsi/pm8001/pm80xx.ko

Dmesg output returns failure and sas discovery failure messages. And "lsscsi
-g" does not show new devices.


Dmesg output:
[   85.396376] pm80xx 0000:01:00.0: pm80xx: driver version 0.1.37
[   85.396441] pm80xx 0000:01:00.0: enabling device (0000 -> 0002)
[   86.258014] scsi host2: pm80xx
[   86.258261] pm80xx 0000:01:00.0: irq 29 for MSI/MSI-X
...
[   86.261347] pm80xx 0000:01:00.0: irq 92 for MSI/MSI-X
[   86.757671] sas: phy-2:4 added to port-2:0, phy_mask:0x10 (5001438023aad066)
[   86.758242] sas: phy-2:5 added to port-2:1, phy_mask:0x20 (5001438023aad066)
[   86.758699] sas: phy-2:6 added to port-2:2, phy_mask:0x40 (5001438023aad066)
[   86.759163] sas: phy-2:7 added to port-2:3, phy_mask:0x80 (5001438023aad066)
[   86.759579] sas: DOING DISCOVERY on port 0, pid:60
[   86.762141] pm80xx mpi_smp_completion 2604:smp IO status 0x2
[   86.762587] sas: expander 5001438023aad066 discovery failed(0xffffffa6)
[   86.763278] sas: DONE DISCOVERY on port 0, pid:60, result:-90
[   86.763766] sas: DOING DISCOVERY on port 1, pid:60
[   86.764597] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.765155] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.765710] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.766269] sas: RG to ex 5001438023aad066 failed:0xffffffba
[   86.767097] sas: DONE DISCOVERY on port 1, pid:60, result:-70
[   86.767704] sas: DOING DISCOVERY on port 2, pid:60
[   86.768601] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.769272] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.769981] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.770601] sas: RG to ex 5001438023aad066 failed:0xffffffba
[   86.771400] sas: DONE DISCOVERY on port 2, pid:60, result:-70
[   86.772067] sas: DOING DISCOVERY on port 3, pid:60
[   86.773587] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.774592] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.775596] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[   86.776273] sas: RG to ex 5001438023aad066 failed:0xffffffba
[   86.778343] sas: DONE DISCOVERY on port 3, pid:60, result:-70

Regression:
1. Different HBA SAS connector, SAS cable and HP SAS expander:
[  558.633914] pm80xx 0000:01:00.0: pm80xx: driver version 0.1.37
[  558.633984] pm80xx 0000:01:00.0: enabling device (0000 -> 0002)
[  559.495069] scsi host2: pm80xx
[  559.495922] pm80xx 0000:01:00.0: irq 29 for MSI/MSI-X
...
[  559.499132] pm80xx 0000:01:00.0: irq 92 for MSI/MSI-X
[  559.993123] sas: phy-2:0 added to port-2:0, phy_mask:0x1 (5001438018c7ed26)
[  559.993660] sas: phy-2:1 added to port-2:1, phy_mask:0x2 (5001438018c7ed26)
[  559.994187] sas: phy-2:2 added to port-2:2, phy_mask:0x4 (5001438018c7ed26)
[  559.994997] sas: phy-2:3 added to port-2:3, phy_mask:0x8 (5001438018c7ed26)
[  559.995429] sas: DOING DISCOVERY on port 0, pid:1017
[  559.999109] pm80xx mpi_smp_completion 2604:smp IO status 0x2
[  559.999551] sas: expander 5001438018c7ed26 discovery failed(0xffffffa6)
[  560.000294] sas: DONE DISCOVERY on port 0, pid:1017, result:-90
[  560.000787] sas: DOING DISCOVERY on port 1, pid:1017
[  560.001896] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.002457] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.003131] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.003688] sas: RG to ex 5001438018c7ed26 failed:0xffffffba
[  560.004459] sas: DONE DISCOVERY on port 1, pid:1017, result:-70
[  560.005104] sas: DOING DISCOVERY on port 2, pid:1017
[  560.005975] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.006697] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.007500] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.008174] sas: RG to ex 5001438018c7ed26 failed:0xffffffba
[  560.009052] sas: DONE DISCOVERY on port 2, pid:1017, result:-70
[  560.009818] sas: DOING DISCOVERY on port 3, pid:1017
[  560.012035] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.012849] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.013585] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  560.014305] sas: RG to ex 5001438018c7ed26 failed:0xffffffba
[  560.015652] sas: DONE DISCOVERY on port 3, pid:1017, result:-70

Despite the failure messages, the pm80xx module seems to load fine:
# lsmod | grep pm80xx
pm80xx                158147  0
libsas                 89155  1 pm80xx
scsi_transport_sas     41028  2 libsas,pm80xx
# dmesg
[   19.226666] pm80xx 0000:01:00.0: pm80xx: driver version 0.1.37
[   19.226738] pm80xx 0000:01:00.0: enabling device (0000 -> 0002)
[   20.088440] scsi host2: pm80xx
[   20.088768] pm80xx 0000:01:00.0: irq 29 for MSI/MSI-X
...till...
[   20.091913] pm80xx 0000:01:00.0: irq 92 for MSI/MSI-X

LED status of the Adaptec 7805 host bus adapter:
BOOT = off
RAAE = off
IOP0 = off
IOP1 = off
Activity 0 = off
Activity 1 = solid green
Activity 2 = off
Activity 3 = off

LED status of the HP SAS expander card:
CR1 = solid green
CR2 = solid green
CR3 = solid green
CR4 = off
CR5 = off
CR6 = blinks green

uname -a
Linux ubuntu14 3.17.0-999-generic #201409240305 SMP Wed Sep 24 02:07:04 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
