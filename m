From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/17] libfcoe: update FIP FCF D flag from advertisments
Date: Fri, 11 Jun 2010 16:44:20 -0700
Message-ID: <20100611234420.4616.45946.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab0FKXoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:21 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Allow the D flag (indicating that keep-alives are not needed) to
be updated dynamically from received FIP advertisements.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 4893098..27c21ca 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -769,18 +769,21 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		list_add(&fcf->list, &fip->fcfs);
 	} else {
 		/*
-		 * Flags in advertisements are ignored once the FCF is
-		 * selected.  Flags in unsolicited advertisements are
-		 * ignored after a usable solicited advertisement
-		 * has been received.
+		 * Update the FCF's keep-alive descriptor flags.
+		 * Other flag changes from new advertisements are
+		 * ignored after a solicited advertisement is
+		 * received and the FCF is selectable (usable).
 		 */
+		fcf->fd_flags = new.fd_flags;
+		if (!fcoe_ctlr_fcf_usable(fcf))
+			fcf->flags = new.flags;
+
 		if (fcf == fip->sel_fcf && !fcf->fd_flags) {
 			fip->ctlr_ka_time -= fcf->fka_period;
 			fip->ctlr_ka_time += new.fka_period;
 			if (time_before(fip->ctlr_ka_time, fip->timer.expires))
 				mod_timer(&fip->timer, fip->ctlr_ka_time);
-		} else if (!fcoe_ctlr_fcf_usable(fcf))
-			fcf->flags = new.flags;
+		}
 		fcf->fka_period = new.fka_period;
 		memcpy(fcf->fcf_mac, new.fcf_mac, ETH_ALEN);
 	}

