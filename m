From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 12/17] bfa: Allow rsp queue process during ioc disable
Date: Mon, 13 May 2013 02:33:30 -0700
Message-ID: <1368437615-9867-13-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50359 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab3EMJv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:51:58 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Allow processing completions from firmware during IOC_DISABLE request is
being processed by the firmware, by setting the queue_process flag
appropriately.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 342d7d9..520540a 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1432,6 +1432,7 @@ bfa_iocfc_disable_cbfn(void *bfa_arg)
 {
 	struct bfa_s	*bfa = bfa_arg;
 
+	bfa->queue_process = BFA_FALSE;
 	bfa_fsm_send_event(&bfa->iocfc, IOCFC_E_IOC_DISABLED);
 }
 
@@ -1567,7 +1568,6 @@ bfa_iocfc_start(struct bfa_s *bfa)
 void
 bfa_iocfc_stop(struct bfa_s *bfa)
 {
-	bfa->queue_process = BFA_FALSE;
 	bfa_fsm_send_event(&bfa->iocfc, IOCFC_E_STOP);
 }
 
@@ -1674,7 +1674,6 @@ bfa_iocfc_disable(struct bfa_s *bfa)
 	bfa_plog_str(bfa->plog, BFA_PL_MID_HAL, BFA_PL_EID_MISC, 0,
 		     "IOC Disable");
 
-	bfa->queue_process = BFA_FALSE;
 	bfa_fsm_send_event(&bfa->iocfc, IOCFC_E_DISABLE);
 }
 
-- 
1.7.12

