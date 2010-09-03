From: madhu.iyengar@qlogic.com
Subject: [PATCH 02/10] qla2xxx: Pass first 64 bytes of MBX information when vendor commands fail.
Date: Fri,  3 Sep 2010 15:20:49 -0700
Message-ID: <1283552457-4497-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39318 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753316Ab0ICW05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:57 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a595ec8..5823398 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3828,8 +3828,6 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	/* Copy mailbox information */
 	memcpy( mresp, mcp->mb, 64);
-	mresp[3] = mcp->mb[18];
-	mresp[4] = mcp->mb[19];
 	return rval;
 }
 
@@ -3890,9 +3888,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	}
 
 	/* Copy mailbox information */
-	memcpy( mresp, mcp->mb, 32);
+	memcpy(mresp, mcp->mb, 64);
 	return rval;
 }
+
 int
 qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic)
 {
-- 
1.6.0.2

