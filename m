From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/2] hpsa: fix potential overrun while memcpy'ing sense data
Date: Fri, 03 Jun 2011 09:57:34 -0500
Message-ID: <20110603145734.17254.10804.stgit@beardog.cce.hp.com>
References: <20110603145639.17254.54228.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20525 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab1FCO5f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 10:57:35 -0400
In-Reply-To: <20110603145639.17254.54228.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This memcpy:

   memcpy(cmd->sense_buffer, ei->SenseInfo,
	   ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
		   SCSI_SENSE_BUFFERSIZE :
		   ei->SenseLen);

The ei->SenseLen field is filled in by the Smart Array.  For requests to
logical drives, it will not exceed 32 bytes, so should be ok, but for physical
requests it depends on the target device, not the Smart Array.  It's conceivable
that this could exceed the 32 byte size of ei->SenseInfo.  In that case, the memcpy
would read past the end of ei->SenseInfo, copying data from the next command,
as if it were sense data, or, if it happened to be the very last command in the
block of allocated commands, could fall off the end of the allocated area and
crash.  I'm not aware of anyone ever encountering this behavior, but it could
conceivably happen.  This bug was found by Coverity.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a75122d..6bba23a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1037,6 +1037,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	unsigned char sense_key;
 	unsigned char asc;      /* additional sense code */
 	unsigned char ascq;     /* additional sense code qualifier */
+	unsigned long sense_data_size;
 
 	ei = cp->err_info;
 	cmd = (struct scsi_cmnd *) cp->scsi_cmd;
@@ -1051,10 +1052,14 @@ static void complete_scsi_command(struct CommandList *cp)
 	cmd->result |= ei->ScsiStatus;
 
 	/* copy the sense data whether we need to or not. */
-	memcpy(cmd->sense_buffer, ei->SenseInfo,
-		ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
-			SCSI_SENSE_BUFFERSIZE :
-			ei->SenseLen);
+	if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
+		sense_data_size = SCSI_SENSE_BUFFERSIZE;
+	else
+		sense_data_size = sizeof(ei->SenseInfo);
+	if (ei->SenseLen < sense_data_size)
+		sense_data_size = ei->SenseLen;
+
+	memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
 	if (ei->CommandStatus == 0) {

