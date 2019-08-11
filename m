Return-Path: <SRS0=NWCA=WH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2878C0650F
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Aug 2019 18:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A27B2147A
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Aug 2019 18:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UE40Ayq0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfHKSZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Aug 2019 14:25:14 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8310 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfHKSZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Aug 2019 14:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565547913; x=1597083913;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a2MHHnzNCphQP/HXYoNZdgfknT6fZfR3qE0jBZMtdrg=;
  b=UE40Ayq0HoJVXpNTq7D5v3BsG4gbVnEefAsmc6MrWKg4JzeFT0GbkCI9
   YQeXQ7mELPlkar15mzBnt4uxxmE2KYKbQaQe8h60QUqv5dTR3KLxZhQso
   M4c512OTJWlX4C/vDwO+nOS+5bbWp5VIqxEcrb2/Z6vGH6aa2JeeQExx0
   NMFejk6vIOSzwR6E3y7YT+k+2U+HOWU89lfAYosEVT6DaiXN8ZU6Tlkhg
   MIIry6X1EBgCweR4v12FNrsKu7jVAvXqa9SX5FIDJv8Y0QimmQzWXmjbD
   IJ8POZetr8ljSpyMQlLhHqPwNX3bA1YI9sLmiv0YO2k6VLa9IwOXVTLXP
   A==;
IronPort-SDR: OnO4J9tfH1EWVzWLfzWLqiCcGBoO7pYVee7zAVl5cC1B5/UUX0gBjS4K62gQPF7x8X5P87s/9Z
 3enrrmfT9ygsq2pXnHoINmu40jCWMGeA10gBiSwKQYY6jq5bZYaxlZhegS1IdECRzGnXfM2+Ed
 7QUM172VuhEbgTQ3EZrbutfwu8us0MITE0U9WMh5QDcP1l8qwlnGi0PotZN2OfMMpaDWRZw+8T
 ARhMqa3L3FJ8EKiIm/a1RRuaNenjHzNctubQUeWMszXdl0+CTwM/skBnqWx0B+WSYD7IsxNzGg
 KHo=
X-IronPort-AV: E=Sophos;i="5.64,374,1559491200"; 
   d="scan'208";a="115598588"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2019 02:25:13 +0800
IronPort-SDR: muXkBD7gqB+bqFRutbgbJhuE5k3/mZ4InWcTNiLvZBb7Oz7vY3ppKPPu9fZStFHfKZqkdYUpVF
 XUc95jevxzpj6Yk4elfHWwdCblh108Tc4FQd6/oY9d1IuNlEJSIA7dDao3QHF55vu1x1tcudZ7
 zk4yCuE/KMsSDilVVQsJRl2FwY+t4HB13DhljLWGiuc5dupqRMrWnSNQ6kRF0/SL3tA+/ROom+
 JjQP792v7ePbfVHd+s1/gfOCPUiekfZ+WIpqMxlCEzC0QzVN+XpHQpGHsX008kTs5+jfJSjdcj
 nvPN7Gn46t3lgAmoSnOnep3F
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2019 11:22:50 -0700
IronPort-SDR: rSGcRUsdXiWLTj37ET1wicbSKUIt9U5puW7PuC8AwsYK9drw552yxpcOlaNA0Oovzuh5AQMGhu
 94Jcb2qrc94PBrxRwBF3jdlkvBzd97ucY+c772cfXqgYYdYoyZYVLBCEMKbyz6nctTx7Wl2vMQ
 EvZzmA4Yp6FMGK63zPEFQ9ccsikCxH61E0t1Hq+Qjq7sQmuyBG+QXuMMJU+L3I+fqbcw+yVNR9
 uuCMupndBh/XXpDYmDTMtnB6fYS7eajPEo0Xt+I2BPvvV+CEID24ZBQn+cL7VyKTt6BM90i+TC
 HlQ=
Received: from dhcp-10-88-173-43.hgst.com (HELO localhost.localdomain) ([10.88.173.43])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Aug 2019 11:25:12 -0700
From:   Dmitry Fomichev <dmitry.fomichev@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2] tcmu: avoid use-after-free after command timeout
Date:   Sun, 11 Aug 2019 11:25:10 -0700
Message-Id: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In tcmu_handle_completion() function, the variable called read_len is
always initialized with a value taken from se_cmd structure. If this
function is called to complete an expired (timed out) out command, the
session command pointed by se_cmd is likely to be already deallocated by
the target core at that moment. As the result, this access triggers a
use-after-free warning from KASAN.

This patch fixes the code not to touch se_cmd when completing timed out
TCMU commands. It also resets the pointer to se_cmd at the time when the
TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
after calling target_complete_cmd() later in the same function,
tcmu_check_expired_cmd().

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 drivers/target/target_core_user.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 04eda111920e..661bb9358364 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
 	bool read_len_valid = false;
-	uint32_t read_len = se_cmd->data_length;
+	uint32_t read_len;
 
 	/*
 	 * cmd has been completed already from timeout, just reclaim
 	 * data area space and free cmd
 	 */
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		WARN_ON_ONCE(se_cmd);
 		goto out;
+	}
 
 	list_del_init(&cmd->queue_entry);
 
@@ -1152,6 +1154,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		goto done;
 	}
 
+	read_len = se_cmd->data_length;
 	if (se_cmd->data_direction == DMA_FROM_DEVICE &&
 	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
 		read_len_valid = true;
@@ -1307,6 +1310,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		list_del_init(&cmd->queue_entry);
+		cmd->se_cmd = NULL;
 	} else {
 		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
@@ -2022,6 +2026,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 		idr_remove(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
 			if (err_level == 1) {
 				/*
-- 
2.21.0

