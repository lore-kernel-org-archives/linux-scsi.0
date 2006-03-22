From: Bryan Holty <lgeek@frontiernet.net>
Subject: [PATCH] scsi: Fix sg memory leak building 2 scatter-gather lists
Date: Wed, 22 Mar 2006 17:03:59 -0600
Message-ID: <200603221703.59337.lgeek@frontiernet.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04.roc.ny.frontiernet.net ([66.133.182.167]:42187 "EHLO
	relay04.roc.ny.frontiernet.net") by vger.kernel.org with ESMTP
	id S1751424AbWCVXEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 18:04:04 -0500
Received: from [192.168.0.100] (208-186-91-54.dsl1.apv.mn.frontiernet.net [208.186.91.54])
	by relay04.roc.ny.frontiernet.net (Postfix) with ESMTP id CBDD53582CD
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 23:04:00 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,
    There is a memory leak in sg that is hit in the case when direct_io is in 
use and the length of the data is longer than we can fit into a single 
scatter-gather list.  Two scatter-gather lists are allocated for each io that 
meets the criteria, and only 1 ever gets released.

    The following fix releases the scatter-gather list created by the 
attempted sg_build_direct when abandoning the effort in favor of 
sg_build_indirect.  sg_build_indirect creates a new scatter-gather list.


Signed-off-by: Bryan Holty <lgeek@frontiernet.net>

--- a/drivers/scsi/sg.c	2006-03-03 13:17:23.000000000 -0600
+++ b/drivers/scsi/sg.c	2006-03-22 16:32:17.536091840 -0600
@@ -1648,6 +1648,7 @@
 		res = sg_build_direct(srp, sfp, dxfer_len);
 		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
 			return res;
+		sg_remove_scat(req_schp);
 	}
 	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
 		sg_link_reserve(sfp, srp, dxfer_len);
-- 
--
 Bryan Holty
