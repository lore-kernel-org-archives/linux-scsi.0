Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952D6C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70394216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405205AbfHIDDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:47075 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so7892251pgt.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KdLwrYJ2HH41De4FuFVc0WXKj9EbyS/iDjVR8OGcN8A=;
        b=Zr06xDbvD+2c9zrbh0Am/Y4w+phffUvi7436fjFPtGUivtxTEKpVPO3xkN7EZxQThG
         wYR0/OROefibcA1clqujgWo3GooGYcpZrsUMA6coiQwF8GF+9oq9fw8W23+RuiY/AKts
         EfGVocwikb0HOqITcAF4pIIB7mUID4U015sMVngTqsfElOflcgTSIlAfpOyA+07eVZxU
         9GAax9Oup2fh4mXZNBY1DNAV9l8wg/ozxo3kai4oXZDSh+of7+zRqeJMXTdfFKqgRUSH
         L86DaWyZc5yuS7hQKA+9bVpbzO9cNth532MI3GjiMdgMlsnuBKfowo3dEkd56Mdmkl3Y
         N2vQ==
X-Gm-Message-State: APjAAAXR2T/1xXJP21bG9vJirR+GEcQhUkHc/Ggw6yF+GhsnEmyq+9vu
        Qk5aHfiNYXqufhMXn5aXKgw=
X-Google-Smtp-Source: APXvYqxwMnSSQJMKuTGo44FZkwoucQNfj29m3AqtvX9wnGJMBbgusV1h/j6s1gvEe2ql7KJQBWdWXQ==
X-Received: by 2002:a62:1c5:: with SMTP id 188mr18271141pfb.26.1565319800309;
        Thu, 08 Aug 2019 20:03:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 33/58] qla2xxx: Complain if waiting for pending commands times out
Date:   Thu,  8 Aug 2019 20:01:54 -0700
Message-Id: <20190809030219.11296-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Such a timeout is a severe issue. Hence complain if waiting for pending
commands times out. This patch fixes a small bug: it modifies
qla82xx_chip_reset_cleanup() such that the "Done waiting" message is
reported if qla82xx_chip_reset_cleanup() succeeded instead of if that
function failed.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 drivers/scsi/qla2xxx/qla_nx.c   | 4 +++-
 drivers/scsi/qla2xxx/qla_os.c   | 7 +++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1fd9a086748e..2d9a379fd8fb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6634,7 +6634,8 @@ qla2x00_quiesce_io(scsi_qla_host_t *vha)
 					LOOP_DOWN_TIME);
 	}
 	/* Wait for pending cmds to complete */
-	qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST);
+	WARN_ON_ONCE(qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST)
+		     != QLA_SUCCESS);
 }
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c1c832271ccb..a91d426add75 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3710,10 +3710,12 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 
 		/* Wait for pending cmds (physical and virtual) to complete */
 		if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
-		    WAIT_HOST)) {
+		    WAIT_HOST) == QLA_SUCCESS) {
 			ql_dbg(ql_dbg_init, vha, 0x00b3,
 			    "Done wait for "
 			    "pending commands.\n");
+		} else {
+			WARN_ON_ONCE(true);
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2ba06a84c501..e91681cbd75d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1059,8 +1059,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
  *    cmd = Scsi Command to wait on.
  *
  * Return:
- *    Not Found : 0
- *    Found : 1
+ *    Completed in time : QLA_SUCCESS
+ *    Did not complete in time : QLA_FUNCTION_FAILED
  */
 static int
 qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
@@ -1372,6 +1372,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	return ret;
 }
 
+/*
+ * Returns: QLA_SUCCESS or QLA_FUNCTION_FAILED.
+ */
 int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 	uint64_t l, enum nexus_wait_type type)
-- 
2.22.0

