From: <vmohan@brocade.com>
Subject: [PATCH 5/8] bfa: Observed auto D-port mode instead of manual
Date: Tue, 19 Nov 2013 23:05:43 -0800
Message-ID: <1384931146-3702-6-git-send-email-vmohan@brocade.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:58152 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab3KTHsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 02:48:10 -0500
In-Reply-To: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

Observed Auto mode in the HBA side while doing manual D-Port test on the
switch side. Mode is not passed to BFA from firmware when the test is
triggered by switch side. BFA just blindly using Auto mode.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_svc.c | 2 +-
 drivers/scsi/bfa/bfi.h     | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 6c41e57..625225f 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -6758,7 +6758,7 @@ bfa_dport_scn(struct bfa_dport_s *dport, struct bfi_diag_dport_scn_s *msg)
 		dport->rp_pwwn = msg->info.teststart.pwwn;
 		dport->rp_nwwn = msg->info.teststart.nwwn;
 		dport->lpcnt = cpu_to_be32(msg->info.teststart.numfrm);
-		bfa_dport_result_start(dport, BFA_DPORT_OPMODE_AUTO);
+		bfa_dport_result_start(dport, msg->info.teststart.mode);
 		break;
 
 	case BFI_DPORT_SCN_SUBTESTSTART:
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 7192e99..1d97a22 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -1144,7 +1144,8 @@ struct bfi_diag_dport_scn_teststart_s {
 	wwn_t	pwwn;	/* switch port wwn. 8 bytes */
 	wwn_t	nwwn;	/* switch node wwn. 8 bytes */
 	u8	type;	/* bfa_diag_dport_test_type_e */
-	u8	rsvd[3];
+	u8	mode;	/* bfa_diag_dport_test_opmode */
+	u8	rsvd[2];
 	u32	numfrm; /* from switch uint in 1M */
 };
 
-- 
1.8.2.1

