Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A515FC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD2A207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbhADSEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADSEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:13 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207FAC06179E
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:09 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id h186so16884016pfe.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z53wicCbTWbcmGaXtcMzmySQdMY1KhwIaIu2viGB+Nk=;
        b=dz9C7REmj0zCc3JYtmSXINcW3Ls59qW/GJbhuOtlP1CXqqeGUdilB5ybh/WyUkbRQL
         LoIXotdqT6e1jqxMK8PZRNPV8EDdlvG5XmMyuMvBQZRXGP3hP6dcCweEp8bX/uQCVVgF
         VWKuS57HCbF2pH28QzMcr07nG7ychOdCS+GcOiUyYKSCRxm56+5t2/Q6n+TJUhUZ+qpo
         8gqTWvCNrQqFsfONIU0URUgkmUMSeDZKmibzGUFZjL78Pey4fBbxKPKfsyFThECUmvuu
         WjAoYugSXuFCKP6G3QVdmD+num9+NaEyyjXj+pOXc34UsnZ0Oaa4k0L2w4dtcRjdPL00
         Dskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z53wicCbTWbcmGaXtcMzmySQdMY1KhwIaIu2viGB+Nk=;
        b=uVkH/N+0FQZlhX/zDpfOZfJWYFUx7SaAfcK2uiiyr8JUn7OMyjdJrar4CnU5ZarV+w
         oLOSGY5awACV3lG/LxAQvjZk7ovBGOD3BNmOpI598cemvF7vLDKYomjMN03j+dGvLeOC
         K0UXXgqsrzjFq4e1XHv1abEUCHfPKbtSNVQFmsanP2hqGceovjy515IbGOaAzzMWy5+s
         /AOTzO1+bOWhQJpHuOl4SERzX1YT7KSfzSaWwPDG60G53pNImw1t9k7/dEO5WJ/bcNpy
         lY4hT9mGleRSLx0soaqjNOvrYkk0qdOwHXuh27WYFPTPsXE+QSr1eGsK7x6ixa+A4Ct0
         tPlw==
X-Gm-Message-State: AOAM533HNV935QQJY7OWk2ndL9weQtMK/oAxusaF42aiVCWxW6CB/bVx
        ihFDjNXLf2CJ5YGOS3Lv+EFtcIS1UWs=
X-Google-Smtp-Source: ABdhPJxtxPkWtoA3QndF6Wgru7uCL2LrNBPpnQrzvDLsZ0Mr2Qpx/RowDPGNf0ZWyldV2eHvloKRIQ==
X-Received: by 2002:a63:c80e:: with SMTP id z14mr71834302pgg.435.1609783388640;
        Mon, 04 Jan 2021 10:03:08 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:08 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 07/15] lpfc: Prevent duplicate requests to unregister with cpuhp framework
Date:   Mon,  4 Jan 2021 10:02:32 -0800
Message-Id: <20210104180240.46824-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the lpfc offline routine, called for various reasons such as sysfs
attribute, driver unload, or port error, the driver is calling
__lpfc_cpuhp_remove() to destroy the hot plug data. If the offline
routine is called while the driver is in the process of being unloaded,
a request using lpfc_cpuhp_remove() is also made from
lpfc_sli4_hba_unset(). The cpuhp elements are no longer valid when the
second removal request is made.

Fix by only calling the cpuhp removal once when the adapter is in the
process of unloading.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 593b175702eb..af926768bcae 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3602,7 +3602,11 @@ lpfc_offline(struct lpfc_hba *phba)
 			spin_unlock_irq(shost->host_lock);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
-	__lpfc_cpuhp_remove(phba);
+	/* If OFFLINE flag is clear (i.e. unloading), cpuhp removal is handled
+	 * in hba_unset
+	 */
+	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
+		__lpfc_cpuhp_remove(phba);
 
 	if (phba->cfg_xri_rebalancing)
 		lpfc_destroy_multixri_pools(phba);
-- 
2.26.2

