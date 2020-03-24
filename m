Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADC6C4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 07:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7308E206F8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 07:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z/YFQKyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgCXH1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 03:27:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgCXH1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 03:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=sQdGzcjtu/OHKLduBOWEwidcFsI1MjEMWz8/QYw8Sz8=; b=Z/YFQKyRlB/lTbApkMRU4pDjNf
        Z+LFq1mRmB88pv8W+WaubwDyzFA582A/8gJgxzQqaId6LhcamOWEgXi5o7sFnaNGpJTPCSeNFkvmj
        +BIp+8KUQd6Y5gzOROVUrEiothgAMYYMHdMvLIuqRo16cbirhTXCwMSAv0PuPE6eh/X471WEfYksa
        wmyg/BSWNI4rGJUhlTuELJgPWluksXT98/uEVnQ3pVOvHmMWfmvwfYFBhA7lxho/JfVGxTANC9vJg
        W3tBUtNAULRVlDB2NVfJxGjDmJdkte1AwAQ6o1C1MYOyxBpv9mxeto6e1R/4iat6Z8bv9Na9F5v7o
        Hy7mNs2A==;
Received: from 213-225-10-87.nat.highway.a1.net ([213.225.10.87] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGdyR-0002CC-VO; Tue, 24 Mar 2020 07:27:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: cleanup the partitioning code v2
Date:   Tue, 24 Mar 2020 08:25:09 +0100
Message-Id: <20200324072530.544483-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

this series cleans up the partitioning code.

Changes sinve v1:
 - rebased to for-5.7/block
