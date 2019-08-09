Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3B2C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F495216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405078AbfHIDC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45953 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so45081880pgp.12
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mX2Zc+5VD6Al0nJLoyM05h9pbYcFZMj7Mr4ADbMrPwg=;
        b=W9dU1ao2yOdBnhOXMUVJXf0UTGOHheajroGnDDDKczkXpFX/rE1QSxIZf5v9Rwhnka
         eZw0WyAYQOA8XVZIgegJWeCHKq3fO1Z7b15ONz2an2aarAx2oNaUG0PiSfZGvAgOeLJk
         2LN+z0g9X2JLu8G6ZYrB403IGtjzAPNqI+OPJvQAQyTxodzWMf5m8PlFbEOdXHJ3LYLi
         SQcXn99qOVTxTIX+66moLTKI8ZcJtn6cA36yuZtwbyw7sWG69zTNYre378LnQZUd2G8N
         sShJmn2qi5x+to70B9vhMuubdMFDHka+yytfRAP6fZCbL0paHUErubIJJaeSwMVlwGqn
         eKjQ==
X-Gm-Message-State: APjAAAX7/HUAQ9NIDEP5l6HNXvSAx6wTxm1xbJUQqGaVFA4FmAKCVw0l
        BqtfI5okDOPewIamS/Zdu8k=
X-Google-Smtp-Source: APXvYqzD8drcPilubX08tmWkjISNzkVcsqkrWSStV5A7rwhCqAi17WW1hbxntmWgZik9I83yrrDmNQ==
X-Received: by 2002:a65:6401:: with SMTP id a1mr15580460pgv.42.1565319778796;
        Thu, 08 Aug 2019 20:02:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 17/58] qla2xxx: Remove two superfluous tests
Date:   Thu,  8 Aug 2019 20:01:38 -0700
Message-Id: <20190809030219.11296-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since qlt_remove_target() only calls qlt_release() if
vha->vha_tgt.qla_tgt != NULL, checking that pointer inside qlt_release()
is not necessary. This patch fixes the following Coverity complaint:

CID 188348 (#1 of 1): Dereference after null check (FORWARD_NULL)
var_deref_model: Passing null pointer &vha->vha_tgt.qla_tgt->tgt_list_entry
to list_del, which dereferences it.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 221912da67c6..12a3e77e0d02 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1580,11 +1580,10 @@ static void qlt_release(struct qla_tgt *tgt)
 	struct qla_qpair_hint *h;
 	struct qla_hw_data *ha = vha->hw;
 
-	if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stop &&
-	    !tgt->tgt_stopped)
+	if (!tgt->tgt_stop && !tgt->tgt_stopped)
 		qlt_stop_phase1(tgt);
 
-	if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stopped)
+	if (!tgt->tgt_stopped)
 		qlt_stop_phase2(tgt);
 
 	for (i = 0; i < vha->hw->max_qpairs + 1; i++) {
-- 
2.22.0

