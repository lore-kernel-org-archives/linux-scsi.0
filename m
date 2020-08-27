Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B538C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 16:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41C2222CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 16:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjCsDJuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgH0Qxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:53:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726323AbgH0Qxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 12:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598547217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XSS20yJqzblct8HVFUbbMyuik467DBMVJ9EOWWHhkZU=;
        b=cjCsDJuAI03E1gfmG8X/RHfCiS9Oi+Lsvt2gVySInm0rkTbANLfXsh2QfcEjioP9auNNe/
        lkkEDj3lkjUcCct+mi6gXw+0pRgj4CMOwEoO3KKK5yYg2nbOHbKhMADVHOfHmCozaC9Sdv
        OXQcSfHEiUJCBx7fJP+o4Agi2rIRMuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-lzA0B5AEMfOfKKIpH_hx9Q-1; Thu, 27 Aug 2020 12:53:35 -0400
X-MC-Unique: lzA0B5AEMfOfKKIpH_hx9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 485A2420E8;
        Thu, 27 Aug 2020 16:53:34 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.195.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 369A77A4D2;
        Thu, 27 Aug 2020 16:53:33 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Subject: [PATCH] scsi: megaraid_sas: Don't call disable_irq from process IRQ poll
Date:   Thu, 27 Aug 2020 18:53:32 +0200
Message-Id: <20200827165332.8432-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

disable_irq might sleep, replace it with disable_irq_nosync which is sufficient,
irq_poll_scheduled protects againt running complete_cmd_fusion in parallel
from megasas_irqpoll and megasas_isr_fusion.

Fixes: a6ffd5bf681 scsi: megaraid_sas: Call disable_irq from process IRQ poll
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 319f241da..766bc2bb1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3690,7 +3690,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 	instance = irq_ctx->instance;
 
 	if (irq_ctx->irq_line_enable) {
-		disable_irq(irq_ctx->os_irq);
+		disable_irq_nosync(irq_ctx->os_irq);
 		irq_ctx->irq_line_enable = false;
 	}
 
-- 
2.25.4

