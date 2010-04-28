From: Roland Dreier <rdreier@cisco.com>
Subject: [PATCH][SCSI] cxgb3i: Fix error path for module init
Date: Tue, 27 Apr 2010 22:39:22 -0700
Message-ID: <adazl0ojfud.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:26265 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab0D1Fj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2010 01:39:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Karen Xie <kxie@chelsio.com>, Rakesh Ranjan <rakesh@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>

If cxgb3i_pdu_init() fails, then it appears that cxgb3i_iscsi_init()
will not be cleaned up, leading to the iscsi transport being left
registered.  Fix this by adding a call to cxgb3i_iscsi_cleanup() on the
error path.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/scsi/cxgb3i/cxgb3i_init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index d0ab23a..685af36 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -104,8 +104,10 @@ static int __init cxgb3i_init_module(void)
 		return err;
 
 	err = cxgb3i_pdu_init();
-	if (err < 0)
+	if (err < 0) {
+		cxgb3i_iscsi_cleanup();
 		return err;
+	}
 
 	cxgb3_register_client(&t3c_client);
 

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
