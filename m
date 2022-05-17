Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3415BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 06:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbiEQGuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 02:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiEQGt3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 02:49:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729CD47AF2;
        Mon, 16 May 2022 23:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=OOcjDSgK8cJWTacTHHEeY2ZV1fsyiqwKHKqJNuxa1c0=; b=Qc4hfvbyF2ro5TiD9xxQUu2e1/
        unv9+3sfNCxGiqiMnratiS2BH9dPkqzf6A3sY8MmNrRp36YZ79RgSAo/efmuwWL1MYD1f6Pszne4R
        pMTR4UI+GgR7eB78m08fvbp9iNWACC/dM24ksVkt6Ab7xSt3MG1BjVpsgKKEF8IePEjBi5++e0tRP
        uO1XaTnPb69lB/27Yk+2RxnyWr/ITW3N4mhMR9/ibSIvxcQXjlcGPyrrDQ/ltIWpkVBfpFT93kSgq
        6QyzTMPEF8DAYVjDiadnjH6qWa5azUOMJ2tOWrL+toNM8eV89nl3XHFF4aDAmm6/ESb3lXFrbuClX
        yleIQR1Q==;
Received: from [2001:4bb8:19a:7bdf:afb1:9e:37ad:b912] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqr0x-00Bsbu-1h; Tue, 17 May 2022 06:49:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: cleanup blk_execute_rq*
Date:   Tue, 17 May 2022 08:48:58 +0200
Message-Id: <20220517064901.3059255-1-hch@lst.de>
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
