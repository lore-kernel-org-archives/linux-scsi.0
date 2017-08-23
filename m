From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 05/19] scsi_setup_fs_cmnd(): Call scsi_req_init() instead of open-coding it
Date: Wed, 23 Aug 2017 14:39:55 -0700
Message-ID: <20170823214009.15015-6-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60815 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdHWVlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:41:42 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

The functional changes in this patch for scsi_setup_fs_cmnd() are:
- scsi_request.sense_len is cleared. This is OK since it is the
  responsibility of the LLD to set .sense_len before calling
  .scsi_done().
- scsi_request.cmd_len is changed to BLK_MAX_CDB. This is fine
  since scsi_driver.init_command() must overwrite this member for
  FS commands.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index efdcd9e79404..f9a0d5b13707 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1215,8 +1215,8 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 			return ret;
 	}
 
-	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
-	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+	scsi_req_init(&cmd->req);
+	cmd->cmnd = cmd->req.cmd;
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
-- 
2.14.0
