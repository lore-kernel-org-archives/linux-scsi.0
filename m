From: guy keren <choo@actcom.co.il>
Subject: questions regarding O_DIRECT with SCSI, and timeout handling
Date: Wed, 19 Nov 2008 00:29:00 +0200
Message-ID: <492341AC.3080101@actcom.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.bezeqint.net ([192.115.188.209]:54349 "EHLO
	out3.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYKRWmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2008 17:42:47 -0500
Received: from [192.117.103.230] (line103-230.adsl.actcom.co.il [192.117.103.230])
	by out3.bezeqint.net (Postfix) with ESMTPA id C7F935E086C
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2008 23:30:34 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

i have two questions, for which i didn't manage to find a clear answer 
so far. i hope it is ok to ask them here.

1. when opening a SCSI disk block device file with O_DIRECT - am i 
guranteed that requests being send using read() or write() system calls 
are transfered all the way to the device before returning, or might they 
get queued in the low-level device driver? am i guaranteed that the 
read() or write() system call will return only when all the underlying 
SCSI Commands have completed fully? if not - is there a general way to 
achieve this, or do i have to resort to device-specific solutions?

does it matter if this is a real disk device, or a SCSI-over-something 
(E.g. iscsi) connection?


2. when sending a SCSI command, a time-out is being delivered with it 
from the SCSI mid-layer down to the lower-layer driver (HBA driver, 
iscsi driver, etc.). when does the system start to count the time - when 
the command was queued to the low-level driver? or when the low-level 
driver sent the command to the underlying device (e.g. an internal disk, 
external RAID, etc)? or does the system start to count the time before this?

thanks,
--guy
