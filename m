From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/8] ipr: Handle check condition status from disk array device
Date: Thu, 26 Apr 2007 16:00:10 -0500
Message-ID: <200704262101.l3QL1Mja004334@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59126 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbXDZVBY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 17:01:24 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QK0BZn015921
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 16:00:11 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1NMw547372
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:23 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1NqP004361
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


On newer levels of microcode for ipr RAID adapters supporting
multi-initiator configurations, the disk array, or VSET, resources
are capable of generating a check condition. This patch prevents
ipr from generating sense data in this scenario and retrieving it
from the logical device instead.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_vset_cc_handling drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_vset_cc_handling	2007-04-26 09:17:39.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:17:39.000000000 -0500
@@ -4672,18 +4672,19 @@ static void ipr_erp_start(struct ipr_ioa
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 	struct ipr_resource_entry *res = scsi_cmd->device->hostdata;
 	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+	u32 masked_ioasc = ioasc & IPR_IOASC_IOASC_MASK;
 
 	if (!res) {
 		ipr_scsi_eh_done(ipr_cmd);
 		return;
 	}
 
-	if (!ipr_is_gscsi(res))
+	if (!ipr_is_gscsi(res) && masked_ioasc != IPR_IOASC_HW_DEV_BUS_STATUS)
 		ipr_gen_sense(ipr_cmd);
 
 	ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
 
-	switch (ioasc & IPR_IOASC_IOASC_MASK) {
+	switch (masked_ioasc) {
 	case IPR_IOASC_ABORTED_CMD_TERM_BY_HOST:
 		if (ipr_is_naca_model(res))
 			scsi_cmd->result |= (DID_ABORT << 16);
_
