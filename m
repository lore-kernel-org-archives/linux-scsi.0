Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512FCC432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 00:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 280D120732
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 00:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="goxRVXgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKPAjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 19:39:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36894 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKPAjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 19:39:00 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so12239464wmj.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2019 16:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sr6iRi3QdVaRD2ID/1O4JaZPqKruFaUeEOS+3wlrkmk=;
        b=goxRVXguj4qxLMG5WAqMm6x0PXYbcljkWtK3lCW9i/DZY4mV/T79K4ga0VWHGAUHQg
         FBO+mjqS5EMcDDXWMwkctrwk2nVNVkvRn9nzEaKk+u4LWCcOI2Ze+PC8hsBYxM+QNLvs
         W9S+hnT5suPaxL1+xl/eq1vl65CEhDe/ZSrRljgc4ZvbiZ/g6BnAIG0MC++M9OgnuasR
         UlEz1jhYJCnzBVmBOqAQVIQuVdt/vMfd8zEmB908HlH29zZu4Q4flTup2UjhVoEM4ior
         7naF9U0gtOT9sAws98Zk7N7SgpyjJh1MJ/E2vHulWAWjsA7OwMGCtv4TZMVIHIeiullw
         Bmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sr6iRi3QdVaRD2ID/1O4JaZPqKruFaUeEOS+3wlrkmk=;
        b=Gz2RI6SncXtKWn3wvrPJGANLRhd/x9HDFJzd1FCzKPNx5/0MRc4z02DPVzsgRhf32Y
         chk++avKpTcNzZU8mfHuhYP/B0Pzs+a7d3ue2gkM1RkgyreAe94VL2P4M4oXVNJCZ2fS
         WFW3skLpKwwSXNJL3Ui5ikt9G/tDIimOYs1f8aDdJsLEDa4aVdxkDGi+MKKcpNMYH0Y7
         lXsBAdc4SSQqVkdSuseRTktc7JzWgeRpKqjMQZGGsjiF4QciDjgDS5q4za0yNnBeQ0Cu
         E7CABo4dO+Y3oVTB9orOQw+8ZOGFeDzAN1s29j9dhJc088Y4mX+Z+gBzNMcdDjqNuru0
         6Tag==
X-Gm-Message-State: APjAAAXcWCe2GxozZd5RDUkTO2jaCwwFuDuit5dVFRoDlWR8r0/6shOj
        LelJYCKd2kwty4ORTM6k6xIUL6is
X-Google-Smtp-Source: APXvYqy0cQphc+iEgFu5HmINFQigd0bo4K3+NOlVECpA9cwU3Pm4XrZV3PdVFKAL0am1bdmAaGJp+Q==
X-Received: by 2002:a1c:2745:: with SMTP id n66mr17818857wmn.171.1573864737159;
        Fri, 15 Nov 2019 16:38:57 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f17sm10389222wmj.40.2019.11.15.16.38.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 15 Nov 2019 16:38:56 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: use hdwq assigned cpu for allocation
Date:   Fri, 15 Nov 2019 16:38:47 -0800
Message-Id: <20191116003847.6141-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looking at the recent conversion from smp_processor_id() to
raw_smp_processor_id(), realized that the allocation should be
based on the cpu the hdwq is bound to, not the executing cpu.

Revise to pull cpu number from the hdwq

Fixes: 765ab6cdac3b ("scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5286c78645ac..7c8527bd1677 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20668,7 +20668,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_buf)
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(raw_smp_processor_id()));
+				   cpu_to_node(hdwq->io_wq->chann));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8353 error kmalloc memory for HDWQ "
@@ -20811,7 +20811,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 		/* allocate more */
 		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
-				   cpu_to_node(raw_smp_processor_id()));
+				   cpu_to_node(hdwq->io_wq->chann));
 		if (!tmp) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"8355 error kmalloc memory for HDWQ "
-- 
2.13.7

