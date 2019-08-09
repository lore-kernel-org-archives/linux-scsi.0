Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344F0C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10C20216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405353AbfHIDDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42612 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so45094711pgb.9
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SLszvezwtJ5eDgdeMnHbQm1BTA24XIo7DWRUhooGehY=;
        b=JUUyFcR7Y4JP7cwTmKQ9iQo2c1tQaJlZoj/aKoJRft1BR0KIACXr1CXXzR3c2rBW4M
         ZZUVFhCGq6LRRtkqVpZi/B9JwN84TpRLSJ39VG3vMFzn2VydTh4eHMaiWwUdXMbHqJ1S
         zHabi/qt4S6iV1SNDVeAn74ZJIef10b4NYGbfXRbR/9Al5bep/IJy3y3AO+e0+M/B2v3
         lr8K1U4CVrNmKkNi+CXwjop8dsiFhmZ/qEp1kWlz2dayfeTcrkgO7lt0ntKY6bRvq1rf
         +7EicTu9+xX8xRlcaSHSK5oLYQKODpYtiZJiHkNQEpS1C3sEtcQPaT+B8PTpHmn+aK8V
         cZtw==
X-Gm-Message-State: APjAAAW62SQke9WuDxR8JbGjAGRBrAPS625aUp0CnK2Cap5liWZ58ehf
        7JSNS8k+it8C+Ppb8dP/IenkTyUY
X-Google-Smtp-Source: APXvYqwZlEKkV1KKa++gea/wOcX4BllbQDYZZWFmwoaCKDqxra1OaxPsqcgV3dHP3HF3dvfdVOlqiQ==
X-Received: by 2002:a63:dc4f:: with SMTP id f15mr15756543pgj.227.1565319827566;
        Thu, 08 Aug 2019 20:03:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 53/58] qla2xxx: Report invalid mailbox status codes
Date:   Thu,  8 Aug 2019 20:02:14 -0700
Message-Id: <20190809030219.11296-54-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is easy to mix up the QLA_* and the MBS_* status codes. Complain loudly
if that happens.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 5 +++++
 drivers/scsi/qla2xxx/qla_init.c | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 527b2a2708a1..556376ce0259 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -990,6 +990,11 @@ struct mbx_cmd_32 {
 #define MBS_LINK_DOWN_ERROR		0x400B
 #define MBS_DIAG_ECHO_TEST_ERROR	0x400C
 
+static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
+{
+	return MBS_COMMAND_COMPLETE <= mbs && mbs <= MBS_DIAG_ECHO_TEST_ERROR;
+}
+
 /*
  * ISP mailbox asynchronous event status codes
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 64c84e53011e..b3f1203bfe87 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -477,6 +477,9 @@ void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	    fcport->fw_login_state, ea->rc, fcport->login_gen, ea->sp->gen2,
 	    fcport->rscn_gen, ea->sp->gen1, fcport->loop_id);
 
+	WARN_ONCE(!qla2xxx_is_valid_mbs(ea->data[0]), "mbs: %#x\n",
+		  ea->data[0]);
+
 	if (ea->data[0] != MBS_COMMAND_COMPLETE) {
 		ql_dbg(ql_dbg_disc, vha, 0x2066,
 		    "%s %8phC: adisc fail: post delete\n",
@@ -1893,6 +1896,9 @@ qla24xx_async_abort_command(srb_t *sp)
 static void
 qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 {
+	WARN_ONCE(!qla2xxx_is_valid_mbs(ea->data[0]), "mbs: %#x\n",
+		  ea->data[0]);
+
 	switch (ea->data[0]) {
 	case MBS_COMMAND_COMPLETE:
 		ql_dbg(ql_dbg_disc, vha, 0x2118,
@@ -1978,6 +1984,9 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		return;
 	}
 
+	WARN_ONCE(!qla2xxx_is_valid_mbs(ea->data[0]), "mbs: %#x\n",
+		  ea->data[0]);
+
 	switch (ea->data[0]) {
 	case MBS_COMMAND_COMPLETE:
 		/*
-- 
2.22.0

