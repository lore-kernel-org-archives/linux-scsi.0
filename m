Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C31DC5DF60
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B5DE2178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfKGFWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:22:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41782 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfKGFWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 00:22:15 -0500
Received: by mail-pf1-f195.google.com with SMTP id p26so1544101pfq.8
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 21:22:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/4TDgepIcZah/edYZGWrYSThpdVjhMFKqnUflESnRcE=;
        b=sSF4h9FSRMe3y915Chs11h6Rylu55lJlJfvIe0+1qZwXLDGb9cOtik0dS6yqTR/4hc
         PWr2LQZe4fBjKoOL9CRpI3bKka6RKLHcLGfvyXucEU0OJ+zwp4BgiXUNV0wYI81L58mC
         ZxeAPOcdb9EUGWcSa5nGaJHCb5PLqag10EGejeHT16e2/2tRE559gchzoK840KUsnx1r
         uM0WHYaFIBod8r6arVdmZd8cgKZefKGQMPdlc83H9NeZk3RUo5yT6rvV0eVPMsrRSkkT
         iH9A3OMY4HnJgt9nOCHnfcx81kLZVh2bzKKeyusf2eZsIUr0pTM4taAgLEpprqzwcEfu
         NZLQ==
X-Gm-Message-State: APjAAAW4X4fajLUcDhKTM2A3UegIFVu8zxV4/Q+sOEUNnPECd0tLG8RC
        K1HrpenuzxRl/nJLuUQipSY=
X-Google-Smtp-Source: APXvYqx7HUrDtg34aHdYee+wn5nN0Cujb8szZIODvn3K4W7JQNZPlYfMUgKSHIdvXJ6vTCxn2JzebA==
X-Received: by 2002:a63:fb4f:: with SMTP id w15mr2016651pgj.403.1573104132986;
        Wed, 06 Nov 2019 21:22:12 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:7917:b099:7983:671c])
        by smtp.gmail.com with ESMTPSA id m13sm719961pga.70.2019.11.06.21.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 21:22:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH 2/2] qla2xxx: Fix a dma_pool_free() call
Date:   Wed,  6 Nov 2019 21:21:57 -0800
Message-Id: <20191107052158.25788-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107052158.25788-1-bvanassche@acm.org>
References: <20191107052158.25788-1-bvanassche@acm.org>
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

