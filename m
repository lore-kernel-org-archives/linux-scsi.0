Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98377C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 21:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbiIAVsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 17:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiIAVr5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 17:47:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33667A535
        for <linux-scsi@vger.kernel.org>; Thu,  1 Sep 2022 14:47:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p18so62275plr.8
        for <linux-scsi@vger.kernel.org>; Thu, 01 Sep 2022 14:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=1qFLmuAicj9UlAmGP9DJpM6tW9KNPkfsUBI3P/CldSo=;
        b=Kt5ESBIY/nOktHtszvwN8rVzSAuAv1zqdRtPmURYDqoDXBxn0VcwlJ0MbBk1SaHL28
         QSjhwzXFaAhx67H7rPhx5jabv9ujI86pQ5Pc6cB+uMlIX7FBaQh4nORss1n2l4SGOI6N
         xzlV4YIlwMJP339g0DHn2vV+bWTYDJ94aF6yw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=1qFLmuAicj9UlAmGP9DJpM6tW9KNPkfsUBI3P/CldSo=;
        b=M0eicqZVZwpE/HHamC4v2NEyCUB/9glS07u3IxQkSsS8Dijsu4eVFg+OMV/RDJjvoL
         apYZR2rUs9p7k2XQNCCCRv/7+xkMMZA7zkonBTqdQ80nyXjElhvkeuURn4qnn6pOherO
         cZl8y0fkecMrXVEPjsi45SFJG2lPamzljgy9sXu92ZVlkqrBLTy649ECjBYx6hQskoTA
         THsDJsrT/fk/rDEVfFqLJMGwD86Qst/vioAFYrR8FbxLZpecha9vkqzzr/MAVqTldkKO
         hMD0jVYMJdV79HYWIczX8KeUuxrI+xdKcIk5c95q+dyANWlC9Ia79Hxv4M/mfVM8NZ3m
         aWXw==
X-Gm-Message-State: ACgBeo0zkogbJGrmdiX8Yf3Ffs+mPFFGdpW93x++NolEIFgRfI7xjnrV
        JHyFQliQWJwohjrd1vYBuRUFl9zZJrwUSmWqtdeM3jA6cX4d+VWrgoJxzrmVEfRrN1z9UuZefjS
        F28co4XC3vutyfzZvjNlrMneixez7DU6j6DV1S3afFcKQHRxpgFrLwTEEIi8dYoQ8JJCtHuyQUX
        hD
X-Google-Smtp-Source: AA6agR4FR8LZik9Jo3cU/LNblu1VdX9Zqjx2iNKvsAdHhmo4ptURKltHGcUZnDjDJnT5YV7qx01erQ==
X-Received: by 2002:a17:902:e5c3:b0:175:534:1735 with SMTP id u3-20020a170902e5c300b0017505341735mr16522770plf.87.1662068875979;
        Thu, 01 Sep 2022 14:47:55 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.10])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090ac98500b001f216407204sm90667pjt.36.2022.09.01.14.47.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 01 Sep 2022 14:47:54 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     Brian Bunker <brian@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>
Subject: [PATCH] scsi: core: Remove ACTION_RETRY since it is redundant
Date:   Thu,  1 Sep 2022 14:47:49 -0700
Message-Id: <20220901214749.18875-1-brian@purestorage.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The case of ACTION_RETRY in scsi_io_completion_action does nothing
different than ACTION_DELAYED_RETRY, and by name gives the idea
that it does.

Following ACTION_RETRY:
__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, false);

Following ACTION_DELAYED_RETRY:
__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, false);

Then __scsi_queue_insert calls scsi_set_blocked(cmd, reason) where
both of the reasons set by ACTION_RETRY and ACTION_DELAYED_RETRY
fall into the same case.

    case SCSI_MLQUEUE_DEVICE_BUSY:
    case SCSI_MLQUEUE_EH_RETRY:
        atomic_set(&device->device_blocked,
               device->max_device_blocked);
        break;

Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_lib.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ef08029a0079..d85d72bc01f2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -687,7 +687,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	struct request *req = scsi_cmd_to_rq(cmd);
 	int level = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
-	      ACTION_RETRY, ACTION_DELAYED_RETRY} action;
+	      ACTION_DELAYED_RETRY} action;
 	struct scsi_sense_hdr sshdr;
 	bool sense_valid;
 	bool sense_current = true;      /* false implies "deferred sense" */
@@ -704,7 +704,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 		 * reasons.  Just retry the command and see what
 		 * happens.
 		 */
-		action = ACTION_RETRY;
+		action = ACTION_DELAYED_RETRY;
 	} else if (sense_valid && sense_current) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
@@ -720,7 +720,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				 * media change, so we just retry the
 				 * command and see what happens.
 				 */
-				action = ACTION_RETRY;
+				action = ACTION_DELAYED_RETRY;
 			}
 			break;
 		case ILLEGAL_REQUEST:
@@ -841,10 +841,6 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	case ACTION_DELAYED_REPREP:
 		scsi_mq_requeue_cmd(cmd, ALUA_TRANSITION_REPREP_DELAY);
 		break;
-	case ACTION_RETRY:
-		/* Retry the same command immediately */
-		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, false);
-		break;
 	case ACTION_DELAYED_RETRY:
 		/* Retry the same command after a delay */
 		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, false);
-- 
2.32.1 (Apple Git-133)

