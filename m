From: Sergey Panov <sipan@sipan.org>
Subject: What "tarnsport attributes" are really for?
Date: Mon, 30 Aug 2004 01:00:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093842055.9886.57.camel@sipan.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:41430 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S266627AbUH3FBC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 01:01:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Hello,
I searched and read all threads about "transport attributes" I could
find in linux-scsi archive, but real design goals of this API still is
not clear. Is it supposed to be:

1) way to store and expose to admin (via syfs) specifics of the
underlying transport layer (such as FC, iSCSI, SPI, ...).

2) way to store transport specific per-device (per LUN) attributes.

3) way to access transport specific per-device (per LUN) attributes
stored in the driver.

?

It looks like that current implementation is aiming to be case (2), but
in reality it is just case (3). I noticed that every time attribute is
queried via sysfs LLD is asked to update it. 

I hope the actual goal is (1). In that case we should be able to add
transport specific host attributes and may prevent unnecessary
replication of the same FC/iSCSI info for every LUN on some big storage
array. 

Before I looked at /sys/class/fc_transport, I expected to find there a
tree for every host, with some extra host info in the root dir and
subdirs for every known transport end-point. In that tree you should
also see links to entries in /sys/class/scsi_host/ and
/sys/class/scsi_device/ , and not links to PCI device dir and SD driver
dir, which are there now.


-- 
Sergey Panov <sipan@sipan.org>
Home


