Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6F9C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 530BC222C2
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUtryaeE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLRX6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44758 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLRX63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:29 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so4120201wrm.11
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KGtupt5O4VqDIbyjx/1nXTaVSxz4aRc+ZHDkOvzEnQk=;
        b=DUtryaeEIqTwYl4L/Qn9uxq6nn+0QU/duf0mryCBL6n55OoIVBnX9F4Pu977ino2Qk
         K5JxQk/aDJPmCsJelUVpDT2MZahBi1hScb9iQmmyHF7oiKGJYa+reeEWKVBCO8mlBInY
         wFsELp260Fh9K4sSnHv0ocGC9fP07QDViggCtgfLc14TjmD8Z3W+lyE6NjR4xDiQSoPq
         GTFYoOYmQYRtxc7uCng5SjoKxbGyPqwa65VALHrKSontBlHj5XtaLoqsoqtblFzN59H+
         RrwuJJ3Md1o7D+w1BNwhbWAxfiNyKWh4pDkyUF5a8QvG1OhPzWNlD+KjUQtKaW5Ch1we
         mOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KGtupt5O4VqDIbyjx/1nXTaVSxz4aRc+ZHDkOvzEnQk=;
        b=SUyAOOC30Ktmudib9ka4dv8iE79oOSvo/tDXB+c7pXyXQRIllNz0RYxiCBKtFw+ol9
         yL4M/a4Xfaq87U1LMl1Fs6JvizQfrsjC+zH8j+IPc2Uqc3jUWdMnUSXD5sG9JCiA78n3
         r6RlD3ydMGexjL5dn5XDFlXf7zTqmgBfzPPooPFYYpIPTpNyQ2DGXsUYsajLU+AzTWs3
         eW8RRG5Qz2tzu1OGNQ+MRLGAj2NZUSr2cu2SxQw2556ZzBt/WekdJG2QKEeZyVHJysCM
         XzQgvaNQz8Vt6HhzYx8Wsf2840ADYo2dLF8dUWbn7MrEOT4A4TFyVEwVAQaavHO0AZpy
         KaLA==
X-Gm-Message-State: APjAAAVWi46QBgXrijm1NXvRsBnzqKed3vQT06Bkg90OSd+uLuoJPDKC
        Am0Fau/cs/VVnA6Z4WcCWz2llFGv
X-Google-Smtp-Source: APXvYqwPuwJcM7i9wcG4ZMxFdYXKhOhEVsOuwD3CxotkNDHflSogvqzCOE8EogfvNXKuMl2YTSN8Wg==
X-Received: by 2002:a5d:6901:: with SMTP id t1mr5454625wru.94.1576713507891;
        Wed, 18 Dec 2019 15:58:27 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:27 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/10] lpfc: Fix disablement of FC-AL on lpe35000 models
Date:   Wed, 18 Dec 2019 15:58:04 -0800
Message-Id: <20191218235808.31922-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The order of the flags/checks for adapters where FC-AL is supported
erroneously excluded lpe35000 adapter models.  Also noted that the G7
flags for Loop and Persistent topology are incorrect. They should follow
the rules as G6.

Rework the logic to enable LPe35000 FC-AL support.
Collapse G7 support logic to the same rules as G6.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 9 ++++-----
 drivers/scsi/lpfc/lpfc_init.c | 8 --------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4ff82b36a37a..46f56f30f77e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4123,14 +4123,13 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 		/*
 		 * The 'topology' is not a configurable parameter if :
 		 *   - persistent topology enabled
-		 *   - G7 adapters
-		 *   - G6 with no private loop support
+		 *   - G7/G6 with no private loop support
 		 */
 
-		if (((phba->hba_flag & HBA_PERSISTENT_TOPO) ||
+		if ((phba->hba_flag & HBA_PERSISTENT_TOPO ||
 		     (!phba->sli4_hba.pc_sli4_params.pls &&
-		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC) ||
-		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC) &&
+		     (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
+		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC))) &&
 		    val == 4) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				"3114 Loop mode not supported\n");
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 633ca46b0e4b..3defada2602f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8320,14 +8320,6 @@ lpfc_map_topology(struct lpfc_hba *phba, struct lpfc_mbx_read_config *rd_config)
 	phba->hba_flag |= HBA_PERSISTENT_TOPO;
 	switch (phba->pcidev->device) {
 	case PCI_DEVICE_ID_LANCER_G7_FC:
-		if (tf || (pt == LINK_FLAGS_LOOP)) {
-			/* Invalid values from FW - use driver params */
-			phba->hba_flag &= ~HBA_PERSISTENT_TOPO;
-		} else {
-			/* Prism only supports PT2PT topology */
-			phba->cfg_topology = FLAGS_TOPOLOGY_MODE_PT_PT;
-		}
-		break;
 	case PCI_DEVICE_ID_LANCER_G6_FC:
 		if (!tf) {
 			phba->cfg_topology = ((pt == LINK_FLAGS_LOOP)
-- 
2.13.7

