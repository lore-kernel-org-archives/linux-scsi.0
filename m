Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26704C2D0E1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 21:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3BCB221E3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 21:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Am/wT710"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgIJVW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:22:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58526 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730999AbgIJOXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 10:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599747820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1yJ9ddxR+iNkpyzrpzM7/oFsZpyU2kWzWgFxFpsaZPk=;
        b=Am/wT7100Rf8Pp/4EgQxrD4lgbdLj6aSXrmazV/bImU/wVzk7AOED0/0yv4cWpi/looQup
        XhdXaL5q+lQUZGtiZpZIcxQ7wxRe3djI6eECx0cu+Pj7kcaLtbO08rHhVmGBsaVvsbttyc
        IBiUCpcZOXViqJj4enZdlDhfnZhiBKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-DqereVxkPyeesllvZl-3yg-1; Thu, 10 Sep 2020 10:21:30 -0400
X-MC-Unique: DqereVxkPyeesllvZl-3yg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E232F8DEC68;
        Thu, 10 Sep 2020 14:21:28 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.195.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4A407E73E;
        Thu, 10 Sep 2020 14:21:27 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: [PATCH] mpt3sas: fix sync irqs
Date:   Thu, 10 Sep 2020 16:21:26 +0200
Message-Id: <20200910142126.8147-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- _base_process_reply_queue called from _base_interrupt
may schedule a new irq poll, fix this by calling
synchronize_irq first
- a fix for "Unbalanced enable for IRQ..."
enable_irq should be called only when necessary

Fixes: 320e77acb327 ("scsi: mpt3sas: Irq poll to avoid CPU hard lockups")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++++++++-----
 drivers/scsi/scsi_scan.c            |  8 ++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a85c9672c6ea..a67749c8f4ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1808,18 +1808,22 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
 		/* TMs are on msix_index == 0 */
 		if (reply_q->msix_index == 0)
 			continue;
+		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 		if (reply_q->irq_poll_scheduled) {
 			/* Calling irq_poll_disable will wait for any pending
 			 * callbacks to have completed.
 			 */
 			irq_poll_disable(&reply_q->irqpoll);
 			irq_poll_enable(&reply_q->irqpoll);
-			reply_q->irq_poll_scheduled = false;
-			reply_q->irq_line_enable = true;
-			enable_irq(reply_q->os_irq);
-			continue;
+			/* check how the scheduled poll has ended,
+			 * clean up only if necessary
+			 */
+			if (reply_q->irq_poll_scheduled) {
+				reply_q->irq_poll_scheduled = false;
+				reply_q->irq_line_enable = true;
+				enable_irq(reply_q->os_irq);
+			}
 		}
-		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 	}
 }
 
-- 
2.25.4

