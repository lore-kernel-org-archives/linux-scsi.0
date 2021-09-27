Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A7AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 16:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CD4660F9B
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 16:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhI0QTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 12:19:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:4321 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbhI0QSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 12:18:18 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 18RGGS6i022829;
        Mon, 27 Sep 2021 09:16:29 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, varun@chelsio.com
Subject: [PATCH] scsi: csiostor: add module softdep on cxgb4
Date:   Mon, 27 Sep 2021 21:44:08 +0530
Message-Id: <1632759248-15382-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both cxgb4 and csiostor drivers run on their own independent Physical
Function. But, when cxgb4 and csiostor are both being loaded in
parallel via modprobe, there is a race when firmware upgrade is
attempted by both the drivers.

When the cxgb4 driver initiates the firmware upgrade, it halts the
firmware and the chip until upgrade is complete. When the csiostor
driver is coming up in parallel, the firmware mailbox communication
fails with timeouts and the csiostor driver probe fails.

Add a module soft dependency on cxgb4 driver to ensure loading
csiostor triggers cxgb4 to load first when available to avoid the
firmware upgrade race.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/scsi/csiostor/csio_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 390b07bf92b9..ccbded3353bd 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1254,3 +1254,4 @@ MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
 MODULE_FIRMWARE(FW_FNAME_T6);
+MODULE_SOFTDEP("pre: cxgb4");
-- 
2.27.0

