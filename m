Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFF1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D3D622EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbhAGExc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:53:32 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:51864 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbhAGExb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:53:31 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 8032882D07;
        Wed,  6 Jan 2021 20:42:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 8032882D07
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609994521;
        bh=AO9NnBejFbaipBaOEMk/5lzpqEdVH+lFgQomZ5z7AHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlLRZs8yg/D7rtB6RWYW8FQOGkL2WVCJxpVbGTp4ZdJhnB9LG3wrGnl1hg5tqgMCF
         YAGmxAQ31+LcLc/ZXW/9aCINRPDyATpzGcV/35B8Xs/tGgqwWd3c45Atu4nqTS2L8G
         gsVhrVP++ZzwvHsU0uvmTk6m3MvsleP7cW9D5Avg=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v8 5/5] scsi:lpfc: Added support for eh_should_retry_cmd
Date:   Thu,  7 Jan 2021 03:19:08 +0530
Message-Id: <1609969748-17684-6-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added support to handle eh_should_retry_cmd in lpfc_template.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v8:
Rebased the patches on top of 5.11-rc2

v7:
New patch
---
 drivers/scsi/lpfc/lpfc_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3b989f720937..09812e72a265 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6662,6 +6662,7 @@ struct scsi_host_template lpfc_template = {
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_timed_out		= fc_eh_timed_out,
+	.eh_should_retry_cmd    = fc_eh_should_retry_cmd,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-- 
2.26.2

