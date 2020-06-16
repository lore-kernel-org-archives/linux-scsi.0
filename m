Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E6BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 15:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9D320644
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 15:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNg/dKKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgFPPEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:04:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38540 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729161AbgFPPEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 11:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592319891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WInRxfdr4eZeODFgcLKE7FCsEl2xVFTQihm9EJeMp50=;
        b=fNg/dKKGEqR3ctiK/Yn7CGAocaryjY7EH697wCpF6QeC+fZvIEUqUYi/0FfRRjAjk7S2aP
        t2NveobMak1pZJ/BtoIEDF6SZ194WyrQ+nNrrulMNbX8gU+1PGJgILIjs4eBrnJF3z7Ze1
        YNWEaQ1SE9qdL9IWfgZKyxvDkASRyLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-YXsoWeAJMT-PE2Gol0X59Q-1; Tue, 16 Jun 2020 11:04:48 -0400
X-MC-Unique: YXsoWeAJMT-PE2Gol0X59Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 077FF18A2663;
        Tue, 16 Jun 2020 15:04:48 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.194.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 278655D9D3;
        Tue, 16 Jun 2020 15:04:46 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     ssaner@redhat.com, sreekanth.reddy@broadcom.com
Subject: [PATCH] mptscsih: fix read sense data size
Date:   Tue, 16 Jun 2020 17:04:46 +0200
Message-Id: <20200616150446.4840-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sense data buffer in sense_buf_pool is allocated with
size of MPT_SENSE_BUFFER_ALLOC(64) (multiplied by req_depth)
while SNS_LEN(sc)(96) is used when reading the data.
That may lead to a read from unallocated area,
sometimes from another (unallocated) page.
To fix this limit the read size to MPT_SENSE_BUFFER_ALLOC.

Co-developed-by: Stanislav Saner <ssaner@redhat.com>
Signed-off-by: Stanislav Saner <ssaner@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/message/fusion/mptscsih.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index f0737c57e..1491561d2 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -118,8 +118,6 @@ int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 int 		mptscsih_resume(struct pci_dev *pdev);
 #endif
 
-#define SNS_LEN(scp)	SCSI_SENSE_BUFFERSIZE
-
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -2422,7 +2420,7 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 		/* Copy the sense received into the scsi command block. */
 		req_index = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 		sense_data = ((u8 *)ioc->sense_buf_pool + (req_index * MPT_SENSE_BUFFER_ALLOC));
-		memcpy(sc->sense_buffer, sense_data, SNS_LEN(sc));
+		memcpy(sc->sense_buffer, sense_data, MPT_SENSE_BUFFER_ALLOC);
 
 		/* Log SMART data (asc = 0x5D, non-IM case only) if required.
 		 */
-- 
2.21.3

