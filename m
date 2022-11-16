Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241B4C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiKPBKz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiKPBKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:10:54 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066AC317F9
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:10:54 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id i9so10734473qki.10
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXQuLH03XzUYi6+WgpNrxfrW2ANmPdXWWQXUz58Src0=;
        b=pbVRgtdVlmQ6+ZnkkUeA+h62H1wicgMLv8OTs3EJoRp67w9M+muDcdp8mDdOKnajt+
         BqG6UgRuoJnlfx9O3jvojS/9mNz9WbSxsiBWe0TMkOOt7bO+Lu9Ktqw2HF+7d09oRqGe
         SJqsyrgFdKdCacc3dimrWDsUiBn2u1lmu46uEwDwCEgHOcN+pzt+ns+ttFoMa4edwjjp
         r6aJcIUPuR8Y6BakuqgaG27pNahfFuNK1ss8RjzsMkkOP79IpVZ/zHXpswD7Wh+xVr5f
         6ZGOoh1LDM+nX2XqIn9hJTZZWLclYt82H1w6JT6F32FwypHYlQDR5ulyAkBGkdfQjKM/
         bY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXQuLH03XzUYi6+WgpNrxfrW2ANmPdXWWQXUz58Src0=;
        b=dY5RjGf4gc+YINU0T2L5Mnf4cnJYugujzBOodQXq1ZF2dEl9ymmY3/Xp0wxYxj054v
         sCUpmrEbHAtUybHX+bCOq0YjN/L5AzZ5pNk+e93Hpp2BMhKDR2F/W5FGq7dHUssztKnZ
         JwXW/lAoWkKk5XTTfBaUnSgPsTiyK6ZxoNv4zFyFuWVLH6L8GNCLzdlttKDHNbMxxKr3
         3Cy4f98BXbfomua3dwhc/4rFIkizcXspZW19kgM8u0FUADGe+XIsUewFhY4YTiJjW6Ev
         3WCZl3bxUsTQkvJ3Wrfp+NLxVm0NraANFcnJ1WTroB8XwKU8sQaSkrq5k+fldDelgDhl
         BVIQ==
X-Gm-Message-State: ANoB5pkiw/VbQyBDC8XPMvDxXUDOBTDbuPAgwpJyhGK6VYI3SeBMTOlw
        sP8BIGjnC3q8t9I99WGmTi2nmzdNBYw=
X-Google-Smtp-Source: AA0mqf7FbN6pScMCm957Qf2nw28A7eE+bi0vvsgprfvbIGoGGCu6wg1i3Eg2siX0HE6+mlpjoSZTjQ==
X-Received: by 2002:a05:620a:1375:b0:6fa:ab2b:b78d with SMTP id d21-20020a05620a137500b006faab2bb78dmr17157557qkl.388.1668561053008;
        Tue, 15 Nov 2022 17:10:53 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.10.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:10:52 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 1/6] lpfc: Fix WQ|CQ|EQ resource check
Date:   Tue, 15 Nov 2022 17:19:16 -0800
Message-Id: <20221116011921.105995-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adapter configurations with limited EQ resources may fail to initialize.

Firmware resources are queried in lpfc_sli4_read_config().  The driver
parameters cfg_irq_chann and cfg_hdw_queue are adjusted from defaults if
constrained by firmware resources.

The minimum resource check includes a special allocation for queues such
as ELS, MBOX, NVME LS. However the additional reservation was also
incorrectly applied to EQ resources.

Reordered WQ|CQ|EQ resource checks to apply the special allocation
adjustment to WQ and CQ resources only.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b49c39569386..a6e32ecd4151 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10092,17 +10092,15 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 		qmin = phba->sli4_hba.max_cfg_param.max_wq;
 		if (phba->sli4_hba.max_cfg_param.max_cq < qmin)
 			qmin = phba->sli4_hba.max_cfg_param.max_cq;
-		if (phba->sli4_hba.max_cfg_param.max_eq < qmin)
-			qmin = phba->sli4_hba.max_cfg_param.max_eq;
 		/*
-		 * Whats left after this can go toward NVME / FCP.
-		 * The minus 4 accounts for ELS, NVME LS, MBOX
-		 * plus one extra. When configured for
-		 * NVMET, FCP io channel WQs are not created.
+		 * Reserve 4 (ELS, NVME LS, MBOX, plus one extra) and
+		 * the remainder can be used for NVME / FCP.
 		 */
 		qmin -= 4;
+		if (phba->sli4_hba.max_cfg_param.max_eq < qmin)
+			qmin = phba->sli4_hba.max_cfg_param.max_eq;
 
-		/* Check to see if there is enough for NVME */
+		/* Check to see if there is enough for default cfg */
 		if ((phba->cfg_irq_chann > qmin) ||
 		    (phba->cfg_hdw_queue > qmin)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.38.0

