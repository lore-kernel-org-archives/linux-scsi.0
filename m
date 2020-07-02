Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00434C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F09206BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593653559;
	bh=d57Z06bRJknnqjS3Wp/YqNK1f++WDqjwuAwuq9k2yN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=L/MW53iJJ6H9XiFoCy3vl1axOEDitM3tbAy8+Tty5r5VwsvqkrPp3SLLPIVLWLURR
	 0XVo9AyadU8m8KxVf8jQDZPnW7NTu0FWCDt3o+LNJ5izi0DmRfmg+e+Xx1DR3Z6gOy
	 bdwO3t77MGDXKxRU91VzEGIXFkhgbTZcDjwLP7K0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgGBB0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgGBB0H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C8DF2083E;
        Thu,  2 Jul 2020 01:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653167;
        bh=d57Z06bRJknnqjS3Wp/YqNK1f++WDqjwuAwuq9k2yN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwqHZR7htj68mVopc/JqdaH8Fum/3vKEs0DfXppvciA9n+HSAG3nzqEWdR83AdvNj
         GsJIYVnkTtlPxbyq87+1RAkMhKk6YhNazpbEknrO0cZEn74giVyby46YzZA2Zm1TKf
         MkS7+7sni7VeFBtqEuqU5xbg3X1O65s5AigJ3Bog=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Henzl <thenzl@redhat.com>,
        Stanislav Saner <ssaner@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/40] scsi: mptscsih: Fix read sense data size
Date:   Wed,  1 Jul 2020 21:23:55 -0400
Message-Id: <20200702012402.2701121-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012402.2701121-1-sashal@kernel.org>
References: <20200702012402.2701121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit afe89f115e84edbc76d316759e206580a06c6973 ]

The sense data buffer in sense_buf_pool is allocated with size of
MPT_SENSE_BUFFER_ALLOC(64) (multiplied by req_depth) while SNS_LEN(sc)(96)
is used when reading the data.  That may lead to a read from unallocated
area, sometimes from another (unallocated) page.  To fix this, limit the
read size to MPT_SENSE_BUFFER_ALLOC.

Link: https://lore.kernel.org/r/20200616150446.4840-1-thenzl@redhat.com
Co-developed-by: Stanislav Saner <ssaner@redhat.com>
Signed-off-by: Stanislav Saner <ssaner@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/message/fusion/mptscsih.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index f0737c57ed5fc..1491561d2e5c9 100644
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
2.25.1

