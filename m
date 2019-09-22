Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8646C3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6CA20B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TG9z0vf9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfIVD7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:35 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37296 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfIVD7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:34 -0400
Received: by mail-oi1-f193.google.com with SMTP id i16so5004033oie.4
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z0VilPmibwA6x129JeLpiupcGkoeAavTxrlvnzm8m40=;
        b=TG9z0vf99dkwEaoFW12TLFKfhkuzCmO9YpwrUmoTKfPFcOz7J27ACHnQOm6uW+4TjT
         IsV19/qnYjHjFoGjVhoim1mgVNX9AgWVBavtoHOvFg7LJkxfuTNLoMuj24noSSj6BJjf
         Z5KIhfnSFA18Xvbe+JicNZVwgTWBjsuiXDHt+doseOhG2XBl+vIBMstTNooi5m3M8RyU
         yy2xPVelzznTWKV9iy8SqGwYKsOF8oVqqaON+iIcMKtfHBvA0pGp3UJYCks5lXH/Q77y
         zerZQv5tNTIeckTVxaoRhXAsG5auk3iIuNqn3vJTfIFUJS4C1WyCmd751GZ46JuuIho8
         HD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z0VilPmibwA6x129JeLpiupcGkoeAavTxrlvnzm8m40=;
        b=Nbjuw6mDu/tYbNZZQxUUzfokO9d9WJq2I1geobz+ERJswb+vMy83/UUi8/l7CtHEFw
         GxHMgwXZROMhfiqe/m8hQ5zT4gGaRxrS0jZKJeJnnUQerAK2GuAbLyK7wFKqs9xZJ/tj
         R8CV89mEuwaxGySi6fCREMGtvrhLICy5m/Q98ikQS+BgkAlPsLg9WoDw7uAntbfKFIKx
         jgtqfXqpAXYJDDZlqrtVx34U5B+CikkxVCgcjtGIpX8AvJLrXJE6SjGoMQCtMLPdnlrd
         Uh9MEHthHqKihHb7S96Ty/pASQML/AXf5Er3bFo9p1P9H1tuC6/8DfEb45wXtlK5AqzP
         V0cg==
X-Gm-Message-State: APjAAAWVrnTmn8EhmOL7EqNvnTQFXSzYahIkFh+NmdbW0SHFj2y34Amf
        7I8ps1GB+Y5w3R/gnw1hG2+aLN1X
X-Google-Smtp-Source: APXvYqxc2ovnNb+GEYz3v8vGytQJYMdZIpfH6Boyu2O5zEKx2GsSuB1aeBQJsJyLvulRN/LdnN290w==
X-Received: by 2002:aca:f002:: with SMTP id o2mr9275770oih.62.1569124773870;
        Sat, 21 Sep 2019 20:59:33 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 17/20] lpfc: Update async event logging
Date:   Sat, 21 Sep 2019 20:59:03 -0700
Message-Id: <20190922035906.10977-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch updates ACQE handling for:
- a EEPROM failure error reported by the adapter
- ensures that all data for any ACQE, recognized or not, is logged.
- Given that all data is now logged unconditionally, the default
  case (unrecognized) data can be reduced.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index f70fb7629c82..6095e3cfddd3 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4261,6 +4261,7 @@ struct lpfc_acqe_sli {
 #define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
 #define LPFC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
 #define LPFC_SLI_EVENT_TYPE_REMOTE_DPORT	0xA
+#define LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE	0x10
 };
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 12885b01fa27..a0aa7a555811 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5289,10 +5289,10 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 	evt_type = bf_get(lpfc_trailer_type, acqe_sli);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"2901 Async SLI event - Event Data1:x%08x Event Data2:"
-			"x%08x SLI Event Type:%d\n",
+			"2901 Async SLI event - Type:%d, Event Data: x%08x "
+			"x%08x x%08x x%08x\n", evt_type,
 			acqe_sli->event_data1, acqe_sli->event_data2,
-			evt_type);
+			acqe_sli->reserved, acqe_sli->trailer);
 
 	port_name = phba->Port[0];
 	if (port_name == 0x00)
@@ -5439,11 +5439,16 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 				"Event Data1:x%08x Event Data2: x%08x\n",
 				acqe_sli->event_data1, acqe_sli->event_data2);
 		break;
+	case LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE:
+		/* EEPROM failure. No driver action is required */
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+			     "2518 EEPROM failure - "
+			     "Event Data1: x%08x Event Data2: x%08x\n",
+			     acqe_sli->event_data1, acqe_sli->event_data2);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-				"3193 Async SLI event - Event Data1:x%08x Event Data2:"
-				"x%08x SLI Event Type:%d\n",
-				acqe_sli->event_data1, acqe_sli->event_data2,
+				"3193 Unrecognized SLI event, type: 0x%x",
 				evt_type);
 		break;
 	}
-- 
2.13.7

