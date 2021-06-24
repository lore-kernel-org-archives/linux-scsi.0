Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC03C49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 15:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C217613C3
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 15:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhFXPLB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 11:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhFXPLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 11:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624547321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wNLa2WobbiA13MiMpsOz6j83JgtxjcaGBkyp5lqAG6k=;
        b=AkUAm31XD9lo1J2BGwO/AALnDvM07cjBSj8Ci4DHnXtWj8JZtzTAS8AH2+CQt5YMFlq10m
        Yir2vz6PYVGP3xOEPdEM2IOxXg/cELTSrxguzrc97kKrmIrnG4PL8j2wngEawfQLUwq/P2
        pOpF5I6V0NCndtulXpqz18vau8MEGyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-bTkPGkT_PROnwmDVicTNAw-1; Thu, 24 Jun 2021 11:08:40 -0400
X-MC-Unique: bTkPGkT_PROnwmDVicTNAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AAD4106B7D8;
        Thu, 24 Jun 2021 15:08:39 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.43.2.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64E0360916;
        Thu, 24 Jun 2021 15:08:38 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
Subject: [PATCH] mpt3sas: a shutdown fix
Date:   Thu, 24 Jun 2021 17:08:37 +0200
Message-Id: <20210624150837.9950-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A driver doesn't have to to free allocated memory when in shutdown
it is enough when it quiesces itself. This patch hardens the driver
when additional commands are queued after .shutdown has been called.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index dc2aaaf645d3..1885d13005cb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11293,7 +11293,7 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
-	mpt3sas_base_detach(ioc);
+	mpt3sas_base_stop_watchdog(ioc);
 }
 
 
-- 
2.31.1

