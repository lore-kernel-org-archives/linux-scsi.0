Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476B2C5519F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 01:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E77B5221FB
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 01:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="RTnh2hGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgKUBV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 20:21:56 -0500
Received: from alln-iport-7.cisco.com ([173.37.142.94]:12811 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKUBV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 20:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2935; q=dns/txt; s=iport;
  t=1605921715; x=1607131315;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yWUUKHQpzyASWYo7Onuii2fFtI78cOmASNBgI0K+rpc=;
  b=RTnh2hGsYhzN16WJ/I0Fe/zzt0C/ZypNrnfTRYXf+3K949gEShLo17Q6
   LpbZsqZsRE6zKkZScAts5BpvW6bUII9fgGYITdiDGKPAD64HrAucVajT7
   h5W5G9WK4+35iLh30l42/r/1rP+K0iy4Nl1Q/nFpGWiiuVzIZoyLRVOdf
   I=;
X-IronPort-AV: E=Sophos;i="5.78,357,1599523200"; 
   d="scan'208";a="595939854"
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Nov 2020 01:21:55 +0000
Received: from localhost.cisco.com ([10.193.101.253])
        (authenticated bits=0)
        by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0AL1Lndl029473
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 21 Nov 2020 01:21:54 GMT
From:   Karan Tilak Kumar <kartilak@cisco.com>
To:     satishkh@cisco.com
Cc:     sebaddel@cisco.com, arulponn@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Avoid looping in TRANS ETH on unload
Date:   Fri, 20 Nov 2020 17:21:45 -0800
Message-Id: <20201121012145.18522-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-6.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This change is to avoid looping in
fnic_scsi_abort_io before sending fw reset when
fnic is in TRANS ETH state and when we have not
received any link events.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 3 ++-
 drivers/scsi/fnic/fnic_fcs.c  | 2 ++
 drivers/scsi/fnic/fnic_main.c | 2 ++
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index ed00b6061e0c..6dc8c916de31 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.49"
+#define DRV_VERSION		"1.6.0.50"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
@@ -245,6 +245,7 @@ struct fnic {
 	u32 vlan_hw_insert:1;	        /* let hw insert the tag */
 	u32 in_remove:1;                /* fnic device in removal */
 	u32 stop_rx_link_events:1;      /* stop proc. rx frames, link events */
+	u32 link_events:1;              /* set when we get any link event*/
 
 	struct completion *remove_wait; /* device remove thread blocks */
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 3fc3a7271dc1..3337d6627baf 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -56,6 +56,8 @@ void fnic_handle_link(struct work_struct *work)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
+	fnic->link_events = 1;      /* less work to just set everytime*/
+
 	if (fnic->stop_rx_link_events) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f8a7ef8f6a8..cad29679e90e 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -580,6 +580,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic->lport = lp;
 	fnic->ctlr.lp = lp;
 
+	fnic->link_events = 0;
+
 	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
 		 host->host_no);
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d1f7b84bbfe8..16e66f5b833a 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2673,7 +2673,8 @@ void fnic_scsi_abort_io(struct fc_lport *lp)
 	/* Issue firmware reset for fnic, wait for reset to complete */
 retry_fw_reset:
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
+	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) &&
+		     fnic->link_events) {
 		/* fw reset is in progress, poll for its completion */
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		schedule_timeout(msecs_to_jiffies(100));
-- 
2.29.2

