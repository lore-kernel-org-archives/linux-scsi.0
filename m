Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DC8C4332B
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F21864E32
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhBVNbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:31:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:48666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231273AbhBVN2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 33416B013;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/31] libsas: add SCSI target pointer to struct domain_device
Date:   Mon, 22 Feb 2021 14:23:59 +0100
Message-Id: <20210222132405.91369-26-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 1bf939818c98..ae247aed857f 100644
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
index 9271d7a49b90..3a024eced38c 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -175,6 +175,7 @@ struct domain_device {
 
 	struct domain_device *parent;
 	struct list_head siblings; /* devices on the same level */
+	struct scsi_target *starget; /* Corresponding SCSI target device */
 	struct asd_sas_port *port;        /* shortcut to root of the tree */
 	struct sas_phy *phy;
 
-- 
2.29.2

