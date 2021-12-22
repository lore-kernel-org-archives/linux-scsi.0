Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E09CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhLVJWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbhLVJWv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:22:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CA7C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=9LQ+wonqxtl/isdk2vaWdJAjCLjF+g1UID+/Wk34n0o=; b=HkOaub9eKBpfKuinr0y1rNGwA8
        3XKzlrNXvY6+2yZyatXxZUgbOln1QqyiH0qhMlMlh9z15IAn2Dx3eNVx8E86Ky+wUtR4gKlfGNv99
        s+c+ms8UaddlFVfyOLpvX+04FKhhhl+x+Ewz/FrL4S8ry1D/NhXqNybTpXnvBQrsE6I6tmu4HFQfX
        2n2DimQ3BKOpfqfYTjeOPMithmUsyeflZmaV+ZfF1YkDFUkOk+pJs06DJWCLWQL0vpUUjKh3hwid7
        HGSHd0PoqtZjeZYHhdUbhETF2JazUa5j/lta3bC+GLjSxdFaIG3vWRBu4ApL+CiDXgkWbuEjnd+6g
        ckB+XxgQ==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxpg-003F0S-MZ; Wed, 22 Dec 2021 09:22:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] pmcraid: don't use GFP_DMA in pmcraid_alloc_sglist
Date:   Wed, 22 Dec 2021 10:22:47 +0100
Message-Id: <20211222092247.928711-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver doesn't express DMA addressing limitation under 32-bits
anywhere else, so remove the spurious GFP_DMA allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/pmcraid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 2fe7a0019fff2..928532180d323 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3221,8 +3221,8 @@ static struct pmcraid_sglist *pmcraid_alloc_sglist(int buflen)
 		return NULL;
 
 	sglist->order = order;
-	sgl_alloc_order(buflen, order, false,
-			GFP_KERNEL | GFP_DMA | __GFP_ZERO, &sglist->num_sg);
+	sgl_alloc_order(buflen, order, false, GFP_KERNEL | __GFP_ZERO,
+			&sglist->num_sg);
 
 	return sglist;
 }
-- 
2.30.2

