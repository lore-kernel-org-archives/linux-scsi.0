Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADF2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 13:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B5320672
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 13:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QDES/ODE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGINbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 09:31:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39545 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726410AbgGINbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 09:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594301511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nlT/8S1sba7V2w20LJ6GZvHdob85iKTm4kvAJN5chOM=;
        b=QDES/ODEv5+V/1T8q1WO2oYs4lMcM1nOqz4/v5TslK5tt9reDIFF5rAlshGCOGkuSDN4wx
        RlHkuV44NVUvQFJ6v4FVMow8H6VSPXvsZeSOzZOCt0nfjSFQkvMkwv156dY//xGz+PHIqX
        Sayus6XtVe7EE1+XDIWdjMzDQZ0m/lc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-64GkH9RkMX27HyZs5mProA-1; Thu, 09 Jul 2020 09:31:48 -0400
X-MC-Unique: 64GkH9RkMX27HyZs5mProA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD2BE1800D42;
        Thu,  9 Jul 2020 13:31:46 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.195.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B95CE1A888;
        Thu,  9 Jul 2020 13:31:45 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Subject: [PATCH V2] megaraid_sas: clear affinity hint
Date:   Thu,  9 Jul 2020 15:31:44 +0200
Message-Id: <20200709133144.8363-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To avoid a warning in free_irq, clear the affinity hint.

Fixes: f0b9e7bdc309e8cc63a640009715626376e047c6 ("scsi: megaraid_sas: Set affinity for high IOPS reply queues")

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
V2: Added 'Fixes' and low_latency_index_start check as
asked by Sumit.

 drivers/scsi/megaraid/megaraid_sas_base.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a378facdd..b40279ae5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5596,9 +5596,13 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 			&instance->irq_context[i])) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
-			for (j = 0; j < i; j++)
+			for (j = 0; j < i; j++) {
+				if (j < instance->low_latency_index_start)
+					irq_set_affinity_hint(
+						pci_irq_vector(pdev, j), NULL);
 				free_irq(pci_irq_vector(pdev, j),
 					 &instance->irq_context[j]);
+			}
 			/* Retry irq register for IO_APIC*/
 			instance->msix_vectors = 0;
 			instance->msix_load_balance = false;
@@ -5636,6 +5640,9 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
 
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
+			if (i < instance->low_latency_index_start)
+				irq_set_affinity_hint(
+				    pci_irq_vector(instance->pdev, i), NULL);
 			free_irq(pci_irq_vector(instance->pdev, i),
 				 &instance->irq_context[i]);
 		}
-- 
2.21.3

