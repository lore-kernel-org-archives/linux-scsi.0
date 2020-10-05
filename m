Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA70AC4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F95D20781
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CyrhZMRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJEIlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8B1C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tRj2uVRYSsJiToQXalM54LYRl8eqDwK4E1AusLHteSo=; b=CyrhZMRDmJeqJ8aiUk04pYYQHv
        9aZ5iIuHayyVJ9bhC2aKe5Am6T2rLb0rpCHoAJg+OSyJAPevNbViigtwP6COzueeG0OINq1oMPr4b
        5WXaTrMBJK+RItYoEK+wO73DQggS+qdXdrnsJ4MIzlKZ3feJrbR588GvpcptpizQqfBt1GDB4cWNH
        0ZUtu2+Pk2MikMR1w6R44WycRVtFMtC7WoX46io4a0JQYYZeuheDKPBYqm6rnutnXDQLXQWIMufJs
        Ovk2Z5mbST3L+FdNTvsSV0DfQpWeA0uVSxBxIZQRozPK5bM6cCa+Pb0PPCdtknmdF+wjVMzIwLA/G
        ARH1oyVg==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3o-0000lQ-Vs; Mon, 05 Oct 2020 08:41:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 01/10] scsi: don't export scsi_device_from_queue
Date:   Mon,  5 Oct 2020 10:41:21 +0200
Message-Id: <20201005084130.143273-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function is only used by code built into scsi_mod.ko.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f0ee11dc07e4b0..b95e00ff346b09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1959,7 +1959,6 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 
 	return sdev;
 }
-EXPORT_SYMBOL_GPL(scsi_device_from_queue);
 
 /**
  * scsi_block_requests - Utility function used by low-level drivers to prevent
-- 
2.28.0

