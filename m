Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B533BC001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 05:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjGZFSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 01:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjGZFSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 01:18:07 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D8B113
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 22:18:07 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-55b1238a013so4477843a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 22:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690348686; x=1690953486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T+J6Ed15Yk5vxDPaPbZ5dBECpzg/w9CpybrlLvkM2Ms=;
        b=K4qTVXllKmKg5x1npK8Bxvgl45zX3Kf29W5CfRSfwdsM0c2PRCMR3oQhnsF1CqlQcJ
         0LCRIVL5P/ZlZGnYizix9E37tzj31tXxYjL3qrMrZfI/NWpag5onkjaM5gXQ9KCh6Dv6
         e2RAsEq9c5g1D28mrws8W1AqFiYFta5dTFrGrIQ0MMumqL0M4W+k1zux07IN5UYQzNrB
         7xipTikkjpoVfEpwarUW86l0eGK/aa5GgrXCNwoDnz0kNYtz/Xk/ybEgcvxDn62NdkUt
         Of/FxAZunrWlHQfGR9qbwABmv9XStmK8MJcwvNCx91k5ipipGQ0qt6Xs+SyhHKQnSR0A
         srWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690348686; x=1690953486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T+J6Ed15Yk5vxDPaPbZ5dBECpzg/w9CpybrlLvkM2Ms=;
        b=Tcsk27ZkbbcgGW+9/OHavqtgeEvvoYkPOe3YPhKOv88A+JU2p8Fs5hTSa06QMlgxi2
         kTtiHciOA1DrzVZ7BI0dZL2UNcxr7AlHqSuPuqS3r4FbYCcJ3pPeffrw67j6TtQRFl3H
         0FRvpKwVDDdVgqZgcTM5drWQp/Ds/l7vpm0kQiq70S2caL15IOWih8s3LAU10XLwNjEs
         6rhWLJkyStc26FLeZUZD8AxquBOPO0JFQ2AvZDEwL/mCvpe+VpXfDEVtp76ThZX3QamJ
         bMVHnDgX9heBFZ3fGZ5GBO2uUuE45WvHOoALerY/oDLvfUkLcj5N3G6SKFez6iVkzvlv
         8xvA==
X-Gm-Message-State: ABy/qLbTnI7JRd27AMt9Rx82stdP8yKF5pgyKVoTG3f5f0aVkZfrp6sW
        xuTBy5i2ag95W4r3SgTBZnTtho/SFu0OISOGM3E=
X-Google-Smtp-Source: APBJJlExTj4h2XeTWimCRhV3cbGQuUDPdUpEacmJfUXScpmXWuJe14teMGiR3rtyJcVwe0rvdmruPg==
X-Received: by 2002:a17:90a:cb8a:b0:268:1217:46bc with SMTP id a10-20020a17090acb8a00b00268121746bcmr802138pju.11.1690348686247;
        Tue, 25 Jul 2023 22:18:06 -0700 (PDT)
Received: from sunil-laptop.dc1.ventanamicro.com ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090a4c8500b002676e961260sm2159979pjh.0.2023.07.25.22.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 22:18:05 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] scsi: hisi_sas: Fix warning detected by sparse
Date:   Wed, 26 Jul 2023 10:47:59 +0530
Message-Id: <20230726051759.30038-1-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LKP reports below warning when building for RISC-V
with randconfig configuration.

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4567:35: sparse:
sparse: incorrect type in argument 4 (different base types)
@@     expected restricted __le32 [usertype] *[assigned] ptr
@@     got unsigned int * @@

Type cast to fix this warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307260823.whMNpZ1C-lkp@intel.com/
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 20e1607c6282..6cd2e485d35b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4576,7 +4576,7 @@ static int debugfs_fifo_data_v3_hw_show(struct seq_file *s, void *p)
 	debugfs_read_fifo_data_v3_hw(phy);
 
 	debugfs_show_row_32_v3_hw(s, 0, HISI_SAS_FIFO_DATA_DW_SIZE * 4,
-				  phy->fifo.rd_data);
+				  (__le32 *)phy->fifo.rd_data);
 
 	return 0;
 }
-- 
2.34.1

