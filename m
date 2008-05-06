From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_dh: remove &rq->cmd access
Date: Tue, 6 May 2008 15:54:11 +0900
Message-ID: <20080506155347T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:47898 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYEFGzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2008 02:55:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is against scsi-misc, a resend of

http://www.spinics.net/lists/linux-ide/msg22659.html


===
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_dh: remove &rq->cmd access

req->cmd was changed from a static array to a pointer. It breaks
&rq->cmd access. scsi_dh acessess to &rq->cmd to initiazlize it but
blk_get_request does so we can remove such.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c   |    1 -
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    1 -
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index ed53f14..644e24a 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -258,7 +258,6 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 		return NULL;
 	}
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
 	rq->cmd[0] = cmd;
 	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 12ceab7..531564f 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -91,7 +91,6 @@ static int hp_sw_activate(struct scsi_device *sdev)
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
 	req->cmd_len = COMMAND_SIZE(START_STOP);
-	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = START_STOP;
 	req->cmd[4] = 1;	/* Start spin cycle */
 	req->timeout = HP_SW_TIMEOUT;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 6fff077..9f94942 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -214,7 +214,6 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
-- 
1.5.4.2

