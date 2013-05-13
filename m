From: Vijay Mohan Guvva <vmohan@Brocade.com>
Subject: [PATCH V1] bfa: fix faulty handling of events in lps sm
Date: Mon, 13 May 2013 03:49:44 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C990203A1C103B5@BRM-EXCH-3.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34206 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab3EMJtv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:49:51 -0400
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id r4D9npUJ016045
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 02:49:51 -0700
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0a-000f0801.pphosted.com with ESMTP id 1c8y1n1epb-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 02:49:51 -0700
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>
Cc: Anil Gurumurthy <agurumur@Brocade.com>, Vijay Mohan Guvva <vmohan@Brocade.com>

Resending the patch as it didn't make the link-scsi list.

When a switch disable/enable or a reboot is done, the HBA port gets an
offline and a subsequent online notification. When the port comes up a
link up notification is sent to bfa from the firmware. The bfa then send
an FLOGI to the firmware which is sent out on the wire.
The switch port meanwhile goes offline (presumably for diagnostics)
which causes the switch not to respond to the FLOGI.
The link down notification is sent to the HBA driver. However owing to a
bug in the lps state machine handling the lps state machine does not
move to sm_init state (it remains in sm_login state and send a login
complete message to fcs). This results in a zero PID assignment as the
login is not really complete.

This fix is to correctly handle the events in lps state machine.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 299c1c8..7ed2c57 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -1276,7 +1276,6 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 
 	switch (event) {
 	case BFA_LPS_SM_FWRSP:
-	case BFA_LPS_SM_OFFLINE:
 		if (lps->status == BFA_STATUS_OK) {
 			bfa_sm_set_state(lps, bfa_lps_sm_online);
 			if (lps->fdisc)
@@ -1305,6 +1304,7 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 		bfa_lps_login_comp(lps);
 		break;
 
+	case BFA_LPS_SM_OFFLINE:
 	case BFA_LPS_SM_DELETE:
 		bfa_sm_set_state(lps, bfa_lps_sm_init);
 		break;
-- 
1.8.2.1

