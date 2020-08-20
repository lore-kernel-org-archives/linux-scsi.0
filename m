Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C20C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1D7207DF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TggKAq+G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHTSwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgHTSv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 14:51:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D913C061385;
        Thu, 20 Aug 2020 11:51:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z18so3102649wrm.12;
        Thu, 20 Aug 2020 11:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OBfjEMXrvHfHA4ZfSTlw1MEhV9y4/rsLJtMDyqLaZE=;
        b=TggKAq+GHBkFEqPv5wF0L7x1EL8m9AjUaZo3YMoCq0oby0froLzwXVCIYof0QcV6gP
         4PDAmkQ8mNAsgGmgcE/0ufjCu1/VA336H7AQmdmWW0s70PdH7AC6M/s6Czw6dysdOy7u
         9PZ7A8lpDnAfn5ogdcCCezXRSParyypBJqEO+NC/YJhank4UfcdWyF4NCaTXXpLF/mHC
         r5TYZ7PtPG/emC8Dl500w54ZLWIoxb2Mbdkg7Liw7sVWpgeVFK18osTAR2wQNBkprzVi
         io4PSPLfeWuaNnu1KnKLvHZCY4wQ/xNOkI5dwWfMCKQCzZvPkAmsheWwpHYUwQ9afR/1
         d07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OBfjEMXrvHfHA4ZfSTlw1MEhV9y4/rsLJtMDyqLaZE=;
        b=RZaFOHbLRR26fs1N1sgJPrzHNZcLxkuTx1jFA5CuDXA1e454zNOedNuOdHX/XeWOFk
         lDUQFU90iCRXQfx27aU3bK/nEGNRvS9oD9G+ezA8bUkOJWxDB+3E+pgbVmYD/VVwhnau
         sx3BUcOUa8v+IMgy2xSVD1LhrVfqemzMLpkxKBOmfYYNeBZ4n+9xd1gL1zqloWvXyaOp
         7sMZ3wAFKOKv4lrmTmGWGzNf+zWmxkL4tyGlCQygoeLGc9kKm0IfS036ztr79vAwj5sk
         Ud4ZUohqd0FlsnNhMqabm7qjsEgNyuxu88WH0BuuYmcAjHj4KrAvI8YVKi5y+gpzjAEL
         z4XA==
X-Gm-Message-State: AOAM530+G/Jc+zSQRBLw6PLWn11H+QpyjpCqw0W98SDy4ZVy8aAeeBpB
        BLyq4/O0H1YZWejqhxhT+RwQNUsZyhitxFxm
X-Google-Smtp-Source: ABdhPJwuFJAYfGU9Hmt7SvFrIIXQWtVurSNECgoa311lZtPpNp64wDhutmHAW01NOap7yrwY/7qQbQ==
X-Received: by 2002:adf:c983:: with SMTP id f3mr96319wrh.348.1597949515238;
        Thu, 20 Aug 2020 11:51:55 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id t17sm5511290wmj.34.2020.08.20.11.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 11:51:54 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alex Dewar <alex.dewar90@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Remove unnecessary call to memset
Date:   Thu, 20 Aug 2020 19:51:49 +0100
Message-Id: <20200820185149.932178-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In qla25xx_set_els_cmds_supported(), a call is made to
dma_alloc_coherent() followed by zeroing the memory with memset. This is
unnecessary as dma_alloc_coherent() already zeros memory. Remove.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 226f1428d3e5..e00f604bbf7a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4925,8 +4925,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	/* List of Purex ELS */
 	cmd_opcode[0] = ELS_FPIN;
 	cmd_opcode[1] = ELS_RDP;
-- 
2.28.0

