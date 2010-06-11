From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/17] libfcoe: Use fka_period as periodic timeouts to age out
	fcf if
Date: Fri, 11 Jun 2010 16:44:15 -0700
Message-ID: <20100611234415.4616.60175.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58175 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab0FKXoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:16 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Vasu Dev <vasu.dev@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

keep alives are disabled due to fd_flags set and also
stop updating keep alive values in that case.

Update select fcf time only if fcf is not already selected or
select time is not already determined from parse adv, and then
have select time cleared only once after fcf is selected.

Changed deadline check to time_after_eq() from time_after()
since now next timeout will be on exact 2.5 times FKA followed
by first advertisement.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 3ab3db3..4893098 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -594,7 +594,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 		}
 
 		deadline += fcf->fka_period;
-		if (time_after(jiffies, deadline)) {
+		if (time_after_eq(jiffies, deadline)) {
 			if (fip->sel_fcf == fcf)
 				fip->sel_fcf = NULL;
 			list_del(&fcf->list);
@@ -612,12 +612,11 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 				sel_time = fcf->time;
 		}
 	}
-	if (sel_time) {
+	if (sel_time && !fip->sel_fcf && !fip->sel_time) {
 		sel_time += msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		fip->sel_time = sel_time;
-	} else {
-		fip->sel_time = 0;
 	}
+
 	return next_timer;
 }
 
@@ -775,7 +774,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		 * ignored after a usable solicited advertisement
 		 * has been received.
 		 */
-		if (fcf == fip->sel_fcf) {
+		if (fcf == fip->sel_fcf && !fcf->fd_flags) {
 			fip->ctlr_ka_time -= fcf->fka_period;
 			fip->ctlr_ka_time += new.fka_period;
 			if (time_before(fip->ctlr_ka_time, fip->timer.expires))
@@ -813,7 +812,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	 * If this is the first validated FCF, note the time and
 	 * set a timer to trigger selection.
 	 */
-	if (mtu_valid && !fip->sel_time && fcoe_ctlr_fcf_usable(fcf)) {
+	if (mtu_valid && !fip->sel_fcf && fcoe_ctlr_fcf_usable(fcf)) {
 		fip->sel_time = jiffies +
 			msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		if (!timer_pending(&fip->timer) ||
@@ -1187,6 +1186,8 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
 			fip->ctlr_ka_time = jiffies + sel->fka_period;
+			if (time_after(next_timer, fip->ctlr_ka_time))
+				next_timer = fip->ctlr_ka_time;
 		} else {
 			printk(KERN_NOTICE "libfcoe: host%d: "
 			       "FIP Fibre-Channel Forwarder timed out.	"

