From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/8] libfc: fix setting of rport dev loss
Date: Fri, 08 Oct 2010 17:12:10 -0700
Message-ID: <20101009001210.7744.83712.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:11 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There does not seem to be a reason why libfc adds a 5
second delay to the user requested value for the dev loss
tmo. There also does not seem to be a reason to allow
setting it to 0 (or really close).

This patch removes the extra 5 sec delay, and for 0 it
sets it to 1 like other fc drivers. We should actually
be able to set it to 0 since the queue_delayed_work API
will just call queue_work, but other drivers set it to 1 in
that case.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b9f2286..a84ef13 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -196,9 +196,9 @@ static const char *fc_rport_state(struct fc_rport_priv *rdata)
 void fc_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 {
 	if (timeout)
-		rport->dev_loss_tmo = timeout + 5;
+		rport->dev_loss_tmo = timeout;
 	else
-		rport->dev_loss_tmo = 30;
+		rport->dev_loss_tmo = 1;
 }
 EXPORT_SYMBOL(fc_set_rport_loss_tmo);
 

