Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CB0C43141
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D66D2243F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfKTKb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:31:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:49212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728251AbfKTKb2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 05:31:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FD0CB234;
        Wed, 20 Nov 2019 10:31:26 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/11] scsi: add scsi_host_quiesce()/scsi_host_resume() helper
Date:   Wed, 20 Nov 2019 11:31:10 +0100
Message-Id: <20191120103114.24723-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191120103114.24723-1-hare@suse.de>
References: <20191120103114.24723-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helper functions for quiescing/resuming all devices on a
given scsi host.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 18 ++++++++++++++++++
 include/scsi/scsi_device.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2563b061f56b..771a8352d3e8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2630,6 +2630,24 @@ scsi_target_resume(struct scsi_target *starget)
 }
 EXPORT_SYMBOL(scsi_target_resume);
 
+void scsi_host_quiesce(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost)
+		scsi_device_quiesce(sdev);
+}
+EXPORT_SYMBOL(scsi_host_quiesce);
+
+void scsi_host_resume(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost)
+		scsi_device_resume(sdev);
+}
+EXPORT_SYMBOL(scsi_host_resume);
+
 /**
  * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
  * @sdev: device to block
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3ed836db5306..2185068ce955 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -420,6 +420,8 @@ extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
+extern void scsi_host_quiesce(struct Scsi_Host *);
+extern void scsi_host_resume(struct Scsi_Host *);
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
 			     unsigned int id, u64 lun,
 			     enum scsi_scan_mode rescan);
-- 
2.16.4

