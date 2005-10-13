From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/12]  qla2xxx: Correct issue where fcport is prematurely marked DEAD.
Date: Thu, 13 Oct 2005 16:15:44 -0700 (PDT)
Message-ID: <20051013231544.27191.74309.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7331 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932527AbVJMXPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:15:44 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

The non-handled failure cases of the Fabric Login mailbox
command handling logic would incorrectly mark the fcport as
dead and not allow the standard port-down-retry-count logic
to manage the transition.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

applies-to: b92e43b7cbae6e7128ca6d7831d06e63989f2a31
67f7dd397a973725712a91d3382eba8d8c5bb1da
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 23d095d..7325658 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2858,7 +2858,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
 			fcport->loop_id = FC_NO_LOOP_ID;
-			atomic_set(&fcport->state, FCS_DEVICE_DEAD);
+			fcport->login_retry = 0;
 
 			rval = 3;
 			break;
---
0.99.8.GIT

-- 
Andrew Vasquez
