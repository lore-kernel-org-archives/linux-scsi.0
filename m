From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 15/18] scsi: storvsc: Initialize driver-private command before using it
Date: Fri, 19 May 2017 11:30:13 -0700
Message-ID: <20170519183016.12646-16-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35772 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755837AbdESSa0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:26 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Long Li <longli@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>

The storvsc driver is the only SCSI LLD that uses driver-private
command data and that does not zero-initialize that data before
reading it. Make this driver consistent with the other SCSI LLDs
that use driver-private command data.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Long Li <longli@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8d955db6424f..cc08593c5218 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1550,6 +1550,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		}
 	}
 
+	memset(cmd_request, 0, sizeof(*cmd_request));
 	/* Setup the cmd request */
 	cmd_request->cmd = scmnd;
 
-- 
2.12.2
