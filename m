Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88689C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 12:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbiEXMPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbiEXMPf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 08:15:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873126F492;
        Tue, 24 May 2022 05:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ImLzo4Z+gpfHhCqP6y5Z2hiix0lT9/GXA9a6s1oQrLg=; b=FW3Q4NQSuBzafQ9W33jTsZ0zpi
        vrUa03DHY1Chvd/qaqHfFOiQFayn+at43a/QDnPPUNKKPPyUKnoAh7uNm2juracFWtPh6GrJdjPly
        UhjpCjnKidUPbKGwee+gzmwzGa4CGzDb/hZ9uXdwFoZ2zdW3jdAYATL4Pzfxhok9t7/iEiQPLwCWh
        0GogylT6V3tzGVn1E0a34TcYfF5/q/jWtOGMjJ805zOb1yBhIcz+3kt4nJJtRqcbFmCI4UEqFvXpV
        nY7cVPzds24MyyWv9Qlj3sgPLxky9ZZ650sBZ+KcmvU+0JfvS6CtN4dLlFQd3gRQwzggZQ1me/lTk
        TgC0UweQ==;
Received: from [2001:4bb8:18c:7298:91b6:63de:2998:b8b2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntTRj-007waP-Sy; Tue, 24 May 2022 12:15:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: cleanup blk_execute_rq* v2
Date:   Tue, 24 May 2022 14:15:27 +0200
Message-Id: <20220524121530.943123-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

this series cleans up the blk_execute_rq* helpers.  It simplifies the
plugging mess a bit, fixes the sparse __bitwise warnings and simplifies
the blk_execute_rq_nowait API a bit.

Changes since v1:
 - rebased to the current Linus tree with the nvme driver changes
   merged
 - fixed a trailing whitespace and odd formatting
 - fixed a mising semicolon in ufs
