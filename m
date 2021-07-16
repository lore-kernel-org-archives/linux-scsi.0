Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A297C12002
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 19:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69CDA613FB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 19:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhGPTeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 15:34:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232897AbhGPTem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jul 2021 15:34:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626463907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=KeSyheTSekXEMQGa/eiEM4Ezddm+G93OaxD1X1K3A7M=;
        b=CdV4ND3Jti1XRVXcN4ykahWZHNw+sNg+B12ODwnYtTXnw+Uy1V8n8Q362dlzRPFhRweRNi
        Cx80zOwEM2l+SHw4fZAg8Af9y1cbKdDpd2EZtpQYBMfUPXGG5ev/2STPmrdvGxQpi65uYH
        otbnpZmK2znjg8SHMUiz/KJTZzxAifg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-LlhQaJzzPWWx2oslK2h57Q-1; Fri, 16 Jul 2021 15:31:46 -0400
X-MC-Unique: LlhQaJzzPWWx2oslK2h57Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B98431023F40;
        Fri, 16 Jul 2021 19:31:44 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-195.rdu2.redhat.com [10.10.114.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8DAA60862;
        Fri, 16 Jul 2021 19:31:43 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
        loberman@redhat.com, djeffery@redhat.com,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH] scsi: sd: only print initial write protect status if enabled
Date:   Fri, 16 Jul 2021 15:31:40 -0400
Message-Id: <20210716193140.25591-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Having a write protect status of zero is generally the assumed
state when a scsi attached disk is presented to the kernel. For
this reason, only print the state of write protect if it is
enabled. If the user needs the write protect status, sysfs can
easily be checked after boot. As an additional positive
consequence, this change will decrease the chattiness of scsi
scan logging which has been shown to overwhelm systems when
thousands of sd devices are attached.

Signed-off-by: John Pittman <jpittman@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b8d55af763f9..30c549cdf35f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2702,8 +2702,8 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
-			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-				  sdkp->write_prot ? "on" : "off");
+			if (sdkp->write_prot)
+				sd_printk(KERN_NOTICE, sdkp, "Write Protect is on");
 			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
 		}
 	}
-- 
2.17.2

