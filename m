From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/64] fcoe: fix missing error check in call to fcoe_if_init
Date: Tue, 25 Aug 2009 13:59:14 -0700
Message-ID: <20090825205914.1553.29745.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbZHYU7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:12 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

fcoe_if_init() can fail, but it's return value wasn't checked

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a39d370..d205ac0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1900,7 +1900,9 @@ static int __init fcoe_init(void)
 	/* Setup link change notification */
 	fcoe_dev_setup();
 
-	fcoe_if_init();
+	rc = fcoe_if_init();
+	if (rc)
+		goto out_free;
 
 	return 0;
 

