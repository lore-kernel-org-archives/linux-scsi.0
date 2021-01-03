Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803C5C43332
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B59207A5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbhACASV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbhACASU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:20 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0469C0617A5
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lb18so7675775pjb.5
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qPdELg+OjQVtOy3duOch0ZFOqM5IHxny4qn9DDoNPCo=;
        b=ngpYyZWNDHEB23TE5fh3BlwGlc7cUMVtx0zNgJ5yNSdNf4LQX1Tlj8jxWKC/iwyLs7
         /y7YayGbRquBRhB4YxUb8NF2XBKw6nz/zW2LtPB7Dgba6lD+HsBM4/lClvD2yQzaKb+G
         bAExGrubcxJTZgkdtWygznVV5KGY7JIx7O2IZRvtrVAbxptotWeH0p9wP9louTUOjJq8
         ACcVbH2x4dnO35UBpiMtfaYhPUpbRMCxffVkGhcIxjrJHnTNL4uDNXs344CLoFjAOIg0
         N1xX53l+QtmtLKqFMFnnFAzJIg6J16YyifX8US+5noVnPTqOmzoJN8OhH7e5IctcVuVV
         RUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qPdELg+OjQVtOy3duOch0ZFOqM5IHxny4qn9DDoNPCo=;
        b=VpWXWvGdtpMjAGR5b8eTJMg0frGrbFVHyXsxxIon6SEr4dm3ZjSRo8D6TvH/5kBtNY
         wv38oEy000aaax76DXFfVGD5eCIljYsTgJZogAOFuRuct9PNe6PG5UNkjlANrC+Iidl/
         4pNxn1EzazqmHc606j7a/w8l7HuvCqWNbNIpEIsgigPsR7R7yAyJq/78k6Z4p1DCgjTU
         Hmcgs6ws23TTutPjjxy053pFIpz9Sxoy0b1jIEa+ThaSyMSv5gO36iANe/7Xdah8Tjwn
         UOqubQsXCh860OKqXKe4c56OTePCdlfXiPqGVDfrU/VHIF6Tp4SMvGy+557WS13Ra3FM
         +8qA==
X-Gm-Message-State: AOAM533+7feGD5XWQleDhgFruqm36funnZX5xJ0XQtFMOqeoDFM35Z2y
        C/Q+VNAu2bN973ggXdSgyB8Of14FVJ8=
X-Google-Smtp-Source: ABdhPJz9lj+qPdI+Cty3eI0HDJ0kfqt5wgSYc7UbYSHwrgdNZKap8SbbNNSX7nYHAAqUkpKZz41L/g==
X-Received: by 2002:a17:902:8307:b029:dc:8ac6:c4f8 with SMTP id bd7-20020a1709028307b02900dc8ac6c4f8mr6314525plb.79.1609633045312;
        Sat, 02 Jan 2021 16:17:25 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 14/15] lpfc: Enhancements to LOG_TRACE_EVENT for better readability
Date:   Sat,  2 Jan 2021 16:16:38 -0800
Message-Id: <20210103001639.1995-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While testing recent discovery node rework, several items were seen
that could be done better with respect to the new trace event logic.

1) in the following msg:
      kernel: lpfc 0000:44:00.0: start 35 end 35 cnt 0
   If cnt is zero in the 1st message, there is no reason to display the
   1st message, which is just giving start/end positioning.

   Fix by not displaying message if cnt is 0.

2) If the driver is loaded with module log verbosity off, and later a
   single NPIV host instance verbosity is enabled via sysfs, it enables
   messages on all instances. This is due to the trace log verbosity
   checks (lpfc_dmp_dbg) looking at the phba only. It should look at the
   phba and the vport.

   Fix by enabling a check on both phba and vport.

3) in the following messages:
       2904 Firmware Dump Image Present on Adapter
       2887 Reset Needed: Attempting Port Recovery...
   These messages are not necessary for the trace event log, which is
   primarily for discovery.

   Fix by changing log level on these 2 messages to LOG_SLI.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 20 +++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  |  2 +-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index dbd7e40f67f9..71f340dd4fbd 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1865,7 +1865,7 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 
 	/* need reset: attempt for port recovery */
 	if (en_rn_msg)
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2887 Reset Needed: Attempting Port "
 				"Recovery...\n");
 
@@ -14177,15 +14177,32 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	int i;
 	int j = 0;
 	unsigned long rem_nsec;
+	struct lpfc_vport **vports;
 
+	/* Don't dump messages if we explicitly set log_verbose for the
+	 * physical port or any vport.
+	 */
 	if (phba->cfg_log_verbose)
 		return;
 
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL) {
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			if (vports[i]->cfg_log_verbose) {
+				lpfc_destroy_vport_work_array(phba, vports);
+				return;
+			}
+		}
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
+
 	if (atomic_cmpxchg(&phba->dbg_log_dmping, 0, 1) != 0)
 		return;
 
 	start_idx = (unsigned int)atomic_read(&phba->dbg_log_idx) % DBG_LOG_SZ;
 	dbg_cnt = (unsigned int)atomic_read(&phba->dbg_log_cnt);
+	if (!dbg_cnt)
+		goto out;
 	temp_idx = start_idx;
 	if (dbg_cnt >= DBG_LOG_SZ) {
 		dbg_cnt = DBG_LOG_SZ;
@@ -14215,6 +14232,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 			 rem_nsec / 1000,
 			 phba->dbg_log[temp_idx].log);
 	}
+out:
 	atomic_set(&phba->dbg_log_cnt, 0);
 	atomic_set(&phba->dbg_log_dmping, 0);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d51d86959bbc..fa1a714a78f0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7491,7 +7491,7 @@ static void lpfc_sli4_dip(struct lpfc_hba *phba)
 			return;
 
 		if (bf_get(lpfc_sliport_status_dip, &reg_data))
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"2904 Firmware Dump Image Present"
 					" on Adapter");
 	}
-- 
2.26.2

