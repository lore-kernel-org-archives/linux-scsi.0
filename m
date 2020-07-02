Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0C5C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A107C20B80
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593653206;
	bh=b9mQDorhFC7sS98onQzu+8sJwNkkUMXw0ygqhBTzCHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VWihdJpZzxrI0k/iIUc9lWmmLeNItI4l+t0jAkgeRX89E4913XRQolvN+2b89T4An
	 kTIYkzeb5TQu1iI/WrwTfME8JqyJ/qMRNmP+b9NOuIolKHWzDqiiWfhwEQ6n/RBUT8
	 3Hj9rYozxnNnqpVg2Ktx5K0PyPu8Iq+0AKn01pwQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgGBB0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgGBB0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2396C206BE;
        Thu,  2 Jul 2020 01:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653203;
        bh=b9mQDorhFC7sS98onQzu+8sJwNkkUMXw0ygqhBTzCHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrURyBMO++IxzB0S/AlbVqZ+56LmSP+c2Qgs/abjq8pVJXGgXf5vd/WR8fV9m/C9s
         jKPeDG4wPu+ZSiJN9DlNtG27nbfkf4xxEOZ3FZvxodQY+1C+m6ZogOt7lxS1kw8ssf
         Q2UayqYNUl7ekFqN6JjYkryxUnIi8215RyjXv3KI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Henzl <thenzl@redhat.com>,
        Stanislav Saner <ssaner@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/27] scsi: mptscsih: Fix read sense data size
Date:   Wed,  1 Jul 2020 21:26:10 -0400
Message-Id: <20200702012615.2701532-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
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
index 6ba07c7feb92b..2af7ae13449d3 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -118,8 +118,6 @@ int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 int 		mptscsih_resume(struct pci_dev *pdev);
 #endif
 
-#define SNS_LEN(scp)	SCSI_SENSE_BUFFERSIZE
-
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -2420,7 +2418,7 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 		/* Copy the sense received into the scsi command block. */
 		req_index = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 		sense_data = ((u8 *)ioc->sense_buf_pool + (req_index * MPT_SENSE_BUFFER_ALLOC));
-		memcpy(sc->sense_buffer, sense_data, SNS_LEN(sc));
+		memcpy(sc->sense_buffer, sense_data, MPT_SENSE_BUFFER_ALLOC);
 
 		/* Log SMART data (asc = 0x5D, non-IM case only) if required.
 		 */
-- 
2.25.1

