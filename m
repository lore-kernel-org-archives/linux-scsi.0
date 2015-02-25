From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] bfa: fix bfa_cb_sfp_state_query()
Date: Wed, 25 Feb 2015 16:12:28 +0300
Message-ID: <20150225131228.GB19745@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37246 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbBYNNE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 08:13:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Krishna Gudipati <kgudipat@brocade.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

There are several missing curly braces so this function doesn't work as
intended.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 315d6d6..59c3492 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3662,7 +3662,7 @@ bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
 	bfa_trc(sfp, sfp->portspeed);
 	if (sfp->media) {
 		bfa_sfp_media_get(sfp);
-		if (sfp->state_query_cbfn)
+		if (sfp->state_query_cbfn) {
 			sfp->state_query_cbfn(sfp->state_query_cbarg,
 					sfp->status);
 			sfp->media = NULL;
@@ -3670,14 +3670,16 @@ bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
 
 		if (sfp->portspeed) {
 			sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
-			if (sfp->state_query_cbfn)
+			if (sfp->state_query_cbfn) {
 				sfp->state_query_cbfn(sfp->state_query_cbarg,
 						sfp->status);
 				sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
+			}
 		}
 
 		sfp->state_query_lock = 0;
 		sfp->state_query_cbfn = NULL;
+	}
 }
 
 /*
