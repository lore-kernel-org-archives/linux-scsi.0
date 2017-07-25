From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 8/9] zfcp: fix waiting for rport(s) unblock in eh_host_reset_handler
Date: Tue, 25 Jul 2017 16:14:26 +0200
Message-ID: <20170725141427.35258-9-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57285 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752013AbdGYOPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:15:10 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEAFaE000636
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:09 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bx3b2mb7r-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:09 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:15:07 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

v2.6.30 commit 63caf367e1c9 ("[SCSI] zfcp: Improve reliability of SCSI eh
handlers in zfcp") added calls to zfcp_erp_wait() within
eh_abort_handler(), eh_device_reset_handler(), eh_target_reset_handler()
in order to synchronize with zfcp recovery completion before returning
from a scsi_eh callback (e.g. with SUCCESS) to prevent eh escalation.

v2.6.33 commit af4de36d911a ("[SCSI] zfcp: Block scsi_eh thread for rport
state BLOCKED") introduced the use of fc_block_scsi_eh() for
eh_abort_handler(), eh_device_reset_handler(), eh_target_reset_handler(),
and eh_host_reset_handler(), because zfcp_erp_wait() from above commit is
not sufficient.
The use in zfcp_task_mgmt_function() is correct even for a LUN reset,
as described in commit 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race
with LUN recovery").
However, the one call in zfcp_scsi_eh_host_reset_handler() waiting for
just one arbitrary port of the arbitrary scsi_cmnd seems insufficient
as the preceding adapter recovery could have recovered multiple ports
for which we all should wait to unblock (or have run into FAST_IO_FAIL).

Therefore, we now wait for all ports of the adapter with this fix.

NB: We cannot easily wait for an event because there is a time window
between zfcp_erp_wait() returned and zfcp_erp_try_rport_unblock() as part
of zfcp_erp_action_cleanup() actually scheduled rport_work which will
unblock an rport in zfcp_scsi_rport_work() asynchronously. Hence a
flush_work() could come early before queue_work() was even done.

v2.6.35 commit a1dbfddd02d2 ("[SCSI] zfcp: Pass return code from
fc_block_scsi_eh to scsi eh") fixed v2.6.33 for the FAST_IO_FAIL case.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: af4de36d911a ("[SCSI] zfcp: Block scsi_eh thread for rport state BLOCKED")
Fixes: a1dbfddd02d2 ("[SCSI] zfcp: Pass return code from fc_block_scsi_eh to scsi eh")
---
 drivers/s390/scsi/zfcp_scsi.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 8e96196fa877..11cf33ea8c14 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -338,16 +338,29 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct zfcp_port *port;
-	int ret;
+	int ret = SUCCESS;
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	port = zfcp_sdev->port;
-	ret = port->rport ? fc_block_rport(port->rport) : 0;
-	if (ret)
-		return ret;
+	/* after internal recovery, wait for async unblock of rport(s) */
+	read_lock(&adapter->port_list_lock);
+	list_for_each_entry(port, &adapter->port_list, list) {
+		int fc_ret;
+
+		if (!port->rport)
+			continue;
+
+		fc_ret = fc_block_rport(port->rport);
+		/* Any rport ran into fast_io_fail_tmo: FAST_IO_FAIL.
+		 * To let pending requests bubble up, even if too many
+		 * because of other rports without this timeout.
+		 */
+		if (fc_ret)
+			ret = fc_ret;
+	}
+	read_unlock(&adapter->port_list_lock);
 
-	return SUCCESS;
+	return ret;
 }
 
 struct scsi_transport_template *zfcp_scsi_transport_template;
-- 
2.11.2
