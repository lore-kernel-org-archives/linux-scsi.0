From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Thu, 02 Aug 2007 23:39:55 +0200
Message-ID: <46B24F2B.2060905@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <1185455711.3501.46.camel@localhost.localdomain> <200707271729.11422.rob@landley.net> <46B2256A.3070902@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46679 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXHBVkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 17:40:18 -0400
In-Reply-To: <46B2256A.3070902@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> Rob Landley wrote:
>> So if you don't attach an sg to every sd, then either there are holes, or they 
>> don't line up, in which case how do you tell which sg goes with a given sd?

Sysfs has pointers from a SCSI logical unit device to the corresponding
sd device and sg device...

$ ll /sys/bus/scsi/devices/1\:0\:0\:0/[bg]*
lrwxrwxrwx 1 root root 0 Aug  2 23:23
/sys/bus/scsi/devices/1:0:0:0/block:sdb -> ../../../../../../block/sdb
lrwxrwxrwx 1 root root 0 Aug  2 23:23
/sys/bus/scsi/devices/1:0:0:0/generic ->
../../../../../../class/scsi_generic/sg1


...as well as from the sd and sg devices to the corresponding SCSI
logical unit device:

$ ll /sys/block/sdb/device
lrwxrwxrwx 1 root root 0 Aug  2 23:27 /sys/block/sdb/device ->
../../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0

$ ll /sys/class/scsi_generic/sg1/device
lrwxrwxrwx 1 root root 0 Aug  2 23:24 /sys/class/scsi_generic/sg1/device
-> ../../../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0


The place where these symlinks live might change in the future.  See
linux-2.6.23*/Documentation/sysfs-rules.txt.
-- 
Stefan Richter
-=====-=-=== =--- ---=-
http://arcgraph.de/sr/
