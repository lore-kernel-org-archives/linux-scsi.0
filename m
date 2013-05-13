From: Vijay Mohan Guvva <vmohan@Brocade.com>
Subject: [PATCH] bfa: fix for FC Direct Attach LUN discovery failure
Date: Mon, 13 May 2013 03:56:48 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C990203A1C103B9@BRM-EXCH-3.corp.brocade.com>
References: <1366384368-17868-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34419 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077Ab3EMJ4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:56:52 -0400
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id r4D9r1QU019257
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 02:56:52 -0700
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0a-000f0801.pphosted.com with ESMTP id 1c8y1n1es9-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 02:56:52 -0700
In-Reply-To: <1366384368-17868-1-git-send-email-vmohan@brocade.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Anil Gurumurthy <agurumur@Brocade.com>, Vijay Mohan Guvva <vmohan@Brocade.com>

Resending the patch as it didn't make the linux-scsi list.

This patch fixes fcs rport state machine to address ocassional Brocade
FC Direct Attach LUN discovery failure due to not sending PLOGI accept
to the target.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 58ac643..610ca95 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -189,8 +189,8 @@ bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_PLOGI_RCVD:
-		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_fcs_online);
-		bfa_fcs_rport_fcs_online_action(rport);
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
 		break;
 
 	case RPSM_EVENT_PLOGI_COMP:
-- 
1.8.2.1

