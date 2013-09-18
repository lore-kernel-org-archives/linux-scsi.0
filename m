From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/4] BNX2FC: Fixed a SCSI CMD cmpl race condition
 between ABTS and CLEANUP
Date: Tue, 17 Sep 2013 22:33:10 -0700
Message-ID: <1379482393-30515-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1605 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3IRFg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Sep 2013 01:36:28 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Robert Love <robert.w.love@intel.com>, fcoe-devel <fcoe-devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

In the case when a SCSI_CMD times out, bnx2fc will initiate the sending of the
ABTS.  However, if the SCSI layer's SCSI command timer also times out, it'll
instantiate a task abort of the same xid.

The race condition this patch tries to fix is as follows:

SCSI_CMD timeout (20s)
thread 1                   thread 2
send ABTS
rx ABTS cmpl
                           task abort_eh
                           explicit LOGO since ABTS was engaged
                           CLEANUP cmpl
SCSI_CMD cmpl (ABTS cmpl)
instantiate RRQ
wait 10s
attempt to send RRQ (because of LOGO, it wouldn't continue)

Note that there is no call to scsi_done for this SCSI_CMD cmpletion
in this path.

The patch changes the path of execution to call scsi_done immediately
instead of instantiating the RRQ.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 575142e..ed88089 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1246,6 +1246,12 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 			kref_put(&io_req->refcount,
 				 bnx2fc_cmd_release); /* drop timer hold */
 		rc = bnx2fc_expl_logo(lport, io_req);
+		/* This only occurs when an task abort was requested while ABTS
+		   is in progress.  Setting the IO_CLEANUP flag will skip the
+		   RRQ process in the case when the fw generated SCSI_CMD cmpl
+		   was a result from the ABTS request rather than the CLEANUP
+		   request */
+		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
 		goto out;
 	}
 
-- 
1.7.1


