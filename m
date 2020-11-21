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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1957EC2D0E4
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 01:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8EC223B0
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 01:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="P79zHEX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgKUBiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 20:38:18 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:4404 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKUBiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 20:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1356; q=dns/txt; s=iport;
  t=1605922697; x=1607132297;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fTBJqajfaNvySCnBGJ7V+namORH6x1RqmP6eLIxV8GI=;
  b=P79zHEX6gC7EgvpiWZDkP37z6lAC0hwlUFrUJgA1bkxPPVetl87yrKsc
   Fi2edc4swIov0D0AAvcXx3r+DPDmsMXcbrzam9ILvRMcr6w1J/7gKSuFk
   PrdwY2czkUJdd80jswTI6cs+xMG8oB20fHqkgM8EBYFu8USaznof9Yiiv
   I=;
X-IronPort-AV: E=Sophos;i="5.78,357,1599523200"; 
   d="scan'208";a="614695986"
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Nov 2020 01:38:17 +0000
Received: from localhost.cisco.com ([10.193.101.253])
        (authenticated bits=0)
        by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0AL1c9uI001185
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 21 Nov 2020 01:38:16 GMT
From:   Karan Tilak Kumar <kartilak@cisco.com>
To:     satishkh@cisco.com
Cc:     sebaddel@cisco.com, arulponn@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Change shost_printk to FNIC_MAIN_DBG
Date:   Fri, 20 Nov 2020 17:37:39 -0800
Message-Id: <20201121013739.18701-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-3.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replacing shost_printk with FNIC_MAIN_DBG so that
these log messages are controlled by fnic_log_level
flag in fnic_handle_link.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h     | 2 +-
 drivers/scsi/fnic/fnic_fcs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 6dc8c916de31..7c5c911b2673 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.50"
+#define DRV_VERSION		"1.6.0.51"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 3337d6627baf..e0cee4dcb439 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -75,7 +75,7 @@ void fnic_handle_link(struct work_struct *work)
 	atomic64_set(&fnic->fnic_stats.misc_stats.current_port_speed,
 			new_port_speed);
 	if (old_port_speed != new_port_speed)
-		shost_printk(KERN_INFO, fnic->lport->host,
+		FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host,
 				"Current vnic speed set to :  %llu\n",
 				new_port_speed);
 
-- 
2.29.2

