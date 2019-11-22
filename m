Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8F6C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 06:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC85720708
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 06:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403424;
	bh=krRnmuaqC7qVirxcwWinxCXHxJDjFmPmqqWCcCAM/RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0xufF1zFn/m5i3Wvr6ZO9R71+0lM+IZnSYSlQIW1QO7DHDWegXl3UXQld62fDrJNZ
	 jqZt1PPcnRWVNrv50mtmS+Wv1lR1SZaUqm58n8QTjNYtenWUixakPltKOGBPAKmGE+
	 pBIqvm4Jlp0/uuh8XxI63JKpALuuO4XsHA7G+P18=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfKVGQr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfKVGNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8B52068E;
        Fri, 22 Nov 2019 06:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403223;
        bh=krRnmuaqC7qVirxcwWinxCXHxJDjFmPmqqWCcCAM/RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeCMiuaQUvh99xGE8hoRYnQuxEBuIKXtOLjFST0QIjQwBkUsuOCVivo8iTgjSI28S
         Hge6wrYUlay4sx1xBFlBqY9TXLxWLPFfOmLJDDccWoXHVTglZsoohjZzI4u5jNe7X1
         5EhwZ3fp7RXUOSzAUG1YL1gDVR8NY2/xUKSucOtM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 37/68] scsi: csiostor: fix incorrect dma device in case of vport
Date:   Fri, 22 Nov 2019 01:12:30 -0500
Message-Id: <20191122061301.4947-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 9934613edcb40b92a216122876cd3b7e76d08390 ]

In case of ->vport_create() call scsi_add_host_with_dma() instead of
scsi_add_host() to pass correct dma device.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index dbe416ff46c27..776b992786881 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -648,7 +648,7 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
 	if (csio_lnode_init(ln, hw, pln))
 		goto err_shost_put;
 
-	if (scsi_add_host(shost, dev))
+	if (scsi_add_host_with_dma(shost, dev, &hw->pdev->dev))
 		goto err_lnode_exit;
 
 	return ln;
-- 
2.20.1

