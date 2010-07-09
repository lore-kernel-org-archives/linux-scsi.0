From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 20/24] bfa: add ioc state checking
Date: Thu, 8 Jul 2010 20:00:24 -0700
Message-ID: <1278644424-3444-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36487 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310Ab0GIDAb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 23:00:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

This patch adds ioc state checking while enabling a port.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index c855e22..f0933d8 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -1393,6 +1393,9 @@ bfa_fcport_enable(struct bfa_s *bfa)
 		return BFA_STATUS_PBC;
 	}
 
+	if (bfa_ioc_is_disabled(&bfa->ioc))
+		return BFA_STATUS_IOC_DISABLED;
+
 	if (fcport->diag_busy)
 		return BFA_STATUS_DIAG_BUSY;
 	else if (bfa_sm_cmp_state
-- 
1.6.5.2

