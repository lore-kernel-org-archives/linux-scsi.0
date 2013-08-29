From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH]scsi disk: disk offline prematurely from medium access timeout
Date: Thu, 29 Aug 2013 15:34:31 -0400
Message-ID: <20130829193431.GA3979@fury.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab3H2TgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 15:36:07 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7TJa69n007322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 15:36:06 -0400
Received: from fury.redhat.com (vpn-56-214.rdu2.redhat.com [10.10.56.214])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7TJa4NU015556
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 15:36:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There is an error with the medium access timeout feature of the sd driver. The
sdkp->medium_access_timed_out value is set to zero in sd_done() in the wrong
place.  It is set to zero only if a command returns sense data.  If an I/O
command times out, error handling succeeds, and the I/O command completes, the
value won't be reset if nothing generates a sense response.  Then, another
timeout (no matter how far in the future) can increment it again, causing the
device to be prematurely set offline.

The resetting of sdkp->medium_access_timed_out should occur before the check for
sense data.

Signed-off-by: David Jeffery <djeffery@redhat.com>

---

To reproduce using scsi_debug, use SCSI_DEBUG_OPT_TIMEOUT or
SCSI_DEBUG_OPT_MAC_TIMEOUT to force an I/O command to timeout.  Then, remove
the opt value so the I/O will succeed on retry.  Perform more I/O as desired.
Finally, repeat the process to make a new I/O command time out.  Without the
patch, the device will be marked offline even though many I/O commands have
succeeded between the 2 instances of timed out commands.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86fcf2c..2779e6b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1669,12 +1669,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 						   sshdr.ascq));
 	}
 #endif
+	sdkp->medium_access_timed_out = 0;
+
 	if (driver_byte(result) != DRIVER_SENSE &&
 	    (!sense_valid || sense_deferred))
 		goto out;
 
-	sdkp->medium_access_timed_out = 0;
-
 	switch (sshdr.sense_key) {
 	case HARDWARE_ERROR:
 	case MEDIUM_ERROR:
