From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] fc transport: correct default value for fc_dev_loss_tmo
Date: Thu, 11 May 2006 11:23:11 +0200
Message-ID: <20060511092311.GA8077@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61629 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1030206AbWEKJZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 05:25:32 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.6/8.13.6) with ESMTP id k4B9PVfT146284
	for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 09:25:31 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4B9Qp8p138884
	for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 11:26:51 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k4B9PUhC006065
	for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 11:25:30 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>, James Smart <james.smart@emulex.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

In current kernels initialization of fc_dev_loss_tmo is wrong.
See fc_remote_port_delete():

    int timeout = rport->dev_loss_tmo;
...
    fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);

So actually a timeout of ((HZ*60)*HZ) is used or with James S's recent
patch we have a timeout of ((HZ*120)*HZ). I think this was not
intentional, so I suggest the following patch to correct this.


Regards,

Andreas


fc transport: correct default value for fc_dev_loss_tmo

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>


diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 95c5478..a1cb05e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -368,7 +368,7 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
  *   should insulate the loss of a remote port.
  *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
  */
-static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
+static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT / HZ;
 
 module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
