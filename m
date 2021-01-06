Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7BDC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD52622EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbhAGEwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:52:31 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:51650 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbhAGEwa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:52:30 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id F15E6361CF;
        Wed,  6 Jan 2021 20:41:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com F15E6361CF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609994518;
        bh=9RuP5spFKKno6uhK1unb7O2ud4u73mH2nyMtQPaiNW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5M/Hsg3/mpLMTEm+LfLBF8BteXnOtLyQ7jeCybN9K1N8mDte0Au8V4yvrJFT1gqe
         Vfu6vppeWlWK21FMU755KPWYeLkgC4fNDdDKNC3b8nRX/x3tVt3f3dn3OD7+s/HsXb
         KJTY3tfYeIIYqsvB8RbVPAfpckFyShQIWWYxUmOI=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v8 1/5] scsi: Added a new error code DID_TRANSPORT_MARGINAL in scsi.h
Date:   Thu,  7 Jan 2021 03:19:04 +0530
Message-Id: <1609969748-17684-2-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
errors in scsi.h

Added a code in scsi_result_to_blk_status to translate
a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
i.e BLK_STS_TRANSPORT

Added DID_TRANSPORT_MARGINAL case to scsi_decide_disposition

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v8:
Rebased the patches on top of 5.11-rc2

v7:
Rearranged the patch by moving the DID_TRANSPORT_MARGINAL
and the changes with respect to the same to this patch
from the previous patch2 in v6

Removed the previuos patch patch1 in v6 as in the
current approach there is no need of this bit SCMD_NORETRIES_ABORT

v6:
Rearranged the patch by merging second hunk of the patch2 in v5
to this patch

v5:
added the DID_TRANSPORT_MARGINAL case to
scsi_decide_disposition
v4:
Modified the comments in the code appropriately

v3:
Merged  first part of the previous patch(v2 patch3) with
this patch.

v2:
set the hostbyte as DID_TRANSPORT_MARGINAL instead of
DID_TRANSPORT_FAILFAST.
---
 drivers/scsi/scsi_error.c | 6 ++++++
 drivers/scsi/scsi_lib.c   | 1 +
 include/scsi/scsi.h       | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f11f51e2465f..28056ee498b3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1861,6 +1861,12 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * the fast io fail tmo fired), so send IO directly upwards.
 		 */
 		return SUCCESS;
+	case DID_TRANSPORT_MARGINAL:
+		/*
+		 * caller has decided not to do retries on
+		 * abort success, so send IO directly upwards
+		 */
+		return SUCCESS;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
 		    status_byte(scmd->result) == RESERVATION_CONFLICT)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b3f14f05340a..d0ae586565f8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -630,6 +630,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 			return BLK_STS_OK;
 		return BLK_STS_IOERR;
 	case DID_TRANSPORT_FAILFAST:
+	case DID_TRANSPORT_MARGINAL:
 		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
 		set_host_byte(cmd, DID_OK);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5339baadc082..5b287ad8b727 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
 				 * paths might yield different results */
 #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
 #define DID_MEDIUM_ERROR  0x13  /* Medium error */
+#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
-- 
2.26.2

