Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C867DC47259
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F7C520757
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rJyjevkJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgEDN76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 09:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728110AbgEDN74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 09:59:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E01AC0610D5;
        Mon,  4 May 2020 06:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=CT9TPYB1gBir/yelz692kCRjhkXIcgo4vO0zDJE8gwk=; b=rJyjevkJ4AJbP004OHAOCBnof1
        YIafKltJ9MfSxyThjuPBAXEj2GLR36kE4nJ8GJokvQILLT6qSQIiWp+GRKXEXjYXAchKjJUjaFHM9
        G4BDqH+3RH3n+9LXVGpwy1cuq3UH+2+nGccvKrTVdOYkcBsY5MrBgX9uTpFQ1ehd/gRhiTBOyxzcb
        YQWNTTvHhkrZa8Ve1OkkvMoQhddwnMoc2+UyoOoynmMQmnsrzOt8TbVI9BbWtuG0vTa+itpKcNdb3
        wwxjlmc4iIzipoTy5Pa8SOYpmy9Ssli5sz+ho9ZZ/CpO6i1dEEOiT0nzFyQ+ixNZZTh6od2ml6tqf
        KBmtyCAw==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jVbd5-0007Y5-DB; Mon, 04 May 2020 13:59:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: stop using ioctl_by_bdev for file system access to CDROMs v3
Date:   Mon,  4 May 2020 15:59:19 +0200
Message-Id: <20200504135927.2835750-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

can you pick up this series?

Except for the DASD case under discussion the last users of ioctl_by_bdev
are the file system drivers that want to query CDROM information using
ioctls.  This series switches them to use function calls directly into
the CDROM midlayer instead, which implies:

 - adding a cdrom_device_info pointer to the gendisk, so that file systems
   can find it without going to the low-level driver first
 - ensuring that the CDROM midlayer (which isn't a lot of code) is built
   in if the file systems are built in so that they can actually call the
   exported functions

Changes since v2:
 - add a patch to also convert hfs (exactly duplicate of the hfsplus code)
Changes since v1:
 - fix up the no-CDROM error case in isofs_get_last_session to return 0
   instead of -EINVAL.
