From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/20] qla2xxx: Mark a port's state as needing-rediscovery during link disruptions.
Date: Wed,  3 Jun 2009 09:55:21 -0700
Message-ID: <1244048131-56590-11-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbZFCQzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:35 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

With RSCN states not being kept across qla2x00_configure_loop()
invocations, loop-resync distruptions during fabric-discovery may
cause ports to remain in a lost state.  Force state
renegotiation during a follow-on configure-loop iteration.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 415fbf6..d145de0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2064,8 +2064,10 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 		if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-		if (test_bit(RSCN_UPDATE, &save_flags))
+		if (test_bit(RSCN_UPDATE, &save_flags)) {
 			set_bit(RSCN_UPDATE, &vha->dpc_flags);
+			vha->flags.rscn_queue_overflow = 1;
+		}
 	}
 
 	return (rval);
-- 
1.6.3.1.244.gf9275

