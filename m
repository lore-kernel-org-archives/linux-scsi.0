Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C73C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 13:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D88218AC
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 13:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLRNpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 08:45:49 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:33832 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfLRNpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 08:45:49 -0500
Received: from fcoe-test11.asicdesigners.com (fcoe-test11.blr.asicdesigners.com [10.193.185.180])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBIDje5P004578;
        Wed, 18 Dec 2019 05:45:41 -0800
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, dt@chelsio.com,
        ganji.aravind@chelsio.com, varun@chelsio.com
Subject: [PATCH] scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()
Date:   Wed, 18 Dec 2019 19:15:31 +0530
Message-Id: <1576676731-3068-1-git-send-email-varun@chelsio.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If cxgb4i_ddp_init() fails then cdev->cdev2ppm will be NULL,
so add a check for NULL pointer before dereferencing it.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index c4e4b01..4bc794d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -121,7 +121,8 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
 		"cdev 0x%p, p# %u.\n", cdev, cdev->nports);
 	cxgbi_hbas_remove(cdev);
 	cxgbi_device_portmap_cleanup(cdev);
-	cxgbi_ppm_release(cdev->cdev2ppm(cdev));
+	if (cdev->cdev2ppm)
+		cxgbi_ppm_release(cdev->cdev2ppm(cdev));
 	if (cdev->pmap.max_connect)
 		cxgbi_free_big_mem(cdev->pmap.port_csk);
 	kfree(cdev);
-- 
2.0.2

