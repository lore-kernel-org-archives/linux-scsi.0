Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65574C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40848611C1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhDJRbH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhDJRbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:05 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E14AC06138C
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c17so6381877pfn.6
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3VicCZ4n6Ofck7CJ6XpD1VuqTGfGUv3jny6IOfNGjYs=;
        b=odelXyU8RQOqLWfI0Kg/vkTmVmqYVGj47g0qotJCWBEp49fxXAxOsVNzUJnJZilA8c
         Hwr2A6Sv+gsbstXI9/059725mIzAjQSqTaX8RfspDzITLHwO7sOCMsnhP4QvSWjYB171
         uE9rhX42tWehfmY7K1STpzL4NxknxIl3JtdmFPgjsS0C9f5Ks/QlDnThM/4zTqjBPJ/w
         x8agEQOEB0Xti+63Yfafbtm6yH+Q4e0MEwEKNi0qLCOMIyOZQQcxIdRkHIY40qqojLqV
         W3BPWKvse0DMX+pJ99SbUnJF/vldLRPj7fTZIXQvdw/uwriwxQi6X221U/tB6gCylvU6
         nBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3VicCZ4n6Ofck7CJ6XpD1VuqTGfGUv3jny6IOfNGjYs=;
        b=LOCUzFZbAfJHBctLqo1n7h91hccg72oGalSsE2FqxF7sxY5MUkvbczdShek/0XsoXp
         WTXPQM0MguldjPMR+TNc/pkBqcJDc/M9XYLkBLJMafe3Uw6nFEiCiKVxNUS1C0PDUki6
         wvhBXGyKr7l8mSFl9oyqSzaLybJhDipO0lqJ+X+INyCpXVmed2fekOOe3a5gA9+nJ0AJ
         08FnC1B1eOOtirnyOFzC4GISdg8Fi8wtS1obXuWQRGx6eR/jVD5EJGvTt71g5tgenL0X
         BXvnypqbzMtrMBkMSgkFXm9XF/E7WQ0BuVvTtBBnev/5sxH+Z9eL2Af6Nfpw4NntvaBF
         bPFw==
X-Gm-Message-State: AOAM533iH6faF/eYxOvBp1xaaN0HdN7pFF/+yV2FGycYmeUArUbsO9CD
        tkVEHOdlGPPtXNolikt3M9NH9Ree8Zc=
X-Google-Smtp-Source: ABdhPJyxH2FXKcGrbdrwQkks1sCxWLTEvK4xq7JhfXSsoR2lMqWvrAxaZmBd0LeFvfS/Cp18BKPCvw==
X-Received: by 2002:a62:7692:0:b029:23e:7a96:a0f9 with SMTP id r140-20020a6276920000b029023e7a96a0f9mr16943927pfc.45.1618075849785;
        Sat, 10 Apr 2021 10:30:49 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/16] lpfc: Fix missing FDMI registrations after Mgmt Svc login
Date:   Sat, 10 Apr 2021 10:30:27 -0700
Message-Id: <20210410173034.67618-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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

