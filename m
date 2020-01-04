Return-Path: <SRS0=nD9h=2Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F526C00523
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 03:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C6A5217F4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 03:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578109060;
	bh=McUFwkqgq1B3keNDLMTz9JF50vJdyj1xjoKR7hsJxRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=drdg3+KHtDwjaE8msTYv2BVVwKQElCOSzImGPB2gS8scw75+CYcy77Tz+xysXhS/M
	 5oSDk/LM6L2TNGgwUJBuwaBHhEh+Vl3lWe3io9r+brj7RMuLGKG0NgmuVSOsha9I9o
	 zVJRjYNl9nL+UR/gteC71or0+pmJpL7pkU3vvTM0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgADDgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 22:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgADDgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC562465A;
        Sat,  4 Jan 2020 03:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578109008;
        bh=McUFwkqgq1B3keNDLMTz9JF50vJdyj1xjoKR7hsJxRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxelU5rlt0cSlbt3a0XOMiE6raa0Nm8ZQ8gS+wohRjLs/OmREJAo0yH4NUX628417
         3nK1FOekUS7fjBgcJPegIklrSFOIT7I24vDOGytqEjBEsZM4RWX4W5VAl72jz19hTM
         pUlvfgWx3HC7/gbHwwULG4d00wS/iL3jFgCnwTVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/5] scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()
Date:   Fri,  3 Jan 2020 22:36:42 -0500
Message-Id: <20200104033644.11121-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033644.11121-1-sashal@kernel.org>
References: <20200104033644.11121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 71482fde704efdd8c3abe0faf34d922c61e8d76b ]

If cxgb4i_ddp_init() fails then cdev->cdev2ppm will be NULL, so add a check
for NULL pointer before dereferencing it.

Link: https://lore.kernel.org/r/1576676731-3068-1-git-send-email-varun@chelsio.com
Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/cxgbi/libcxgbi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index cd2c247d6d0c..559d8bda4cca 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -121,7 +121,8 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
 		"cdev 0x%p, p# %u.\n", cdev, cdev->nports);
 	cxgbi_hbas_remove(cdev);
 	cxgbi_device_portmap_cleanup(cdev);
-	cxgbi_ppm_release(cdev->cdev2ppm(cdev));
+	if (cdev->cdev2ppm)
+		cxgbi_ppm_release(cdev->cdev2ppm(cdev));
 	if (cdev->pmap.max_connect)
 		cxgbi_free_big_mem(cdev->pmap.port_csk);
 	kfree(cdev);
-- 
2.20.1

