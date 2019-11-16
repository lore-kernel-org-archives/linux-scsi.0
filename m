Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0037FC432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A8E2073B
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKPDrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 22:47:40 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:35260 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfKPDrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 22:47:40 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 86FF92A71F; Fri, 15 Nov 2019 22:47:39 -0500 (EST)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        "Ondrej Zary" <linux@zary.sk>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <4277b28ee2551f884aefa85965ef3c498344f301.1573875417.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] NCR5380: Unconditionally clear ICR after do_abort()
Date:   Sat, 16 Nov 2019 14:36:57 +1100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When do_abort() succeeds, the target will go to BUS FREE phase and
there will be no connected command. Therefore, that function should
clear the Initiator Command Register before returning. It already does
so in case of NCR5380_poll_politely() failure; do the same for the
other error case too, that is, NCR5380_transfer_pio() failure.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Ondrej Zary <linux@zary.sk>
Reviewed-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3ea2557e7938..f2f7e6e76c07 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1396,7 +1396,7 @@ static void do_reset(struct Scsi_Host *instance)
  * MESSAGE OUT phase and sending an ABORT message.
  * @instance: relevant scsi host instance
  *
- * Returns 0 on success, -1 on failure.
+ * Returns 0 on success, negative error code on failure.
  */
 
 static int do_abort(struct Scsi_Host *instance)
@@ -1421,7 +1421,7 @@ static int do_abort(struct Scsi_Host *instance)
 
 	rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
 	if (rc < 0)
-		goto timeout;
+		goto out;
 
 	tmp = NCR5380_read(STATUS_REG) & PHASE_MASK;
 
@@ -1432,7 +1432,7 @@ static int do_abort(struct Scsi_Host *instance)
 		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 		rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0, 3 * HZ);
 		if (rc < 0)
-			goto timeout;
+			goto out;
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 	}
 
@@ -1441,17 +1441,17 @@ static int do_abort(struct Scsi_Host *instance)
 	len = 1;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &msgptr);
+	if (len)
+		rc = -ENXIO;
 
 	/*
 	 * If we got here, and the command completed successfully,
 	 * we're about to go into bus free state.
 	 */
 
-	return len ? -1 : 0;
-
-timeout:
+out:
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	return -1;
+	return rc;
 }
 
 /*
@@ -2283,7 +2283,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
 		hostdata->connected = NULL;
 		hostdata->dma_len = 0;
-		if (do_abort(instance)) {
+		if (do_abort(instance) < 0) {
 			set_host_byte(cmd, DID_ERROR);
 			complete_cmd(instance, cmd);
 			result = FAILED;
-- 
2.23.0

