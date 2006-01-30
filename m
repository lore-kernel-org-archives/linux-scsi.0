From: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Subject: Large Sequential Reads Being Broken Up. Why?
Date: Mon, 30 Jan 2006 10:20:16 -0500
Message-ID: <43DE2EB0.2040700@datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postoffice.datadirectnet.com ([64.213.193.141]:44430 "EHLO
	postoffice.datadirectnet.com") by vger.kernel.org with ESMTP
	id S932313AbWA3PTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 10:19:09 -0500
Received: from localhost (localhost [127.0.0.1])
	by postoffice.datadirectnet.com (Postfix) with ESMTP id 1A65236B2D3C
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2006 07:19:09 -0800 (PST)
Received: from postoffice.datadirectnet.com ([127.0.0.1])
 by localhost (postoffice.datadirectnet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22782-10 for <linux-scsi@vger.kernel.org>;
 Mon, 30 Jan 2006 07:19:08 -0800 (PST)
Received: from [127.0.0.1] (ddneng.com [70.88.130.31])
	by postoffice.datadirectnet.com (Postfix) with ESMTP id 3B694340275F
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2006 07:19:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am running a program on my Linux box which is asking for 2M IO (reads 
and writes) with the file handle being opened with the O_DIRECT flag. 
However, the IO being put out on the wire is no larger than 512K.  My 
target device is the SCSI block device (/dev/sdb in this case). What is 
preventing me from getting large IO through the SCSI block layer? How 
can I fix it?

The sg device can achieve the 2M IO size, so I know its at least 
possible. How can I improve the IO size for the SCSI block layer?

Details:

Dell 2850 server with dual Xeons, 1G RAM
OS: Linux racerx 2.6.11.4-21.10-smp #1 SMP Tue Nov 29 14:32:49 UTC 2005 
x86_64 x86_64 x86_64 GNU/Linux
Emulex LP11000 Fibre Channel HBA using driver version 8.0.13 (changing 
the driver hasn't helped, so far)
I set the lookahead value pretty large to improve read performance 
(hdparm -a)
The scheduler for this device is anticipatory.

Any ideas?

Thanks,
Martin Schlining




