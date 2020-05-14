Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D6DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFBA62065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgENVgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:36:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39833 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENVgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:36:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id u35so1831617pgk.6
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rZNKW6fQaRJIuqrblRpelFzAa/NeKrc1Gk4iWvFhKWQ=;
        b=N3YKrluzGoqRmPvjW0ReFtlnnnmnSmO+Vp7GZ8B2p3N9zm44DrmONnE0NHmZ2WIWTE
         Ld1qQGUuD1pbEcBG+4OiND9+eOzXLvMZEvrVRUf2rHSp6b/JCkmkWkDbCpPAZ+5u8yZP
         +CQR3ChhbpzneNxh8QJuZW3m0hdoN+cZcN+Aa6m7r8v57MCqx95SRYEdlS1YxqpAI4tO
         SflrC8vKlnxBCwQylboWy4r24X72BoqHJC7E0/j4J7gBkgdbbFzpZuyqadguj0viFGFp
         0C/bua+9iSrx78O4GEgS3y8eWb5J8mkuoMNJe0rvcxV2aFy8HzZPhK2SyOE9HOU644bB
         AJwg==
X-Gm-Message-State: AOAM532AdPmsiBgZnw8ALo8XiFP85tzIpH8gOgehzAvBkaYZsRvQe2r6
        lnJmjayxYzS2RO6lVUx22YI=
X-Google-Smtp-Source: ABdhPJxiKj5B6QR4O2s45qEOTz/UVCYQ3CNqNUU+//ZhCHsS0y1NuIqMpOJTsUCYPRQtYKG/fSYQzQ==
X-Received: by 2002:aa7:85d3:: with SMTP id z19mr531073pfn.215.1589492167117;
        Thu, 14 May 2020 14:36:07 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:36:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v6 08/15] qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
Date:   Thu, 14 May 2020 14:35:09 -0700
Message-Id: <20200514213516.25461-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
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
