From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 18/19] hpsa: report check condition even if no sense data
	present for ioaccel2 mode
Date: Thu, 08 May 2014 14:28:56 -0500
Message-ID: <20140508192856.13481.43269.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44543 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaEHT3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:47 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It shouldn't happen that we get a check condition with no sense data, but if it
does, we shouldn't just drop the check condition on the floor.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9d4a0bd..3446b8d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1556,9 +1556,13 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			dev_warn(&h->pdev->dev,
 				"%s: task complete with check condition.\n",
 				"HP SSD Smart Path");
+			cmd->result |= SAM_STAT_CHECK_CONDITION;
 			if (c2->error_data.data_present !=
-					IOACCEL2_SENSE_DATA_PRESENT)
+					IOACCEL2_SENSE_DATA_PRESENT) {
+				memset(cmd->sense_buffer, 0,
+					SCSI_SENSE_BUFFERSIZE);
 				break;
+			}
 			/* copy the sense data */
 			data_len = c2->error_data.sense_data_len;
 			if (data_len > SCSI_SENSE_BUFFERSIZE)
@@ -1568,7 +1572,6 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 					sizeof(c2->error_data.sense_data_buff);
 			memcpy(cmd->sense_buffer,
 				c2->error_data.sense_data_buff, data_len);
-			cmd->result |= SAM_STAT_CHECK_CONDITION;
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_BUSY:

