Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A723FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F16613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346898AbhI2WIl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:41 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:44736 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347104AbhI2WIi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:38 -0400
Received: by mail-pj1-f41.google.com with SMTP id lp15-20020a17090b4a8f00b0019f4059bd90so1636352pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xovr5aSMt2uSUC20pA1RBp5MP6CUZICgGZJSyXaXwcI=;
        b=BTnCsUsNOySfnQL9sTKU8tUP+nJmIezpjrbNW/MhKBL1lLMYkby1m1nRcGEr8Xtl5F
         qFFio2TskkyRdXYeqki1waAREoksfMNM9rYI8/4Oyt3PfUyYq1rFcZwMngyQ+K3Y1UEq
         KQJ2jofch+nlKcrp2/u9kIOJq0MdMffonbkUSozVpMXwthJraRI2e4wTbDJDLgxpPkkW
         9U/nZeRn7soexj+t+MyKnHA0zKRXR3ixlOo8qgld/q+ARp5CuRJt5JMhgIbaZNgMvBdz
         cqp0TGNAx5CQ1o1+e6gXpfV0Koi5OvwGnuJx5LR4Sjwm9hSGnWfBuws+WcAb7kPXE5nr
         xmFA==
X-Gm-Message-State: AOAM530isvC4VijT1Kubsaxii15X8V+d9GCes0VAFoGFWAXldNxAWl7W
        EEmRf1gw72KjJQ2X1t641vfT2hFNQUM=
X-Google-Smtp-Source: ABdhPJwAl1tOFKLh3lfd3HsF5VHqLsVu+/AOCwsjqKz4LbqfDPrnjWORTeNs2q34evOA5U7ZY2LWPQ==
X-Received: by 2002:a17:902:c245:b0:13e:2254:d3d6 with SMTP id 5-20020a170902c24500b0013e2254d3d6mr779104plg.52.1632953216556;
        Wed, 29 Sep 2021 15:06:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 25/84] bnx2fc: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:01 -0700
Message-Id: <20210929220600.3509089-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index f2996a9b2f63..b9114113ee73 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -205,7 +205,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		sc_cmd->allowed);
 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 }
 
 struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
@@ -1610,7 +1610,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 	}
 
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 	if (io_req->wait_for_abts_comp) {
@@ -1853,7 +1853,7 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -2019,7 +2019,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		break;
 	}
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 }
 
