From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/1] [SCSI] Clear Devloss Callback Done flag in
 fc_remote_port_rolechg
Date: Thu, 3 Nov 2011 11:10:40 -0400
Message-ID: <ec85bf96-10aa-4dc6-bc68-1707d7f22cd1@exht2.ad.emulex.com>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:27181 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756043Ab1KCPLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 11:11:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: alex.iannicelli@emulex.com, james.smart@emulex.com

This patch fixes a bug where devloss is not called on fc_host teardown.
The issue is seen if the LLDD uses rport_rolechg to add the target role
to an rport.

When an rport goes away, the LLDD will call fc_remote_port_delete, which
will start the devloss timer.  If the timer expires, the transport will
call the devloss callback and set the FC_RPORT_DEVLOSS_CALLBK_DONE flag.
However, the rport structure is not deleted, it is retained to store the
SCSI id mappings for the rport in case it comes back. In the scenario
where it does come back, and the driver calls fc_remote_port_add, but does
not indicate the "target" role for the rport - the create will clear the
structure, but forgets to clear FC_RPORT_DEVLOSS_CALLBK_DONE flag (which
is cleared if it's added with the target role). The secondary call, of
fc_remote_port_rolechg to add the target role also does not clear the flag.
Thus, the next time the rport goes away, the resulting devloss timer
expiration will not call the driver callback as the flag is still set.

This patch adds the FC_RPORT_DEVLOSS_CALLBK_DONE flags to the list of
those that are cleared upon reuse of the rport structure.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2011-11-03 10:27:14.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2011-11-03 10:28:59.000000000 -0400
@@ -3048,7 +3048,8 @@ fc_remote_port_rolechg(struct fc_rport  
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
-				  FC_RPORT_DEVLOSS_PENDING);
+				  FC_RPORT_DEVLOSS_PENDING |
+				  FC_RPORT_DEVLOSS_CALLBK_DONE);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		/* ensure any stgt delete functions are done */


