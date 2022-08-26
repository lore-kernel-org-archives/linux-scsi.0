Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65699ECAAA3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245714AbiHZKOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242826AbiHZKOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:14:41 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D741EBE4F9
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:14:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e13so329855wrm.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=YRpdcaJ4r7VRT3/3i///gd/6IhC/k0ujvr195lrn9Lk=;
        b=VSUkeWQzqxVlhVFu4DC9tyaajVlj//djUl8X7BaKZwQua+k3/xBJFtIuDLjNJjQWLL
         GUaedmIJPtnNIiSBpY5M30o+30Jmmq1+sM9Rcp9s3vlmgwWWjzOLVA9s2rUJiYwfzqSI
         ruXSplnM+iFUnlzG+3jlq28Y6R/yJQmNN42YpzLUNlvU/DMtnH8RREhwp6CNmsiD6cAn
         P+odQZOAnBZyjm6qfeiccNeyztJh7Y0leBhqXWaNypkUwVE/lTfDMjJZ14dvEqlveVCO
         JbSmJo0t4quHGh+3J0eEE02Ec8Xn1LwKIkbOSGlqxJVVetWJH28se8Gz+WiQRhVspY0M
         RAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=YRpdcaJ4r7VRT3/3i///gd/6IhC/k0ujvr195lrn9Lk=;
        b=3NASf5TEhl89TpjGBSulJ9pil0KKM+/Yqk2BReQeA9OjxAQp8MKDvWVCPBqeZOKoiZ
         Od43vR5g2xxsXlURljeqRihhakVWJlU90hT+2pC7EQ/Xqe3nm3LGiDmxdYRIS5G65MWQ
         3hsYu0JSBiKn8kx2xO3OfflRVfSnnfk28JDcRNarlgdCUEp13BSffkQRNCfM4tsbs7qn
         czAkpK3AN5a2HPWJGUAtI0QQjEmheyMQU40keMlC6yezQlojfxNQJ09jb74zjCeYEwdf
         wNNAMjOoUpQj/o0zkkJrNlWFSqDbInf17T32dTH7LmyTN3rDqyjkAyWqUYtafTWuG3xF
         gw3w==
X-Gm-Message-State: ACgBeo3qcq9kihGW9pVq84/oDKmJ6a0zm7zxgPzwqnbjhBgDwcrvyMyT
        zZ5nRpZsHfLOG2jqEPHTgaNfTQ==
X-Google-Smtp-Source: AA6agR6XuzcSJ7avTDDbXtkKVvQcQEVjKXh2P9x7wWoHp7sT5sEudBIMCpUai6U2OGmhHrEje1PKMg==
X-Received: by 2002:adf:f90d:0:b0:20c:de32:4d35 with SMTP id b13-20020adff90d000000b0020cde324d35mr4466170wrr.583.1661508877365;
        Fri, 26 Aug 2022 03:14:37 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:140d:2300:3a17:fa67:2b0b:b905])
        by smtp.gmail.com with ESMTPSA id r8-20020a05600c284800b003a3561d4f3fsm1920423wmb.43.2022.08.26.03.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 03:14:36 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     jejb@linux.ibm.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi/qlogicpti: Fix dma_map_sg check
Date:   Fri, 26 Aug 2022 12:14:35 +0200
Message-Id: <20220826101435.79170-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the missing error check for dma_map_sg.

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/qlogicpti.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 57f2f4135a06..8c961ff03fcd 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -909,7 +909,8 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 		sg_count = dma_map_sg(&qpti->op->dev, sg,
 				      scsi_sg_count(Cmnd),
 				      Cmnd->sc_data_direction);
-
+		if (!sg_count)
+			return -1;
 		ds = cmd->dataseg;
 		cmd->segment_cnt = sg_count;
 
-- 
2.34.1

