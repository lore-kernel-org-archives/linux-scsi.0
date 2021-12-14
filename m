Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5A8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 13:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhLNNT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 08:19:57 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:39060 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhLNNT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 08:19:57 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5D4A921124;
        Tue, 14 Dec 2021 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639487996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWHVxcdFcBgER4PZS8F9yn2nv8ZByotPQ0jfapHHvmY=;
        b=2Q+Cf2oTkVB48167Jr8ziICrnwp5PdQWs3C0plCa2pPKmXZ4XBaooKhqgk7jhjA+wxhu+4
        g/iDxA+Nia1NMAG6vCiwss8n6gDd1r1eBW+BgjeM+7HsKTwdH9WXuW+H6WBT7APWekdf+2
        ghaMazGZR51TaI/Glu/agkWXQ9VdJ00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639487996;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWHVxcdFcBgER4PZS8F9yn2nv8ZByotPQ0jfapHHvmY=;
        b=r+0/9Tt1xWs/FE+9VAI0WfxDQX5xlMLcudjQqL3XiypD26KcKYN/eIXHaClUUVyfAUBOyK
        4SbNOVPKS3eAqnDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 55C2BA3B84;
        Tue, 14 Dec 2021 13:19:56 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 17828)
        id 47764519214E; Tue, 14 Dec 2021 14:19:56 +0100 (CET)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] lpfc: Reintroduce old IRQ probe logic
Date:   Tue, 14 Dec 2021 14:19:55 +0100
Message-Id: <20211214131955.76858-1-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210618085257.ouah6xsjv3akkjhz@beryllium.lan>
References: <20210618085257.ouah6xsjv3akkjhz@beryllium.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This brings back the original probing logic by adding the dropped code
to lpfc_sli_hba_setup().

Fixes: d2f2547efd39 ("scsi: lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi James,

after a back and forth, this version of the patch 'fixes' the problem
with older hardware. I just post for reference.

Daniel

See also:
https://lore.kernel.org/linux-scsi/20210618085257.ouah6xsjv3akkjhz@beryllium.lan/

 drivers/scsi/lpfc/lpfc_attr.c |  2 +-
 drivers/scsi/lpfc/lpfc_init.c |  8 ++++++--
 drivers/scsi/lpfc/lpfc_sli.c  | 34 +++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 7a7f17d71811..5730ac6462fa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3632,7 +3632,7 @@ unsigned long lpfc_no_hba_reset[MAX_HBAS_NO_RESET] = {
 module_param_array(lpfc_no_hba_reset, ulong, &lpfc_no_hba_reset_cnt, 0444);
 MODULE_PARM_DESC(lpfc_no_hba_reset, "WWPN of HBAs that should not be reset");
 
-LPFC_ATTR(sli_mode, 3, 3, 3,
+LPFC_ATTR(sli_mode, 3, 0, 3,
 	"SLI mode selector: 3 - select SLI-3");
 
 LPFC_ATTR_R(enable_npiv, 1, 0, 1,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2fe7d9d885d9..3f3734127a7f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12112,8 +12112,12 @@ lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 
 	/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
 	retval = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
-	if (retval)
-		return intr_mode;
+	if (retval) {
+		/* Try SLI-2 before erroring out */
+		retval = lpfc_sli_config_port(phba, LPFC_SLI_REV2);
+		if (retval)
+			return intr_mode;
+	}
 	phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;
 
 	if (cfg_mode == 2) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 513a78d08b1d..5f32b5243302 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5602,7 +5602,39 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 
 	/* Enable ISR already does config_port because of config_msi mbx */
 	if (phba->hba_flag & HBA_NEEDS_CFG_PORT) {
-		rc = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+		int mode = 3;
+
+		switch (phba->cfg_sli_mode) {
+		case 2:
+			if (phba->cfg_enable_npiv) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+						"1824 NPIV enabled: Override sli_mode "
+						"parameter (%d) to auto (0).\n",
+						phba->cfg_sli_mode);
+				break;
+			}
+			mode = 2;
+			break;
+		case 0:
+		case 3:
+			break;
+		default:
+			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+					"1819 Unrecognized sli_mode parameter: %d.\n",
+					phba->cfg_sli_mode);
+			break;
+		}
+
+		rc = lpfc_sli_config_port(phba, mode);
+
+		if (rc && phba->cfg_sli_mode == 3)
+			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+					"1820 Unable to select SLI-3.  "
+					"Not supported by adapter.\n");
+		if (rc && mode != 2)
+			rc = lpfc_sli_config_port(phba, 2);
+		else if (rc && mode == 2)
+			rc = lpfc_sli_config_port(phba, 3);
 		if (rc)
 			return -EIO;
 		phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;
-- 
2.29.2

