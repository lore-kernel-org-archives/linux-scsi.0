Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C440C433FB
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB0A22BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nA25U+E/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgHCVCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgHCVCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF23C06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a5so25484608wrm.6
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=amsdS0i3yach/ZyeU3GbfouuKrNpke8YbxuSpjHNkhw=;
        b=nA25U+E/QAp+H93QRwqcnAhfjx6KNXDWyPljyoMuqqmqk84KEGgzQmsg8BXff7pCH4
         RBW1eFTnr/fME6KkU7ia4jVLipe2khEIRCU3e8l1mFxn8NrmfcOvGdYfic4B85gU8Ln4
         bPM7jpTQHe5szFJN5w/7xuXwwh/xp7XQ8IHWl7gvU/KYaRY4g1nAW1knzAfRa5gzokhO
         wBMpyQXzTi37Yc3jdrtoaEWEF5dbZPFZrN02CuUzU+ARetEivefwxsoccIZ5EN3fxXTg
         t+FETZyxf94zvpWr9QD3zB7gmDiCb8a3UrAkCGy4iF2uhQuhw7iy5Rj0hJ8cqQzRXDW3
         ydqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=amsdS0i3yach/ZyeU3GbfouuKrNpke8YbxuSpjHNkhw=;
        b=DSsN0qY0QZszRbUMg84mYvl7JZCxpKA88Q+QwU1qqEXNbIGoopHzEiYO6Gr005zNZs
         W0OiN7Oq9UL88vd083olOlTVG2FrELkmiYkqCxeQLXSlhiX6DM0x5KTgXqF//T86Nk+O
         sfB2ixwVwFl0t0wVOrKmEqXQgWxVJVSPsHgtKfhVGSpHSRjeR1Z+ahquf1KWNar6E/w0
         bXlZE366GmRVyw+qfscRAMQ4nsAeCYJQGRSLN8pLDWzIvCrvNnQo2N/e2zO3ukV4JSDG
         L0NiFM1tRCvw4uzN9y+YotIqNfRaQvt+VLQ6GS9Lg0Y2WVub7JSRZoiuM9B8t9Gg2OLY
         jw+Q==
X-Gm-Message-State: AOAM531qkMSeap6gRsMV+zIQ5VI9/cFdMjzMsL9rTloVhxkjZNQNriPl
        OfrVTEciMNp1xYIlncQySa8X3i46
X-Google-Smtp-Source: ABdhPJyqEO9NwFOpg27ZfxzShhb0xeGmrU2TDPDtND9k+ZoTSDXMnI22y9qYZEhUC9/aulee+nGoHQ==
X-Received: by 2002:adf:9501:: with SMTP id 1mr16576530wrs.413.1596488570462;
        Mon, 03 Aug 2020 14:02:50 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 7/8] lpfc: Fix lun loss after cable pull
Date:   Mon,  3 Aug 2020 14:02:28 -0700
Message-Id: <20200803210229.23063-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On devices that support FCP sequence error recovery, which attempts to
preserve the devices login across link bounce, adisc is used for device
validation. Turns out the device fc4 type is cleared as part of the link
bounce, but the ADISC handling doesn't restore the FC4 support as it
normally would with a PRLI. This caused situations where the device wasn't
reregistered with the transport thus scan logic and lun discovery never
kicked in.

In the ADISC completion handling, reset the fc4 type so that transport
port reregistration occurs with the remote port.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e4c710fe0245..cad53d19cb25 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1745,7 +1745,13 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 		}
 	}
 
-	if (ndlp->nlp_type & NLP_FCP_TARGET) {
+	if (ndlp->nlp_type & NLP_FCP_TARGET)
+		ndlp->nlp_fc4_type |= NLP_FC4_FCP;
+
+	if (ndlp->nlp_type & NLP_NVME_TARGET)
+		ndlp->nlp_fc4_type |= NLP_FC4_NVME;
+
+	if (ndlp->nlp_type & (NLP_FCP_TARGET | NLP_NVME_TARGET)) {
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
 	} else {
-- 
2.26.2

