Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DC0C35247
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 15:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A8022082E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 15:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jC2lVX+x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgBDPYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:24:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43584 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727305AbgBDPYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 10:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580829861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uLNYjInZmuSB8p1vTFVvtLlVJKCKerG2KH+Xn1fvgmI=;
        b=jC2lVX+x6k876WrRkABoevBLJ5wdEZB5dJe32CrOcbwUy09+N+7O5bU9Ln+eYKHUQZn2nl
        oDPUr3H5jrgqngj+y5IL046hXZ2eFJxfLBq3BiHbB9yhyRUWTLRPZe1A4CT8dNwOqlUBxp
        s4iJONBKdn77ks6liShF0MwjlS8KA5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-ROffcyp5OJun87cGKwsmVg-1; Tue, 04 Feb 2020 10:24:17 -0500
X-MC-Unique: ROffcyp5OJun87cGKwsmVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4637ADB23;
        Tue,  4 Feb 2020 15:24:16 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.43.2.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4552C5C1B5;
        Tue,  4 Feb 2020 15:24:15 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        lduncan@suse.com
Subject: [PATCH V2] megaraid_sas: silence a warning
Date:   Tue,  4 Feb 2020 16:24:13 +0100
Message-Id: <20200204152413.7107-1-thenzl@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a flag to dma mem allocation to silence a warning.

This code allocates DMA memory for driver's IO frames which may exceed
MAX_ORDER pages for few megaraid_sas controllers(controllers
with High Queue Depth). So there is logic to keep on reducing controller
Queue Depth until DMA memory required for IO frames fits within
MAX_ORDER. So or impacted megaraid_sas controllers,
there would be multiple DMA allocation failure until driver settles
down to Controller Queue Depth which has memory requirement
within MAX_ORDER. These failed DMA allocation requests causes stack
traces in system logs which is not harmful and this patch
would silence those warnings/stack traces.

With CMA (Contiguous Memory Allocator) enabled, it's possible  to
allocate DMA memory exceeding MAX_ORDER.
And that is the reason of keeping this retry logic with less
controller Queue Depth instead of calculating controller Queue depth
at first hand which has memory requirement less than MAX_ORDER.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
V2: A change in the description, additional information is added,
kindly written by Sumit.

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/m=
egaraid/megaraid_sas_fusion.c
index 0f5399b3e..1fa2d1449 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -606,7 +606,8 @@ megasas_alloc_request_fusion(struct megasas_instance =
*instance)
=20
 	fusion->io_request_frames =3D
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				GFP_KERNEL, &fusion->io_request_frames_phys);
+				GFP_KERNEL | __GFP_NOWARN,
+				&fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
 		if (instance->max_fw_cmds >=3D (MEGASAS_REDUCE_QD_COUNT * 2)) {
 			instance->max_fw_cmds -=3D MEGASAS_REDUCE_QD_COUNT;
@@ -644,7 +645,7 @@ megasas_alloc_request_fusion(struct megasas_instance =
*instance)
=20
 		fusion->io_request_frames =3D
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				       GFP_KERNEL,
+				       GFP_KERNEL | __GFP_NOWARN,
 				       &fusion->io_request_frames_phys);
=20
 		if (!fusion->io_request_frames) {
--=20
2.21.1

