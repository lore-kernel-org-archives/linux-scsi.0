From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] qla2xxx: spin_unlock_irq in IRQ context
Date: Tue, 09 Jan 2007 14:35:53 +0900
Message-ID: <6.0.0.20.2.20070109140514.02ea25e0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:48699 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbXAIGO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 01:14:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi.

  The function qla2x00_ramp_up_queue_depth()  can be called in IRQ context.
  So spin_unlock_irq in qla2x00_ramp_up_queue_depth() is not appropriate.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

--- linux-2.6.20-rc4.org/drivers/scsi/qla2xxx/qla_isr.c	2006-11-30 
06:57:37.000000000 +0900
+++ linux-2.6.20-rc4/drivers/scsi/qla2xxx/qla_isr.c	2007-01-09 
11:26:45.000000000 +0900
@@ -650,10 +650,18 @@ qla2x00_ramp_up_queue_depth(scsi_qla_hos
  	    fcport->last_queue_full + ql2xqfullrampup * HZ))
  		return;

-	spin_unlock_irq(&ha->hardware_lock);
+	if (in_irq())
+		spin_unlock(&ha->hardware_lock);
+	else
+		spin_unlock_irq(&ha->hardware_lock);
+
  	starget_for_each_device(sdev->sdev_target, fcport,
  	    qla2x00_adjust_sdev_qdepth_up);
-	spin_lock_irq(&ha->hardware_lock);
+
+	if (in_irq())
+		spin_lock(&ha->hardware_lock);
+	else
+		spin_lock_irq(&ha->hardware_lock);
  }

  /** 

