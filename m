From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/16] libfc: fix sequence-initiative WARN in fc_seq_start_next
Date: Fri, 12 Mar 2010 16:08:29 -0800
Message-ID: <20100313000829.22251.55312.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAI3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:29 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When starting a new response sequence in a multi-sequence
exchange, a warning was issued that sequence initiative
wasn't held.

The bug was that sequence initiative was cleared by the previous
sequence due to the END_SEQ flag being on.  The intent may have
been to check LAST_SEQ.  Change just to check SEQ_INIT.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7f43647..1ad1ded 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -488,7 +488,7 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	 */
 	spin_lock_bh(&ep->ex_lock);
 	ep->f_ctl = f_ctl & ~FC_FC_FIRST_SEQ;	/* not first seq */
-	if (f_ctl & (FC_FC_END_SEQ | FC_FC_SEQ_INIT))
+	if (f_ctl & FC_FC_SEQ_INIT)
 		ep->esb_stat &= ~ESB_ST_SEQ_INIT;
 	spin_unlock_bh(&ep->ex_lock);
 	return error;

