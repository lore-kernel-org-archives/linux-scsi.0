Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301D5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 20:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiEWUBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiEWUBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 16:01:44 -0400
X-Greylist: delayed 3597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 May 2022 13:01:42 PDT
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E904C5DBE6
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 13:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Rp6lg8HRxHqDig1j8uGr1UUFpGMW7dGsFYdyux2VykY=; b=nuzm9p5cMtUx2sOubl3SLEafkR
        h04F34Xvj2nj4+R+NCJL24X9mjw2rgdEpcmnQQGU7wk+eHHNOE0vdSou98k4rOAHBCWu5Ir/j4VC+
        tXsIQLdnioJ1I0wCrN62BSb8e8XLOYqilvXDSixkxwXZbSlRgkL2XnxwryXtXNvyiV+CColOTrLNN
        BxniHCVJWiXU/4NvSNTEgPDFvDARQxEIi2rXM3D6pM0myNsLOHBsqtM4mb6ZntWetb7lLoX8MhE7M
        sxSLdpECITp93dd797OCpJLYa/bxfEo+qiI0hjPWsLQZKr+TfmZuTFSCDiK/fOudrciWyKBu0FGOs
        3no4g3lQ==;
Received: from [2001:4bb8:19a:6dab:5f72:16bd:9d04:6b8a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nt3aK-002V5s-Op; Mon, 23 May 2022 08:38:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: unexport scsi_bus_type
Date:   Mon, 23 May 2022 10:38:38 +0200
Message-Id: <20220523083838.227987-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_bus_type is not used by any code outside of scsi_mod.ko.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_sysfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dc6872e352bd4..81b6ca75f395f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -560,7 +560,6 @@ struct bus_type scsi_bus_type = {
 	.pm		= &scsi_bus_pm_ops,
 #endif
 };
-EXPORT_SYMBOL_GPL(scsi_bus_type);
 
 int scsi_sysfs_register(void)
 {
-- 
2.30.2

