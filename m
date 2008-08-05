From: Martin Petermann <martin@linux.vnet.ibm.com>
Subject: With kernel 2.6.19 no sg devices for devices that return PQ=1, PDT=0x1f
Date: Tue, 05 Aug 2008 14:40:00 +0200
Message-ID: <48984A20.2050002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:50312 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbYHENGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 09:06:31 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.8/8.13.8) with ESMTP id m75CdHTG578544
	for <linux-scsi@vger.kernel.org>; Tue, 5 Aug 2008 12:39:17 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m75CdHnF4259978
	for <linux-scsi@vger.kernel.org>; Tue, 5 Aug 2008 14:39:17 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m75CdGra016629
	for <linux-scsi@vger.kernel.org>; Tue, 5 Aug 2008 14:39:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

With kernel 2.6.19 a change was introduced that no sg device was 
generated if PQ=1, PDT=0x1f was returned from the particular device:

commit 84961f28e9d13a4b193d0c8545f3c060c1890ff3
Author: dave wysochanski <davidw@netapp.com>
Date:   Wed Aug 9 14:56:32 2006 -0400

     [SCSI] Don't add scsi_device for devices that return PQ=1, PDT=0x1f

Before it was possible on Linux 390 in user space to a e.g. LUN 0 to a 
port and to receive a generic device:

t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
total 0
-r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
-rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
-r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
-r--r--r-- 1 root root 4096 Aug  4 12:07 status
--w------- 1 root root 4096 Aug  4 12:07 uevent
--w------- 1 root root    0 Aug  4 13:46 unit_add
--w------- 1 root root    0 Aug  5 14:24 unit_remove
t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # echo 0 > 
unit_add
t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
total 0
drwxr-xr-x 2 root root    0 Aug  5 14:25 0x0000000000000000
-r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
-rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
-r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
-r--r--r-- 1 root root 4096 Aug  4 12:07 status
--w------- 1 root root 4096 Aug  4 12:07 uevent
--w------- 1 root root    0 Aug  5 14:25 unit_add
--w------- 1 root root    0 Aug  5 14:24 unit_remove
t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # lsscsi -g
[0:0:0:0]    no dev  IBM      2107900          2.27  -         /dev/sg0

After this fix there is no /dev/sg0 device generated.

We are utilizing the possibility to create such a device for the 
sg_utils commands in the case no other LUN has been attached to a port.

I do not want to put this fix into question. I would like to know if 
someone has an idea how to workaround this problem and to generate a 
generic device in user space using kernel 2.6.19 or a later version.

Regards
    Martin

