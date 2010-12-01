From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 25/27] libfcoe: reorder FCF list to put latest advertiser first
Date: Tue, 30 Nov 2010 16:20:07 -0800
Message-ID: <20101201002007.18369.33898.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0LAAUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:20:08 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When there are several FCFs to choose from, the one most likely
to accept a FLOGI on certian switches is the one that last
answered a multicast solicit.

So, when receiving an advertisement, move the FCF to the front
of the list so that it gets chosen first among those with the
same priority.

Without this, more FLOGIs need to be sent in a test with
multiple FCFs and a switch in NPV mode, but it still
eventually finds one that accepts the FLOGI.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index dcccb0b..1a0bb23 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1000,6 +1000,17 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		fcoe_ctlr_solicit(fip, NULL);
 
 	/*
+	 * Put this FCF at the head of the list for priority among equals.
+	 * This helps in the case of an NPV switch which insists we use
+	 * the FCF that answers multicast solicitations, not the others that
+	 * are sending periodic multicast advertisements.
+	 */
+	if (mtu_valid) {
+		list_del(&fcf->list);
+		list_add(&fcf->list, &fip->fcfs);
+	}
+
+	/*
 	 * If this is the first validated FCF, note the time and
 	 * set a timer to trigger selection.
 	 */

