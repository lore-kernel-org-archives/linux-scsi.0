From: Douglas Gilbert <dougg@torque.net>
Subject: scsi sysfs design, ch driver
Date: Sun, 16 Oct 2005 15:50:19 +1000
Message-ID: <4351EA1B.6020402@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:20708 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751292AbVJPFtV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 01:49:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 7B0943946FA
	for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2005 15:49:20 +1000 (EST)
Received: from [192.168.48.80] (dsl-237.26.240.220.dsl.comindico.com.au [220.240.26.237])
	by borg.st.net.au (Postfix) with ESMTP id 705EE3946F9
	for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2005 15:49:18 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

I am trying to map programmatically from an sg device
to whatever [if it has a corresponding upper level device].
The code is looking at this directory:
/sys/devices/pseudo_0/adapter0/host1/target1:0:0/1:0:0:0

and is confronted with these choices:

bus             iocounterbits  power        scsi_changer:sch0    timeout
delete          iodone_cnt     queue_depth  scsi_device:1:0:0:0  type
device_blocked  ioerr_cnt      queue_type   scsi_generic:sg0     vendor
driver          iorequest_cnt  rescan       scsi_level
generic         model          rev          state

Now if it was a block device (sd or sr) there would be a
"block" symlink to follow; if it was a tape device there
would be a "tape" symlink to follow. However as can be seen
it is a medium changer, so why not a "changer" symlink?
The "scsi_changer:sch0" symlink has a useless appendage IMO.
The directory needs to be scanned to find it, and when followed,
if my code is interested, then there are several ways to
determine that its sysfs name is sch0.

So my question is why was "scsi_generic:sg0" form introduced,
especially the ":sg0" part? It may help visually but it
is a nuisance programmatically.

Doug Gilbert
