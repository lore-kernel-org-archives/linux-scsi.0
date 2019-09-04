Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD95FC3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 16:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFC3A2339D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 16:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbfIDQES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:04:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:44109 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731874AbfIDQER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 12:04:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 09:04:17 -0700
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="334258110"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 09:04:14 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id B0A0F202A8;
        Wed,  4 Sep 2019 19:04:11 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.92)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1i5Xlf-000113-Au; Wed, 04 Sep 2019 19:04:23 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        rafael@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 1/1] scsi: lpfc: Convert existing %pf users to %ps
Date:   Wed,  4 Sep 2019 19:04:23 +0300
Message-Id: <20190904160423.3865-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the remaining %pf users to %ps to prepare for the removal of the
old %pf conversion specifier support.

Fixes: 323506644972 ("scsi: lpfc: Migrate to %px and %pf in kernel print calls")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e7463d561f305..749286acdc173 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6051,7 +6051,7 @@ __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (filter(ndlp, param)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-					 "3185 FIND node filter %pf DID "
+					 "3185 FIND node filter %ps DID "
 					 "ndlp x%px did x%x flg x%x st x%x "
 					 "xri x%x type x%x rpi x%x\n",
 					 filter, ndlp, ndlp->nlp_DID,
@@ -6062,7 +6062,7 @@ __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 		}
 	}
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-			 "3186 FIND node filter %pf NOT FOUND.\n", filter);
+			 "3186 FIND node filter %ps NOT FOUND.\n", filter);
 	return NULL;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bb5705267c395..2ff0879a95126 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2712,7 +2712,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 
 		/* Mailbox cmd <cmd> Cmpl <cmpl> */
 		lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-				"(%d):0307 Mailbox cmd x%x (x%x/x%x) Cmpl %pf "
+				"(%d):0307 Mailbox cmd x%x (x%x/x%x) Cmpl %ps "
 				"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x "
 				"x%x x%x x%x\n",
 				pmb->vport ? pmb->vport->vpi : 0,
-- 
2.20.1

