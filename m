From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/41] hpsa: allow SCSI mid layer to handle unit attention
Date: Wed, 15 Jan 2014 16:36:54 -0600
Message-ID: <20140115223654.5061.71759.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6185 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaAOVgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:36:55 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

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
index ef7614f..6b53170 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1241,10 +1241,8 @@ static void complete_scsi_command(struct CommandList *cp)
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

