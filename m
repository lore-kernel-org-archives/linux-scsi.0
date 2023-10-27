Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686AAC25B47
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 18:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346209AbjJ0SDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Oct 2023 14:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjJ0SDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Oct 2023 14:03:32 -0400
Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C216F4;
        Fri, 27 Oct 2023 11:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2502; q=dns/txt; s=iport;
  t=1698429810; x=1699639410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=slFAmSPvNAgschnNw3qQmhrZbli7ashLCnTbqYkfOek=;
  b=IhqegN0O8F21QqN/5/KYTRvkzVgJ6nFqOLbepNCQ2BlyGly85Yd65+0/
   l3/fJ1WtXwMkvgEnQmZ57KolRz09MWtX0+OOo0wful5Ae7TCprC5dM3Lr
   0nu5jOtMCWc3RiBlRHelz2cqABnxZJl+gsWGk8P2DsQc9MLimpBXMJOPK
   g=;
X-CSE-ConnectionGUID: g5mnZOM3QESImaYNOt+F7g==
X-CSE-MsgGUID: +H+3OqtuS5egXBBZ9ZLWvA==
X-IronPort-AV: E=Sophos;i="6.03,256,1694736000"; 
   d="scan'208";a="181456396"
Received: from rcdn-core-11.cisco.com ([173.37.93.147])
  by alln-iport-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 18:03:28 +0000
Received: from localhost.cisco.com ([10.193.101.253])
        (authenticated bits=0)
        by rcdn-core-11.cisco.com (8.15.2/8.15.2) with ESMTPSA id 39RI39Oe029226
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 27 Oct 2023 18:03:27 GMT
From:   Karan Tilak Kumar <kartilak@cisco.com>
To:     sebaddel@cisco.com
Cc:     arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
        mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 02/13] scsi: fnic: Add and use fnic number
Date:   Fri, 27 Oct 2023 11:02:51 -0700
Message-Id: <20231027180302.418676-3-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231027180302.418676-1-kartilak@cisco.com>
References: <20231027180302.418676-1-kartilak@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-11.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add fnic_num in fnic.h to identify fnic in a multi-fnic environment.
Increment and set the fnic number during driver load in fnic_probe.
Replace the host number with fnic number in debugfs.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h         | 1 +
 drivers/scsi/fnic/fnic_debugfs.c | 2 +-
 drivers/scsi/fnic/fnic_main.c    | 6 +++++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 93c68931a593..c6c549c633b1 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -216,6 +216,7 @@ struct fnic_event {
 
 /* Per-instance private data structure */
 struct fnic {
+	int fnic_num;
 	struct fc_lport *lport;
 	struct fcoe_ctlr ctlr;		/* FIP FCoE controller structure */
 	struct vnic_dev_bar bar0;
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index c4d9ed0d7d75..fac617672868 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -676,7 +676,7 @@ void fnic_stats_debugfs_init(struct fnic *fnic)
 {
 	char name[16];
 
-	snprintf(name, sizeof(name), "host%d", fnic->lport->host->host_no);
+	snprintf(name, sizeof(name), "fnic%d", fnic->fnic_num);
 
 	fnic->fnic_stats_debugfs_host = debugfs_create_dir(name,
 						fnic_stats_debugfs_root);
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 984bc5fc55e2..ea7b1ba27ac7 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -84,6 +84,9 @@ static struct libfc_function_template fnic_transport_template = {
 	.exch_mgr_reset = fnic_exch_mgr_reset
 };
 
+
+atomic_t fnic_num;
+
 static int fnic_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
@@ -587,6 +590,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i;
 	unsigned long flags;
 
+	atomic_inc(&fnic_num);
 	/*
 	 * Allocate SCSI Host and set up association between host,
 	 * local port, and fnic
@@ -608,7 +612,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 host->host_no);
 
 	host->transportt = fnic_fc_transport;
-
+	fnic->fnic_num = atomic_read(&fnic_num);
 	fnic_stats_debugfs_init(fnic);
 
 	/* Setup PCI resources */
-- 
2.31.1

