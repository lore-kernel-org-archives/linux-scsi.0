From: akpm@linux-foundation.org
Subject: [patch for 2.6.33? 1/2] hpsa: fix scsi status reporting yet again.
Date: Tue, 02 Feb 2010 14:12:35 -0800
Message-ID: <201002022212.o12MCZjR017496@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756991Ab0BBWMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2010 17:12:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, scameron@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Fix scsi status reporting yet again, reverting an earlier attempt.  The
status byte does not need to be shifted << 1.  Code in other drivers that
does "scp->result |= CHECK_CONDITION << 1;" works because CHECK_CONDITION
macro is pre-shifted right 1 bit.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-scsi-status-reporting-yet-again drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-scsi-status-reporting-yet-again
+++ a/drivers/scsi/hpsa.c
@@ -930,7 +930,7 @@ static void complete_scsi_command(struct
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus << 1);
+	cmd->result |= ei->ScsiStatus;
 
 	/* copy the sense data whether we need to or not. */
 	memcpy(cmd->sense_buffer, ei->SenseInfo,
_
