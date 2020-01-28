Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B68C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F6C2467E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yl7dVeq1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgA1AXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:33 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52723 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA1AXd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:33 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so614477wmc.2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wuzLHqakvnNgZW9rPCCfZQiW1py/VLkR94NJjS2NNqw=;
        b=Yl7dVeq1EIf2Bu3DVjz7dJb6WtpRFFSdhcjHsFFAODxMcGiQADYRQRm5B4Cz7xA2yy
         G1T9bPoVouvJ12K/6SKyTe9FvvuNHA81GomJkNL2bPUob6zds6EHZgI4HNw1ncogSB3T
         5x5V1cH3NrlHmVUhocFSP7hOeeI0OEEdbu6YBL50+WAIdk0i6Ykogp+xLDpQkearYm83
         jAK8aByKZDR+7UIGrYnJMJAP1VNk8lLwJAi2fsmB9ye00Xq4cbKwNFnFbvVzwFwOjWWj
         gDpuLt/HLzCnXSif+/QlW05//sS+pfreegGfAHB0X8KzjgE9Oeg3hi1jTsKsAMvy0+Ar
         F/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wuzLHqakvnNgZW9rPCCfZQiW1py/VLkR94NJjS2NNqw=;
        b=QIKRcsVHgDrV389/7TKwzQM1OSx7/12MNzzLW7eq7vOu+QAC0hnBAsk54xhZgRu81r
         o4Tw02EQoNsV0fKnH4nNmEfikaRPCq+4WuzzvU1tVKlKhfmRhsWj85LQk2TyVed1AfpG
         DB8zfKnDd79yeUn4XwApzBT2cU8q2/FtFpYQMe5bfqL781+9MXKRX1JK0xwO6zKVvPoO
         FTNfhTCzGO1beG6GFIXVfVy+Z9+Ztmh7Do1YUKHlbGZsde5s/ajmKCBFggaCoUqn6CiQ
         3ZNrUJCAfDq8ksuniu+AteFgauxg5E+oxil43aEN1eAgJ8/S+Db+seRBWZm5QtoiibgL
         PNQg==
X-Gm-Message-State: APjAAAU+aUH4qsfMhrQPqcS/ROBBdz2R5hqZ5bNuz+2HkYBLlrxyIPUy
        eyzH+S9cpBtg/36jfFRVIuGjgURh
X-Google-Smtp-Source: APXvYqx374wxgj8EPyMxNL3EdSdspC3KN9Y/Fegh68tZuvvVZbDWnHcMJHgBKy8n+vgLDoHWvsbQbQ==
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr1243373wme.130.1580171010712;
        Mon, 27 Jan 2020 16:23:30 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/12] lpfc: Fix registration of ELS type support in fdmi
Date:   Mon, 27 Jan 2020 16:23:04 -0800
Message-Id: <20200128002312.16346-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adjust FC4 Types in FDMI settings

The driver sets FDMI information registring ELS as a FC4 type.
ELS is a fc3 type and should not be registered.

Fix by removing ELS type bit when we register for FDMI Port attributes.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 58b35a1442c1..fa70e2001b8e 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2453,7 +2453,6 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 32);
 
-	ae->un.AttrTypes[3] = 0x02; /* Type 0x1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
 	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
 
@@ -2771,7 +2770,6 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 32);
 
-	ae->un.AttrTypes[3] = 0x02; /* Type 0x1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
 	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
 
-- 
2.13.7

