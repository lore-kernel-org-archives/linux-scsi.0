Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D1FC8300D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE6E72076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgD3NU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:60748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbgD3NUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1F158AFA0;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 35/41] libsas: add SCSI target pointer to struct domain_device
Date:   Thu, 30 Apr 2020 15:18:58 +0200
Message-Id: <20200430131904.5847-36-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a pointer to the SCSI target which corresponds to the
domain device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libsas/sas_scsi_host.c | 2 ++
 include/scsi/libsas.h               | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9e0975e55c27..c5a430e3fa2d 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -830,6 +830,7 @@ int sas_target_alloc(struct scsi_target *starget)
 
 	kref_get(&found_dev->kref);
 	starget->hostdata = found_dev;
+	found_dev->starget = starget;
 	return 0;
 }
 
@@ -919,6 +920,7 @@ void sas_target_destroy(struct scsi_target *starget)
 		return;
 
 	starget->hostdata = NULL;
+	found_dev->starget = NULL;
 	sas_put_device(found_dev);
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4e2d61e8fb1e..2d9bc4882930 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -175,6 +175,7 @@ struct domain_device {
 
 	struct domain_device *parent;
 	struct list_head siblings; /* devices on the same level */
+	struct scsi_target *starget; /* Corresponding SCSI target device */
 	struct asd_sas_port *port;        /* shortcut to root of the tree */
 	struct sas_phy *phy;
 
-- 
2.16.4

