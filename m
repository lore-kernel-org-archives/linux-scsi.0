From: <Alex.Iannicelli@Emulex.Com>
Subject: [PATCH 1/1] [SCSI] Clear Devloss Callback Done flag in
 fc_remote_port_rolechg.
Date: Thu, 27 Oct 2011 07:53:28 -0700
Message-ID: <fc185e15-b38b-407a-a98b-bb65c53c5f78@exht2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:9024 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714Ab1J0O7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2011 10:59:12 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com, Alex.Iannicelli@Emulex.Com

This patch fixes a bug where devloss is not called on fc_host teardown.=
 The=20
issues is seen if the LLDD uses rport_rolechg to add target role to rpo=
rt.
When an rport is discovered the LLDD uses fc_rport_add to add the rport=
 and then=20
uses remote_port_rolechg to indicate that it is a target. If this rport=
 goes away=20
and the LLDD calls fc_report_port_delete. The transport calls devloss a=
fter the=20
devloss timer fires and it sets the FC_RPORT_DEVLOSS_CALLBK_DONE flag. =
If the
LLDD discovers this target again and uses remote_port_add to add it, bu=
t it was
a target and there is no target role assigned yet then this function re=
turns=20
without clearing the FC_RPORT_DEVLOSS_CALLBACK_DONE flag. When the LLDD=
 calls
again to change the role to a target the report_port_rolechg routine ne=
glects to
clear the flag as well. Once in this state, if the LLDD tears down the =
fc_host
then devloss will not be called for this target because the DEVLOSS_CAL=
LBK_DONE
flag is still set.
=A0
This patch adds the FC_RPORT_DEVLOSS_CALLBK_DONE flag to the group of f=
lags that
it clears when flushing devloss timers.
=A0
Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
=A0
---
=A0
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_trans=
port_fc.c
index 1b21491..f59d4a0 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3048,7 +3048,8 @@ fc_remote_port_rolechg(struct fc_rport=A0 *rport,=
 u32 roles)
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_lock_irqsave(shost->=
host_lock, flags);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rport->flags &=3D ~(FC_RP=
ORT_FAST_FAIL_TIMEDOUT |
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 FC_RPORT_DEVLOSS_PENDING);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 FC_RPORT_DEVLOSS_PENDING |
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 FC_RPORT_DEVLOSS_CALLBK_DONE);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock_irqrestore(sh=
ost->host_lock, flags);
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* ensure any stgt delete=
 functions are done */

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
