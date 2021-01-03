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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC4EC433E6
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D5E207A5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbhACASK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbhACASK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:10 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0DDC061795
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:04 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i5so16444176pgo.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e+e6PS6MqiXs8IIBjboY/Gk1idWmNALiKP+1QgE6I18=;
        b=OW9sexi1iZuTCAo3X1s1aoRrrblRr3YbP3XzcQhVPI0GTz1bLnYqGDq4vifvy2HCWu
         DuapnKoOby+TvIU1d9vwJ3tC33LasRKcrlpOWkqWj0MMhuSPpQ1/Y6Qi+0ECFeWe6YIp
         gkKAKwdSbxwpquFIerClzUL/+q0jTspwii3tE/Sbq5owpMFQ0iRyidVEDIH7H/Yd9lJA
         FCHuatC86qsY1HXbp/DcVKcWNdAFnGiDqmlH5040nK9+CNlSyGfWSG0Dzka+dN81OZnl
         rtNNMyeZk+xv8gB4+M/c5jSJ0sQBh8c9N/+cguU8Oq+QNdr+WkNR730QUhyjwCgABjTR
         BnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+e6PS6MqiXs8IIBjboY/Gk1idWmNALiKP+1QgE6I18=;
        b=mN/JnCfanPp4SDK9ITCQK/thYD3T5Vau/RnXvnEM5iDsNrTfho4/ptiCuxezuSM1f1
         gpOsei1QSNnznjdf7tuoZT1xpV3Iqn7RKe2myINtf6UT+w1TD6jJImSWV+8SusdlVpgX
         Blc9m6vsa7kWBp7nn8bYhqzGP8w5u/ifKYmixOY5tYfXXeKPEib9i3lMfsDejupSGcyD
         L5oOxlKc5zGRjkmIfXyrM8FgoW7NkYgjcT6bD8Y2CJppAyITR46+OwhR7y3M9B44DXfI
         4MfBgAaCA6lh4uMTuKf/gROO1ucZ7O8N2Zt/AbKo+KuRLyGyeqBlV6Bke/ZIUQR6mk8j
         BSqA==
X-Gm-Message-State: AOAM533g8/DeIOrgZfPvUFXGFjkH3D8MaXVpBDLad/eWfdsA+ReR3Jps
        kQsYDz+lBioM2LIq0POn8jMCChQzSww=
X-Google-Smtp-Source: ABdhPJzosNkpT2K4hIfXpwMJC9xFcitUxJMaJTuFkQRXuhZy5AMBPUdjlMEvndG/ov8D/nQEogaDXQ==
X-Received: by 2002:aa7:8f35:0:b029:19b:1258:ec5d with SMTP id y21-20020aa78f350000b029019b1258ec5dmr60777583pfr.9.1609633024273;
        Sat, 02 Jan 2021 16:17:04 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:03 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/15] lpfc: Fix FW reset action if IOs are outstanding
Date:   Sat,  2 Jan 2021 16:16:30 -0800
Message-Id: <20210103001639.1995-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the port is configured for NVME and has any outstanding IOs when a FW
reset is requesteed, outstanding I/O's are not properly cleaned up. This
causes the fw download request to fail.

Fix by clearing the LPFC_SLI_ACTIVE flag to signify the I/O must be
manually flushed by the driver on port reset.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1f0a62ecfad8..593b175702eb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1833,6 +1833,16 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2887 Reset Needed: Attempting Port "
 				"Recovery...\n");
+
+	/* If we are no wait, the HBA has been reset and is not
+	 * functional, thus we should clear LPFC_SLI_ACTIVE flag.
+	 */
+	if (mbx_action == LPFC_MBX_NO_WAIT) {
+		spin_lock_irq(&phba->hbalock);
+		phba->sli.sli_flag &= ~LPFC_SLI_ACTIVE;
+		spin_unlock_irq(&phba->hbalock);
+	}
+
 	lpfc_offline_prep(phba, mbx_action);
 	lpfc_sli_flush_io_rings(phba);
 	lpfc_offline(phba);
-- 
2.26.2

