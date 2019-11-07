Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A9DC5DF60
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D102178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfKGFWL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:22:11 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37871 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKGFWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 00:22:11 -0500
Received: by mail-pf1-f196.google.com with SMTP id p24so1569976pfn.4
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 21:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SQ9oM0QF6lMXsy/WycLkPXzM32zey87RAjzy8hYB4cE=;
        b=LM+Zef1wtsLb4PRTRvjUmzTvSTEEC2DGWtCxv2lJkDBngZq+u3O7xb99PBvVVleNJm
         qJWbsvm57LA9xDjMIHNnIa4iaF1DDry181br0bLOF68gAMJbtrzOzWLiMGWiYSVkbRU2
         z/2xd/6oC8I8dy7f6006GGGlzgfDgN4yS8JoegTl3eZB5i72riOl5hWkmWbyFuc3X0oz
         s1QL2b4yheVvKYbqzRuhtz2qvAyGpoSTrEsqJyM3LKfV07VyIfTsbWWT/N1V+tRPNiZN
         4QwPrUS0yIGFDd6w8zfCsk3sw6VpUigeNyVb9lwgjZ/JpkUft30ctYdxJOY/GkuRAJYL
         sMGw==
X-Gm-Message-State: APjAAAVYvQH65xsusJDlTIzw+TYj4bNr2UKLl/UKB7QfmuPoasEHKThh
        yeSN1/3fwmE6jG0ourivMac=
X-Google-Smtp-Source: APXvYqzFZ9Kuq7cy+yDXFqk3OQJB5nyBymEFvfspeURkqwYlaJUydjtddkNPxHjZvO7jOZSo9/WYwQ==
X-Received: by 2002:a65:664e:: with SMTP id z14mr2106661pgv.201.1573104130333;
        Wed, 06 Nov 2019 21:22:10 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:7917:b099:7983:671c])
        by smtp.gmail.com with ESMTPSA id m13sm719961pga.70.2019.11.06.21.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 21:22:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH 1/2] qla2xxx: Remove an include directive
Date:   Wed,  6 Nov 2019 21:21:55 -0800
Message-Id: <20191107052158.25788-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107052158.25788-1-bvanassche@acm.org>
References: <20191107052158.25788-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the code in qla_init.c is initiator code, remove the SCSI target
core include directive.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7cb7545de962..c1004d47514c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -17,7 +17,6 @@
 #include <asm/prom.h>
 #endif
 
-#include <target/target_core_base.h>
 #include "qla_target.h"
 
 /*
-- 
2.23.0

