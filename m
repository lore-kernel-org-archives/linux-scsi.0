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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A2FC5519F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 01:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B2D42237B
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 01:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="A+ElR4Dh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgKUBvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 20:51:46 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:43603 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgKUBvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 20:51:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1530; q=dns/txt; s=iport;
  t=1605923505; x=1607133105;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6JVOBhH2ePfV/T11DuvXMi6/3HLBKamql7U40L3mheg=;
  b=A+ElR4Dh7R09rt2PuR2pC5AkzQKdA2ArElxFOOq3sJ06ypQwIqEH0wcP
   KVmerdg3Rrvk/STj7UcRBrw0EmJY4g3SElVT7pRC2l1sL/mE93aC9+81s
   sJ/b67DqTfVLe2c1+VJ+VLfCVWEBHgX0s2Xn3sOn2amQ46+F+C0N3d6if
   8=;
X-IronPort-AV: E=Sophos;i="5.78,357,1599523200"; 
   d="scan'208";a="588614504"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Nov 2020 01:51:44 +0000
Received: from localhost.cisco.com ([10.193.101.253])
        (authenticated bits=0)
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0AL1paVi022858
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 21 Nov 2020 01:51:44 GMT
From:   Karan Tilak Kumar <kartilak@cisco.com>
To:     satishkh@cisco.com
Cc:     sebaddel@cisco.com, arulponn@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: set scsi_set_resid only for underflow
Date:   Fri, 20 Nov 2020 17:51:34 -0800
Message-Id: <20201121015134.18872-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-11.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix to set scsi_set_resid() only if
FCPIO_ICMND_CMPL_RESID_UNDER is set.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 2 +-
 drivers/scsi/fnic/fnic_scsi.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 7c5c911b2673..e4d399f41a0a 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.51"
+#define DRV_VERSION		"1.6.0.52"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 16e66f5b833a..532c3c7ae372 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -921,10 +921,11 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	case FCPIO_SUCCESS:
 		sc->result = (DID_OK << 16) | icmnd_cmpl->scsi_status;
 		xfer_len = scsi_bufflen(sc);
-		scsi_set_resid(sc, icmnd_cmpl->residual);
 
-		if (icmnd_cmpl->flags & FCPIO_ICMND_CMPL_RESID_UNDER)
+		if (icmnd_cmpl->flags & FCPIO_ICMND_CMPL_RESID_UNDER) {
 			xfer_len -= icmnd_cmpl->residual;
+			scsi_set_resid(sc, icmnd_cmpl->residual);
+		}
 
 		if (icmnd_cmpl->scsi_status == SAM_STAT_CHECK_CONDITION)
 			atomic64_inc(&fnic_stats->misc_stats.check_condition);
-- 
2.29.2

