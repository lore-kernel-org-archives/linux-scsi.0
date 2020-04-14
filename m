Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14496C352B6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BFC206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mZGEHRFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406804AbgDNHmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406798AbgDNHmd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 03:42:33 -0400
X-Greylist: delayed 800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 00:42:28 PDT
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFE0C0A3BDC;
        Tue, 14 Apr 2020 00:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=JJ5p+3/4IGSnlDpePvLUhJym9cud2qctPPEa9hKpgOM=; b=mZGEHRFvMVjixYpNm3y0zpmQjV
        IC9wydu/Xq4lMZvgsrmgMxNkFERUCAjs3f8J0/5wVTNywoZV3uCEIT8qAAtKV0YO94ZgF2FK51m1H
        vajT4cliScjbIguGiXn2RA8fC+zCjbCIYKn12IP9YpSPdMocRBFokH08fC7Sfko8e0stwbptBPv+e
        oouFi+80pNZ7tRxPc2lL+SqmxxShS7ZjVQEGdJg/UPhgnHiYCFbAHvkxLFBh160Yh+srwNXcV1Szw
        lX6vVL3wX1vFWmyhgEB2vCiFI6oXcr6R6Y1BByOGu5shaghfjpinuSyxHNWHysEQHvA50d/TYeVTV
        l7cg2/xw==;
Received: from [2001:4bb8:180:384b:4c21:af7:dd95:e552] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOGDD-00073b-R8; Tue, 14 Apr 2020 07:42:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: clean up DMA draining
Date:   Tue, 14 Apr 2020 09:42:20 +0200
Message-Id: <20200414074225.332324-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

currently the dma draining and alignining specific to ATA CDROMs
and the UFS driver has its ugly hooks in core block code.  Move
this out into the scsi and ide drivers instead.
