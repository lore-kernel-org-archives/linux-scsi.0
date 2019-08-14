Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6A4C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE912086C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzGieJDQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbfHNX5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45359 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbfHNX5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id w26so316515pfq.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N/3rb523l7fqHLZw22JXzBCXMrIQL4Ktlwfk0iVLa38=;
        b=XzGieJDQm+PhYmOqFFIaSTpQEjCXHCkDLKrSiQATRzsujQrKOao5v0XS16Kk5WyaaA
         CcxaRlAxhfHnjmFcry/PF5IWlQhNL56yuBrUaQmQVPMWJoINMS0HXUhH85DzMkUrxN0W
         gzxWaylaqe7dO2ZdIsIBRbXX1rAgvne1Waz68CFk6VTpGlqc6OGXWPrzid1ULHj2LXpJ
         AlVkjfzx+NNWObts+F6sN+RJ1Kdr5IdbIvhJ1TS9jH5mzyRZ63mZrW3RLulm+XFv+86+
         Fc9IbXjIasCN1I/kTgAElq7GTnpv5FVkeOl8y3J/S+4BSPUU3ydRbG3kktq/PVwMvKRe
         7fuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N/3rb523l7fqHLZw22JXzBCXMrIQL4Ktlwfk0iVLa38=;
        b=WgbM1/9jrgByoHzcZRl4Yc0pEkJE/Z9yUeaWoZXwKTyGqz6j60Te7Rgp5cY8aXmebC
         9zWm1shJXZ9EpC9CXe+D2ENIHIdhbGG+SO2mqILALWvKKdzXtM2eoUadO/W0M3kvEXPo
         o6yQ/ibTPg06qNZSNrep41FQoxkOSLwC5ttvl5GxVkDEkl9xq3yMGoM7liMIbMj1Bv+I
         PvkgP/YQX/o0WwLL5V7NOiUXppiQHDUxZMEGY+qzc21piYWnowg1MDMQurpzfSaxjttY
         woLrZTwTSnXjsYuxk8dh4zz9Nzw1/92Lnkiy1lV9m2hyQSq8KC+FFeUl5s1qPodKjwOo
         8NAA==
X-Gm-Message-State: APjAAAV3o1cvpt6tsWY8FTG9Y1wx/VsorrMbs9bFRGfReVb8/1CklsmQ
        rFcJ30VWNia3waJB+dfaj+i2m4GR
X-Google-Smtp-Source: APXvYqwbXnUtOthz12CLIuz5D13Y4VZ12IZmNOY0yDwhv+/1yJZqSnCTP8OIjJUpz6/8peMxH22MhQ==
X-Received: by 2002:a62:fb15:: with SMTP id x21mr2652910pfm.233.1565827049964;
        Wed, 14 Aug 2019 16:57:29 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/42] lpfc: Fix issuing init_vpi mbox on SLI-3 card
Date:   Wed, 14 Aug 2019 16:56:40 -0700
Message-Id: <20190814235712.4487-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is inadvertantly trying to issue an INIT_VPI mailbox
command on an SLI-3 driver. The command is specific to SLI-4. When
the call is made to send the command, if on an SLI-3 adapter, an
array pointer is NULL and the driver will oops.

Fix by restricting the command to SLI-4 adapters only.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 343bc71d4615..b76646357980 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -527,9 +527,11 @@ disable_vport(struct fc_vport *fc_vport)
 	 * scsi_host_put() to release the vport.
 	 */
 	lpfc_mbx_unreg_vpi(vport);
-	spin_lock_irq(shost->host_lock);
-	vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
-	spin_unlock_irq(shost->host_lock);
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+		spin_unlock_irq(shost->host_lock);
+	}
 
 	lpfc_vport_set_state(vport, FC_VPORT_DISABLED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
-- 
2.13.7

