From: David Milburn <dmilburn@redhat.com>
Subject: [RFC] aic7xxx - ahc_done check SCB_ACTIVE for tagged transactions
Date: Fri, 25 Jan 2008 12:16:18 -0600
Message-ID: <20080125181618.GB26158@dhcp-210.hsv.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYAYSXo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 13:23:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org

Hannes,

Does ahc_done need to check the SCB_ACTIVE flag only if the SCB
is not in the untagged queue before panic?

If the driver is in error recovery, you may end panic'ing
on a TUR that is in the untagged queue.

Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
SCB 3 done'd twice

This patch is included in Adaptec's 6.3.11 driver on their 
website.

Thank you,
David

--- scsi-misc-2.6.git/drivers/scsi/aic7xxx/aic7xxx_osm.c.abort
+++ scsi-misc-2.6.git/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1658,9 +1658,12 @@ ahc_done(struct ahc_softc *ahc, struct s
 		untagged_q = &(ahc->untagged_queues[target_offset]);
 		TAILQ_REMOVE(untagged_q, scb, links.tqe);
 		BUG_ON(!TAILQ_EMPTY(untagged_q));
-	}
-
-	if ((scb->flags & SCB_ACTIVE) == 0) {
+	} else if ((scb->flags & SCB_ACTIVE) == 0) {
+		/*
+		 * Transactions aborted from the untagged queue may
+		 * not have been dispatched to the controller, so
+		 * only check the SCB_ACTIVE flag for tagged transactions.
+		 */
 		printf("SCB %d done'd twice\n", scb->hscb->tag);
 		ahc_dump_card_state(ahc);
 		panic("Stopping for safety");

