From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.2 18/16] arcmsr: replace calling flush_scheduled_work by
 flush_work
Date: Thu, 15 May 2014 18:59:43 +0800
Message-ID: <1400151583.7179.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62236 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaEOK7x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2014 06:59:53 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf12so4098552vcb.15
        for <linux-scsi@vger.kernel.org>; Thu, 15 May 2014 03:59:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From: Ching<ching2048@areca.com.tw>

This is a new patch v1.2 18/16 after patch v1.2 17/16.
To prevent flushing entire workqueue, replace flush_scheduled_work by flush_work.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-14 18:29:30.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-15 17:53:12.000000000 +0800
@@ -845,7 +845,7 @@ static int arcmsr_suspend(struct pci_dev
 	intmask_org = arcmsr_disable_outbound_ints(acb);
 	arcmsr_free_irq(pdev, acb);
 	del_timer_sync(&acb->eternal_timer);
-	flush_scheduled_work();
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 	arcmsr_enable_outbound_ints(acb, intmask_org);


