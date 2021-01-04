Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4D5C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4500207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbhADSET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbhADSET (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B471FC0617A3
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:19 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 15so19543997pgx.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=372YtE8g/LlFqtHbGA+4Uprj5mZWcvkwKFbxQ3ClOLY=;
        b=oIOZN/e7SliN3Vdp8Di0kTgX9cYKuUzvd1fQCJ5GV+T6lFMSFw87yu7OxZRQDd4udT
         pAKIVMX+/7/e0Xa5Stbgned1z8Fkwsf8HfBxezvXFAqCfxcQHY8OD9b0Eck+MvKPn9Iw
         jYY+VQgtY3AW/IG0YCALZlQRbaPGO6OCSkijXMvDhALj27ucKq7/dwCe9AvixY2MnaWV
         XxkKQkFfAIxncGiF70Avsv1W8Py19i7VNb9TH2M7wx0RHLb+2iqDipnX6yXQ4o67a56s
         7O9ZfqqAbHonWfpm6wp3Nq9fR7NWN+V4o7xJRvJNuJO3iJI6b5YvKlrnQ5dZoRl6WLDe
         3Akw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=372YtE8g/LlFqtHbGA+4Uprj5mZWcvkwKFbxQ3ClOLY=;
        b=ZMq3Q/atZonRHVfqpYeuSg8pxJNwdbElXieRotum40RYEBjEHpD+AEd7jgVR2h0AGl
         31HBi8fp9oKfAKO6X4qwWIBVWYKdznLCl137aJS+zcGa0sznGQO+qPPny5twhY15BCjh
         NqTkvkG7qGZ+7xCdPsoMtWNGRj+nzaJ1iqBOWSvt6JQ6R/AuvTblispu1DhgCHy5NjEU
         QMJyD7CrgPTV4AqQ7F97G/U6e2QLU4m+Y6TRXWpjfiq5VxY1NZ1erjHpVyzbQ5mukKLu
         MlEjSRAl/RVmj5OH2LgjbIjiyu3MazzUzt+pfzSKWlga+4QLLFsQDE5ADYfbbnzSfXMm
         EBXA==
X-Gm-Message-State: AOAM5301KLbqerAyWYng+jY4+d8tatjcFNAijU7EjMdgdAtREN/ewsCA
        Bukg2GSPN4mdKW5R6CjXunENxP8m9oI=
X-Google-Smtp-Source: ABdhPJwgTd1h0UbJQ2c+hzEbo+xuSylmZx9HsLPAnjwBcZR6oJou95kanVtEGlMYMJWRPZ1XhkvjmQ==
X-Received: by 2002:a63:1b22:: with SMTP id b34mr42444642pgb.132.1609783399289;
        Mon, 04 Jan 2021 10:03:19 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:18 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 11/15] lpfc: Fix vport create logging
Date:   Mon,  4 Jan 2021 10:02:36 -0800
Message-Id: <20210104180240.46824-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When with testing with large numbers of npiv vports and link bounces,
the driver is flooding the messages file, even with log_verbose = 0.

The new LOG_TRACE_EVENT messages are still generating events to the
messages files.

Fix by converting the vport create msg from LOG_TRACE_EVENT to
LOG_VPORT.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index a99fdfba7d27..ccf7b6cd0bd8 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -478,7 +478,7 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	rc = VPORT_OK;
 
 out:
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1825 Vport Created.\n");
 	lpfc_host_attrib_init(lpfc_shost_from_vport(vport));
 error_out:
-- 
2.26.2

