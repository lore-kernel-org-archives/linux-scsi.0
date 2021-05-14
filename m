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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF58C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4135761574
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhENT5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhENT5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:19 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410D0C061574
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c17so497914pfn.6
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j8DAvSRnecD1lSX2w3DovQ0I4S6TWZhTIr5U7pv2t/Y=;
        b=qXQME3Sbp5BzYiC+W88B3Gg3bGP2AcbfF4IWpZ4UeV/uyQfgDgWdDKZ0hci2E4sqXQ
         kjBVDeg7nZFJBGEV1lQ10MXpkSk+aMIEvdg4FJvTRldg3VE0STXGDwCcl7R6C1lIuovU
         oMnAZBFgBSx8GAoUdT8lFWoJJGNEKjTSzKTiiXIQcgUX4CtkSgRuPSflYGYIgL6SinJu
         ZNHTDB40PWdx19PUjJiNU289kbd1Aq8/f6ng8X144JgTaHypxB4GRsbkcPEw3rffjQXA
         1MAKcLXFz150+nOW53PZEiwNK5k0LKuWi5ohIgHnQIzoYht+QkSuOZBGbDfTw7NH9Isy
         Ureg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j8DAvSRnecD1lSX2w3DovQ0I4S6TWZhTIr5U7pv2t/Y=;
        b=V5ATeK6w5PK7L40ufDaZ7+1kHIiprqUX4edW+7C4SWgjmKfvLKxaZiKikMWuarAKws
         QdwfTSPIYZ9zKpP5AjJ9S3GI+qxgDCXOSfH21hLfr5jijuUwox+8buGHaI8E7ibdWC6U
         lDnKxlpCtT7O7M0SpjK8sVgxyHPimWkGJ9uUYn+QZPeU0+i49Yt9LcjLK0IioBfSms3a
         W9I1gbuH4MM/An8b8WN0m9lUql7CPE9aCFMknreEPpH/OfotGRrrzvMsDYt0CR1SNv1k
         wvTdOKMgTXqF6SMz33Iw1X5fmv+isT2j28U/ElYpAkFhQBIx6e8gqleqnaAjdTGCQh7N
         xr7A==
X-Gm-Message-State: AOAM5331OOiHjfWu/thx677MTSiNCkdleHCfYnT0/7YQ3yM9zkXpx2F+
        S3z8r4pjTCXtyadLdn92VJMe+91Qxlo=
X-Google-Smtp-Source: ABdhPJwzk7/UtaKVPdRBIv/5vtlpB1neTEXkQOfb4EI/TYf+mZ6cPMp5q9LAeXrf/S57uJcupeOL3g==
X-Received: by 2002:aa7:86c5:0:b029:28e:756e:a889 with SMTP id h5-20020aa786c50000b029028e756ea889mr47145082pfo.59.1621022166744;
        Fri, 14 May 2021 12:56:06 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:06 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/11] lpfc: Fix "Unexpected timeout" error in direct attach topology
Date:   Fri, 14 May 2021 12:55:51 -0700
Message-Id: <20210514195559.119853-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An 'unexpected timeout' message may be seen in a pt-2-pt topology.
The message occurs when a PLOGI is received before the driver is
notified of FLOGI completion. The FLOGI completion failure causes
discovery to be triggered for a second time. The discovery timer is
restarted but no new discovery activity is initiated, thus the
timeout message eventually appears.

In pt-2-pt, when discovery has progressed before the FLOGI completion
is processed, it is not a failure. Add code to FLOGI completion to
detect that discovery has progressed and exit the FLOGI handling
(noop'ing it).

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a0ff15e63109..118f0d50968a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1175,6 +1175,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			phba->fcf.fcf_redisc_attempted = 0; /* reset */
 			goto out;
 		}
+	} else if (vport->port_state > LPFC_FLOGI &&
+		   vport->fc_flag & FC_PT2PT) {
+		/*
+		 * In a p2p topology, it is possible that discovery has
+		 * already progressed, and this completion can be ignored.
+		 * Recheck the indicated topology.
+		 */
+		if (!sp->cmn.fPort)
+			goto out;
 	}
 
 flogifail:
-- 
2.26.2

