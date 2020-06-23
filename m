Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7D2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 08:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B302520720
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 08:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="I+KDXaHk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgFWImD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 04:42:03 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:31545 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731732AbgFWImC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 04:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592901722; x=1624437722;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=3qBFEw3x0r6bNqV2zJ7slaRDovv3TN5c1Z3S4iPJbGE=;
  b=I+KDXaHk8qzmM4YWLnmosg66/u+ecDEJi/vAahish6q+iirMaBG6Tmv5
   JGtu8F0ZWS0Ce59LbdQMfAbkHVW9MwoJfGXGTQ3kKZNEtBm8MXbYGzjd+
   +tHbRbU1RrISaA0aYu2t+AjJdfLMfE3S+YkPEQfHqy7hD860plWttsfKF
   8=;
IronPort-SDR: Uv0Wpq3QHiYDL0enQytvGY72Cv4qYs5ky+tluqLYQgCSLdCvjBeExqQt7PKw2WJXdaQgPDgDYM
 Llcx/+QowVHQ==
X-IronPort-AV: E=Sophos;i="5.75,270,1589241600"; 
   d="scan'208";a="39247947"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Jun 2020 08:42:00 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id B619BA1DCA;
        Tue, 23 Jun 2020 08:41:58 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 23 Jun 2020 08:41:57 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.48) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 23 Jun 2020 08:41:48 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <james.smart@broadcom.com>, <jsmart2021@gmail.com>,
        <dick.kennedy@broadcom.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH] scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()
Date:   Tue, 23 Jun 2020 10:41:22 +0200
Message-ID: <20200623084122.30633-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D24UWB002.ant.amazon.com (10.43.161.159) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Commit cdb42becdd40 ("scsi: lpfc: Replace io_channels for nvme and fcp
with general hdw_queues per cpu") has introduced static checker warnings
for potential null dereferences in 'lpfc_sli4_hba_unset()' and
commit 1ffdd2c0440d ("scsi: lpfc: resolve static checker warning in
lpfc_sli4_hba_unset") has tried to fix it.  However, yet another
potential null dereference is remaining.  This commit fixes it.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 1ffdd2c0440d ("scsi: lpfc: resolve static checker warning inlpfc_sli4_hba_unset")
Fixes: cdb42becdd40 ("scsi: lpfc: Replace io_channels for nvme and fcp with general hdw_queues per cpu")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 69a5249e007a..6637f84a3d1b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11878,7 +11878,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	lpfc_sli4_xri_exchange_busy_wait(phba);
 
 	/* per-phba callback de-registration for hotplug event */
-	lpfc_cpuhp_remove(phba);
+	if (phba->pport)
+		lpfc_cpuhp_remove(phba);
 
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
-- 
2.17.1

