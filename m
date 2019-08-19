Return-Path: <SRS0=CaZB=WP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2939EC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 16:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A782087E
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 16:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfHSQf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 12:35:58 -0400
Received: from relay.sw.ru ([185.231.240.75]:35498 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfHSQf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Aug 2019 12:35:58 -0400
Received: from [10.94.4.83] (helo=finist-ce7.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <khorenko@virtuozzo.com>)
        id 1hzkdH-0001ug-Co; Mon, 19 Aug 2019 19:35:47 +0300
From:   Konstantin Khorenko <khorenko@virtuozzo.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sagar Biradar <sagar.biradar@microchip.com>
Cc:     Konstantin Khorenko <khorenko@virtuozzo.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH v3 1/1] scsi: aacraid: resurrect correct arc ctrl checks for Series-6
Date:   Mon, 19 Aug 2019 19:35:46 +0300
Message-Id: <20190819163546.915-2-khorenko@virtuozzo.com>
X-Mailer: git-send-email 2.15.1
In-Reply-To: <20190819163546.915-1-khorenko@virtuozzo.com>
References: <yq15zo86nvk.fsf@oracle.com>
 <20190819163546.915-1-khorenko@virtuozzo.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch introduces another wrapper similar to aac_is_src()
which avoids checking for Series 6 devices.

Use this new wrapper in order to revert original arc ctrl checks for
Series-6 controllers which were occasionally changed by commit
395e5df79a95 ("scsi: aacraid: Remove reference to Series-9")

The patch above not only drops Series-9 cards checks but also
changes logic for Series-6 controllers which lead to controller
hungs/resets under high io load.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1777586

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 drivers/scsi/aacraid/aacraid.h  | 11 +++++++++++
 drivers/scsi/aacraid/comminit.c |  5 ++---
 drivers/scsi/aacraid/linit.c    |  2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3fa03230f6ba..ddfa78c05728 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2740,6 +2740,17 @@ static inline int aac_is_src(struct aac_dev *dev)
 	return 0;
 }
 
+static inline int aac_is_srcv(struct aac_dev *dev)
+{
+	u16 device = dev->pdev->device;
+
+	if (device == PMC_DEVICE_S7 ||
+	    device == PMC_DEVICE_S8)
+		return 1;
+
+	return 0;
+}
+
 static inline int aac_supports_2T(struct aac_dev *dev)
 {
 	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index d4fcfa1e54e0..1918e46ae3ec 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -349,8 +349,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
-	if (aac_is_src(dev) &&
-	     dev->msi_enabled)
+	if (aac_is_srcv(dev) && dev->msi_enabled)
 		aac_set_intx_mode(dev);
 	return status;
 }
@@ -605,7 +604,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		dev->max_fib_size = status[1] & 0xFFE0;
 		host->sg_tablesize = status[2] >> 16;
 		dev->sg_tablesize = status[2] & 0xFFFF;
-		if (aac_is_src(dev)) {
+		if (aac_is_srcv(dev)) {
 			if (host->can_queue > (status[3] >> 16) -
 					AAC_NUM_MGT_FIB)
 				host->can_queue = (status[3] >> 16) -
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 644f7f5c61a2..c8badc9d9ae7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1835,7 +1835,7 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	aac_adapter_enable_int(dev);
 
 
-	if (aac_is_src(dev))
+	if (aac_is_srcv(dev))
 		aac_define_int_mode(dev);
 
 	if (dev->msi_enabled)
-- 
2.15.1

