Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E06C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiKPBLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiKPBLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:11:01 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D143137B
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:00 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id cg5so9867077qtb.12
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5IP2zZ0ikXwU/6tqJtqLv3xaAmM7FUpKnU+9266pdAo=;
        b=YWP+vArPap1tXdk/HQyhrjl2Oj1p/JbS1A+TMufYpIXg4ZikMgHtG/kxcC9+qxwXpO
         56ix0CgLCuaQOTSnmmMfEWomEIqw+OyBOz7wQCt5oJHYuJOphi0EDpUer2qwCIGaPEDm
         hUFrXpS5jk5ERFnezw4841c5tocJaH5XrkNZFPuCJUyKC5BWCrjwoThzXXElRdK9EGRZ
         WXaFVjHYaGIk+4xg5AisfHq02xeY6sqgZMwXJtQi23ueCzXEEXyCf64gzsfsJovjHn1B
         Dbdf5GZ8CaOphhGjIyIaWZW8AbpkHETwMiahaOk15mf1s+kfz8rla1IZ5r8rHKfQdsvM
         CBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5IP2zZ0ikXwU/6tqJtqLv3xaAmM7FUpKnU+9266pdAo=;
        b=6XYkQiTvTw6zS51iQyfEfP7sc6iCoP5lJ4UdM16teasiOpL3WTzuIheJIgOdSLJXrj
         QL0dQi+Z3t4JrmD1TFV8yfMSf4na88GHBblauDHDEjzzJOLnR/m8xjfCJCrphJrHwWaY
         ZSXNzuT0E+lULkL1LLir5/e+71mvNcuo0ApurUog/TOGB0NVYGZhS2o0nlQ6TZwtIFCy
         WKx2DIUa//F13BeP2Y1hbJ6mZu0lvh6OFuIS/1LYb+4JduGhJojsz86qUQc6L3yOaUjl
         tJHntE+JAMEh6fNT/cmI78I50f9/B7hJpsZhZGjKHn2ou74Btr0j/4TRJ0sr/yr8+qxh
         jLog==
X-Gm-Message-State: ANoB5plToPbYms8cBIPZs1bsoAeQAw6UKb/vpiuJum7BEcxc9nkgCeFk
        +KQtw9mkRd8WeQUcokm9qJaebskWoIQ=
X-Google-Smtp-Source: AA0mqf5tHFDthV6rGCIgUdWY+KmUNAC1DD8FjsptVU4lDwdlhJXvJe/iiyYrdcV9JdYSBfKR4LNonw==
X-Received: by 2002:a05:622a:248c:b0:3a5:6005:7db6 with SMTP id cn12-20020a05622a248c00b003a560057db6mr19066934qtb.131.1668561059267;
        Tue, 15 Nov 2022 17:10:59 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.10.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:10:59 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/6] lpfc: Fix MI capability display in cmf_info sysfs attribute
Date:   Tue, 15 Nov 2022 17:19:18 -0800
Message-Id: <20221116011921.105995-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The dynamic mi_ver value holds the currently configured MI setting.  mi_ver
was being displayed as part of the cmf_info sysfs attribute, when the
output string meant to display MI capabilities instead.

Add a mi_cap member in the lpfc_pc_sli4_params structure that will store
MI capabilities during initialization so that cmf_info prints out
capabilities instead of current configuration.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 drivers/scsi/lpfc/lpfc_init.c | 3 +++
 drivers/scsi/lpfc/lpfc_sli4.h | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 030ad1d59cbd..77e1b2911cb4 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -134,7 +134,7 @@ lpfc_cmf_info_show(struct device *dev, struct device_attribute *attr,
 	scnprintf(tmp, sizeof(tmp),
 		  "Congestion Mgmt Info: E2Eattr %d Ver %d "
 		  "CMF %d cnt %d\n",
-		  phba->sli4_hba.pc_sli4_params.mi_ver,
+		  phba->sli4_hba.pc_sli4_params.mi_cap,
 		  cp ? cp->cgn_info_version : 0,
 		  phba->sli4_hba.pc_sli4_params.cmf, phba->cmf_timer_cnt);
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a6e32ecd4151..a119c06742b8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -699,6 +699,8 @@ lpfc_sli4_refresh_params(struct lpfc_hba *phba)
 		return rc;
 	}
 	mbx_sli4_parameters = &mqe->un.get_sli4_parameters.sli4_parameters;
+	phba->sli4_hba.pc_sli4_params.mi_cap =
+		bf_get(cfg_mi_ver, mbx_sli4_parameters);
 
 	/* Are we forcing MI off via module parameter? */
 	if (phba->cfg_enable_mi)
@@ -13839,6 +13841,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 					   mbx_sli4_parameters);
 	phba->sli4_hba.extents_in_use = bf_get(cfg_ext, mbx_sli4_parameters);
 	phba->sli4_hba.rpi_hdrs_in_use = bf_get(cfg_hdrr, mbx_sli4_parameters);
+	sli4_params->mi_cap = bf_get(cfg_mi_ver, mbx_sli4_parameters);
 
 	/* Check for Extended Pre-Registered SGL support */
 	phba->cfg_xpsgl = bf_get(cfg_xpsgl, mbx_sli4_parameters);
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index cbb1aa1cf025..f927c2a25d54 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -556,6 +556,7 @@ struct lpfc_pc_sli4_params {
 #define LPFC_MIB3_SUPPORT	3
 	uint16_t mi_value;
 #define LPFC_DFLT_MIB_VAL	2
+	uint8_t mi_cap;
 	uint8_t mib_bde_cnt;
 	uint8_t cmf;
 	uint8_t cqv;
-- 
2.38.0

