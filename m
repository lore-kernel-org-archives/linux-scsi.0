Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0A4C54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbjAIXWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237653AbjAIXWv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:51 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D305FFD
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:50 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jn22so11266665plb.13
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTGlDQjCAI8x+EKU12D0EsHSkX6w9bmXQmp0JVE1HUE=;
        b=EfZ3JgQ49IdE4G8GUjHUT2/Cvwe951W1bS9tuM+cUhJFAP5xj+Yy9WLSDeNE1HkEmR
         6NnNlRu87OVw9ES0xqkutooDB+8Y4ckKWgBlPNuwQJgytDDnj688rORN2t6EvCpQcJZB
         VRdbGi6jYJJwJAy3yBoqcFlp0/qLAqfEuXDbWTodWNcizmC1sYtaz4AqJwCT/5lYUKW3
         zto0+dLXwSS5AvZXC6l5PuupeBytaVFWMljpquUEgEXrojFF2JVfx758f+YSVH77y5PU
         wx7kZ5sW9rZeWfGMFMqP7k/Hoqv5tTRt8p2zSTgVTPnEW7Vho2u8Z1sZJeXoFgjNyT5G
         QhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTGlDQjCAI8x+EKU12D0EsHSkX6w9bmXQmp0JVE1HUE=;
        b=bTZWimm03/BOSv9xIrnVpa5sZDpb5ni7Jc0tPEJfE+cljlQ2MA+3306EqHZkcvFcgs
         ST467wW9gB3Ti1iyFiFp6PzADKir4yQvANRKfOjAdFP1T3Qq9dQF1KRLu1HW7ZqvvprI
         mya3mD3VoHXdQ2Nvtmd6UV4qh4czXT5HNao7TnyB9l0//QPjJ9qJqpYdmEj7sDsJUiSZ
         RwNc/QqIOjThLYotM+pojyETFa/Lmn5EyxiZXe8IilpmeWL0rJfKLfbAShtdvAHDrHLj
         1TIj9xvSXHc+AgZl6yzAOeEeUnI7S63OJqdhIxX8elrCwJAC8U0lxk4c3jZWcyTJvm3T
         fdhQ==
X-Gm-Message-State: AFqh2kqwWajU3CQeXTch3T0u/Bpuq58XpVWgl44Ul/epLWr7s9Rd/CeL
        MdBTYT2tSz67J8VTq0obtBJ6p5nUrEQ=
X-Google-Smtp-Source: AMrXdXtg1QlkaT9H8QMRxure/acA2kdIH4LufT2ZeyRwoSBoX1nTboTg7RArJdyJCcAXdwTiFM5YCQ==
X-Received: by 2002:a17:903:240b:b0:192:991f:d8e8 with SMTP id e11-20020a170903240b00b00192991fd8e8mr47417222plo.53.1673306570073;
        Mon, 09 Jan 2023 15:22:50 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:49 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/12] lpfc: Exit PRLI completion handling early if ndlp not in PRLI_ISSUE state
Date:   Mon,  9 Jan 2023 15:33:12 -0800
Message-Id: <20230109233317.54737-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In a large SAN testing configuration, frequent target port toggle tests are
occasionally resulting in missing lun path rediscoveries.  An outstanding
PRLI can be inflight when a target RSCN dissappearance occurs, causing
the driver to retry PRLIs using invalid rpi contexts.

Fix by verifying that an ndlp's state was not restarted from PRLI_ISSUE
due to an intermediate RSCN.  If not in a valid state, early exit PRLI
completion handling.

The last follow up RSCN indicating target reappearance retriggers
PLOGI/PRLI with a valid rpi context and is expected to succeed in lun path
rediscovery.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 919741bbe267..4d3b8f2036d2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2373,15 +2373,30 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* PRLI failed */
 		lpfc_printf_vlog(vport, mode, loglevel,
 				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
-				 "data: x%x\n",
+				 "data: x%x x%x\n",
 				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4, ndlp->fc4_prli_sent);
+				 ulp_word4, ndlp->nlp_state,
+				 ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
+		/* The following condition catches an inflight transition
+		 * mismatch typically caused by an RSCN. Skip any
+		 * processing to allow recovery.
+		 */
+		if (ndlp->nlp_state >= NLP_STE_PLOGI_ISSUE &&
+		    ndlp->nlp_state <= NLP_STE_REG_LOGIN_ISSUE) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+					 "2784 PRLI cmpl: state mismatch "
+					 "DID x%06x nstate x%x nflag x%x\n",
+					 ndlp->nlp_DID, ndlp->nlp_state,
+					 ndlp->nlp_flag);
+				goto out;
+		}
+
 		/*
 		 * For P2P topology, retain the node so that PLOGI can be
 		 * attempted on it again.
@@ -4673,6 +4688,15 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				/* the nameserver fails */
 				maxretry = 0;
 				delay = 100;
+			} else if (cmd == ELS_CMD_PRLI &&
+				   ndlp->nlp_state != NLP_STE_PRLI_ISSUE) {
+				/* State-command disagreement.  The PRLI was
+				 * failed with an invalid rpi meaning there
+				 * some unexpected state change.  Don't retry.
+				 */
+				maxretry = 0;
+				retry = 0;
+				break;
 			}
 			retry = 1;
 			break;
-- 
2.38.0

