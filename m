From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 15/17] mvumi: Remove dead code
Date: Fri, 23 Jan 2015 13:14:18 +0100
Message-ID: <54C23B1A.8050405@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:47752
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbbAWMOX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:14:23 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.
Hence remove the code that tests for this value.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/mvumi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 3e6b866..eae3cb2 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2081,7 +2081,6 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	case DMA_TO_DEVICE:
 		pframe->cmd_flag |= CMD_FLAG_DATA_OUT;
 		break;
-	case DMA_BIDIRECTIONAL:
 	default:
 		dev_warn(&mhba->pdev->dev, "unexpected data direction[%d] "
 			"cmd[0x%x]\n", scmd->sc_data_direction, scmd->cmnd[0]);
-- 
2.1.2

