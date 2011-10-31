From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [smatch stuff] re: [SCSI] lpfc 8.3.27: Changed worst case mailbox
 timeout
Date: Mon, 31 Oct 2011 09:58:13 +0300
Message-ID: <20111031065813.GA12501@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20316 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab1JaG60 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2011 02:58:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org

Smatch complains about a183a15f "[SCSI] lpfc 8.3.27: Changed worst
case mailbox timeout".

drivers/scsi/lpfc/lpfc_sli.c +2220 lpfc_sli_handle_mb_event(66)
	error: we previously assumed 'pmb->vport' could be null (see line 2177)

+                                       pmb->vport ? pmb->vport->vpi : 0,
                                        ^^^^^^^^^^
Checked.

+                                       pmbox->mbxCommand,
+                                       lpfc_sli_config_mbox_subsys_get(phba,
+                                                                       pmb),
+                                       lpfc_sli_config_mbox_opcode_get(phba,
+                                                                       pmb),
+                                       pmbox->mbxStatus,
+                                       pmbox->un.varWords[0],
+                                       pmb->vport->port_state);
                                        ^^^^^^^^^^^^
Dereferenced without checking.

regards,
dan carpenter

