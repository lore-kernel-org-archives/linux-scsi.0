Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE67AC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948682067B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r7yyv8M7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgFOGql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 02:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgFOGqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 02:46:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E4BC061A0E;
        Sun, 14 Jun 2020 23:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xtyx9uoKMYq+HMFU16+7Gs+ZbH0KWY7ZWnCdcrwcIb8=; b=r7yyv8M74ozs+RSHz6+EEeqA8/
        vo2BHajJ3VH0/9RAeQeSN4pg7EyfkqrmtDugvYBB9FE2Xjj6EttYrzmHyK6QT+w/0HrSJFwSecwBZ
        TZQyi9VkwrtT+La5/NdY5kDHVaflSLDkjzVn9gcd7sJWFytgT8d+I2zfr3C/vN9rbSp61pGRphcjV
        yGIwR29ZU+M2kd14lZNx2PnylncFbFa1PO5HiMeo3uX1SH9GPGKq6rjKOmGKtwlY2VTLDcVy1FDtj
        vK17oIrGDAOzk+xYcgOpBuA3jh+RLgYn3HazTp/j0vEJwinzEPqn8pkT1QtknBGna0nf6H8poT96Z
        fumQ5GEw==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkit4-0001W1-3B; Mon, 15 Jun 2020 06:46:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     brking@us.ibm.com, jinpu.wang@cloud.ionos.com,
        John Garry <john.garry@huawei.com>, mpe@ellerman.id.au,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 1/2] libata: provide a ata_scsi_dma_need_drain stub for !CONFIG_ATA
Date:   Mon, 15 Jun 2020 08:46:23 +0200
Message-Id: <20200615064624.37317-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615064624.37317-1-hch@lst.de>
References: <20200615064624.37317-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SAS drivers can be compiled with ata support disabled.  Provide a
stub so that the drivers don't have to ifdef around wiring up
ata_scsi_dma_need_drain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/libata.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index af832852e62044..042e584daca73e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1092,7 +1092,11 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #define ATA_SCSI_COMPAT_IOCTL /* empty */
 #endif
 extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);
+#if IS_ENABLED(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
+#else
+#define ata_scsi_dma_need_drain NULL
+#endif
 extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 			    unsigned int cmd, void __user *arg);
 extern bool ata_link_online(struct ata_link *link);
-- 
2.26.2

