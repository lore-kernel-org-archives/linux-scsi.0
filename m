Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2475C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE70216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405101AbfHIDDF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34581 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so45222264pfo.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVBGxRVNMZ0I7u5sBXnDWJT3P05Ev/mTUYVPZaD/y8w=;
        b=sV2Ix6EOiy7ZxUT7fEAKbJ0l50WoHJxO4VAdvr0ZvR5+gQG+ZwdWixN76xdKQRAOF2
         mQBLkyaoi0i3xM1O5g29xEUKus41IZJ7hZH3X/0jOveU67UvcTxPrTlHN+FCi6aIsvEn
         sPg4hh5Gf5/PN65KyIr7NZbpjPQjEITBx7368adlspRvElFJhChnxD3+zdECaJqkXt69
         XOSLeU8u3kbOU9guBj9oIuUYglHjkXXV+1BolNVlzfV22du9J4AR+xS+ahdpnjET91f4
         l15uWoVx62OhUlH+WIS/y1ZXDgI5UX+Yh+fD9s/Cem3Lu/BJSdQM50gKd56KEDg7FvoV
         3OgA==
X-Gm-Message-State: APjAAAWNBad8VQhd5kpxIsqZAzYxMZc3ByFVwGfSkeKjJ0lJDY6zf1Hn
        PTY6wT4RNdPa3kVOpmyv9uk=
X-Google-Smtp-Source: APXvYqzvFcZuMV+WcPpOa88BzCTJCaEIi5vLnpi7aH0KrOBDPaCY2AsC26rjbsXNHuaDYSvo0p6siQ==
X-Received: by 2002:a65:6081:: with SMTP id t1mr15750480pgu.9.1565319784277;
        Thu, 08 Aug 2019 20:03:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 21/58] qla2xxx: Do not corrupt vha->plogi_ack_list
Date:   Thu,  8 Aug 2019 20:01:42 -0700
Message-Id: <20190809030219.11296-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Delete the PLOGIN ACK data structure from the vha->plogi_ack_list before
freeing that data structure to avoid that that list gets corrupted.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c     | 8 ++++++--
 drivers/scsi/qla2xxx/qla_target.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a5acd5e2dfb1..37e24987c852 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5083,8 +5083,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 				   "%s %8phC mem alloc fail.\n",
 				   __func__, e->u.new_sess.port_name);
 
-			if (pla)
+			if (pla) {
+				list_del(&pla->list);
 				kmem_cache_free(qla_tgt_plogi_cachep, pla);
+			}
 			return;
 		}
 
@@ -5195,8 +5197,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 	if (free_fcport) {
 		qla2x00_free_fcport(fcport);
-		if (pla)
+		if (pla) {
+			list_del(&pla->list);
 			kmem_cache_free(qla_tgt_plogi_cachep, pla);
+		}
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ea22e62257cb..9cd5e2fba8ca 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4796,8 +4796,10 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 			    __func__, sess->port_name, sec);
 		}
 
-		if (!conflict_sess)
+		if (!conflict_sess) {
+			list_del(&pla->list);
 			kmem_cache_free(qla_tgt_plogi_cachep, pla);
+		}
 
 		qlt_send_term_imm_notif(vha, iocb, 1);
 		goto out;
-- 
2.22.0

