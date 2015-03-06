From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 25/41] hpsa: do not print ioaccel2 warning messages about
 unusual completions.
Date: Fri, 06 Mar 2015 17:47:59 -0600
Message-ID: <20150306234759.29973.56856.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:50525 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbbCFXt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:49:29 -0500
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 3F91166E4A
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2015 23:49:29 +0000 (UTC)
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9015b68..0ad327e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1909,9 +1909,6 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 		case IOACCEL2_STATUS_SR_TASK_COMP_GOOD:
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_CHK_COND:
-			dev_warn(&h->pdev->dev,
-				"%s: task complete with check condition.\n",
-				"HP SSD Smart Path");
 			cmd->result |= SAM_STAT_CHECK_CONDITION;
 			if (c2->error_data.data_present !=
 					IOACCEL2_SENSE_DATA_PRESENT) {
@@ -1931,30 +1928,18 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
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
@@ -1983,9 +1968,6 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			break;
 		default:
 			retry = 1;
-			dev_warn(&h->pdev->dev,
-				"unexpected delivery or target failure, status = 0x%02x\n",
-				c2->error_data.status);
 		}
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_COMPLETE:
@@ -1993,17 +1975,11 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
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

