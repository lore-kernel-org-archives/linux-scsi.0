Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5205AC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 14:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiGVOZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 10:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiGVOZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 10:25:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9B33B0A
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 07:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658499904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q2mGRXz22bkMOk7xLIcJYRLD2bboN65vI3Em/QI2a08=;
        b=ChdZndQ8Z7HSBGdovi3ITcueoU4a2yzpIOGyDoC/WX6dsp+xdHoCoDbT5zEjpFjQHRT0m7
        Ja5jL4Avtn1K3ULRbGFzd4Ccf0I9kRBmlWwdugue5kyhcZ6QVch54gYUujLDJfp1Klgyzn
        3cj0svSLGKnyfNouzNsovMkELEcZ/M8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-qUuK0DkHOeWPd3hCEMVgIw-1; Fri, 22 Jul 2022 10:25:01 -0400
X-MC-Unique: qUuK0DkHOeWPd3hCEMVgIw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48DDD1C006AD;
        Fri, 22 Jul 2022 14:25:01 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.10.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11A18492C3B;
        Fri, 22 Jul 2022 14:25:01 +0000 (UTC)
From:   David Jeffery <djeffery@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>
Subject: [PATCH] scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown
Date:   Fri, 22 Jul 2022 10:24:48 -0400
Message-Id: <20220722142448.6289-1-djeffery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system shutdown or reboot, mpt3sas will reset the firmware back to
ready state. However, the driver leaves running a watchdog work item
intended to keep the firmware in operational state. This causes a second,
unneeded reset on shutdown and moves the firmware back to operational
instead of in ready state as intended. And if the mpt3sas_fwfault_debug
module parameter is set, this extra reset also panics the system.

mpt3sas's scsih_shutdown needs to stop the watchdog before resetting the
firmware back to ready state.

Fixes: fae21608c31c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b519f4b59d30..5e8887fa02c8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11386,6 +11386,7 @@ scsih_shutdown(struct pci_dev *pdev)
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
+	mpt3sas_base_stop_watchdog(ioc);
 	ioc->shost_recovery = 1;
 	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 	ioc->shost_recovery = 0;
-- 
2.36.1

