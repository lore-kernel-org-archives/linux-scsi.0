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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98130C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ADF5207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbhADSEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhADSEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:12 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140EC06179A
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:06 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m5so48902pjv.5
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e+e6PS6MqiXs8IIBjboY/Gk1idWmNALiKP+1QgE6I18=;
        b=Belw6o0cZrqc3coppWveXFRnmdPHEnyUSAsWoKuxbZYzVC5239mUbX90+QDG0bT4Zn
         QX+mrqS5qkn22b9+BmTxilcHBmv7KO8bmLal8mVe6BtVojSL1F8Lb83X2aVjrap3ElR3
         msEYKQb6DOXe5JQmZI3bwNwWn+37aUQyC23cJaerZdQJ/rCbt5T1wYD/XI7Wq6af2LJR
         AxrmZxk6NGidWb3y7rHf790/p94ndN9zF6+lLEXTQTjNIcR5XkydnjY44QtXuapfFWfV
         4AgJTOCes0hlBMruAMiZ6uYJeLl9NQFNwenKvDEJ+olQbUuSKIMTWb5PUMNmmB6fwgSR
         Q83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+e6PS6MqiXs8IIBjboY/Gk1idWmNALiKP+1QgE6I18=;
        b=hw7zeHW+17mPf6D0bfs6ZkmEecBBeuNqfTmk6v3Nm8rCe0s9KSUDsFRoihBL+J3iBY
         hV+1SQwOY4SHSTycOY6m56Vqdw6BJaHTBh7B2QcDesEkLoyFrukZHj7dE3UU1FRg6C0K
         t6TPGVQYDi6MxxIPcAIT8Uj0utq+EtNCMK/XXMljVnfWJeAWbqEaWdCkpxbtRyliO5UN
         nbGTHXSrdOav2w+D5N/or5vj1m9ixUvT5MTpS8+x9VU3rOT8eTq37Y0FNKB8pMtWIi7Q
         ISrBvwMYJw8m51zMDH6sJXDJ1LxnpHUO5FDYJl52r5hyli1jfziWcLpDEmTja4Na5esS
         qfvA==
X-Gm-Message-State: AOAM530Otb22Oodyo6ySf2H25wGI1DBgWRLERXPAB0OQBdDcqZ79ULnn
        AgsjpqLsvizDbwI12VVS9JkWMvFfqWc=
X-Google-Smtp-Source: ABdhPJx5QiDGxkBH14BHnWZh9RI13k6D77+EvF7wmXqoXFGrqgzOfYsTbN9bFuZryJjEFL5mc3Ap8w==
X-Received: by 2002:a17:902:c38b:b029:db:fa4b:5d31 with SMTP id g11-20020a170902c38bb02900dbfa4b5d31mr51748689plg.5.1609783386025;
        Mon, 04 Jan 2021 10:03:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:05 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 06/15] lpfc: Fix FW reset action if IOs are outstanding
Date:   Mon,  4 Jan 2021 10:02:31 -0800
Message-Id: <20210104180240.46824-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the port is configured for NVME and has any outstanding IOs when a FW
reset is requesteed, outstanding I/O's are not properly cleaned up. This
causes the fw download request to fail.

Fix by clearing the LPFC_SLI_ACTIVE flag to signify the I/O must be
manually flushed by the driver on port reset.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1f0a62ecfad8..593b175702eb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1833,6 +1833,16 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2887 Reset Needed: Attempting Port "
 				"Recovery...\n");
+
+	/* If we are no wait, the HBA has been reset and is not
+	 * functional, thus we should clear LPFC_SLI_ACTIVE flag.
+	 */
+	if (mbx_action == LPFC_MBX_NO_WAIT) {
+		spin_lock_irq(&phba->hbalock);
+		phba->sli.sli_flag &= ~LPFC_SLI_ACTIVE;
+		spin_unlock_irq(&phba->hbalock);
+	}
+
 	lpfc_offline_prep(phba, mbx_action);
 	lpfc_sli_flush_io_rings(phba);
 	lpfc_offline(phba);
-- 
2.26.2

