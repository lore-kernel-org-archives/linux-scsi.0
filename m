From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: be2iscsi: allocate enough memory in
 beiscsi_boot_get_sinfo()
Date: Fri, 18 Nov 2016 14:53:39 +0300
Message-ID: <20161118115339.GD3281@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39266 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbcKRLyE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 06:54:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We accidentally allocate sizeof(u32) instead of sizeof(struct
be_cmd_get_session_resp).

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index aebc4dd..ac05317b 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1083,7 +1083,7 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 	nonemb_cmd = &phba->boot_struct.nonemb_cmd;
 	nonemb_cmd->size = sizeof(*resp);
 	nonemb_cmd->va = pci_alloc_consistent(phba->ctrl.pdev,
-					      sizeof(nonemb_cmd->size),
+					      nonemb_cmd->size,
 					      &nonemb_cmd->dma);
 	if (!nonemb_cmd->va) {
 		mutex_unlock(&ctrl->mbox_lock);
