Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97003CA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6433F20717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3Lg3pxz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbfKEA5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39339 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730066AbfKEA5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id t26so14032130wmi.4
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9h46+cMJ4jTlZ/AqJEUGMa/g+Cx9maiI8rZoDuRgNA8=;
        b=P3Lg3pxzkWSN2hIr4V4/4PIQgfJnrQ19rkFRFGfNwrWsS68qXo6qsVj9tiAYsHnqdX
         8r4CDjVtDrxECFN0G8aiIqCX4QB6wTzK2h2uIaglbj/zN9nCuQPp4un/OGA5IObN+GFR
         6F76qpQqMleD14JybjcBKVKSYUrwvOPKY7b7gyyRP9dDVd4ISnOb+Lcgvfy3FA0qPfnh
         lIYPvQ2kxYrr96wFUy7+5LAn9odLNYQJTL5FJRb9gvY8V7nBphhojvlU1V3nvaOOqJsG
         Tx/y36lZiy3ubhyDnkmvdHHu6tmXP4KUQrqrPpqt5KLLaPOWA4NCU8OpW0+L1eZZxleS
         QmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9h46+cMJ4jTlZ/AqJEUGMa/g+Cx9maiI8rZoDuRgNA8=;
        b=sL/ZDzKMNmnbZsSFRgVGdgXfs8USQrGviAOBJkISrYc2IPaj+z7lWGxMkWdmHv/UeW
         3oGBfLi9UKfJCrTOy5tcYghRSqHiqi6r0W87YcHWbU03LRS0tfeOJ138wgyCNG+bWisM
         VPlZ2YK+SycWry7r8QPah32VEq9CVuZr8GIQJ9AB1295OblOepzYA/a5D/c6upXAzBwy
         +P1xo93Qt2WvgAJ0c4EgPNOcFJY0x83ibn5K6+SX6+njHHxZhIhwE17rJNbuBg3k2Pr4
         hSQ9scPajj6dN5d9tpLp4rfbsdHezrB+O/h3Q7ABs7QPDsmGePsGoMZKZZttR8OTTPdW
         xv4A==
X-Gm-Message-State: APjAAAUO4ehlR+BzLyb1S21yZvuAXBsHYns/qYNAB9ETEqSU0L4bESOf
        k3LyfhApyVPChKLISA4EFWILUTIgbSI=
X-Google-Smtp-Source: APXvYqzQUz0R86GfRNHLRbDPVz/PjGTduqnWCAcnQV6RIrJDL81NgbapfO1+hPmKpTEFNt5jUBWRLQ==
X-Received: by 2002:a05:600c:12:: with SMTP id g18mr1718865wmc.44.1572915452556;
        Mon, 04 Nov 2019 16:57:32 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:32 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/11] lpfc: Clarify FAWNN error message
Date:   Mon,  4 Nov 2019 16:57:04 -0800
Message-Id: <20191105005708.7399-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current message on FAWWN events is rather cryptic.

Expand the message to clarify its meaning.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 88507aa4e920..85ada3deb47d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3452,8 +3452,8 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				phba->pport->port_state, vport->fc_flag);
 		else if (attn_type == LPFC_ATT_UNEXP_WWPN)
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
-				"1313 Link Down UNEXP WWPN Event x%x received "
-				"Data: x%x x%x x%x x%x x%x\n",
+				"1313 Link Down Unexpected FA WWPN Event x%x "
+				"received Data: x%x x%x x%x x%x x%x\n",
 				la->eventTag, phba->fc_eventTag,
 				phba->pport->port_state, vport->fc_flag,
 				bf_get(lpfc_mbx_read_top_mm, la),
-- 
2.13.7

