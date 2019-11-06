Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB53C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336162075C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbfKFEmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:42:37 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44470 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731251AbfKFEmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:42:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id q26so17862059pfn.11
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 20:42:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/4TDgepIcZah/edYZGWrYSThpdVjhMFKqnUflESnRcE=;
        b=j0xwGC0etbxhamvGRCOEECg/uR5QaMGz46h1aKEdWSw2FroV0YJupIeNs5ABAvmB8U
         Dm/yGTFao8YQFz81z5VifoOvwq1MA1853uNutL/NbWZVBh2Qlp14pIzZI53u1SmO6zDC
         QabxpVgmxMImbrb/EBR2lC2IN+kLjV2y6JRQJ6x7bfbFdJTGcPx6ii28qbA0uAh3ylYN
         vT0XuOGHfgSC7wV7lpX0QY3pLNCNeS22bp3fSfGvmtQqKBNPd2i5qoMFLWxF5VViTq3P
         98Caoc2Mz3rvMQ8z+OlTmzfep/+jxwztug00PZYM1ZF2XsvxDmEzihEjIJoluzOzlIrS
         XhRg==
X-Gm-Message-State: APjAAAWbO9i8VZKVqtF4amOrKtRClT6XEleFNzQU/x8Yo/I2opLToPWF
        9FBTgD+R7oifPFPZ12FlMWpasfCN
X-Google-Smtp-Source: APXvYqyQjbOFh5KzTiQHeiLkaUlTtTPH+ZpII1VUV1gykjVzLsIfvng69BIGn8wqPq6b+NCSXKC4Ew==
X-Received: by 2002:a17:90a:174a:: with SMTP id 10mr1078812pjm.104.1573015356180;
        Tue, 05 Nov 2019 20:42:36 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:a0dc:7f54:c925:d679])
        by smtp.gmail.com with ESMTPSA id m15sm10262501pfh.19.2019.11.05.20.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:42:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH 2/2] qla2xxx: Fix a dma_pool_free() call
Date:   Tue,  5 Nov 2019 20:42:26 -0800
Message-Id: <20191106044226.5207-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191106044226.5207-1-bvanassche@acm.org>
References: <20191106044226.5207-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following kernel warning:

DMA-API: qla2xxx 0000:00:0a.0: device driver frees DMA memory with different size [device address=0x00000000c7b60000] [map size=4088 bytes] [unmap size=512 bytes]
WARNING: CPU: 3 PID: 1122 at kernel/dma/debug.c:1021 check_unmap+0x4d0/0xbd0
CPU: 3 PID: 1122 Comm: rmmod Tainted: G           O      5.4.0-rc1-dbg+ #1
RIP: 0010:check_unmap+0x4d0/0xbd0
Call Trace:
 debug_dma_free_coherent+0x123/0x173
 dma_free_attrs+0x76/0xe0
 qla2x00_mem_free+0x329/0xc40 [qla2xxx_scst]
 qla2x00_free_device+0x170/0x1c0 [qla2xxx_scst]
 qla2x00_remove_one+0x4f0/0x6d0 [qla2xxx_scst]
 pci_device_remove+0xd5/0x1f0
 device_release_driver_internal+0x159/0x280
 driver_detach+0x8b/0xf2
 bus_remove_driver+0x9a/0x15a
 driver_unregister+0x51/0x70
 pci_unregister_driver+0x2d/0x130
 qla2x00_module_exit+0x1c/0xbc [qla2xxx_scst]
 __x64_sys_delete_module+0x22a/0x300
 do_syscall_64+0x6f/0x2e0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cc: Michael Hernandez <mhernandez@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 3f006ac342c0 ("scsi: qla2xxx: Secure flash update support for ISP28XX") # v5.2-rc1~130^2~270.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 16f9b6ed574a..05fba5c2c926 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4676,7 +4676,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->sfp_data = NULL;
 
 	if (ha->flt)
-		dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+		dma_free_coherent(&ha->pdev->dev,
+		    sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 		    ha->flt, ha->flt_dma);
 	ha->flt = NULL;
 	ha->flt_dma = 0;
-- 
2.23.0

