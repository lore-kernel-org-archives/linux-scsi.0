Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B675C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 17:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E42020707
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 17:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0uZj6Zy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404130AbgFYRM3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 13:12:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404083AbgFYRM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 13:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593105147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L7q/q0B64Z88wSL1s6uDF2PpyGaTVUVAi/hdXuSecyg=;
        b=O0uZj6ZylcWeye8FLML7eC4T4ZDZadWFNWlmPzuVsmpJYANM8bcMg7geCOjERhbGjp6DQX
        QqUJbcf6fRnLXIbOTLqkkE6hIlEgk1H9gIQ9kAXMrMChbfMLsezijXoNYZAuogWKpwxN+8
        4RIzHilBsdNtQiJuEyESiQYavcWbj3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-MPnraenqPI6Kw0dJhao3jQ-1; Thu, 25 Jun 2020 13:12:23 -0400
X-MC-Unique: MPnraenqPI6Kw0dJhao3jQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8423518585A0;
        Thu, 25 Jun 2020 17:12:22 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.192.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79E612B4B0;
        Thu, 25 Jun 2020 17:12:21 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Subject: [PATCH] megaraid_sas: clear affinity hint
Date:   Thu, 25 Jun 2020 19:12:20 +0200
Message-Id: <20200625171220.9168-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Affinity hint should be cleared before freeing irq.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c..d5626ad8b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5602,9 +5602,11 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 			&instance->irq_context[i])) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
-			for (j = 0; j < i; j++)
+			for (j = 0; j < i; j++) {
+				irq_set_affinity_hint(pci_irq_vector(pdev, j), NULL);
 				free_irq(pci_irq_vector(pdev, j),
 					 &instance->irq_context[j]);
+			}
 			/* Retry irq register for IO_APIC*/
 			instance->msix_vectors = 0;
 			instance->msix_load_balance = false;
@@ -5642,6 +5644,7 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
 
 	if (instance->msix_vectors)
 		for (i = 0; i < instance->msix_vectors; i++) {
+			irq_set_affinity_hint(pci_irq_vector(instance->pdev, i), NULL);
 			free_irq(pci_irq_vector(instance->pdev, i),
 				 &instance->irq_context[i]);
 		}
-- 
2.21.3

