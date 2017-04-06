From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH] scsi: aacraid: fix PCI error recovery path
Date: Thu,  6 Apr 2017 18:12:09 -0300
Message-ID: <20170406211209.27129-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753870AbdDFVMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 17:12:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v36L91Vc029563
        for <linux-scsi@vger.kernel.org>; Thu, 6 Apr 2017 17:12:46 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29nrdwcpwe-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 06 Apr 2017 17:12:46 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Thu, 6 Apr 2017 18:12:44 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v36LCaH78192162
        for <linux-scsi@vger.kernel.org>; Thu, 6 Apr 2017 18:12:41 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v36LCK55030718
        for <linux-scsi@vger.kernel.org>; Thu, 6 Apr 2017 18:12:21 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com
Cc: gpiccoli@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com

During a PCI error recovery, if aac_check_health() is not aware that
a PCI error happened and we have an offline PCI channel, it might
trigger some errors (like NULL pointer dereference) and inhibit the
error recovery process to complete.

This patch makes the health check procedure aware of PCI channel
issues, and in case of error recovery process, the function
aac_adapter_check_health() returns -1 and let the recovery process
to complete successfully. This patch was tested on upstream kernel
v4.11-rc5 in PowerPC ppc64le architecture with adapter 9005:028d
(VID:DID) - the error recovery procedure was able to recover fine.

Fixes: 5c63f7f710bd ("aacraid: Added EEH support")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
 drivers/scsi/aacraid/aacraid.h | 11 ++++++++---
 drivers/scsi/aacraid/commsup.c |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d036a806f31c..d281492009fb 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1690,9 +1690,6 @@ struct aac_dev
 #define aac_adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4) \
 	(dev)->a_ops.adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4)
 
-#define aac_adapter_check_health(dev) \
-	(dev)->a_ops.adapter_check_health(dev)
-
 #define aac_adapter_restart(dev, bled, reset_type) \
 	((dev)->a_ops.adapter_restart(dev, bled, reset_type))
 
@@ -2615,6 +2612,14 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 	return capacity;
 }
 
+static inline int aac_adapter_check_health(struct aac_dev *dev)
+{
+	if (unlikely(pci_channel_offline(dev->pdev)))
+		return -1;
+
+	return (dev)->a_ops.adapter_check_health(dev);
+}
+
 /* SCp.phase values */
 #define AAC_OWNER_MIDLEVEL	0x101
 #define AAC_OWNER_LOWLEVEL	0x102
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index c8172f16cf33..1f4918355fdb 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1873,7 +1873,8 @@ int aac_check_health(struct aac_dev * aac)
 	spin_unlock_irqrestore(&aac->fib_lock, flagv);
 
 	if (BlinkLED < 0) {
-		printk(KERN_ERR "%s: Host adapter dead %d\n", aac->name, BlinkLED);
+		printk(KERN_ERR "%s: Host adapter is dead (or got a PCI error) %d\n",
+				aac->name, BlinkLED);
 		goto out;
 	}
 
-- 
2.11.0
