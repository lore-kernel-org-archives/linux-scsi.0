Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BDBC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBFFE216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405025AbfHIDCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:52 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36519 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:51 -0400
Received: by mail-pf1-f180.google.com with SMTP id r7so45224731pfl.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F9Xad0CRbx6yI14GI5WIUUw39eOlyXGAfRyPRBZF2ao=;
        b=XP6nuEjlynnREr4eYiSKh4X0Nf0aok8fDPyaTpCR+nHtRht+NWH21F5PGxrFvb7sQ2
         URrcyqGoXVEUZ9z6qQHC51sE2UPZBeQgAz9Ukxn6UaAni5g4Gw2OFGRUf8ccj6n9fc6K
         5DPomqbv1QGcq2uS+Ud4vlV0WqGj5leF1S5Ckh3EjpNmjOon3ZD1941hAFtCyyZjUlJm
         VIYL2IJfAEs8eW+3OqLumvvdCrYxt8NXmMLX4Inh7BF5kQp0I7nEmYKL6yc6IDCBuyL/
         pf1/fPVcsdaD8PgPaf5WK/LuSlj7ZbgB+RYkn3s5Rqp9SQ0wUS9qeCvDEEsTJrKBmxLr
         wRhQ==
X-Gm-Message-State: APjAAAUnh6zwKVb5cGprVXqGe7HY0Ib6WFJ2itKPCHQZN38A69Zq5Tsi
        FSmeHBLCg4yJq8WT/EBRvwM=
X-Google-Smtp-Source: APXvYqzQxb+3IuYvSv987anmHY97a8+MUIiSDXqHNhsJ3F8a2RqBrT7nk1Z7DvYdNpIj/nswoEI6mw==
X-Received: by 2002:a62:1616:: with SMTP id 22mr19318793pfw.120.1565319771122;
        Thu, 08 Aug 2019 20:02:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 11/58] qla2xxx: Declare qla_tgt_cmd.cdb const
Date:   Thu,  8 Aug 2019 20:01:32 -0700
Message-Id: <20190809030219.11296-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it clear that the CDB is not modified after processing of a SCSI
command has started.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index b8d244f1e189..29d98757acff 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -912,7 +912,7 @@ struct qla_tgt_cmd {
 	uint8_t scsi_status, sense_key, asc, ascq;
 
 	struct crc_context *ctx;
-	uint8_t		*cdb;
+	const uint8_t	*cdb;
 	uint64_t	lba;
 	uint16_t	a_guard, e_guard, a_app_tag, e_app_tag;
 	uint32_t	a_ref_tag, e_ref_tag;
-- 
2.22.0

