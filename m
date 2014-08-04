From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v1.3 18/18] arcmsr: replace flush_scheduled_work() by
 flush_work()
Date: Mon, 04 Aug 2014 18:31:41 +0800
Message-ID: <1407148301.4756.117.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61667 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaHDKbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2014 06:31:48 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so9439968pdj.28
        for <linux-scsi@vger.kernel.org>; Mon, 04 Aug 2014 03:31:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

To prevent flushing entire workqueue, replace flush_scheduled_work() by flush_work().

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:47:02.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:47:12.000000000 +0800
@@ -841,7 +841,7 @@ static int arcmsr_suspend(struct pci_dev
 	intmask_org = arcmsr_disable_outbound_ints(acb);
 	arcmsr_free_irq(pdev, acb);
 	del_timer_sync(&acb->eternal_timer);
-	flush_scheduled_work();
+	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 	arcmsr_enable_outbound_ints(acb, intmask_org);


