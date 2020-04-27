Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816E8C55194
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A833206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgD0DD2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:28 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:40433 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgD0DD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:27 -0400
Received: by mail-pj1-f54.google.com with SMTP id fu13so6237969pjb.5
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/UJokiW7kMBPbUk2tuUzYZ/VFLriJMS9wQdxaFqD/U=;
        b=W1pnM0QieR6vCm43C79u4Zvr2GAUwk6iyf4A0xVK2v0n/8lqBaEpO7MEEcmTiPlehh
         mYkMqbbEZs9AisrsYm6W9RpgQujwXgdtxS8IVdYxbOI+Lrano4AQ2EH+jaXMwEZJ6naL
         SrsUhq83IJ+aINB5OufzY6hNKXAc414sZxkRaDCgwlyn5hrYQDZri1zj1/mIoj7v/v1K
         KMSRjoP5M1+YJkqfozH7zNXRCJ7DbZmpDOxg6cbI1oxM8alQaSMXOGQFGs4QGbo3xcIs
         Sw9R1TY9hYtgM6ULwjnZ/z7aqlTmUuzdGKb6SW01TCBhB09DmdCkgrKKn9uMdw6QYXsr
         Inbg==
X-Gm-Message-State: AGi0PuZPXpQy+n3dJwLlHY4H4ESPTwMFkmAJexsYQ8pyLr2gvIY8X+YQ
        vfKv2QwcSzxGdP/PaPhTicf7+HB8tkg=
X-Google-Smtp-Source: APiQypK59UDEB9mSQd3Pl6V1hGniBa7SKc2HifyNhFnVPkBqatU6lIdgVtiSSqH7L6M4RxP07jBqzA==
X-Received: by 2002:a17:902:9004:: with SMTP id a4mr19507710plp.275.1587956606864;
        Sun, 26 Apr 2020 20:03:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v4 07/11] qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
Date:   Sun, 26 Apr 2020 20:03:06 -0700
Message-Id: <20200427030310.19687-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427030310.19687-1-bvanassche@acm.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_fw.h  | 3 +--
 drivers/scsi/qla2xxx/qla_sup.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 4fa34374f34f..f18d2d00d28c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2216,9 +2216,8 @@ struct qla_fcp_prio_cfg {
 #define FCP_PRIO_ATTR_ENABLE    0x1
 #define FCP_PRIO_ATTR_PERSIST   0x2
 	uint8_t  reserved;      /* Reserved for future use          */
-#define FCP_PRIO_CFG_HDR_SIZE   0x10
+#define FCP_PRIO_CFG_HDR_SIZE   offsetof(struct qla_fcp_prio_cfg, entry)
 	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
-#define FCP_PRIO_CFG_ENTRY_SIZE 0x20
 	uint8_t  reserved2[16];
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 3da79ee1d88e..57ffbf9d7dbf 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -3617,7 +3617,7 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
 
 	/* read remaining FCP CMD config data from flash */
 	fcp_prio_addr += (FCP_PRIO_CFG_HDR_SIZE >> 2);
-	len = ha->fcp_prio_cfg->num_entries * FCP_PRIO_CFG_ENTRY_SIZE;
+	len = ha->fcp_prio_cfg->num_entries * sizeof(struct qla_fcp_prio_entry);
 	max_len = FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE;
 
 	ha->isp_ops->read_optrom(vha, &ha->fcp_prio_cfg->entry[0],
