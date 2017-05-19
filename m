From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 18/18] scsi_setup_fs_cmnd(): Call scsi_req_init() instead of open-coding it
Date: Fri, 19 May 2017 11:30:16 -0700
Message-ID: <20170519183016.12646-19-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43736 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756068AbdESSab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:31 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

The only functional change is that this patch causes scsi_setup_fs_cmnd()
to clear scsi_request.sense_len.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5431d114c897..a93c7d5a9322 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1212,8 +1212,8 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 			return ret;
 	}
 
-	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
-	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+	scsi_req_init(&cmd->req);
+	cmd->cmnd = scsi_req(req)->cmd;
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
-- 
2.12.2
