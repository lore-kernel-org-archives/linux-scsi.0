From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 25/42] hpsa: do not print ioaccel2 warning messages about
 unusual completions.
Date: Thu, 23 Apr 2015 09:34:00 -0500
Message-ID: <20150423143400.18832.27617.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46908 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966081AbbDWOfI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:35:08 -0400
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 31447631F3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 14:35:08 +0000 (UTC)
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

The SCSI midlayer already prints more detail about completions,
and has logging level options to filter them if not wanted.
These just slow down the system if a lot of errors occur,
stressing error handling even more.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 224fc48..870cf57 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1871,9 +1871,6 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 		case IOACCEL2_STATUS_SR_TASK_COMP_GOOD:
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_CHK_COND:
-			dev_warn(&h->pdev->dev,
-				"%s: task complete with check condition.\n",
-				"HP SSD Smart Path");
 			cmd->result |= SAM_STAT_CHECK_CONDITION;
 			if (c2->error_data.data_present !=
 					IOACCEL2_SENSE_DATA_PRESENT) {
@@ -1893,30 +1890,18 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_BUSY:
-			dev_warn(&h->pdev->dev,
-				"%s: task complete with BUSY status.\n",
-				"HP SSD Smart Path");
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_RES_CON:
-			dev_warn(&h->pdev->dev,
-				"%s: task complete with reservation conflict.\n",
-				"HP SSD Smart Path");
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL:
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_ABORTED:
-			dev_warn(&h->pdev->dev,
-				"%s: task complete with aborted status.\n",
-				"HP SSD Smart Path");
 			retry = 1;
 			break;
 		default:
-			dev_warn(&h->pdev->dev,
-				"%s: task complete with unrecognized status: 0x%02x\n",
-				"HP SSD Smart Path", c2->error_data.status);
 			retry = 1;
 			break;
 		}
@@ -1943,9 +1928,6 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			break;
 		default:
 			retry = 1;
-			dev_warn(&h->pdev->dev,
-				"unexpected delivery or target failure, status = 0x%02x\n",
-				c2->error_data.status);
 		}
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_COMPLETE:
@@ -1953,17 +1935,11 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 	case IOACCEL2_SERV_RESPONSE_TMF_SUCCESS:
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_REJECTED:
-		dev_warn(&h->pdev->dev, "task management function rejected.\n");
 		retry = 1;
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_WRONG_LUN:
-		dev_warn(&h->pdev->dev, "task management function invalid LUN\n");
 		break;
 	default:
-		dev_warn(&h->pdev->dev,
-			"%s: Unrecognized server response: 0x%02x\n",
-			"HP SSD Smart Path",
-			c2->error_data.serv_response);
 		retry = 1;
 		break;
 	}

