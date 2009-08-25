From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 63/64] libfc: don't swap OX_ID and RX_ID when sending BA_RJT
Date: Tue, 25 Aug 2009 14:04:03 -0700
Message-ID: <20090825210403.1553.92556.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbZHYVEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:04:01 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

I saw an lport debug message from the exchange manager saying:
"lport  70500: Received response for out of range oxid:ffff"

A trace showed this was a BA_RJT sent due to an incoming ABTS
which arrived on an unknown exchange.  So, the sender of the
BA_RJT was in error, but in this case, both the initiator and
responder were the same machine.

The OX_ID and RX_ID should not have been reversed in this case.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index b51db15..c1c1574 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1017,8 +1017,8 @@ static void fc_exch_send_ba_rjt(struct fc_frame *rx_fp,
 	 */
 	memcpy(fh->fh_s_id, rx_fh->fh_d_id, 3);
 	memcpy(fh->fh_d_id, rx_fh->fh_s_id, 3);
-	fh->fh_ox_id = rx_fh->fh_rx_id;
-	fh->fh_rx_id = rx_fh->fh_ox_id;
+	fh->fh_ox_id = rx_fh->fh_ox_id;
+	fh->fh_rx_id = rx_fh->fh_rx_id;
 	fh->fh_seq_cnt = rx_fh->fh_seq_cnt;
 	fh->fh_r_ctl = FC_RCTL_BA_RJT;
 	fh->fh_type = FC_TYPE_BLS;

