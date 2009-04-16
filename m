From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: fix PCI permanent error handler
Date: Thu, 16 Apr 2009 18:41:32 -0300
Message-ID: <1239918093.6371.197.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:36362 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZDPVnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 17:43:00 -0400
Received: from mailhub3.br.ibm.com (mailhub3.br.ibm.com [9.18.232.110])
	by e24smtp04.br.ibm.com (8.13.1/8.13.1) with ESMTP id n3GLchom031170
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 18:38:43 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3GLhGft1900732
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 18:43:19 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3GLgnah006134
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 18:42:52 -0300
Received: from [9.8.3.249] ([9.8.3.249])
	by d24av02.br.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id n3GLgkaf006075
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 18:42:46 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

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
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_pci_perm_failure_hang
drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_pci_perm_failure_hang
2009-04-15 09:25:21.000000000 -0500
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


