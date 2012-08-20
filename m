From: joystick <joystick@shiftmail.org>
Subject: Using SCSI timeouts in place of ERC
Date: Mon, 20 Aug 2012 13:37:00 +0200
Message-ID: <5032215C.9080105@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:2577 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2HTLgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 07:36:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hello lists
I am wondering what kind of support I can get from linux for 
"inexpensive" (SATA over SAS HBA in my case) disks on RAID ...
Inexpensive non-raid-edition disks haven't got settable ERC timeout 
(scterc) and can take very long time to respond in case of unreadable sector
However I see an /dev/sdX/device/timeout tunable
Supposing that I accept one disk being dropped from the array at the 
first unreadable sector, can I set that tunable low such as 10sec and 
live happy?

Unfortunately I have read that the expiration of the SCSI timeout can 
trigger a "Host" reset in case the drive does not respond to a reset message
https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/task_controlling-scsi-command-timer-onlining-devices.html
would that drop all my drives from the array? That would be a major problem.

Firstly, in "reset the bus": isn't the bus just an electrical wire? How 
can it be "reset" and what does that do? I can understand in the case of 
iSCSI the bus is maybe the TCP socket, I can somehow understand that it 
can be reset, but what about physically attached disks?
I suppose "device" is the disk.. ok for that one, suppose it's doomed
I suppose "host" is the HBA card... so what does a reset of the HBA do? 
Does it drop all the drives and rescan? MD wouldn't react well *at all* 
to this

Thank you
J
