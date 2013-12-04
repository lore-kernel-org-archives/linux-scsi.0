From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 9/9] hpsa: allow SCSI mid layer to handle unit attention
Date: Wed, 04 Dec 2013 17:10:36 -0600
Message-ID: <20131204231036.21798.92520.stgit@beardog.cce.hp.com>
References: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:40225 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3LDXKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 18:10:37 -0500
In-Reply-To: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Matt Gates <matthew.gates@hp.com>

We were clobbering the SCSI status and setting
cmd->result = DID_SOFT_ERROR << 16; to get a retry,
but better to let the mid layer handle the unit
attention.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 693c801..107f3c4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1240,10 +1240,8 @@ static void complete_scsi_command(struct CommandList *cp)
 		}
 
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
-			if (check_for_unit_attention(h, cp)) {
-				cmd->result = DID_SOFT_ERROR << 16;
+			if (check_for_unit_attention(h, cp))
 				break;
-			}
 			if (sense_key == ILLEGAL_REQUEST) {
 				/*
 				 * SCSI REPORT_LUNS is commonly unsupported on

