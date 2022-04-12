Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD23BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiDLXgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiDLXcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CB88CDB6
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 12so248327pll.12
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zaMEUCC1A+uyCQTvpb71rcxXx7DO/IPcmKR6u1Qa62s=;
        b=kxbgXRJ/2Qi5sVgf/rYjGQN8pG08UKfQDNQFH8rsw7okIJfS3ueE+XtwAt0oGztFH3
         dVdEr+niqbO/9eFrkw43u2OmexWEhLXnFn1bNHa2EFT5P6PoGFXWAG3sE722AFQN6Fwm
         8zchin9/1BBnd/PoXnJjVBxdKz1sXl1DpI+WIs+DYC2+titws0MWB/C8zb2OekaSsWQ5
         Yz6fuEoAIP1dreK1MxA/3WgGDN83l6BEZtDdKGAsWUJQGfIgvPD1bfIkRwhPk6KBVfxq
         u1jmtJA+Y8uQZKxjBN8J0G6LtRk4FuhX3ku9gYK6vX8NcuKpWGb45Y6LzmrS4jK37i3j
         a3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zaMEUCC1A+uyCQTvpb71rcxXx7DO/IPcmKR6u1Qa62s=;
        b=tZv3CVGXttIEsZYeeIUjnMqSTvLhg3wWNCe2ZEtpWvrY4SWKpdK7F+5KqSZ0IDEghA
         d7nAHxbwLAU5JvDs87IFn2U6PwXdMjbsSi/bKyIS9Z0cchfQ0gepzuE1uUAZg4oZb5w5
         wUCXCB/0wDxXKDFmRXyIMOuRYrckPgzCtLPjOo/4Yqs8maTfWLuYvdnXjpahoIAViAPC
         9HEYNCIGt3k1uKAHF0Wt67/Ea29J0eLv7+KKI05gQYFtMtmIcQTBTO7DOgYQJ7yKoFly
         P6YY0Lc9Muf8Mtnf4VLiQz/1/AxOn0Vsq7xhtmNATyUwT7ey9Kjzjsx0v3ctuHMeDRbf
         iCmQ==
X-Gm-Message-State: AOAM533HKgGeUw8gCaMgtD+4p7BA0Se1bLaPkZbcu+49YktpHrKOvpFq
        dtLQY2vWK/mCFfVXC0MIrrsnuchf10A=
X-Google-Smtp-Source: ABdhPJzHjKqXridave79HvY6roG3K1lJCSkt83uehvFQMgfAzOwDXzsB+TZrjD3fbZLsQT33ufuDeg==
X-Received: by 2002:a17:903:240f:b0:156:8e81:a0a3 with SMTP id e15-20020a170903240f00b001568e81a0a3mr38995833plo.13.1649802017763;
        Tue, 12 Apr 2022 15:20:17 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/26] lpfc: Fix diagnostic fw logging after a function reset
Date:   Tue, 12 Apr 2022 15:19:45 -0700
Message-Id: <20220412222008.126521-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_sli4_ras_setup routine is only called from lpfc_pci_probe_one_s4
routine, which means diagnostic fw logging initialization only occurs
during probing.

Thus, any path involving a reset of the HBA that restarts the
state of the SLI port does not reinitialize diagnostic fw logging.

Move lpfc_sli4_ras_setup into lpfc_sli4_hba_setup so that the
LOWLEVEL_SET_DIAG_LOG_OPTIONS mailbox command can be sent after a
function reset.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ---
 drivers/scsi/lpfc/lpfc_sli.c  | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f9cd4b72d949..7dfd47dcaad9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14832,9 +14832,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Check if there are static vports to be created. */
 	lpfc_create_static_vport(phba);
 
-	/* Enable RAS FW log support */
-	lpfc_sli4_ras_setup(phba);
-
 	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bda2a7ba4e77..7c86271f05fd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8864,6 +8864,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	}
 	mempool_free(mboxq, phba->mbox_mem_pool);
 
+	/* Enable RAS FW log support */
+	lpfc_sli4_ras_setup(phba);
+
 	phba->hba_flag |= HBA_SETUP;
 	return rc;
 
-- 
2.26.2

