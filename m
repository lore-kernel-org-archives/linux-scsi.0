Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA2DC83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 18:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF74A208FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 18:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Qt0YN4cR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgD1S0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 14:26:43 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.68]:45659 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728547AbgD1S0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588098396; i=@ts.fujitsu.com;
        bh=h35Z7tldSI0c2t/f6ALJrBSQPirsm+vLrDuxe2SGGk0=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=Qt0YN4cR9E+IGri3SSQUOuiihX+NqnKW9I0D36QLme+63+nKHr8lt7hvMkMknsp2c
         OrM2vO8ndzYB5YeBJNyda7lu2gomMqanpL4lc3mhN8LcwiLSnGygT1xCXz9HFbmYkn
         kSGcLz0dITNFCsyyP2w7xUyUOX4ZTBnWOwA+MggpitMsDKUGP2CQLEnNYKQvIN4UIZ
         mVuIr3DxFyTejYhb5ULWek1WlbRF4rbFI35H0UwFh9j8N4ifV4U26wQIhqKwB1ncmL
         QeTucyNTN4p3v+NWxz8G7D+olQPLPsmV5AXcN4wHds+QKCIQCkB73F3hG7cZ2H1k9i
         sLaYmCC4dfpeg==
Received: from [100.112.198.136] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 2D/62-51957-C5578AE5; Tue, 28 Apr 2020 18:26:36 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRWlGSWpSXmKPExsViZ8MxRTe6dEW
  cwf8uQ4vu6zvYLJYf/8dk0bb6DKNF69K3TA4sHve3H2Hy+Pj0FovH501yAcxRrJl5SfkVCawZ
  j/uXshYcl6iY+GQ+WwNjs2gXIxeHkMBkRonuf6tYIZzpjBJTPxxl6mLk5GATMJBYMek+C4gtI
  lAq8fDYT2YQm1lAT2Lav3XsILawgIvEvvnHgZo5OFgEVCVOLTAFCfMK2El8+7mTDcSWEJCX6D
  gwmWUCI+cCRoZVjBZJRZnpGSW5iZk5uoYGBrqGhka6hpZmukYmlnqJVbpJeqmluuWpxSW6hnq
  J5cV6xZW5yTkpenmpJZsYgf5PKTjycwfjjLXv9Q4xSnIwKYnyvn+zPE6ILyk/pTIjsTgjvqg0
  J7X4EKMMB4eSBG9lyYo4IcGi1PTUirTMHGAowqQlOHiURHjLQdK8xQWJucWZ6RCpU4yKUuK8/
  4qBEgIgiYzSPLg2WPhfYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTM2wYyniczrwRu+iugxU
  xAi7OFl4MsLklESEk1MIUfMnrVc6TdNI9ndcCuJYe33TU7llP+TTlElfNkq1TDwsp9jPnyDkE
  zvMVWC12LTTvN9cuuMixX7qSsvY3E8865jsltbfHBnlJpNd7n1v8JyJY/ZsF9fVran1IZwby3
  cw7V8Hk22BSnPl3V0CXe3PvFoGmHaYDFytCV+v81DO1vmuiv9bU68sT54T6zqbyBVYK+Zm9LO
  TP5lRrEC567VD+yWHLJ3UzDZPLELzcmRjhr6Nu46cXOvzR/SjGf1BFRxYVBXrp3loUZu+5M5v
  zAHfMguud1AG/6vQXBRyqKd75bWGiZeT106RGFV/Yr2LNKpsa+Y7lX9Hhd4yofRs2/cWe4e+/
  yMZ/9v4Q9f4ESS3FGoqEWc1FxIgCs2gf4+gIAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-9.tower-291.messagelabs.com!1588098395!299900!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29160 invoked from network); 28 Apr 2020 18:26:35 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-9.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 28 Apr 2020 18:26:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 03SIQJ98023285;
        Tue, 28 Apr 2020 19:26:26 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id E24D720521;
        Tue, 28 Apr 2020 20:26:18 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, nab@linux-iscsi.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] target: loopback: fix READ with data and sensebytes
Date:   Tue, 28 Apr 2020 20:26:17 +0200
Message-Id: <20200428182617.32726-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use tcm_loop with tape emulations running on tcmu.
In case application reads a short tape block with a longer READ,
or a long tape block with a short READ, according to SCC spec
data has to be tranferred _and_ sensebytes with ILI set and
information field containing the residual count.
Similar problem also exists when using fixed block size in READ.

Up to now tcm_loop is not prepared to handle sensebytes if input
data is provided, as in tcm_loop_queue_data_in() it only sets
SAM_STAT_GOOD and if necessary the residual count.

To fix the bug, the same handling for sensebytes as present in
tcm_loop_queue_status() must be done in tcm_loop_queue_data_in()
also.

After adding this handling, the two function now are nearly
identical, so I created a single function with two wrappers.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/loopback/tcm_loop.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3305b47fdf53..16d5a4e117a2 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -545,32 +545,15 @@ static int tcm_loop_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+static int tcm_loop_queue_data_or_status(const char *func,
+		struct se_cmd *se_cmd, u8 scsi_status)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
 	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 __func__, sc, sc->cmnd[0]);
-
-	sc->result = SAM_STAT_GOOD;
-	set_host_byte(sc, DID_OK);
-	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
-	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
-		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
-	return 0;
-}
-
-static int tcm_loop_queue_status(struct se_cmd *se_cmd)
-{
-	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
-				struct tcm_loop_cmd, tl_se_cmd);
-	struct scsi_cmnd *sc = tl_cmd->sc;
-
-	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 __func__, sc, sc->cmnd[0]);
+		 func, sc, sc->cmnd[0]);
 
 	if (se_cmd->sense_buffer &&
 	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
@@ -581,7 +564,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 		sc->result = SAM_STAT_CHECK_CONDITION;
 		set_driver_byte(sc, DRIVER_SENSE);
 	} else
-		sc->result = se_cmd->scsi_status;
+		sc->result = scsi_status;
 
 	set_host_byte(sc, DID_OK);
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
@@ -591,6 +574,17 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
+static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+{
+	return tcm_loop_queue_data_or_status(__func__, se_cmd, SAM_STAT_GOOD);
+}
+
+static int tcm_loop_queue_status(struct se_cmd *se_cmd)
+{
+	return tcm_loop_queue_data_or_status(__func__,
+					     se_cmd, se_cmd->scsi_status);
+}
+
 static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
-- 
2.12.3

