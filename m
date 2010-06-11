From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/17] libfcoe: FIP link keep-alive should continue while
	logged off
Date: Fri, 11 Jun 2010 16:43:33 -0700
Message-ID: <20100611234333.4616.10740.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55220 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0FKXne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:43:34 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

A check in fcoe_ctlr_send_keep_alive() returns if there's no
port_id for the local port.  This could miss a keep alive if
we just did a host reset and have logged off and will log back in.

Return only if we are doing the port keep alive, in which case
we need to be logged in.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 50aaa4b..cc5e886 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -343,7 +343,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 
 	fcf = fip->sel_fcf;
 	lp = fip->lp;
-	if (!fcf || !lp->port_id)
+	if (!fcf || (ports && !lp->port_id))
 		return;
 
 	len = sizeof(*kal) + ports * sizeof(*vn);

