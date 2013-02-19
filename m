From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 21/21] libfc: XenServer fails to mount root filesystem.
Date: Tue, 19 Feb 2013 11:32:27 -0800
Message-ID: <20130219193227.10192.48866.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933341Ab3BSTc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:32:27 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Krishna Mohan <krmohan@cisco.com>

From: Krishna Mohan <krmohan@cisco.com>

schedule_delayed_work() is using msec instead of jiffies. On PLOGI
reject from target, remote port retry is scheduled @ 20 sec instead
of 2sec(FC_DEF_E_D_TOV).
XenServer dom0 kernel is configured with CONFIG_HZ=100Hz

Signed-off-by: Krishna Mohan <krmohan@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 83aa1ef..d518d17 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -582,7 +582,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 				 struct fc_frame *fp)
 {
-	unsigned long delay = FC_DEF_E_D_TOV;
+	unsigned long delay = msecs_to_jiffies(FC_DEF_E_D_TOV);
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)

