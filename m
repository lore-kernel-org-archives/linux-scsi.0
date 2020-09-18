Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A9EC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 846FE21582
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600399007;
	bh=ZnLj/QanGbny801H/qtAJkF9ao4X/iYTvxHzv8kHxjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=y9vsEyYhmmHBSlBL+XPgvb9N5BtFmJaeByDhKZFjiq79T9oUudyBCnD4ifsaIKVoq
	 PBfjhyWAysx2pIks3m61rTqeaCQMTLybbmv4uHU328nDahrApZHnnXEnTbVDCBYP+K
	 zMGEDG2W2I8HbFP66O8nU1n2WbIotJJ5RjgSxLYI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIRCBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgIRCBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F2F2137B;
        Fri, 18 Sep 2020 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394476;
        bh=ZnLj/QanGbny801H/qtAJkF9ao4X/iYTvxHzv8kHxjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhxEY5JypYHKYOdzTGsjWzrKYStU80Zax6/hlpsJWIZWhgHwADJANx/CuIyfyCsWu
         q4D/ch7lUA7n7hWPIoK88WH1q4ZD61MAiiDVzpxbAk5AqFARzaCE9TRw1XEd4gVo3L
         MdXWswwitmzHEeCnR2eUHXhzZmbaYFwMEZjgQU0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 004/330] scsi: mpt3sas: Free diag buffer without any status check
Date:   Thu, 17 Sep 2020 21:55:44 -0400
Message-Id: <20200918020110.2063155-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 764f472ba4a7a0c18107ebfbe1a9f1f5f5a1e411 ]

Memory leak can happen when diag buffer is released but not unregistered
(where buffer is deallocated) by the user. During module unload time driver
is not deallocating the buffer if the buffer is in released state.

Deallocate the diag buffer during module unload time without any diag
buffer status checks.

Link: https://lore.kernel.org/r/1568379890-18347-5-git-send-email-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d5a62fea8fe3e..bae7cf70ee177 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3717,12 +3717,6 @@ mpt3sas_ctl_exit(ushort hbas_to_enumerate)
 		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
 			if (!ioc->diag_buffer[i])
 				continue;
-			if (!(ioc->diag_buffer_status[i] &
-			    MPT3_DIAG_BUFFER_IS_REGISTERED))
-				continue;
-			if ((ioc->diag_buffer_status[i] &
-			    MPT3_DIAG_BUFFER_IS_RELEASED))
-				continue;
 			dma_free_coherent(&ioc->pdev->dev,
 					  ioc->diag_buffer_sz[i],
 					  ioc->diag_buffer[i],
-- 
2.25.1

