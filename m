Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A46C38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14BC2082E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgEGE24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40555 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEGE24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id j21so2239323pgb.7
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TzEOTCAxT0J64ovyFgfWtPQmxxnko7qUntCwks98go=;
        b=f7XKvr57X0Y0+nAlNM72s1yJYBwTYq85nOAZPLqMo19t9p/tpKZcF15iVaziOhWR9a
         3+vszawGk/1CVl+jVPjboEVUHMG/c/FT44oKOmXO3U3YaxZUZoYVB+uW7fNucrTCiaKC
         ku9lenKmxBV0UuakLXCi307U5ZvUAioKpGmdHJhQEbOWAU859XF3mMZVlgCRh5htVa8Q
         kj0pCY9PDmJDJCLUUptac5xjscRpFOprK8NGHX0r0hwUopk/i2MrQfM9DW41Ep2Bsz3E
         PeI4SELcJlReH0omMQJ5BDAs//qICXB281emcyvVQES2ywa6tib2Zv+5AuyRQEeZlNaQ
         a6rQ==
X-Gm-Message-State: AGi0PuaQ+/HRqdevJ7qjyDd6vJSPl3fgB16dyoqIZ0UKJCsSjEql0tHu
        zBEPf8toy0X15ER5FijLBlQ=
X-Google-Smtp-Source: APiQypKmYuN+DA4srxqSUgsqqdJcWJ2n56W6Wk/UejR5WN4bL+KWlExi2jjQ2hT5zha4XXKL+fGN6A==
X-Received: by 2002:aa7:8505:: with SMTP id v5mr12000288pfn.224.1588825734128;
        Wed, 06 May 2020 21:28:54 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 07/11] qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
Date:   Wed,  6 May 2020 21:28:31 -0700
Message-Id: <20200507042835.9135-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507042835.9135-1-bvanassche@acm.org>
References: <20200507042835.9135-1-bvanassche@acm.org>
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
