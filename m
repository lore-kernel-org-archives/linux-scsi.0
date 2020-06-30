Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43513C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158B02074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQlNpg5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgF3Vuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgF3Vub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:31 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B863C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:31 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so21640688wrv.9
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xRNR0ZxnIn0JZFGDvrLWiqlG6djBZmdXn0xjvUvhb50=;
        b=qQlNpg5yy49sj0dDjBCAnKVxp6UqINHoyfCA2z41afuqJjYOkc+afSX8dCzDo3JsuC
         NQTG5UzvI0wLs6eRi24w9ILWaS33ouzBvWSc84yCkfFa0iDaXXJ7BW6PVt1aKOmeWr7s
         nX3H1KFScsnVbm7N6+zBTU9INygYlaQKSJHU7HcAAjzsmHubwZaRAwukDBEyF3q64PIl
         OV1IfP6RjmjkM04Vdzgh4jOLsIlY4zt3f13+Aw00wXW0ROrC1uONZ8WaNd2HSBjVKAD8
         MJg8PkQ0wOdOGQjvDDIuUsp9AQwyb7UgSu0kWF5UiOWgOqwW4YL+84prteE9BOkEhn6G
         ZxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xRNR0ZxnIn0JZFGDvrLWiqlG6djBZmdXn0xjvUvhb50=;
        b=WlavKjuFFrQteO68uS1jaR5ffIockb/lhLHzGxbY1A2IKBBKW6hIRpgxDqlzARiiI1
         dBAZpDCU13FsVe7c1UAsG8u3Vigonses3PF9+j8xpHWFK1przUPx5RjNHyfWFKAKrznS
         TjpbZDTJ2+e8g6AccAH/BCMmnnU3CeBny23w1kzx7p2HnWyZNzGFpcmBR5SDm5Q9Kxpc
         zhsoI5PEHf7/33DjGbg1ihBAr0oK5UCDsLDLk9QIKtO/AzyRg9S2fVOJjmMkvzKgXRdw
         E6jqdRcCZCsrpXEa4c9M0V2lwy/QLhF1ylj22961czp7j8BYKdT6M/PH85qOfbMqwb9o
         kgpw==
X-Gm-Message-State: AOAM533IAp9t3Rj7ehIBbI0uBZR2z1X1U6cFxiAJSZDLPBwLfkcDqLM5
        6qlXqlxvCjKCL/oyNKCuiGJWImuV
X-Google-Smtp-Source: ABdhPJxkabiCQZWh1k8RaKY8gXhXmbQ9MdcdwbzGieQJ1ZYzYUwsEeSIC39JVyhCK5k/XhBZHnkIog==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr22543657wrs.270.1593553829679;
        Tue, 30 Jun 2020 14:50:29 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/14] lpfc: Add support to display if adapter dumps are available
Date:   Tue, 30 Jun 2020 14:49:58 -0700
Message-Id: <20200630215001.70793-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, if there has been an issue whereby an adapter dump was taken,
there is nothing displayed to hint that it is present. Utilities must be
run and they must query for the status in order to then download the dump.

Add a message to the driver to query dump image presence when initializing
the SLI Port.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h |  3 +++
 drivers/scsi/lpfc/lpfc_sli.c | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index b8d3144a452d..c4ba8273a63f 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -650,6 +650,9 @@ struct lpfc_register {
 #define lpfc_sliport_status_oti_SHIFT	29
 #define lpfc_sliport_status_oti_MASK	0x1
 #define lpfc_sliport_status_oti_WORD	word0
+#define lpfc_sliport_status_dip_SHIFT	25
+#define lpfc_sliport_status_dip_MASK	0x1
+#define lpfc_sliport_status_dip_WORD	word0
 #define lpfc_sliport_status_rn_SHIFT	24
 #define lpfc_sliport_status_rn_MASK	0x1
 #define lpfc_sliport_status_rn_WORD	word0
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 271ba82f5d85..1ea710f9e842 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7300,6 +7300,26 @@ lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	return 1;
 }
 
+static void lpfc_sli4_dip(struct lpfc_hba *phba)
+{
+	uint32_t if_type;
+
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_2 ||
+	    if_type == LPFC_SLI_INTF_IF_TYPE_6) {
+		struct lpfc_register reg_data;
+
+		if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+			       &reg_data.word0))
+			return;
+
+		if (bf_get(lpfc_sliport_status_dip, &reg_data))
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2904 Firmware Dump Image Present"
+					" on Adapter");
+	}
+}
+
 /**
  * lpfc_sli4_hba_setup - SLI4 device initialization PCI function
  * @phba: Pointer to HBA context object.
@@ -7338,6 +7358,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		spin_unlock_irq(&phba->hbalock);
 	}
 
+	lpfc_sli4_dip(phba);
+
 	/*
 	 * Allocate a single mailbox container for initializing the
 	 * port.
-- 
2.25.0

