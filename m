From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH repost] sg: fix bio leak with a detached device
Date: Thu, 22 Jul 2010 09:36:51 +0900
Message-ID: <20100722093552Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59748 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0GVAhC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Novell.com
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com, Nate.Dailey@stratus.com

James, you missed this?

http://marc.info/?l=linux-scsi&m=127860094028580&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: fix bio leak with a detached device

After blk_rq_map_user is successful, if we find that a device is
unavailable (was detached), we must call blk_end_request_all to free
bio(s) before blk_rq_unmap_user and blk_put_request.

Reported-by: "Dailey, Nate" <Nate.Dailey@stratus.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: "Dailey, Nate" <Nate.Dailey@stratus.com>
---
 drivers/scsi/sg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..d454909 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -729,6 +729,8 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if (sdp->detached) {
+		if (srp->bio)
+			blk_end_request_all(srp->rq, -EIO);
 		sg_finish_rem_req(srp);
 		return -ENODEV;
 	}
-- 
1.6.5

