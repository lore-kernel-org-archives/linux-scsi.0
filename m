From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/12] fcoe: reset FIP ctlr link state on disable/enable
Date: Fri, 09 Apr 2010 14:22:23 -0700
Message-ID: <20100409212223.1968.34689.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504Ab0DIVWX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:23 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

The FIP controler state wasn't being reset on a disable.
A disable/enable sequence should be treated as a link event.
Otherwise, when using disable to mask a time when the link
is up but unusable, FCF discovery would attempt to continue
and login would jump directly to the non-FIP fallback on
enable.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 927b3e6..0d8127e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1901,9 +1901,10 @@ static int fcoe_disable(const char *buffer, struct kernel_param *kp)
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
-	if (fcoe)
+	if (fcoe) {
 		fc_fabric_logoff(fcoe->ctlr.lp);
-	else
+		fcoe_ctlr_link_down(&fcoe->ctlr);
+	} else
 		rc = -ENODEV;
 
 	dev_put(netdev);
@@ -1950,9 +1951,11 @@ static int fcoe_enable(const char *buffer, struct kernel_param *kp)
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	rtnl_unlock();
 
-	if (fcoe)
+	if (fcoe) {
+		if (!fcoe_link_ok(fcoe->ctlr.lp))
+			fcoe_ctlr_link_up(&fcoe->ctlr);
 		rc = fc_fabric_login(fcoe->ctlr.lp);
-	else
+	} else
 		rc = -ENODEV;
 
 	dev_put(netdev);

