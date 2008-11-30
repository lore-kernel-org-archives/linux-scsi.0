From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/7] megaraid_sas: switch to block timeout
Date: Sun, 30 Nov 2008 10:27:51 -0600
Message-ID: <1228062471.4115.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41384 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbYK3Q1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:27:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>, "Yang, Bo" <Bo.Yang@lsi.com>

megaraid_sas sets the timeout in its slave configure routine for devices
on special channels.  This now needs to update the request queue timeout
in block.

Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index a454f94..17ce7ab 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1016,7 +1016,8 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	 * The RAID firmware may require extended timeouts.
 	 */
 	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-		sdev->timeout = MEGASAS_DEFAULT_CMD_TIMEOUT * HZ;
+		blk_queue_rq_timeout(sdev->request_queue,
+				     MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
 	return 0;
 }
 


