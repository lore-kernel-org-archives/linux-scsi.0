Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038B9C433E3
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D05972071A
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgFNWjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:37 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50438 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgFNWjg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:36 -0400
Received: by mail-pj1-f65.google.com with SMTP id jz3so5947165pjb.0
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0PAcuPeM0qeY4e1f/YGcBkSny5Gxr0QswWF1YiOE+0=;
        b=PmkW3/UWbvrk0uRchG8V3gV/0xQdx4+rh5fPxdrDHJsS8FPjgSCPY3GlFUrVIhC8zh
         iinRDF3zWqUwbFe9bziSjVzJNvODps1KPMX9nOfL3P5+8UwsmSNjZ7YSnAOWNlO9svm4
         13tB9BZLzUNjO6kHxtY0h8UhlYbAMvLWUF3YTUs30xpifJUoN0XtJ0xYA1w3XrtQYW7A
         T5lY5fEdfnPG8uQafJ4zt5QRvE3JsoCr0W/StfyvgTVXunSR5c0oTRV4srfvAaxUDWph
         8s4R61sUY4tk6cwooIVT63iYH5fyK7in9OxWSpYkAzromIdu+CDyA3DWRzn3Lwnm+XuL
         6xtg==
X-Gm-Message-State: AOAM532cGXT2wblCic/jzNE8MmT3Bb1rJVsUx1PQ0hqe/GZT7dfV7Uo5
        NcCV3gxhh7UHTfcX77WPmWA=
X-Google-Smtp-Source: ABdhPJxJ9/lV0koVU74Ky1jj/kxSXf2R11vxIhEmS4Wwr3AXYuYzzwh0OadXO5tdWwarHF3a/eqnVw==
X-Received: by 2002:a17:90a:6483:: with SMTP id h3mr9006251pjj.229.1592174375456;
        Sun, 14 Jun 2020 15:39:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 5/9] qla2xxx: Remove a superfluous cast
Date:   Sun, 14 Jun 2020 15:39:17 -0700
Message-Id: <20200614223921.5851-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove an unnecessary cast because it prevents the compiler to perform
type checking.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 88c0338a2ec7..67efde1d4b8e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -223,8 +223,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 
 		/* validate fcp priority data */
 
-		if (!qla24xx_fcp_prio_cfg_valid(vha,
-		    (struct qla_fcp_prio_cfg *) ha->fcp_prio_cfg, 1)) {
+		if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 1)) {
 			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
