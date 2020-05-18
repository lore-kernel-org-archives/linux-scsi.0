Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0E1C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38F12081A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgERVRe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39905 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgERVRe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id u35so5412084pgk.6
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rZNKW6fQaRJIuqrblRpelFzAa/NeKrc1Gk4iWvFhKWQ=;
        b=jHbBLnnslD07Zw1dJGTJPjdQUqFkTgVIcgEbpRGItDocZ00/WYdVgq2MCygwCRbGFQ
         BdFIUKa9YT2ha2M2N0oSTg95Yk6yyuV05e30QlDg66Wx2V4z2sSLj79xo9bcbm7tBEoZ
         pUQef31ScJTzcI0ZM/mk4G2lRIt54if5YCWQdsP3zaQXaqE2Pf1CmjiIdrM8mJFQUd/2
         hAvibPD81nIZpYXZ/LqbkWn255WBOGFYpH6EMUqYvOiw97xcZ6YC/LB9GlyRw+/AFKoY
         HlfK2308laJZ94c/UK8R9ncqj7hpT588L9f2/kC2o5OkOU8IG+C6gZyXnpASrYACcfY3
         5iBQ==
X-Gm-Message-State: AOAM533b8Efz5hJSneqZP91G9gr0whQMWuv9xT1RUbsB4t0Gy1LpGd0B
        j2BaLrSspf3yuuLC4dwNdlazRm81
X-Google-Smtp-Source: ABdhPJzzA+X7d9iSwPLF2b3SUgLE1JJJo2yYQl8DOqhz4q0PArmCFscu73H5rp9HxE8K6tgRyDiRjQ==
X-Received: by 2002:a63:b95a:: with SMTP id v26mr16424524pgo.196.1589836652014;
        Mon, 18 May 2020 14:17:32 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:31 -0700 (PDT)
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
Subject: [PATCH v7 08/15] qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
Date:   Mon, 18 May 2020 14:17:05 -0700
Message-Id: <20200518211712.11395-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
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
