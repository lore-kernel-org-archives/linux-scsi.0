Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E84C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiFCRrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244999AbiFCRqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C76F222A5
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g205so7653242pfb.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dZuuFdsa30R1WGJTSTvb66jkpPKSwK0EQB5k/zdw9cg=;
        b=ZNkJtyXI4GnaXpDZ7Ov/bcz3aPpseYAKw5Fmk9IlI8YG3PzuXAaKBlpNW5DQcZg1jn
         1b/AVTPQiQA6oyEBqgR+5040h/0cwOlBgVtGfl5yOvAA7ntB3viGnX5hf0ZIbKlWjKYq
         2Mzz6YlNYAU7ZoHWxExI342gZ1vG5z4cZDGWiyAjsTVU0KMMWeCcfXY/txM+qmxpvpAi
         Z8oFqC4JqGffLHEBEEg5TOUI3tGsWKjOLdprB6yaGC8CifExejc0zTHjfJ43cFItGN/k
         SYgPT2DE617L06FrOJgY0vPqOUZOwERIfC0MbjCzkGzUm8khvxlygo8YScZZJmRw3dJG
         vBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dZuuFdsa30R1WGJTSTvb66jkpPKSwK0EQB5k/zdw9cg=;
        b=JSkoOk/1WUX6JL1zss1wkWSyBBg9ktKZSNkPKN2G+AyCaFMKAZXjkTL9fSmGCqezCr
         WQ5Zt3nIPHEe4wZhYXiAb0D7pvjEeyE7uCgo07k0B1T+wM4vJFXhKvn6msjdwm36ckL+
         /hQcIJwfdRQRn6VpEbBGZDryLzfk5mzTBNhTvjhl2qkV9shaq2mOEnO2jb43DDocwZH4
         j0MX0ip+VOL2h9kI04pZGY5UkGPTTwW6RIbnm4ga2OcWVmPn7ea0DHXKBmulZ526aVi+
         fTvSAKaS2RAh+Lg1dRdVcwL0Ytf9k0EYdyn7e5ZWpzkvPNo2k7w6wmjAf5QWj7AApJJf
         5m+w==
X-Gm-Message-State: AOAM532myY6ApawVSEQ8ESp9FhGsnLj30BklDu95IsxElwwEtFM3gyJh
        9Pqh0nyjQt1ewtrkcsc6LwUzFwW4+GY=
X-Google-Smtp-Source: ABdhPJzC6SeefG+BvrLMFgIx3bb5kzUwFqGcX9RyihA+Oct7Bg7r7d184Mk/gaF8xjrDykcGH+P9vw==
X-Received: by 2002:a63:8a4c:0:b0:3fc:5c99:a194 with SMTP id y73-20020a638a4c000000b003fc5c99a194mr10076876pgd.313.1654278220275;
        Fri, 03 Jun 2022 10:43:40 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:39 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 6/9] lpfc: Fix port stuck in bypassed state after lip in PT2PT topology
Date:   Fri,  3 Jun 2022 10:43:26 -0700
Message-Id: <20220603174329.63777-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After issuing a lip, a specific target vendor does not ACC the FLOGI that
lpfc sends.  However, it does send its own FLOGI that lpfc ACCs.  The
target then establishes the port IDs by sending a PLOGI.  Lpfc PLOGI_ACCs
and starts the RPI registration for DID 0x000001.  The target then sends
a LOGO to the fabric DID.  Lpfc is currently treating the LOGO from the
fabric DID as a link down and cleans up all the ndlps.  The ndlp for DID
0x000001 is put back into NPR and discovery stops, leaving the port in
stuck in bypassed mode.

Change lpfc behavior such that if a LOGO is received for the fabric DID in
PT2PT topology skip the lpfc_linkdown_port routine and just move the fabric
DID back to NPR.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 639f86635127..b86ff9fcdf0c 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -834,7 +834,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_nvmet_invalidate_host(phba, ndlp);
 
 	if (ndlp->nlp_DID == Fabric_DID) {
-		if (vport->port_state <= LPFC_FDISC)
+		if (vport->port_state <= LPFC_FDISC ||
+		    vport->fc_flag & FC_PT2PT)
 			goto out;
 		lpfc_linkdown_port(vport);
 		spin_lock_irq(shost->host_lock);
-- 
2.26.2

