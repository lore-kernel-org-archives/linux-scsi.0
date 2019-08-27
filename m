Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8290BC3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 404A620828
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="PrihlO43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbfH0VT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 17:19:56 -0400
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:39518 "EHLO
        rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0VT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 17:19:56 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2019 17:19:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1244; q=dns/txt; s=iport;
  t=1566940795; x=1568150395;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ctQoQRPIDAnumzvZIxcHe/wDmcyljwj9W3MoQzgkDsA=;
  b=PrihlO43/56a/WZ0UnSNGFvGb91aHhea01SqyQ1jqcqZll6OG0+r3dFu
   Vj7ht2SLvQBRYDRHMsSc3213OyAj9Y7jqmLJScBxMW44KXaWQGCKSzNNb
   TZBRxmU9Eih2PjGuhRjrMlqDdqd7gbP/yb65Y+T01y2No/TSk06Af8a1O
   4=;
X-IronPort-AV: E=Sophos;i="5.64,438,1559520000"; 
   d="scan'208";a="620082385"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Aug 2019 21:12:51 +0000
Received: from cisco.cisco.com ([10.157.132.113])
        (authenticated bits=0)
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPSA id x7RLCki6005712
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 27 Aug 2019 21:12:51 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Satish Kharat <satishkh@cisco.com>
Subject: [PATCH] scsi: fnic: fix msix interrupt allocation
Date:   Tue, 27 Aug 2019 14:13:40 -0700
Message-Id: <20190827211340.1095-1-gvaradar@cisco.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.157.132.113, [10.157.132.113]
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pci_alloc_irq_vectors() returns number of vectors allocated.
Fix the check for error condition.

Fixes: cca678dfbad49 ("scsi: fnic: switch to pci_alloc_irq_vectors")
Acked-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
---
 drivers/scsi/fnic/fnic_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index da4602b63495..2fb2731f50fb 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -254,7 +254,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		int vecs = n + m + o + 1;
 
 		if (pci_alloc_irq_vectors(fnic->pdev, vecs, vecs,
-				PCI_IRQ_MSIX) < 0) {
+				PCI_IRQ_MSIX) == vecs) {
 			fnic->rq_count = n;
 			fnic->raw_wq_count = m;
 			fnic->wq_copy_count = o;
@@ -280,7 +280,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	    fnic->wq_copy_count >= 1 &&
 	    fnic->cq_count >= 3 &&
 	    fnic->intr_count >= 1 &&
-	    pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) < 0) {
+	    pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) == 1) {
 		fnic->rq_count = 1;
 		fnic->raw_wq_count = 1;
 		fnic->wq_copy_count = 1;
-- 
2.21.0

