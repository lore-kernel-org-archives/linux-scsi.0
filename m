Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221FEC54FCF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14932072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVNepXzk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgCVSNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:18 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39811 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCVSNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:18 -0400
Received: by mail-pj1-f65.google.com with SMTP id ck23so4964204pjb.4
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JISChDeiSMMSzMsJsJ+fx02DzLTDm4jfRSH9vdl0tRI=;
        b=dVNepXzk+ivqXuZsTnBnnMYSX5WOk/mHFlz+rtyMcdL6PlkNPuZaIJkYFPEZETEzsr
         BMXMD2Q6Od1XoJB3mgC/NR0VUUukSm7WTQ6Z4RsiMxDCAGbrr2eub729uI5uEPmYBwwt
         1ZbLpbN6SrUKPoUi9/gVlK1bFhPKfO2bPwoW9GskX51oM7OazUUcBen9h92j7AH1hjGJ
         h016TiA+XL7qGuRjxmxC33CBiMqvlMz47w2JohTMjF1q4WbdjzKGwH/HudyAI8+i7gh0
         vGOg8nGr/xngqnri2qIQvuIF1h+fmq2ZRk1/brIdj5faSIxj7p87RG/rauGMeGxTrJTQ
         uFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JISChDeiSMMSzMsJsJ+fx02DzLTDm4jfRSH9vdl0tRI=;
        b=heH4pGLrMj7rSaW1YAEsNh0dXuIwIaEcqitBetMcnDDmPJcSe0nMfPpzM89rxXUxsb
         kaoTNiARPyyw3UFA5k6G9DBqABVwR/WENFS7Xppx8clYEAAZE/DBYZb4IE+IeWFFmfSL
         t9FKk4K06BWwlHsVR3whq58t4cOJcx32reBJLkVsZSRXFrBrTcGIMbVak6Jd2jHSwerW
         njVKl2dRqnYcr9SH/oBI9/e82TURzF4WQ2KxAP+kgOPma8C9CcjCoCORMZNZdGdCiWQM
         vuyhIZT7yJktgIEJEuiM8YLXf4/jgcWDZdLmCmVCCqBWvY9d1jA/l5ZyjLOf6eFXT1st
         SzXg==
X-Gm-Message-State: ANhLgQ1Elpaff6WaNWxkNIhjTNlBfOu/Ojij2xqIPW3Sx6ydZy3TNcsD
        aQEDdMMSK8zS04xkgHur7LdgQhix
X-Google-Smtp-Source: ADFU+vsy2QcX1UtX+250PwE7Gb4NbaM0NEkOFeIctTFxoAKJETFNoDJDGgqhOsPLaG9tsztDU9f+Lw==
X-Received: by 2002:a17:902:9048:: with SMTP id w8mr5589462plz.24.1584900797016;
        Sun, 22 Mar 2020 11:13:17 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/12] lpfc: Fix crash after handling a pci error.
Date:   Sun, 22 Mar 2020 11:12:57 -0700
Message-Id: <20200322181304.37655-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Injecting EEH on a 32GB card is causing kernel oops

The pci error handler is doing an IO flush and the offline code is also
doing an IO flush. When the 1st flush is complete the hdwq is destroyed
(freed), yet the second flush accesses the hdwq and crashes.

Added a check in lpfc_sli4_fush_io_rings to check both the HBA_IOQ_FLUSH
flag and the hdwq pointer to see if it is already set and not already
freed.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 08bf2f0a1065..780ff187e9a3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4046,6 +4046,11 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 	struct lpfc_iocbq *piocb, *next_iocb;
 
 	spin_lock_irq(&phba->hbalock);
+	if (phba->hba_flag & HBA_IOQ_FLUSH ||
+	    !phba->sli4_hba.hdwq) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
 	/* Indicate the I/O queues are flushed */
 	phba->hba_flag |= HBA_IOQ_FLUSH;
 	spin_unlock_irq(&phba->hbalock);
-- 
2.16.4

