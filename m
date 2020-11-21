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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A499C64E69
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 02:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2226822403
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 02:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="NBhm/llc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgKUCd5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 21:33:57 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:17934 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgKUCd4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 21:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1549; q=dns/txt; s=iport;
  t=1605926035; x=1607135635;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qrdrfc85GgzgnaPExtbGJgoy0KSfHxDba/cz8fzEu38=;
  b=NBhm/llcduG7e2aYCXda2xtJGX1B0ZLGfLF+1gtHBuMAoL5RfryE+4HM
   3300wVlKyV8ki5ZyrJTWRbk7h35OZlZBv1zJSuufT4TRtwXH51pQa/8D2
   wU0tXPcn+pNWk4p/4o7wIFE700gKPuv0DJXrE7eS1XmEQzDIS7r4QbJ4T
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,358,1599523200"; 
   d="scan'208";a="614725737"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Nov 2020 02:33:55 +0000
Received: from localhost.cisco.com ([10.193.101.253])
        (authenticated bits=0)
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0AL2Xlw6010143
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 21 Nov 2020 02:33:54 GMT
From:   Karan Tilak Kumar <kartilak@cisco.com>
To:     satishkh@cisco.com
Cc:     sebaddel@cisco.com, arulponn@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Validate io_req before others
Date:   Fri, 20 Nov 2020 18:33:37 -0800
Message-Id: <20201121023337.19295-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-8.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to check for a valid io_req before
we check other data. Also, removing
redundant checks.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 2 +-
 drivers/scsi/fnic/fnic_scsi.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index e4d399f41a0a..69f373b53132 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.52"
+#define DRV_VERSION		"1.6.0.53"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 532c3c7ae372..36744968378f 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1735,15 +1735,14 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 			continue;
 		}
 
-		cmd_rport = starget_to_rport(scsi_target(sc->device));
-		if (rport != cmd_rport) {
+		io_req = (struct fnic_io_req *)CMD_SP(sc);
+		if (!io_req) {
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
 
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
-
-		if (!io_req || rport != cmd_rport) {
+		cmd_rport = starget_to_rport(scsi_target(sc->device));
+		if (rport != cmd_rport) {
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
-- 
2.29.2

