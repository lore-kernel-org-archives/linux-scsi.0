From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3] scsi/bfa: use designated initializers
Date: Thu, 20 Apr 2017 15:00:02 -0700
Message-ID: <20170420220002.GA65324@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36808 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947842AbdDTWAF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:00:05 -0400
Received: by mail-oi0-f42.google.com with SMTP id r203so69436878oib.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 15:00:05 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. This also initializes the
array members using the enum used to look up __port_action entries.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3:
- drop bfa_module_s changes, since that has been removed entirely; hch.
- init array with enum literals; hch.
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 4ddda72f60e6..638c0a2857f7 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -89,16 +89,27 @@ static struct {
 	void		(*online) (struct bfa_fcs_lport_s *port);
 	void		(*offline) (struct bfa_fcs_lport_s *port);
 } __port_action[] = {
-	{
-	bfa_fcs_lport_unknown_init, bfa_fcs_lport_unknown_online,
-			bfa_fcs_lport_unknown_offline}, {
-	bfa_fcs_lport_fab_init, bfa_fcs_lport_fab_online,
-			bfa_fcs_lport_fab_offline}, {
-	bfa_fcs_lport_n2n_init, bfa_fcs_lport_n2n_online,
-			bfa_fcs_lport_n2n_offline}, {
-	bfa_fcs_lport_loop_init, bfa_fcs_lport_loop_online,
-			bfa_fcs_lport_loop_offline},
-	};
+	[BFA_FCS_FABRIC_UNKNOWN] = {
+		.init = bfa_fcs_lport_unknown_init,
+		.online = bfa_fcs_lport_unknown_online,
+		.offline = bfa_fcs_lport_unknown_offline
+	},
+	[BFA_FCS_FABRIC_SWITCHED] = {
+		.init = bfa_fcs_lport_fab_init,
+		.online = bfa_fcs_lport_fab_online,
+		.offline = bfa_fcs_lport_fab_offline
+	},
+	[BFA_FCS_FABRIC_N2N] = {
+		.init = bfa_fcs_lport_n2n_init,
+		.online = bfa_fcs_lport_n2n_online,
+		.offline = bfa_fcs_lport_n2n_offline
+	},
+	[BFA_FCS_FABRIC_LOOP] = {
+		.init = bfa_fcs_lport_loop_init,
+		.online = bfa_fcs_lport_loop_online,
+		.offline = bfa_fcs_lport_loop_offline
+	},
+};
 
 /*
  *  fcs_port_sm FCS logical port state machine
-- 
2.7.4


-- 
Kees Cook
Pixel Security
