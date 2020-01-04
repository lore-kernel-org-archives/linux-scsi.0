Return-Path: <SRS0=nD9h=2Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73FDC32767
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 03:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 841CD24676
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jan 2020 03:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578109043;
	bh=ZmS3ecpNKbKpZ80YMGwX6STvyWgGYbJUG1w6hAEWutk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oQTnNcVy1QDLJ7EAdmGhw5s72j23XYo+5PdkrIiFM1aBkHEdw+W8xXOizyp/g7lOO
	 5fAeUK0Mux+840eLkak6VcbdeKJbjPzMY5/f+ipOEVmEaXzBjpBh2i185ghS3O6vYD
	 HR1t+p6z/BDZtbQ1vcebYFb8olLox1zw0SXrsYwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgADDhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 22:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgADDhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Jan 2020 22:37:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22B72464B;
        Sat,  4 Jan 2020 03:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578109026;
        bh=ZmS3ecpNKbKpZ80YMGwX6STvyWgGYbJUG1w6hAEWutk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqD6bcmsAZi/9Mu0QxtgBJ0szrLJfUrATGRaOYFu3V4vtT1j0bx+E182zojWz9EzU
         7ICaSGouiy1Fv6GWIXD4PMIHXECDEorRHVq2tM4ocFpc//PyX4o/Loa7veUV6Tye2T
         TrX8trX5y0Zxdt8vHA2BdP0GCuEibRNDYb0Afe64=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()
Date:   Fri,  3 Jan 2020 22:37:01 -0500
Message-Id: <20200104033702.11304-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033702.11304-1-sashal@kernel.org>
References: <20200104033702.11304-1-sashal@kernel.org>
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
index e974106f2bb5..3d6e653f5147 100644
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

