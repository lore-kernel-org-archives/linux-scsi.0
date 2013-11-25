From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: qla2xxx: automatically rescan removed luns.
Date: Mon, 25 Nov 2013 15:37:24 +0000
Message-ID: <52936EB4.4090508@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.blacknight.com ([78.153.203.205]:49301 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3KYPos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2013 10:44:48 -0500
Received: from [10.0.2.163] (unknown [91.123.228.39])
	by relay2.blacknight.com (Postfix) with ESMTP id A368339407A
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2013 15:37:24 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Using the qla2xxx driver from Linux 3.10.1 (release), if a LUN from the 
target side (multiple drives exported over a LIO IBlock qla2xxx export) 
is removed at the LIO level, the initiator side will not automatically 
detect that this LUN was removed.

All commands to this LUN will fail (sg_inq, read, writes) but the 
qla2xxx will never kick the drive out.

If another drive was to be exported on the target side using the same 
lun as the previously removed drive, commands sent to the same block id 
would now work again but be sent to the new LUN.

I tried to echo "- - -" in the scsi_host sysfs "scan" file corresponding 
to the FC port. This worked to detect new LUNs but not to "clear" 
removed ones.

I tried issuing a lip_reset on both sides, but no change.

Looking through Google, I realized that, on RedHat, a /proc/scsi/qla2xxx 
virtual FS exists which allows to send a "scsi-qlascan" command to the 
driver that apparently can detect removed LUNs. Unfortunately I don't 
have this FS visible on my Linux kernel, and I made sure /proc/scsi was 
enabled.

The only way I found was to "echo 1 > /sys/block/sdX/device/delete" to 
the stale device (that corresponds to the removed LUN from the target 
side), then replace the removed LUN on the target side before finally 
issuing a "scan" command on the initiator side.

Am I missing something here? Is there a way to rescan a Qlogic FC port 
using the "qla2xxx" driver from the official, stock kernel?

Thank you very much in advance for your help!

Regards,

Ben - MPSTOR
