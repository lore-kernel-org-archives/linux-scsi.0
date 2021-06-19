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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EE4C2B9F4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9889C61154
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhFSP7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 11:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbhFSP7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2021 11:59:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFBEC061574
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 08:57:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so5578018pjo.3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 08:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzE2D6RwS6IQbiNnscLxjoc95shJAmHHLimUG5bjD34=;
        b=MYlrCb6ylOlwP3riKrgyvOk2fyl3puKkkwG/UM6ZMYxZT+VK4XTLJSWTwWCjXcceO+
         IBRdB7qe/YzoYfZk9eZ4VFKxiAA+e0Kfp5Z92qs6ApLpQ6ILbPhN3+REphuErrrFO9ql
         UO/8QoORUr5TYgOTnRtjsfazPpRQeC2dvdQiYVyB1rhZJGOz2v9fzp3qHxlxWrWkC8Lc
         2VnAY8YGspE4YHIEuzABqqdtAICc3PBK3BAd3X+eWaMZuvb9SUclHiLVESoeRpDVvECD
         ldgYLlDOSf3y1ICOQ1IdcNRbHvuI5/EnJUB38/0ML/fx0UmDxNKQrLpXi6Enojl49Efo
         oPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzE2D6RwS6IQbiNnscLxjoc95shJAmHHLimUG5bjD34=;
        b=aeUHK4Om7AeUB4vH7RpJm5gliJeOqPf7Crj5KgNC/z/5hnE/E3Kiqn/OTcNJzbxuyJ
         qihlbn//YRFSQTjumFODfoPWuhSYvKRopQKpOXPz+vhd7iwjLOOgpH6ojFsXnD2/qGhn
         KkHw4UgKBRzgF6drxQThqb0ba5V0d64nVVUYvJoasvdsD33zaPHaNF6YE6ix/GtM/CTk
         nsQ5BfKJceSGjXUQTRHwmuUjxbQZ4HjCFFkGkZOxEi88ybI+5/wQlA/GTE9OY/sFj1SU
         aH+FHwI1ulGnl8jYgqAVJq4yDR6uXPX1K5UkG8Di1iVgfX2QhV9jft4zyF1qfZ48DuLX
         uIRQ==
X-Gm-Message-State: AOAM530Uv0A0suHwIpzxn3OvRVSHJSRTkahazmmcKkd88DG41PMbchKY
        QLEpXsGLalV3Z70XYZmSOcxCOLG3xzQ=
X-Google-Smtp-Source: ABdhPJzlf30wYLp4MqwXFGSlbbitX+HZiEuHQWTDcM1LrL06xw4Fx4ExL0xIgAU+jigqCytUKhNjAQ==
X-Received: by 2002:a17:90b:503:: with SMTP id r3mr17219675pjz.195.1624118258881;
        Sat, 19 Jun 2021 08:57:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u12sm10774420pjc.0.2021.06.19.08.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 08:57:38 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     ram.vegesna@broadcom.com, dan.carpenter@oracle.com,
        James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH] elx: efct: fix vport list linkage in lio backend
Date:   Sat, 19 Jun 2021 08:57:29 -0700
Message-Id: <20210619155729.20049-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vport is linked onto the drivers vport list at allocation, but
failure path fails to removed from the list.

Change location of linkage until after complete vport completion.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index e1bab2b17e4d..6ad5168a86ca 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -832,10 +832,6 @@ efct_lio_npiv_make_nport(struct target_fabric_configfs *tf,
 	}
 
 	vport_list->lio_vport = lio_vport;
-	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
-	INIT_LIST_HEAD(&vport_list->list_entry);
-	list_add_tail(&vport_list->list_entry, &efct->tgt_efct.vport_list);
-	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
 
 	memset(&vport_id, 0, sizeof(vport_id));
 	vport_id.port_name = npiv_wwpn;
@@ -853,6 +849,10 @@ efct_lio_npiv_make_nport(struct target_fabric_configfs *tf,
 	}
 
 	lio_vport->fc_vport = new_fc_vport;
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+	INIT_LIST_HEAD(&vport_list->list_entry);
+	list_add_tail(&vport_list->list_entry, &efct->tgt_efct.vport_list);
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
 
 	return &lio_vport->vport_wwn;
 }
-- 
2.26.2

