From: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: RESEND: fix PCI permanent error handler
Date: Mon, 20 Apr 2009 13:59:42 -0300
Message-ID: <1240246790.7458.112.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43884 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZDTRBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 13:01:07 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp04.br.ibm.com (8.13.1/8.13.1) with ESMTP id n3KGufQY031949
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 13:56:41 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.18.232.46])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KI0L3w3440736
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 15:00:23 -0300
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KH14Ic030511
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 14:01:04 -0300
Received: from [9.18.200.203] ([9.18.200.203])
	by d24av01.br.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id n3KH13EG030474
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 14:01:03 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

From: Brian King <brking@linux.vnet.ibm.com>

The ipr driver can hang if it encounters enough PCI errors
to trigger the permanent error handler. The driver will attempt
to initiate a "bringdown" of the adapter and fail all pending
ops back. However, this bringdown is unlike any other bringdown
of the adapter in the code as the driver. In this code path we
end up failing back ops with allow_cmds still set to 1. This results
in some commands, the HCAM commands in particular, getting immediately
re-issued to the adapter on the done call, which results in
an infinite loop in ipr_fail_all_ops. Fix this by setting allow_cmds
to zero in this path. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Kleber S. Souza <klebers@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_pci_perm_failure_hang
drivers/scsi/ipr.c
---
linux-2.6/drivers/scsi/ipr.c~ipr_pci_perm_failure_hang      2009-04-15
09:25:21.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c        2009-04-15
09:25:39.000000000 -0500
@@ -6998,6 +6998,7 @@ static void ipr_pci_perm_failure(struct 
                ioa_cfg->sdt_state = ABORT_DUMP;
        ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES;
        ioa_cfg->in_ioa_bringdown = 1;
+       ioa_cfg->allow_cmds = 0;
        ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
        spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 }
_
--

-- 
Kleber S. Souza
IBM Linux Technology Center

