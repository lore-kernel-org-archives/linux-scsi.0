Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59096C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1B7216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404974AbfHIDCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33358 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so45223457pfq.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xBDtwkQKeTLFNtgBQLWgPuySFV2AE+byVxRNKLKZto0=;
        b=WPB3QE49FGFOtZOMwkd0lNzao1aLvMFTW7Gl5Z9FiocbAFnIMFp25/QmtblOZga0S3
         TwCeShSMx+M4WVKvAnVZ9LnV6OPdMUCbaNBDgjNmJvpmuaXgDIkpyURw5Ddj8IYef624
         X0dEgT/rnFX9u/65cV9LdunrYJYLHBzNo345lnMnTELmdXZmgT/Nfa/tBdMqHvLYuDzS
         F5hJZzx5Ify2eeVbXNg5cK/iumfrZoKMiSAU6Kxn7OwTVxgj781J85hvwvJegpolW696
         wCjEC503iLaUr7U1HSEeRr4vPD9tT+5gIR43T0h76h8eapEeUuUblkWYblC+imCB5Zj9
         BCuA==
X-Gm-Message-State: APjAAAXp0NRLb9r+nfHjgmkEZvJEi7aRctfnMgUINayaTSlL7TzLgDKN
        hhvYdPMOxrlpqVU1YV0xRuM=
X-Google-Smtp-Source: APXvYqz4A+qb+kY4h2ukYNMlPXCBitN+XSoBSuy7WYjxbQKB5ZtfxRInA8OHvzxoeZKV4a+U4RS4Qw==
X-Received: by 2002:a62:be02:: with SMTP id l2mr19357421pff.63.1565319764600;
        Thu, 08 Aug 2019 20:02:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 06/58] qla2xxx: Remove an include directive from qla_mr.c
Date:   Thu,  8 Aug 2019 20:01:27 -0700
Message-Id: <20190809030219.11296-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no bsg code in the qla_mr.c source file. Hence do not include
the <linux/bsg-lib.h> header file from qla_mr.c.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 942ee13b96a4..cd892edec4dc 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -10,7 +10,6 @@
 #include <linux/pci.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
-#include <linux/bsg-lib.h>
 #include <scsi/scsi_tcq.h>
 #include <linux/utsname.h>
 
-- 
2.22.0

