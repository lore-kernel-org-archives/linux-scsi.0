From: Pierre Beck <mail@pierre-beck.de>
Subject: Tunables for timeout behaviour?
Date: Mon, 23 Apr 2012 23:12:00 +0200
Message-ID: <4F95C59A.7010706@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozy.pierre-beck.de ([178.63.78.113]:37269 "EHLO
	ozy.pierre-beck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab2DWVrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 17:47:45 -0400
Received: from p4ff4ac5c.dip.t-dialin.net ([79.244.172.92] helo=[192.168.1.102])
	by ozy.pierre-beck.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <mail@pierre-beck.de>)
	id 1SMQYC-0002op-H7
	for linux-scsi@vger.kernel.org; Mon, 23 Apr 2012 23:12:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

asking on the linux-raid list about implementing timeouts in mdraid, 
Neil Brown answered with a quite definitive "no" and said the next lower 
level should take care of timeouts. So here I am :-)

SCSI timeouts currently reset device, then bus, then host adapter. I 
currently experience bus and / or host adapter resets as several minutes 
of zero I/O on HW RAID cards. Can't speak for simple HBAs, but HW RAID 
cards seem to search for logical volumes on all attached disks or 
something and take ages to "reset" even in JBOD mode.

In other words, a bad sector may escalate to unnecessary long 
unavailability of a whole array of disks, despite mdraid in place. Yes, 
drives with TLER / SCTERC management should not spend much time on bad 
sectors, but not every drive supports that and a *failing* drive with 
crashed firmware won't be cooperative anyways.

So is there any way to influence this behaviour? I think the mdraid 
layer could profit alot from stopping retries at the device level. 
mdraid can simply fail the device and keep working. Neil mentioned 
"FAILFAST" flags that can be added to requests issued by mdraid, but 
reading a few patches I suspect these are meant for multipath only 
(there's zero documentation on FAILFAST?).

What I'd wish for was a tunable that goes along with 
/sys/bus/scsi/devices/.../timeout to limit escalation to a specific 
level and / or some way for mdraid to flag requests.

Greetings,

Pierre Beck

