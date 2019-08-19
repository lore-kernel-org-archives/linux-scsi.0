Return-Path: <SRS0=CaZB=WP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16A6C3A59B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 07:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73D922085A
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 07:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sv++iQj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfHSHyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 03:54:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44761 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfHSHyR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 03:54:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so718912pgl.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2019 00:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O8wSuGj2WtF5bgJTiZfxRbtOMqruBXCPOl3dwbFPOys=;
        b=Sv++iQj67rISVxv6mdBJsuOPy56Me0/aCHIvjY3ETR9AOCF3nPa1yqr+ozh8iL3+96
         cRP5gdJ3/PSLHlE2v2LBZWI9vH6gd1rwGt4hTo0bi6fr5E+kDbQON5j9pF0Ir4nPMvUT
         BCY3n4XNNZbN7VLz2BlA8O+5JHtgvYCiDLImK4pjZzzrQ44AMdbMsitsVUC5rMR/wG2S
         ULgFbLvYESxm7V3hU7qlE7jw/IbUv8UCxWrGmjZI30s39LZcPSR6098KpgHWKyP6KZO1
         de/iCH0NrxtENWHW/XwTG1adJi/fdWmH8AnI0ZBMq6cCePl+bbW5xacSBFobt4UabtLP
         +8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O8wSuGj2WtF5bgJTiZfxRbtOMqruBXCPOl3dwbFPOys=;
        b=nQQnlNF22seg9WuqRtYErGMruc8L9yfCTf9QqW/Gj3fl1vpW9e/X/04ryIGKxB3Opg
         tbInn01NuQJ2giu4qMmUEy18HMMUtUNSKgo3Os0wj2p2NKCle43kJ2r4iWcq6U7rLnfm
         2BJ1mL8ScyvrfwbS7PQB/253VTqON94wcFRiAvAn5zgEE+KVhRhvcW7rgBY0RSqiBTr6
         GGtVclMZHgDTnw2TNBEACRbik4Hj/+obnzm8Cm0Xb4w2AoTQwQ5cenI4nZ+uX22332uO
         rdA1AuJq+IGk09SRktnkogbk3Y/A65Q77b0O9KGdbXQ9CuywB/RgvAsOGlmRG5fIhvqO
         ryng==
X-Gm-Message-State: APjAAAWEMHLPJ2j2C5YgCfRunVJWh2c7JLzGLeBLitJeFpbMu/Qm1YqR
        /BrlPbTlzNGTif+1Br4RnK40gw8h
X-Google-Smtp-Source: APXvYqzWeRMybDbAP6dzoaf3vLi3tnYyc+19W1LH2eIKVauxxSJgyIbSHp+O4/jYKgqKQM9NeqPPzg==
X-Received: by 2002:a17:90a:9f46:: with SMTP id q6mr18817556pjv.110.1566201256498;
        Mon, 19 Aug 2019 00:54:16 -0700 (PDT)
Received: from localhost.localdomain ([110.225.16.165])
        by smtp.gmail.com with ESMTPSA id u24sm13936212pgk.31.2019.08.19.00.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 00:54:16 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com, martin.peterson@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] scsi: bfa: bfa_fcpim: Make structure cmnd_z0 constant
Date:   Mon, 19 Aug 2019 13:24:01 +0530
Message-Id: <20190819075401.1237-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Static structure cmnd_z0, of type fcp_cmnd_s, is only used when being
copied into another variable. Hence make it constant to protect it from
modification.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/scsi/bfa/bfa_fcpim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 284baa3b0c8e..ef604e27896a 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2450,7 +2450,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 {
 	struct bfa_itnim_s *itnim = ioim->itnim;
 	struct bfi_ioim_req_s *m;
-	static struct fcp_cmnd_s cmnd_z0 = { { { 0 } } };
+	static const struct fcp_cmnd_s cmnd_z0 = { { { 0 } } };
 	struct bfi_sge_s *sge, *sgpge;
 	u32	pgdlen = 0;
 	u32	fcp_dl;
-- 
2.19.1

