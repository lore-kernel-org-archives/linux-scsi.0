Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D5BC2BA83
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 561AA2073C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgBMOF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:05:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:46242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbgBMOF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 09:05:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71FD7AFA5;
        Thu, 13 Feb 2020 14:05:27 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/13] scsi: add scsi_host_(block,unblock) helper function
Date:   Thu, 13 Feb 2020 15:04:17 +0100
Message-Id: <20200213140422.128382-9-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213140422.128382-1-hare@suse.de>
References: <20200213140422.128382-1-hare@suse.de>
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
index 610ee41fa54c..a48a5727831b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2845,6 +2845,36 @@ scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
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
index d11a0a030dd3..a230e2c0e11f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -757,6 +757,8 @@ static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
+extern int scsi_host_block(struct Scsi_Host *shost);
+extern int scsi_host_unblock(struct Scsi_Host *shost, int new_state);
 
 struct class_container;
 
-- 
2.16.4

