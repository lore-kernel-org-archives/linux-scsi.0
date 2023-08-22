Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44ADEE4996
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 16:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbjHVQiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 12:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjHVQiR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 12:38:17 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D0E19A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 09:38:16 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-26d1a17ce06so2513522a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 09:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692722295; x=1693327095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T0PVAouymOC3V+ToGvpjAzQ0QeBSl4SRFMO+eMaIhTM=;
        b=SqWQYlZgnQVrM+CxaxZZ187yewOQez54o/PQ5tkx473TWpbG19TyAIreBh27pndc8K
         C42fT2rGxetMA1LK0UBmJqP5Zq4qphh9r/1wlp+mA8J0yzmHQs6hR59NzQzVLX7wduWr
         IhS/sKPpP+Kay6cl6+m7Y2VdncXxdYE9lGt4qQ0v+3uJ0afGKb6dy15pHWatqeAlCWVb
         eBtJ1d54BhaGUNuVmTAsgUA9NHz0jCIHhnchGKrIkhqV6VHRH1PdP0WFAa9CrAwdLsrN
         Tk8BGbM7ijZ0hv4LCKP/7sd5avJ9BfeYQ2NuJcZrxnFgPPqwVq2ArxxA1PBc5I9bx24H
         5hVA==
X-Gm-Message-State: AOJu0YzwxooiL47BtTeoUcb+K59c05U+ul307gWqRVdHSsd7XY5BbK8I
        utNhmFu/H5mFfBjRHlcVlMQ=
X-Google-Smtp-Source: AGHT+IEWi+Fnv2GkfFHhKzFaQwvC2vpphhiFhCbfU0mQw6728Sjj8rqC93zKm2+5FzxzDIY44L5ZTA==
X-Received: by 2002:a17:90a:dc08:b0:26b:1dc1:c4bd with SMTP id i8-20020a17090adc0800b0026b1dc1c4bdmr7032984pjv.20.1692722295306;
        Tue, 22 Aug 2023 09:38:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id mm8-20020a17090b358800b0026b6b17ca5dsm8163485pjb.54.2023.08.22.09.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 09:38:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2] scsi: core: Report error list information in debugfs
Date:   Tue, 22 Aug 2023 09:38:10 -0700
Message-ID: <20230822163811.219569-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Provide information in debugfs about SCSI error handling to make it
easier to debug the SCSI error handler. Additionally, report the maximum
number of retries in debugfs (.allowed).

Reviewed-by: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1:
 - If a command is found on the eh_abort list, do not search the eh_cmd_q.

 drivers/scsi/scsi_debugfs.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index 217b70c678c3..f795848b316c 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -3,6 +3,7 @@
 #include <linux/seq_file.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_host.h>
 #include "scsi_debugfs.h"
 
 #define SCSI_CMD_FLAG_NAME(name)[const_ilog2(SCMD_##name)] = #name
@@ -33,14 +34,33 @@ static int scsi_flags_show(struct seq_file *m, const unsigned long flags,
 
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
+			goto unlock;
+		}
+	}
+	list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry) {
+		if (cmd == cmd2) {
+			list_info = "on eh_cmd_q";
+			goto unlock;
+		}
+	}
+unlock:
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
