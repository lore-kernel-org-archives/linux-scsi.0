Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F787C54E8D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2D8D20720
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbgEKUKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:10:06 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40850 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731405AbgEKUKG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:10:06 -0400
Received: by mail-pj1-f65.google.com with SMTP id fu13so8295962pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TzEOTCAxT0J64ovyFgfWtPQmxxnko7qUntCwks98go=;
        b=T67KNh0dSVHxfZY1aTbEODGdzdfIGpcJBcfykMrPLUK7vjwUWly1qKbbKP9X+6Wtim
         qTIlEPW6HplXvz7FxAqnAgXVIHYScpsDN7Fd9pAWGK108pX6RTpAe9QBWgu/tXWKRieO
         ObQPnoQqDAZ8r6dfjiYH0OagHfqUt0JIDubjTVBsUD0NdSsGIu8vEW0UfMSimSN9s0cD
         dKXE+pQiTTtFptRBa0yYhpL1FkDh0WvemV2xP8Y8g1hfHHGskuHIJ+PIeL77kPqX8dsn
         Vknp0MjQf8FWEUsaoKXac64EYz3YEiEUhC2xoeNP7RHK+sLKUZ3bx1ntSL/TNV1Lar21
         dtjQ==
X-Gm-Message-State: AGi0PuZJ5Vfa1DaVWv9pmHvxh0zShRhRSDzfP+Abu7818f2APvPG54qC
        Y6XzZYciHH+xdSRQLKQA5yo=
X-Google-Smtp-Source: APiQypLrUfOnv5cInu3QhevwPulfJHXDtZ/qYDyrp7gGC7ZR6mvqWy7UUQUzqNVorMHx21l8fTV4BA==
X-Received: by 2002:a17:902:8d8d:: with SMTP id v13mr16895267plo.67.1589227805586;
        Mon, 11 May 2020 13:10:05 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:10:04 -0700 (PDT)
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
Subject: [PATCH v5 08/15] qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
Date:   Mon, 11 May 2020 13:09:39 -0700
Message-Id: <20200511200946.7675-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
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
