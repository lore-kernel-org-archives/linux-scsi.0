From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: [RFC] scsi_device printk helper macro - sdev_printk
Date: Mon, 29 Sep 2003 14:03:04 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309291403.04443.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:48594 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262412AbTI2VEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 17:04:09 -0400
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e5.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id h8TL48Ed730694
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 17:04:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Larry Kessler <lkessler@us.ibm.com>, James Keniston <kenistoj@us.ibm.com>


The purpose of the sdev_printk macro, which is intended for the scsi mid-layer 
and LLDs, is to help with the following:

- Adding consistency to printk messages in mid-layer and LLDs where 
scsi_device is concerned. Scsi_device information will be printed in the same 
consistent format. A consistent format will help readability and provide a 
means to automate responding to log messages.

- Identifing a printk with a specific scsi_device. 

- Providing one point for changing what identification information is printed. 
Instead of having to edit every single printk, one could simply change the 
macro. 

The patch below does a couple things:

1) Moves setting scsi_device's sdev_gendev struct device bus_id from 
scsi_sysfs.c to scsi_scan.c.

2) Adds sdev_printk definition to scsi_device.h

3) Replaces many printks in the mid-layer with sdev_printk.

Please take a look, all comments and suggestions are welcome.

Thanks,

Dan


Example Output - Rescan
-----------------------------


Sep 26 13:31:48 elm3b99 kernel: scsi_scan_host_selected: 
<3:4294967295:4294967295:4294967295>
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:0>: scan: Sending REPORT LUNS (try 
0)
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:0>: scan: REPORT LUNS failed (try 
0) result 0x8000002
Sep 26 13:31:48 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 0
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:1>: scan: INQUIRY to host
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:0:1>: scan: 1st INQUIRY failed with 
code 0x10000
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:0>: scan: Sending REPORT LUNS (try 
0)
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:0>: scan: REPORT LUNS failed (try 
0) result 0x8000002
Sep 26 13:31:48 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 1
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:1>: scan: INQUIRY to host
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:1:1>: scan: 1st INQUIRY failed with 
code 0x10000
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:2:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 2
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:2:1>: scan: INQUIRY to host
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:2:1>: scan: 1st INQUIRY failed with 
code 0x10000
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:3:0>: scan: device found
Sep 26 13:31:48 elm3b99 kernel: scsi <3:0:3:0>: scan: Sending REPORT LUNS (try 
0)
Sep 26 13:31:49 elm3b99 kernel: scsi <3:0:3:0>: scan: REPORT LUNS failed (try 
0) result 0x8000002
Sep 26 13:31:49 elm3b99 kernel: scsi scan: Sequential scan of host 3 channel 0 
id 3
Sep 26 13:31:49 elm3b99 kernel: scsi <3:0:3:1>: scan: INQUIRY to host
Sep 26 13:31:49 elm3b99 kernel: scsi <3:0:3:1>: scan: 1st INQUIRY failed with 
code 0x10000


Example Patch Follows:
--------------------------



