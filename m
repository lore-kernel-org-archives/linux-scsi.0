From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/24] libfcoe: don't send ELS in FIP mode if no FCF selected
Date: Fri, 18 Sep 2009 15:49:25 -0700
Message-ID: <20090918224925.5928.52021.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769AbZIRWtW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:49:22 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

If link is up, but no FCF is selected, don't send any ELS frames.

This came up when an fnic received a multicast advertisement but
no solitited advertisments, so no FCF was selected.  It tried
to send FLOGIs anyway.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 1ee2350..062ad15 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -501,6 +501,8 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 
 	if (fip->state == FIP_ST_NON_FIP)
 		return 0;
+	if (!fip->sel_fcf)
+		goto drop;
 
 	switch (op) {
 	case ELS_FLOGI:

