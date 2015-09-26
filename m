From: Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH] scsi_dh: Use the correct module name when loading device
 handler
Date: Sat, 26 Sep 2015 10:19:15 +1000
Message-ID: <20150926001915.GD12540@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:38132 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbIZATc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 20:19:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

This fixes a bug in recent kernels which results in failure to boot
on systems that have multipath SCSI disks.  I observed this failure
on a POWER8 server where all the disks are multipath SCSI disks.
The symptoms are several messages like this on the console:

[    3.018700] device-mapper: table: 253:0: multipath: error attaching hardware handler
[    3.018828] device-mapper: ioctl: error adding target to table

and the system does not find its disks, and therefore fails to boot.

Bisection revealed that the bug was introduced in commit 566079c849cf,
"dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath".
The specific reason for the failure is that where we previously loaded
the "scsi_dh_alua" module, we are now trying to load the "alua" module,
which doesn't exist.

To fix this, we change the request_module call in scsi_dh_lookup()
to prepend "scsi_dh_" to the name, just like the old code in
drivers/md/dm-mpath.c:parse_hw_handler() used to do.

Fixes: 566079c849cf
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 drivers/scsi/scsi_dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..0a2168e 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 
 	dh = __scsi_dh_lookup(name);
 	if (!dh) {
-		request_module(name);
+		request_module("scsi_dh_%s", name);
 		dh = __scsi_dh_lookup(name);
 	}
 
-- 
2.1.4

