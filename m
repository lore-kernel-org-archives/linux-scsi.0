From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/17] libfcoe: No solicitation if adv is dropped
Date: Fri, 11 Jun 2010 16:43:44 -0700
Message-ID: <20100611234344.4616.61068.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21711 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab0FKXnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:43:47 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Host does not send discovery solicitation messages if Disc. Adv
from FCF are dropped. It restarts sending solicitation only
after receiving a Discovery Adv. from FCF. Fix is to restart
solicitation immediately after CVL processing.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 66120f1..1d5b949 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1232,8 +1232,11 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 	fip->reset_req = 0;
 	spin_unlock_bh(&fip->lock);
 
-	if (reset)
+	if (reset) {
 		fc_lport_reset(fip->lp);
+		/* restart things with a solicitation */
+		fcoe_ctlr_solicit(fip, NULL);
+	}
 
 	if (fip->send_ctlr_ka) {
 		fip->send_ctlr_ka = 0;

