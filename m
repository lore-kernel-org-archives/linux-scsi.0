From: madhu.iyengar@qlogic.com
Subject: [PATCH 10/14] qla2xxx: Don't perform a BIG_HAMMER if Get-ID (0x20) mailbox command fails on CNAs.
Date: Tue, 21 Dec 2010 16:00:23 -0800
Message-ID: <1292976027-12034-11-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36169 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753967Ab0LVADZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:25 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The semantics we employ now in the driver, performing a
BIG_HAMMER in the event of Get-ID (0x20) mailbox command
failing, should only be done for FC.  On FC configurations, it
makes sense since advertising is only really performed once,
so a BIG_HAMMER to reinitiate the process is needed to
restart.  Under FCoE, this is not needed, as there's a
continous stream of advertisements/ACks at the protocol layer
to initiate a relogin/reinitialization process.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d0a0dc9..f948e1a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2024,6 +2024,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	    &loop_id, &al_pa, &area, &domain, &topo, &sw_cap);
 	if (rval != QLA_SUCCESS) {
 		if (LOOP_TRANSITION(vha) || atomic_read(&ha->loop_down_timer) ||
+		    IS_QLA8XXX_TYPE(ha) ||
 		    (rval == QLA_COMMAND_ERROR && loop_id == 0x7)) {
 			DEBUG2(printk("%s(%ld) Loop is in a transition state\n",
 			    __func__, vha->host_no));
-- 
1.6.0.2

