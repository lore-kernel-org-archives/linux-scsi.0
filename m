Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989F8C33CB3
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 16:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649CF20663
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579193413;
	bh=W5GsXPgetj+H1lgqnH7m0kOe+yhVb2jMSSzjWLFHHfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=C8AH8MfmTM/vikFdF0fwlaxTz3Fd3753FSo2iJ7RNodlQexx9uu6gdRv1GXGfoL6a
	 Ayk1BUdR2qXI7AocrmZtFemcGFIZILHwhgIwYc9fZlSJZruuZ9s53J1vi56+L6cXMJ
	 njwfUtHziHHiRgSQ/yfLDaOzAeifa0/M1MiaCec0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgAPQrz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgAPQrv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD9120663;
        Thu, 16 Jan 2020 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193270;
        bh=W5GsXPgetj+H1lgqnH7m0kOe+yhVb2jMSSzjWLFHHfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGfsOCotVZtKU70uk+2cd1ZqfRex4mMdMfhFkr0hnUuHmAGdq9AT7tJ2cynbArc77
         x4UQ65e2+9dcdf77Q3BlQQEKx5RsNj9hnSKW8XGkoXlqkI1SKKTjhdSbvh/U6oXx0U
         VRnXS8OGt2c8xABnpNuiv7hS267wVXi21Up9xubE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 061/205] scsi: esas2r: unlock on error in esas2r_nvram_read_direct()
Date:   Thu, 16 Jan 2020 11:40:36 -0500
Message-Id: <20200116164300.6705-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 906ca6353ac09696c1bf0892513c8edffff5e0a6 ]

This error path is missing an unlock.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Link: https://lore.kernel.org/r/20191022102324.GA27540@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/esas2r/esas2r_flash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 7bd376d95ed5..b02ac389e6c6 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -1197,6 +1197,7 @@ bool esas2r_nvram_read_direct(struct esas2r_adapter *a)
 	if (!esas2r_read_flash_block(a, a->nvram, FLS_OFFSET_NVR,
 				     sizeof(struct esas2r_sas_nvram))) {
 		esas2r_hdebug("NVRAM read failed, using defaults");
+		up(&a->nvram_semaphore);
 		return false;
 	}
 
-- 
2.20.1

