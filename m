Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6ADC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86505216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404992AbfHIDCs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:48 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34559 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:47 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so45221906pfo.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWdo/NCcAcZRQB5OuE5sPiTx/ktJm016GuKX/Ul6kmE=;
        b=FGUhNgIkG6smTJz+ivUvtQwlE62pTTTo/8Mnb1nok1VY49Lijimwaa94Bf9yRchxTd
         PrW17BUnMWJff48EFik5Ae4Ne6uzM0mulPPF+L3capwZyOMBp1d4OSIt/29i64y5RXxU
         tZQaFKZwl+++OQmp6yrW16L3p+LYrQPcoKbLwz1uMvt2wNr/cY18UyksLI45wOOpDxu2
         2P0hpnxiJl2mkzqgjIhFfwOnqJvob3RMoYK2Hy+tIobyZtEgrY+YoKOn90HAAarWZMUT
         cwdscdwER9dXYzJLM1hVy/Bs8l/uqetoA01pOL73z6lu0ij2RP0JognKxRMc1NfG15fa
         KDfA==
X-Gm-Message-State: APjAAAVNn6+tu2g7tEX0kAZipaYAWg2+NRaZ6+6XfaPs9Q/nPVLXsjHt
        hohYHWjuoo/GQuwtTchdsHE=
X-Google-Smtp-Source: APXvYqyUam8v0OHt/F5hZncDVV2RUjds9yXPtyJT4KEwGsxEkQ1RPsFNXxVI0gSKm/MsZG0Z1QEYrg==
X-Received: by 2002:a17:90a:ad86:: with SMTP id s6mr7301139pjq.42.1565319766947;
        Thu, 08 Aug 2019 20:02:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 08/58] qla2xxx: Declare the fourth ql_dump_buffer() argument const
Date:   Thu,  8 Aug 2019 20:01:29 -0700
Message-Id: <20190809030219.11296-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes it clear to humans and also to the compiler that
ql_dump_buffer() does not modify the memory the @buf argument points at.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 3 ++-
 drivers/scsi/qla2xxx/qla_gbl.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9e80646722e2..30afc59c1870 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2743,7 +2743,8 @@ ql_dump_regs(uint level, scsi_qla_host_t *vha, uint id)
 
 
 void
-ql_dump_buffer(uint level, scsi_qla_host_t *vha, uint id, void *buf, uint size)
+ql_dump_buffer(uint level, scsi_qla_host_t *vha, uint id, const void *buf,
+	       uint size)
 {
 	uint cnt;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f9669fdf7798..6f6801722a09 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -630,7 +630,7 @@ extern ulong qla27xx_fwdt_template_size(void *);
 
 extern void qla2xxx_dump_post_process(scsi_qla_host_t *, int);
 extern void ql_dump_regs(uint, scsi_qla_host_t *, uint);
-extern void ql_dump_buffer(uint, scsi_qla_host_t *, uint, void *, uint);
+extern void ql_dump_buffer(uint, scsi_qla_host_t *, uint, const void *, uint);
 /*
  * Global Function Prototypes in qla_gs.c source file.
  */
-- 
2.22.0

