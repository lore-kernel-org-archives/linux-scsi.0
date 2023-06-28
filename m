Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D1BEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 15:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjF1PIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 11:08:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231208AbjF1PIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2023 11:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687964873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2nVO6tSp+XXSaxCVRxFDWreK5qTv77fQcvdGnm+J0D4=;
        b=LUOdECssbyvCJTuVjEREER1sZ1eCNEcgveemcQDtYdeJRgB62y86bjcFqa6ML3UcyC2K2b
        DZd4IDJj2gE7rFaZpmUknKxnbncSum2XzK4Yx5Cy1Tk6OifJ1iwf6IudI4C/a2CrWMUOSo
        7abbjEv9Gn4PUhb9q1aH2gLGfEvkdto=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-2kzSRf5kOoSt6_r6p54JQg-1; Wed, 28 Jun 2023 11:07:18 -0400
X-MC-Unique: 2kzSRf5kOoSt6_r6p54JQg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0768B3C1CCEB;
        Wed, 28 Jun 2023 15:06:41 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C973848FB01;
        Wed, 28 Jun 2023 15:06:39 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: remove dead code
Date:   Wed, 28 Jun 2023 17:06:38 +0200
Message-Id: <20230628150638.53218-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ramdisk rwlocks are not used anymore

Fixes: 87c715dcde63 ("scsi: scsi_debug: Add per_host_store option")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_debug.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8c58128ad32a..9c0af50501f9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -841,11 +841,6 @@ static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static int poll_queues; /* iouring iopoll interface.*/
 
-static DEFINE_RWLOCK(atomic_rw);
-static DEFINE_RWLOCK(atomic_rw2);
-
-static rwlock_t *ramdisk_lck_a[2];
-
 static char sdebug_proc_name[] = MY_NAME;
 static const char *my_name = MY_NAME;
 
@@ -6818,9 +6813,6 @@ static int __init scsi_debug_init(void)
 	int k, ret, hosts_to_add;
 	int idx = -1;
 
-	ramdisk_lck_a[0] = &atomic_rw;
-	ramdisk_lck_a[1] = &atomic_rw2;
-
 	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
 		pr_warn("ndelay must be less than 1 second, ignored\n");
 		sdebug_ndelay = 0;
-- 
2.39.3

