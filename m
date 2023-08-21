Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F6CEE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjHUUml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjHUUmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:42:06 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B302E62
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:41:07 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bf6ea270b2so10251675ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692650466; x=1693255266;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2TLXSffV0Mdb76aW2RDBjh2NGDe6pa1hzPKUkIdKlZA=;
        b=Qav/+AIxfWzflvA05SvQ4WOpWcWH0bKMQaEwelRHmC51CzgFwojv9G/QlN/qt5r61n
         KriGQhbNbE2LbJllvX0MWxs1s6xAiLTLpwrIL2A505OpUJ/1n0M9tWAY2GX6nVtZM57Q
         Jrrgnv4rE7mVkHkgwlcjMv2p05tPoMrCBlcPwc9k6+ugJUrvaiIqMJeaSYh4NVeK9+a7
         Epzor7iq4mxlqq4y/EtBMCcdTOxf+Nf88fhi1W/BrfVH0f9joV6i+H5+UhXAW+yTGgbk
         bk6LoH3yCG5BjC0m4CURMlm7telgGt3kem2mUtM7wHl60h8ZoMieE/N5xwyrxBx9bfQx
         CIiQ==
X-Gm-Message-State: AOJu0Yy/bOKJT6q13kuzP61156hJvAim/d3WBhHh9fhS6isSd6Hi4Xu9
        P7MRJBkKloU6CqUbWXS8T+A=
X-Google-Smtp-Source: AGHT+IE3si9sPg2kAnR3LwcNKZWsLv79dykOUvJf8i6J6iHGBiu45dP+fvhL/WaTa0qoLeq7nKMzIw==
X-Received: by 2002:a17:902:f68a:b0:1b8:2ba0:c9c0 with SMTP id l10-20020a170902f68a00b001b82ba0c9c0mr6024570plg.59.1692650466506;
        Mon, 21 Aug 2023 13:41:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef58:6534:ec7a:8ab2])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902c11300b001ab39cd875csm7521097pli.133.2023.08.21.13.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 13:41:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: core: Report error list information in debugfs
Date:   Mon, 21 Aug 2023 13:41:01 -0700
Message-ID: <20230821204101.3601799-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Provide information in debugfs about SCSI error handling to make it
easier to debug the SCSI error handler. Additionally, report the maximum
number of retries in debugfs (.allowed).

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debugfs.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index 217b70c678c3..a9bc5f7ce745 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -3,6 +3,7 @@
 #include <linux/seq_file.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_host.h>
 #include "scsi_debugfs.h"
 
 #define SCSI_CMD_FLAG_NAME(name)[const_ilog2(SCMD_##name)] = #name
@@ -33,14 +34,32 @@ static int scsi_flags_show(struct seq_file *m, const unsigned long flags,
 
 void scsi_show_rq(struct seq_file *m, struct request *rq)
 {
-	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq), *cmd2;
+	struct Scsi_Host *shost = cmd->device->host;
 	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
 	int timeout_ms = jiffies_to_msecs(rq->timeout);
+	const char *list_info = NULL;
 	char buf[80] = "(?)";
 
+	spin_lock_irq(shost->host_lock);
+	list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry) {
+		if (cmd == cmd2) {
+			list_info = "on eh_abort_list";
+			break;
+		}
+	}
+	list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry) {
+		if (cmd == cmd2) {
+			list_info = "on eh_cmd_q";
+			break;
+		}
+	}
+	spin_unlock_irq(shost->host_lock);
+
 	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
-	seq_printf(m, ", .cmd=%s, .retries=%d, .result = %#x, .flags=", buf,
-		   cmd->retries, cmd->result);
+	seq_printf(m, ", .cmd=%s, .retries=%d, .allowed=%d, .result = %#x, %s%s.flags=",
+		   buf, cmd->retries, cmd->allowed, cmd->result,
+		   list_info ? : "", list_info ? ", " : "");
 	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
 			ARRAY_SIZE(scsi_cmd_flags));
 	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
