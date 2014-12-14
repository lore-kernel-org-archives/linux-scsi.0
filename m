From: John Gehring <jgehring@nexgenstorage.com>
Subject: Mode parameters changed followed by I/O error, disk failure, disabling
 device
Date: Sat, 13 Dec 2014 17:40:27 -0700
Message-ID: <548CDC7B.5060006@nexgenstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0079.outbound.protection.outlook.com ([157.56.111.79]:42194
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757AbaLNBOU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2014 20:14:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm working with a supermicro 6036ST-6LR, which includes a sas2 dual 
expander backplane allowing access to dual-port SAS drives from the two 
storage controllers in this system. I'm running into a case where 
submitting an sdparm or smartctl command to a drive from one of the 
controllers results in the log messages shown below on the partner 
controller. I'm running the 3.16.7 kernel and mpt2sas 19. This is new 
behaviour with the 3.16.7 kernel. The previous kernel used, 3.4.60 did 
not exhibit this behaviour. I can't figure out if this is expected 
behaviour or if there is a configuration or code change that could be 
made to stop this from happening (aside from not issuing those commands 
from the non-owning controller).

On my test system, I do the following:

* On the A controller, create a raid 6 array with 8 drives (md11).
* On the A controller, start a long running dd write against the md11 array.
* On the B controller, repeatedly execute sdparm --page=po 
--clear=IDLE_B,IDLE_C,STANDBY_Y -S /dev/sdb (sdb is in the md11 array on 
controller A).

Eventually, sdb is kicked out of the array. I can see that the mode 
parameters changed message is due to
asc==0x2a  - asymmetric access state changed
and
ascq==0x01 - access denied - initiator pending-enrolled


[83107.838064] sd 1:0:0:0: Mode parameters changed
[83107.838080] end_request: I/O error, dev sdb, sector 67592
[83107.838082] md: super_written gets error=-5, uptodate=0
[83107.838085] md/raid:md11: Disk failure on sdb2, disabling device.
[83107.838085] md/raid:md11: Operation continuing on 7 devices.

Bug or intended behaviour?

Thanks.
