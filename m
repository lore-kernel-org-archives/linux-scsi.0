From: <kgudipat@brocade.com>
Subject: [PATCH 02/15] bfa: BSG return value fix to be compatible with kernel convention.
Date: Wed, 20 Jul 2011 16:59:44 -0700
Message-ID: <1311206384-27707-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56020 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab1GUAAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 20:00:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made changes to adhere to the kernel convention return value.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 88bfa92..3601508 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -56,7 +56,7 @@ bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	if (bfad->disable_active) {
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-		return EBUSY;
+		return -EBUSY;
 	}
 
 	bfad->disable_active = BFA_TRUE;
@@ -390,7 +390,7 @@ bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 	void	*iocmd_bufptr;
 
 	if (iocmd->nrports == 0)
-		return EINVAL;
+		return -EINVAL;
 
 	if (bfad_chk_iocmd_sz(payload_len,
 			sizeof(struct bfa_bsg_lport_get_rports_s),
@@ -1516,7 +1516,7 @@ static int
 bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 		unsigned int payload_len)
 {
-	int rc = EINVAL;
+	int rc = -EINVAL;
 
 	switch (cmd) {
 	case IOCMD_IOC_ENABLE:
@@ -1704,10 +1704,10 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 		rc = bfad_iocmd_porglog_get(bfad, iocmd);
 		break;
 	default:
-		rc = EINVAL;
+		rc = -EINVAL;
 		break;
 	}
-	return -rc;
+	return rc;
 }
 
 static int
-- 
1.7.3.rc1

