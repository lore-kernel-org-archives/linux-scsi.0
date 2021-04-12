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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9552C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C5361027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbhDLBc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbhDLBcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4F3C061343
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p16so1546558plf.12
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3VicCZ4n6Ofck7CJ6XpD1VuqTGfGUv3jny6IOfNGjYs=;
        b=W7519NPT79aomD9SdPomPKLWgnWn2e7A8zL/zsam1nqlsHOFeYy2JvAM6cfJV9E7I7
         GZIfipDmfdyJF9+FI657P3RRqCpWRJQRMjvEuC+D9zhjGM5STD5SUPL7/fokuzhw6kYn
         5h1v9Cevmv2/x+0wShzg1FhP+bgLpJ1cD7l2jC2oSHFFDh5w8pTiat02qywEg1oWmlRx
         W2twbPwqA/uhUCBBRVVwwn2qAK9r0i+HfmW1Mehm3cscgzsp5lc4Ft4n0MZqeKNfKfAr
         qSbfs7GClt3bj4MHlxmHM8BgE+Gxyw5ncUKolmgpfgHNd8cQQIJ8EqQMlwjBcgM7N/uo
         oEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3VicCZ4n6Ofck7CJ6XpD1VuqTGfGUv3jny6IOfNGjYs=;
        b=kaNp3UjBQiml3T2nNXTQLtWjmwzr76C8hP/pLVeiiFL/AXZ5FqOZUCYgbayIO6FAlf
         DGVJCSDwCPayUtsvWI+peDx3rvJL7f79UpYY6vwmyT+GnNkX+pOiBo2bqeSMfkYNJybt
         ONM0tmJPl3gIniXMS6PqqrGfAM+UK2nwfqwsZ/NmFJrhBwjJZk78S2pq71qCnGbXq8n7
         ZWsLqCcoGetmIZ/8qgJF9yPBO2JVoROUWyc1VYPxkSJjM+x4BjDwFlSuTJay6tw35ZeP
         4KAPV8e+yHqVBGol3AIOc1es2ZUPLKef2Ov3rhxw6Au5AcrfVwgziekov9lp8rQfER/l
         cnuQ==
X-Gm-Message-State: AOAM531D4Wkc9vBJe2sn/2q9pISv+OrYdMvxUpOhjrTWV/k9cJYcFL4K
        EVVzwO+R2MAT6mS863NXspyItpxqWWg=
X-Google-Smtp-Source: ABdhPJwb+oWaI+Cbt+zLP1pXw90gS7IEXHEYQlDvxscwe8QZgDYw3WMcCuSIqRC/AVN4o6wMG2fY4g==
X-Received: by 2002:a17:902:525:b029:e8:e347:b07f with SMTP id 34-20020a1709020525b02900e8e347b07fmr23931516plf.34.1618191125363;
        Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 09/16] lpfc: Fix missing FDMI registrations after Mgmt Svc login
Date:   Sun, 11 Apr 2021 18:31:20 -0700
Message-Id: <20210412013127.2387-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FDMI registration needs to be performed after every login with the FC
Mgmt service. The flag the driver is using to track registration is
cleared on link up, but never on Mgmt service logout/re-login.

Fix by clearing the flag whenever a new login is completed with the
FC Mgmt service.

While perusing the flag use, logging was performed as if FDMI
registration occurred on vports. However, it is limited to the physical
port only. Revise the logging to reflect physical port based.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 28 ++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  6 ++++--
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 37b0c2024998..8da9e18a1fde 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2253,12 +2253,12 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			return;
 
 		case SLI_MGMT_RPA:
-			/* No retry on Vendor RPA */
+			/* No retry on Vendor, RPA only done on physical port */
 			if (phba->link_flag & LS_CT_VEN_RPA) {
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_DISCOVERY | LOG_ELS,
-						 "6460 VEN FDMI RPA failure\n");
 				phba->link_flag &= ~LS_CT_VEN_RPA;
+				lpfc_printf_log(phba, KERN_ERR,
+						LOG_DISCOVERY | LOG_ELS,
+						"6460 VEN FDMI RPA failure\n");
 				return;
 			}
 			if (vport->fdmi_port_mask == LPFC_FDMI2_PORT_ATTR) {
@@ -2306,23 +2306,24 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if (phba->link_flag & LS_CT_VEN_RPA) {
 				lpfc_printf_vlog(vport, KERN_INFO,
 						 LOG_DISCOVERY | LOG_ELS,
-						 "6449 VEN RPA Success\n");
+						 "6449 VEN RPA FDMI Success\n");
+				phba->link_flag &= ~LS_CT_VEN_RPA;
 				break;
 			}
 
 			if (lpfc_fdmi_cmd(vport, ndlp, cmd,
 					  LPFC_FDMI_VENDOR_ATTR_mi) == 0)
 				phba->link_flag |= LS_CT_VEN_RPA;
-			lpfc_printf_vlog(vport, KERN_INFO,
+			lpfc_printf_log(phba, KERN_INFO,
 					LOG_DISCOVERY | LOG_ELS,
 					"6458 Send MI FDMI:%x Flag x%x\n",
 					phba->sli4_hba.pc_sli4_params.mi_value,
 					phba->link_flag);
 		} else {
-			lpfc_printf_vlog(vport, KERN_INFO,
-					 LOG_DISCOVERY | LOG_ELS,
-					 "6459 No FDMI VEN MI support - "
-					 "RPA Success\n");
+			lpfc_printf_log(phba, KERN_INFO,
+					LOG_DISCOVERY | LOG_ELS,
+					"6459 No FDMI VEN MI support - "
+					"RPA Success\n");
 		}
 		break;
 	}
@@ -2369,10 +2370,13 @@ lpfc_fdmi_change_check(struct lpfc_vport *vport)
 		 * DHBA -> DPRT -> RHBA -> RPA  (physical port)
 		 * DPRT -> RPRT (vports)
 		 */
-		if (vport->port_type == LPFC_PHYSICAL_PORT)
+		if (vport->port_type == LPFC_PHYSICAL_PORT) {
+			/* For extra Vendor RPA */
+			phba->link_flag &= ~LS_CT_VEN_RPA;
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
-		else
+		} else {
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DPRT, 0);
+		}
 
 		/* Since this code path registers all the port attributes
 		 * we can just return without further checking.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 85633eb7524f..03977a2268fe 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5952,10 +5952,12 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * DHBA -> DPRT -> RHBA -> RPA  (physical port)
 	 * DPRT -> RPRT (vports)
 	 */
-	if (vport->port_type == LPFC_PHYSICAL_PORT)
+	if (vport->port_type == LPFC_PHYSICAL_PORT) {
+		phba->link_flag &= ~LS_CT_VEN_RPA; /* For extra Vendor RPA */
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
-	else
+	} else {
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DPRT, 0);
+	}
 
 
 	/* decrement the node reference count held for this callback
-- 
2.26.2

