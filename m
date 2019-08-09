Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C66C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF94216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405098AbfHIDDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41721 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so34750970pgg.8
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yOD/L/Lc3Jm8OuMIzb8AScscGuJSOuxz7GclvBQ7Q+Q=;
        b=RQQf/pWjtXnvOEePdDgC8X4D/1dHAwWZgI79C6NDFrke50HX50f0CSl3+TjhQ5mw4I
         qxnHObKdVqzuKB7HN7TfNiaoQ7RPFsSYTx1qpq/nowQA08oj2uPvuMLHZuV3drF4Z5Ml
         CBb6qG2UTHafazKNvRpDrAWoOn49nR7Qp+RJQixaow3hL0FHYvHQNmYKqID+ogj2w9xE
         8vk9SEG3gpFncsuvZfUrbLCJaZafmxXGN6R57faZSuC9KE+/xrpdoJzCpTQdajnJ5ky3
         3gO4aki9h3alqHI9N8QYePv6/qL4Mi1WkQn9j/omevjmSTJ+00YeU5J+lGmcBvy0fuhk
         hxcw==
X-Gm-Message-State: APjAAAVC/ZTdOAch6dta04xysrpWTvWpTqTiQf7UPJOJ7hd82zgeG8+W
        sugBxPkECV45ZZ2ogxrr4lE=
X-Google-Smtp-Source: APXvYqyzXye5NWipu33ILcrdkRz3aSNhaqXFr8h6SfbIo7qfO9A7sAPz7A0k5BNBTnALa66dYMRc7A==
X-Received: by 2002:aa7:97aa:: with SMTP id d10mr19059712pfq.176.1565319782928;
        Thu, 08 Aug 2019 20:03:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 20/58] qla2xxx: Report the firmware status code if a mailbox command fails
Date:   Thu,  8 Aug 2019 20:01:41 -0700
Message-Id: <20190809030219.11296-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is helpful when debugging this driver to have the firmware status
code available if a mailbox command fails. Hence report that firmware
status code.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 133f5f6270ff..783a84606047 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -394,8 +394,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			goto premature_exit;
 		}
 
-		if (ha->mailbox_out[0] != MBS_COMMAND_COMPLETE)
+		if (ha->mailbox_out[0] != MBS_COMMAND_COMPLETE) {
+			ql_dbg(ql_dbg_mbx, vha, 0x11ff,
+			       "mb_out[0] = %#x <> %#x\n", ha->mailbox_out[0],
+			       MBS_COMMAND_COMPLETE);
 			rval = QLA_FUNCTION_FAILED;
+		}
 
 		/* Load return mailbox registers. */
 		iptr2 = mcp->mb;
-- 
2.22.0

