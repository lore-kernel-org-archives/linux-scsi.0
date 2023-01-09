Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51168C5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbjAIXW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbjAIXWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038695591
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso11479270pjf.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uUq+HbvoXMZpOyoCQi3I8VvGWUAYK/4dmUAWPinMXY=;
        b=fJfBiFewz9Tydb5FY3MpwnyDfmVn5pZxIJSDOY809dI0wxKBEqCUrNQxt+cJHi+5Fk
         r7CyqMr5xKmdx+su8qfXo4ZeXjjINuCznlyTTUmgGWnuXVKp9b583wgJUZ6NyBZOnc1G
         2GNEFqp8WitmAQ2AmyyLjfLzzarT5HX9IK5UhHYH5XtXmhEWGIE5gsE7yXcFlSeVHhyU
         noHOsyppUDIbVX1+2kZUYN/xEXgeC/c0tkPt3xgUjC2uScojXZMd5eafHN9iCixAvUIQ
         ZnwQ65fR+rt/8KA+zjUNO9O0jPxw7g6MG+3n/62ZgP4fxxglVVSdFIsg8fPku370eWpd
         iSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8uUq+HbvoXMZpOyoCQi3I8VvGWUAYK/4dmUAWPinMXY=;
        b=MrywLvEkKZPphN20cLmCp+7W0OFQCDmUeGrgoJRKnMnVRVeiNMDFzEtVlIs67Wxv99
         OIMCG6PdFzIU40iXmOpy9g8OSp2z8nUHq1q1Gg1EEN2Et2VTmQdj3flahsdwU8ha9iwN
         NixeiOgn6f0FdMbymtaomrGgbCDBKN2oidIqujIAg3y1FnUnHnHwLN+tYK4TUhV56dsg
         vEyLv47v3/164fQxAogcye1VxeQIM/9DIGqsQEb0PaqwzmNh5PISerE83eXW80o3JH0e
         SiHMLymxs+25kQwMclio1JcTyAfPi2vLj43lduoFOiNET1R8DmuwP57lEAcaDvnTMHiU
         EBrA==
X-Gm-Message-State: AFqh2kprkoZkpUFJbapDdZU1tDVXEod+RGs8nNRwX3s1cusgPI9ZZVNh
        vhbug3kaLB1iNo3kGrHQUXl3ICXKfeE=
X-Google-Smtp-Source: AMrXdXvjYQ5vgBJssrm+0x9zjgAmVMFWUvYlfVVM5aUTtRxoRaGaWnxsivzAhtN9SdXSXjTDp0xTZA==
X-Received: by 2002:a17:903:2785:b0:194:3e2f:e078 with SMTP id jw5-20020a170903278500b001943e2fe078mr902914plb.43.1673306568267;
        Mon, 09 Jan 2023 15:22:48 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:48 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/12] lpfc: Remove duplicate ndlp kref decrement in lpfc_cleanup_rpis
Date:   Mon,  9 Jan 2023 15:33:11 -0800
Message-Id: <20230109233317.54737-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With faulty cables in PT2PT topology, an unintentional ndlp double kref
decrement can occur.

If a FLOGI request is outstanding before the link goes down, the missing
FLOGI_ACC causes an F_Port ndlp to remain in the UNUSED state.  During link
down, lpfc_cleanup_rpis is called and decrements an ndlp kref.
Additionally, when the driver later decides to abort the FLOGI, the FLOGI
completion handler decrements the ndlp kref a second time.

Remove duplicate clean up logic in lpfc_cleanup_rpis because the updated
FLOGI completion handler already handles the ndlp kref decrement.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 80375d73b732..af0acf55b343 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1129,21 +1129,6 @@ lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove)
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
-			/* It's possible the FLOGI to the fabric node never
-			 * successfully completed and never registered with the
-			 * transport.  In this case there is no way to clean up
-			 * the node.
-			 */
-			if (ndlp->nlp_DID == Fabric_DID) {
-				if (ndlp->nlp_prev_state ==
-				    NLP_STE_UNUSED_NODE &&
-				    !ndlp->fc4_xpt_flags)
-					lpfc_nlp_put(ndlp);
-			}
-			continue;
-		}
-
 		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
 		    ((vport->port_type == LPFC_NPIV_PORT) &&
 		     ((ndlp->nlp_DID == NameServer_DID) ||
-- 
2.38.0

