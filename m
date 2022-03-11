Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6575CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Mar 2022 18:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346302AbiCKSpo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Mar 2022 13:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiCKSpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2022 13:45:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 231E31168FD
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2022 10:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647024279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pZ8W+kqP3rM1aeyvVoZIfwssauxiRK0wpWLZ1D8Sr1o=;
        b=ZrnErbBAwdKx6TVCGEvtLaQb708pxRFpowsLpeLqs1VWnfVFkTPqd7bMQlRNYIYfbqSkMA
        NBsRl/J2k9RABNtJ4Ebjppqvkq16nBEbXP0uvi5OS2LopvGhffQy7/t/NHY1bsQnTvjzFH
        lhWdGpjnQOffYJp/Jq2Qg7LjDYR8CBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-V3z_Gpo1Oy6rmDmGkshopA-1; Fri, 11 Mar 2022 13:44:36 -0500
X-MC-Unique: V3z_Gpo1Oy6rmDmGkshopA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 007AAFC80;
        Fri, 11 Mar 2022 18:44:35 +0000 (UTC)
Received: from gluttony.redhat.com (unknown [10.22.19.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59D5B848DD;
        Fri, 11 Mar 2022 18:44:34 +0000 (UTC)
From:   David Jeffery <djeffery@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Laurence Oberman <loberman@redhat.com>,
        John Pittman <jpittman@redhat.com>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH] fnic: finish scsi_cmnd before dropping the spinlock to prevent abort race
Date:   Fri, 11 Mar 2022 13:43:59 -0500
Message-Id: <20220311184359.2345319-1-djeffery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When aborting a scsi command through fnic, there is a race with the fnic
interrupt handler which can result in the scsi command and its request
being completed twice. If the interrupt handler claims the command by
setting CMD_SP to NULL first, the abort handler assumes the interrupt
handler has completed the command and returns SUCCESS, causing the request
for the scsi_cmnd to be re-queued.

But the interrupt handler may not have finished the command yet. After it
drops the spinlock protecting CMD_SP, it does memory cleanup before
finally calling scsi_done to complete the scsi_cmnd. If the call to
scsi_done occurs after the abort handler finishes and re-queues the
request, the completion of the scsi_cmnd will advance and try to double
complete a request already queued for retry.

This patch fixes the issue by moving scsi_done and any other use of
scsi_cmnd to before the spinlock is released by the interrupt handler.

Signed-off-by: David Jeffery <djeffery@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 88c549f257db..40a52feb315d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -986,8 +986,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	CMD_SP(sc) = NULL;
 	CMD_FLAGS(sc) |= FNIC_IO_DONE;
 
-	spin_unlock_irqrestore(io_lock, flags);
-
 	if (hdr_status != FCPIO_SUCCESS) {
 		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
@@ -996,8 +994,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 
-	mempool_free(io_req, fnic->io_req_pool);
-
 	cmd_trace = ((u64)hdr_status << 56) |
 		  (u64)icmnd_cmpl->scsi_status << 48 |
 		  (u64)icmnd_cmpl->flags << 40 | (u64)sc->cmnd[0] << 32 |
@@ -1021,6 +1017,12 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	} else
 		fnic->lport->host_stats.fcp_control_requests++;
 
+	/* Call SCSI completion function to complete the IO */
+	scsi_done(sc);
+	spin_unlock_irqrestore(io_lock, flags);
+
+	mempool_free(io_req, fnic->io_req_pool);
+
 	atomic64_dec(&fnic_stats->io_stats.active_ios);
 	if (atomic64_read(&fnic->io_cmpl_skip))
 		atomic64_dec(&fnic->io_cmpl_skip);
@@ -1049,9 +1051,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		if(io_duration_time > atomic64_read(&fnic_stats->io_stats.current_max_io_time))
 			atomic64_set(&fnic_stats->io_stats.current_max_io_time, io_duration_time);
 	}
-
-	/* Call SCSI completion function to complete the IO */
-	scsi_done(sc);
 }
 
 /* fnic_fcpio_itmf_cmpl_handler
-- 
2.31.1

