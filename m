From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] vmw_pvscsi: return SUCCESS for successful command aborts
Date: Fri, 28 Oct 2016 12:27:26 -0400
Message-ID: <20161028162726.GA1270@rage>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030370AbcJ1Q12 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 12:27:28 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25DA88FCF5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 16:27:28 +0000 (UTC)
Received: from rage (vpn-49-37.rdu2.redhat.com [10.10.49.37])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9SGRQQV028789
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 12:27:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The vmw_pvscsi driver reports most successful aborts as FAILED to the scsi
error handler.  This is do to a misunderstanding of how completion_done() works
and its interaction with a successful wait using wait_for_completion_timeout().
The vmw_pvscsi driver is expecting completion_done() to always return true if
complete() has been called on the completion structure.  But completion_done()
returns true after complete() has been called only if no function like
wait_for_completion_timeout() has seen the completion and cleared it as part of
successfully waiting for the completion.

Instead of using completion_done(), vmw_pvscsi should just use the return
value from wait_for_completion_timeout() to know if the wait timed out or not.

Signed-off-by: David Jeffery <djeffery@redhat.com>

---
 vmw_pvscsi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -793,6 +793,7 @@ static int pvscsi_abort(struct scsi_cmnd
 	unsigned long flags;
 	int result = SUCCESS;
 	DECLARE_COMPLETION_ONSTACK(abort_cmp);
+	int done;
 
 	scmd_printk(KERN_DEBUG, cmd, "task abort on host %u, %p\n",
 		    adapter->host->host_no, cmd);
@@ -824,10 +825,10 @@ static int pvscsi_abort(struct scsi_cmnd
 	pvscsi_abort_cmd(adapter, ctx);
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
 	/* Wait for 2 secs for the completion. */
-	wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
+	done = wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
-	if (!completion_done(&abort_cmp)) {
+	if (!done) {
 		/*
 		 * Failed to abort the command, unmark the fact that it
 		 * was requested to be aborted.
