Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC72C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1302216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404965AbfHIDCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:44 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39967 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so44308321pla.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzK2POMip9UsodUJ8d+FruqGSkBBAktF2mbcg1yVbZs=;
        b=AgXYJGe7XnEDft+iNuf6mUJC5/tQ6T0X3QJ+UBeE+PW5Ff1I8dvV2b/cxtAUGF6djg
         274vD/lDPsqyvSG1zEPWdyDetYO/cAK0LM7AmHAACctRVHCa6YMuL7I1+XxAmk5kHR45
         BWmTnNHSwW05LSZg0FP0idmlkXaXP2c7AauLiJAzW106qrdzJ0SWye/LgmY26XxX5ypB
         vvp/L90kI33cLs6i45HmC/aCA++/4m+inD9JhJfcVgf2fcP3SygHpunl6x5YFBqyesbW
         UyyavRJDlY7jcpg8rpeZ96LOZNesJvOlrTMMMQ6vrhYlH0LNkNIRriaQjrxZQpUEV0bd
         OpLA==
X-Gm-Message-State: APjAAAXJXZOAHlhQbi9TaGXT9cymH+uQgq8A4knsA9W+r/T27VfIkP+N
        iYOSd0b9nYwEDnJUOv/strI=
X-Google-Smtp-Source: APXvYqwPZhAqlTkcuFgEaETqWchREK5OQOtaNUmf3GTE39PQCz9zVhwFumJxdxCSYxdHU6cYcZUhQQ==
X-Received: by 2002:a17:902:4283:: with SMTP id h3mr16286422pld.15.1565319763282;
        Thu, 08 Aug 2019 20:02:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 05/58] qla2xxx: Include the <asm/unaligned.h> header file from qla_dsd.h
Date:   Thu,  8 Aug 2019 20:01:26 -0700
Message-Id: <20190809030219.11296-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the put_unaligned_*() macros are used in this header file, include
the header file that defines these macros.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 15b7a68c1d03 ("scsi: qla2xxx: Introduce the dsd32 and dsd64 data structures") # v5.2-rc1.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dsd.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dsd.h b/drivers/scsi/qla2xxx/qla_dsd.h
index 7479924ba422..20788054b91b 100644
--- a/drivers/scsi/qla2xxx/qla_dsd.h
+++ b/drivers/scsi/qla2xxx/qla_dsd.h
@@ -1,6 +1,8 @@
 #ifndef _QLA_DSD_H_
 #define _QLA_DSD_H_
 
+#include <asm/unaligned.h>
+
 /* 32-bit data segment descriptor (8 bytes) */
 struct dsd32 {
 	__le32 address;
-- 
2.22.0

