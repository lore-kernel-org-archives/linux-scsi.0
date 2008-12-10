From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH] qla2xxx: Fix for incorrect unconditionally interrupts enabling
 on IRQ context
Date: Wed, 10 Dec 2008 19:22:37 +0300
Message-ID: <493FECCD.6060904@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:53002 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754278AbYLJQWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 11:22:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org

A rather trivial patch. Function qla2x00_schedule_rport_del() can be called on IRQ
context, so it can't unconditionally enable interrupts. Spotted by lockdep.

This patch is against 2.6.27.2, but applies also on 2.6.28-rc7.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
	
 qla_os.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -upr linux-2.6.27.2/drivers/scsi/qla2xxx/qla_os.c linux-2.6.27.2/drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.27.2/drivers/scsi/qla2xxx/qla_os.c	2008-10-21 13:57:15.000000000 +0400
+++ linux-2.6.27.2/drivers/scsi/qla2xxx/qla_os.c	2008-12-05 11:14:21.000000000 +0300
@@ -1862,9 +1885,10 @@ qla2x00_schedule_rport_del(struct scsi_q
 
 	rport = fcport->rport;
 	if (defer) {
-		spin_lock_irq(ha->host->host_lock);
+		unsigned long flags;
+		spin_lock_irqsave(ha->host->host_lock, flags);
 		fcport->drport = rport;
-		spin_unlock_irq(ha->host->host_lock);
+		spin_unlock_irqrestore(ha->host->host_lock, flags);
 		set_bit(FCPORT_UPDATE_NEEDED, &pha->dpc_flags);
 		qla2xxx_wake_dpc(pha);
 	} else

