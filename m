Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6A7C43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21E132084F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfLDO7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:59:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:36202 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728053AbfLDO7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Dec 2019 09:59:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E98FFADE4;
        Wed,  4 Dec 2019 14:59:23 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        Balsundar P <balsundar.p@microchip.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/13] scsi: add scsi_host_(block,unblock) helper function
Date:   Wed,  4 Dec 2019 15:59:13 +0100
Message-Id: <20191204145918.143134-9-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191204145918.143134-1-hare@suse.de>
References: <20191204145918.143134-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helper functions to call scsi_internal_device_block()/
scsi_internal_device_unblock() for all attached devices on a
scsi host.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c  | 30 ++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2563b061f56b..d48405dddce4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2840,6 +2840,36 @@ scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
 }
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
+int
+scsi_host_block(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	int ret = 0;
+
+	shost_for_each_device(sdev, shost) {
+		ret = scsi_internal_device_block(sdev);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_host_block);
+
+int
+scsi_host_unblock(struct Scsi_Host *shost, int new_state)
+{
+	struct scsi_device *sdev;
+	int ret = 0;
+
+	shost_for_each_device(sdev, shost) {
+		ret = scsi_internal_device_unblock(sdev, new_state);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_host_unblock);
+
 /**
  * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
  * @sgl:	scatter-gather list
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5c61f128f8e6..71472eace583 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -760,6 +760,8 @@ static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
+extern int scsi_host_block(struct Scsi_Host *shost);
+extern int scsi_host_unblock(struct Scsi_Host *shost, int new_state);
 
 struct class_container;
 
-- 
2.16.4

