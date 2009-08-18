From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/27] zfcp: Only issue one test link command per port
Date: Tue, 18 Aug 2009 15:43:11 +0200
Message-ID: <20090818135029.534319000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57748 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759005AbZHRNuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:39 -0400
Content-Disposition: inline; filename=707-zfcp-one-test-link.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the FCP channel returns a series of commands with the error
status "test link", zfcp will send a series of ELS ADISC commands.
This is technically no problem, but it is enough to only issue one
test command per remote port. So, track whether a ELS ADISC command is
already pending, and do not send a new one if there is already a
pending command.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_fc.c  |    9 +++++++++
 2 files changed, 10 insertions(+)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-08-12 10:05:29.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-08-12 10:05:30.000000000 +0200
@@ -232,6 +232,7 @@ struct zfcp_ls_adisc {
 
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
+#define ZFCP_STATUS_PORT_LINK_TEST		0x00000002
 
 /* well known address (WKA) port status*/
 enum zfcp_wka_status {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-08-12 10:04:57.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-08-12 10:05:30.000000000 +0200
@@ -404,6 +404,7 @@ static void zfcp_fc_adisc_handler(unsign
 	/* port is good, unblock rport without going through erp */
 	zfcp_scsi_schedule_rport_register(port);
  out:
+	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	zfcp_port_put(port);
 	kfree(adisc);
 }
@@ -450,13 +451,21 @@ void zfcp_fc_link_test_work(struct work_
 	port->rport_task = RPORT_DEL;
 	zfcp_scsi_rport_work(&port->rport_work);
 
+	/* only issue one test command at one time per port */
+	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_LINK_TEST)
+		goto out;
+
+	atomic_set_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
+
 	retval = zfcp_fc_adisc(port);
 	if (retval == 0)
 		return;
 
 	/* send of ADISC was not possible */
+	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
 
+out:
 	zfcp_port_put(port);
 }
 

