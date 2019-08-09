Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6391AC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F080216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405132AbfHIDDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34585 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so45222321pfo.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SnfaZ/0oaipWE1K5VXr0cFs2V604/T/FQr4lNOxbilg=;
        b=e1nmdorxA4jRkmq1RkenMHtaLpGAGJAlSC9u9Y+wyHsxTp2CNp5lITpsi/Cq2ZFYxt
         FbFPggmIEZAtwRbo4lBf49EdUN1/PfVIEL4BlciIV5n+C/dt1UjRcNnSR9sdkpo/M71R
         hxUODUxlQAHj0+3F2J5KVVGxpaJIiXLIwja8iKqzaBm+ncm9ugSWqdnzlQ+4BzyWI5go
         IFWViBba+f91YNM3xoxl6nTK8bb2jTldZ3lO/fovieys0+f8jzoAcgN0AxKNpsxUeO2J
         EoTDeR1Nihkvp6ZKr31UyDtF4W5NCqJJlpfEpZuMtMtmJdySSmSdDpTe8mpFVUTY94qp
         x/DQ==
X-Gm-Message-State: APjAAAUuooVhHfGyP+KYhOvAmikd1OsUtkGtR5NyqBvw/MXVUw/OSX/T
        75q7oibAC24vrxTEXiWC6og=
X-Google-Smtp-Source: APXvYqwbWGUqsZXwI4qPP7LcX4JjREJFq2SgfuAUVFyjVOLlPyiE30y8ZmuDjVk37gS2nueuKhOy7Q==
X-Received: by 2002:a17:90a:8c90:: with SMTP id b16mr7138214pjo.133.1565319786846;
        Thu, 08 Aug 2019 20:03:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 23/58] qla2xxx: Complain if a mailbox command times out
Date:   Thu,  8 Aug 2019 20:01:44 -0700
Message-Id: <20190809030219.11296-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint:

Unchecked return value (CHECKED_RETURN)
check_return: Calling wait_for_completion_timeout without checking return
value (as is done elsewhere 14 out of 17 times).

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index b6be7e7f2a43..9e3f2f462a2e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -148,7 +148,8 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 		QLAFX00_SET_HST_INTR(ha, ha->mbx_intr_code);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
+		WARN_ON_ONCE(wait_for_completion_timeout(&ha->mbx_intr_comp,
+							 mcp->tov * HZ) != 0);
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x112c,
 		    "Cmd=%x Polling Mode.\n", command);
-- 
2.22.0

