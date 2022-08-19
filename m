Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD1CC28B2B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 06:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346618AbiHSGJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Aug 2022 02:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346536AbiHSGIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2022 02:08:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A3032EDF
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 23:08:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w3so4457299edc.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 23:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=YRpdcaJ4r7VRT3/3i///gd/6IhC/k0ujvr195lrn9Lk=;
        b=dClsiF8/qquQhG3mTRGsAcbFLgD7BqtxZiG5igXl/tQMnq+DIwQy/n4vJcD74RLzhw
         rNVuNVbIvfInB6tJAS5ktMLxANQJGYE6tJI++8kwlx0MVpwVvVVWeLX3wqXy/pUq/vXt
         tuaEzz4CONIC6f00x7TfopRSRwbdWOp3IFUXi28obkv0HnhgvKxHPPtyVoGuwuJlTrPU
         U6R37X9gq0WGh3ocZ2O7O/uBLi1rv88P3Xx/+z22g4XfE4rMpDNDuXTscJg9kFy7ThsW
         B/QjpE6PfUWQ8nozGKYds8I2ZhfTUHWPYdiX+rLRN2Xl9LqofiZaXGXKggMh6F+JH6K+
         KTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=YRpdcaJ4r7VRT3/3i///gd/6IhC/k0ujvr195lrn9Lk=;
        b=xdGjN7d/ScRquzbV7oNp0NvGoHmDZkutSyB0aDHwTpECOWFxSuj0olLkoZup5jsyI0
         de/iv4vJ3mdFrYj+nJ+eykhGczsezjDNWJf1v7dBVs9uf8O8XwBw9iYQ8nFNKaOz3qvg
         iRPAjU7RBASZbjRWLVvPchtoVcJOuUcKqD/Dxl/vUGl0XF6tcFn88bEWc3FrDzFsrsR2
         h0+KFP0zL5lLGASwhcMxcZPkqXV4MuxXHwPluySA9YgzO96tb+O2tPEbfMblr7hNPn28
         c43YATRzGMW4XpSH7F66hO3Avd/4rTM1E4nlgAFT7Clda7vfypnMQxGwifgdRSyjN5ZO
         QCFg==
X-Gm-Message-State: ACgBeo0jrUOP16Ut4fNGVduui6V6HbJ5te0Gvtvl6XOQrgEaAnzkUNJ6
        uEMtyRDd90BXfjAoNMDmhpSTwA==
X-Google-Smtp-Source: AA6agR76uQfP+U8eTNPUlQ2cBewfTbiI+d5oZ56Bftjg4YGeZIcjKUqA7r+vN12AdAnt1dgkLq5dSg==
X-Received: by 2002:a05:6402:4411:b0:437:b723:72 with SMTP id y17-20020a056402441100b00437b7230072mr5001891eda.38.1660889307277;
        Thu, 18 Aug 2022 23:08:27 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:143b:fd00:5207:8c7f:747a:b80d])
        by smtp.gmail.com with ESMTPSA id y14-20020a1709063a8e00b0073a644ef803sm1809660ejd.101.2022.08.18.23.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 23:08:26 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-kernel@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v1 16/19] scsi/qlogicpti: Fix dma_map_sg check
Date:   Fri, 19 Aug 2022 08:07:58 +0200
Message-Id: <20220819060801.10443-17-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819060801.10443-1-jinpu.wang@ionos.com>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
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

