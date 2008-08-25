From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: scsi_dh: no need to memset cmd
Date: Mon, 25 Aug 2008 13:51:58 -0700
Message-ID: <1219697518.14830.123.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50426 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYHYUwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 16:52:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7PKqTwu019674
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 16:52:29 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PKqT81158738
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 14:52:29 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7PKqSKs023313
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 14:52:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Hi James,

I resent Fujita's patch a while back, But it didn't make it yet to
2.6.27 (just checked rc4). Can you please apply.

Thanks,

chandra
----------------
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_dh: no need to initialize rq->cmd with blk_get_request

blk_get_request initializes rq->cmd (rq_init does) so the users don't
need to do that.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c   |    1 -
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 --
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    2 --
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index aa46b13..2b96865 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -278,7 +278,6 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 		return NULL;
 	}

-	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->cmd_len = COMMAND_SIZE(cmd);
 	rq->cmd[0] = cmd;

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9c7a1f8..ae576dc 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -114,7 +114,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
 	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
-	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = TEST_UNIT_READY;
 	req->timeout = HP_SW_TIMEOUT;
 	req->sense = h->sense;
@@ -207,7 +206,6 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
 	req->cmd_len = COMMAND_SIZE(START_STOP);
-	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = START_STOP;
 	req->cmd[4] = 1;	/* Start spin cycle */
 	req->timeout = HP_SW_TIMEOUT;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..c93dbaf 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -225,8 +225,6 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}

-	memset(rq->cmd, 0, BLK_MAX_CDB);
-
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
 	rq->retries = RDAC_RETRIES;
-- 


