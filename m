From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 18/24] hpsa: report check condition even if no sense data
	present for ioaccel2 mode
Date: Thu, 29 May 2014 10:53:54 -0500
Message-ID: <20140529155354.8180.5999.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19914 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074AbaE2Pzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:47 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id ECDEEE99
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:36:29 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It shouldn't happen that we get a check condition with no sense data, but if it
does, we shouldn't just drop the check condition on the floor.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Justin Lindley <justin.lindley@hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
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

