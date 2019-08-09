Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5ABC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFB6C2173C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405301AbfHIDDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36049 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:40 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so45094585pgm.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jhKFIsARYyxeyrQG3mNlL7sh7MTLGkPne5Ts1oo1w6E=;
        b=kCRX3c2XWbWUKMZf7kZaC1SgPV+C8CHE4adhLYZO345kDEDG5g6Saozy37RXWTBzfx
         3AVEmVFuegyopLFJHdaTq7FD0kLkDmzW8LZrBCJniezBPIjmUDZb0Id/qt10WYUaFlWi
         cp0L4KbiKzvPKoplCetrO7g+pC8GePQmOCjzBBjNSf8Tc2clujF1g7KWGUyR1TMBAwiE
         EmhLXYfWFDIl7eAlPOyx0Ret1MjD4HGWx32Uu1ZqIUUjYuPrZwkdBRqycSL8xllG/t5C
         8J3qLOSTZs9MXPNvepOadx/wmiUfvd4CaoResdtCqDSXTT/HADfs57O++p70m2qQbuU/
         /0/g==
X-Gm-Message-State: APjAAAWJ5UmlgmT10TfWMKmZiUQotir+TkWmvVGQgsH7LjpzqMuNqdnN
        5clW+Y0T017XflbmeSR+96I=
X-Google-Smtp-Source: APXvYqy+/oc6Y/kI0g2Fp0itUU1JOGw0gZWDQ+VuzAbfom4hkOOguizk6GFFDCmfXDPiQ3LuiXOFcA==
X-Received: by 2002:aa7:86cc:: with SMTP id h12mr19363268pfo.2.1565319819504;
        Thu, 08 Aug 2019 20:03:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 47/58] qla2xxx: Modify NVMe include directives
Date:   Thu,  8 Aug 2019 20:02:08 -0700
Message-Id: <20190809030219.11296-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since struct sg_table is used in nvme-fc-driver.h, include
<linux/scatterlist.h> from that header file.

Since no definitions or declarations from <linux/blk-mq.h> are used in
the qla_nvme.h header file, do not include <linux/blk-mq.h> from that
header file.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nvme.h | 1 -
 include/linux/nvme-fc-driver.h  | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index 25a2b82d5095..ef912902d4e5 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -7,7 +7,6 @@
 #ifndef __QLA_NVME_H
 #define __QLA_NVME_H
 
-#include <linux/blk-mq.h>
 #include <uapi/scsi/fc/fc_fs.h>
 #include <uapi/scsi/fc/fc_els.h>
 #include <linux/nvme-fc-driver.h>
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 98d904961b33..10f81629b9ce 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -6,6 +6,8 @@
 #ifndef _NVME_FC_DRIVER_H
 #define _NVME_FC_DRIVER_H 1
 
+#include <linux/scatterlist.h>
+
 
 /*
  * **********************  LLDD FC-NVME Host API ********************
-- 
2.22.0

