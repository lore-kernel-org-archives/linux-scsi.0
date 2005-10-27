From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/5]  qla2xxx: Correct issue where fcport is prematurely marked DEAD.
Date: Thu, 27 Oct 2005 11:09:38 -0700 (PDT)
Message-ID: <20051027180938.11768.36072.sendpatchset@plap.qlogic.com>
References: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:54887 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751399AbVJ0SJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 14:09:39 -0400
In-Reply-To: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
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

043751053f799d81e39ce8a5874957a607b9bcbd
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 127e1a5..8fd40fb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2878,7 +2878,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
 			fcport->loop_id = FC_NO_LOOP_ID;
-			atomic_set(&fcport->state, FCS_DEVICE_DEAD);
+			fcport->login_retry = 0;
 
 			rval = 3;
 			break;

-- 
Andrew Vasquez
