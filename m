Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2FBC4332E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3921A650E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhCPD5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:21 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:56164 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbhCPD5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:07 -0400
Received: by mail-pj1-f51.google.com with SMTP id bt4so9923349pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7IKYsOC1X4EjHUenVf724LnE6hJ//GY2O7wGY4ce7Ro=;
        b=b0evG7NAP1PRqTrNcZzK0mWfrAR/I8lUQYyAc/yzy/GzV3E/IELWYtQQ9Fd0LmcQaM
         mknFNz30Qj6uGmeswfCHxKlxG/EL8/JOfm7PS48FZvUfbJyPguS7SgNr1xX2CV3LDv7A
         5V17+Ww5G9RnsHIR8mD/J8JYCgcZj43Rpph9dOiBO02yAO+mEBeK8g0ZpmFAkniHmya+
         5e+esrDyzEG4Z0bpf7ayvLkZSqbot33tJm1EpeAEIQAWwJoocjWlC9BoHlrg2BZRlkVH
         Ikdo/sjRA+jlf6sh9Z1266W0aBQ+/PjuoaxSx2ySsEASvcR2nHs1lCVtQDWzhHrH9dKN
         fgJw==
X-Gm-Message-State: AOAM530stvGFDx82Jk6NSySMVJ2UZrd2NwotrHwp/s5b/BmdC8Lasd5d
        tsxJix+aJ4YrmXbYRLQ6Uqk=
X-Google-Smtp-Source: ABdhPJz9TOntbhBHok6WfAPwoMOhrTBU9DLyFvqA98qzDWPDJrLOA55/Lz+U2cFZDxOjxwZsUNWtOw==
X-Received: by 2002:a17:90b:38f:: with SMTP id ga15mr2580403pjb.149.1615867027150;
        Mon, 15 Mar 2021 20:57:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 4/7] qla2xxx: qla82xx_pinit_from_rom(): Initialize 'n' before using it
Date:   Mon, 15 Mar 2021 20:56:52 -0700
Message-Id: <20210316035655.2835-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch suppresses the following sparse warning:

qla_nx.c:1218: qla82xx_pinit_from_rom() error: uninitialized symbol 'n'.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0677295957bc..5683126e0cbc 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1095,7 +1095,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	int i ;
 	struct crb_addr_pair *buf;
 	unsigned long off;
-	unsigned offset, n;
+	unsigned offset, n = 0;
 	struct qla_hw_data *ha = vha->hw;
 
 	struct crb_addr_pair {
