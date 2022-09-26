Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80336C07E9D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 15:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiIZPyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiIZPxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 11:53:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B896CD3E;
        Mon, 26 Sep 2022 07:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VYXPaePPkFQmtHgeaR7pqY5gEI8Hr9hwmGA4CbheL6U=; b=RsFTdd5zg/exo3TqDiYoJjwfjl
        xKcJ3QUiNsmjEXltcvK7Z/QPuQ8hhrjTdUBZftsFKgpl8foLD1AjGdbF3k4PMyiSgPSGepXBVM62b
        /OIUAEaEX7nQk9SeJol8V0+XIWj8rs1D/q3XPE/MhQfo3NduWUlGKw0/IcphLkwRrSosQRY8o4h7B
        UUpGWadS8QJxHsEdW6umDbgkVeSQdsTyKRAMx3UR1aJOBkdHiEGm/nO4LlaOrvn4hX/qPJaCrbge4
        nmNzFASVeNQzFTjuDrgfN9tFY/lVxpuf1Y+WUSlihTDDV9O42cWqBCDpaQiIlGz8J1mger+9RAo7C
        gAfKJd1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ocpI8-005PSJ-10; Mon, 26 Sep 2022 14:41:04 +0000
Date:   Mon, 26 Sep 2022 07:41:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Message-ID: <YzG5/1zSdiMlMLnB@infradead.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-5-axboe@kernel.dk>
 <Yy3O7wH16t6AhC3j@infradead.org>
 <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 23, 2022 at 02:52:54PM -0600, Jens Axboe wrote:
> For both of these, how about we just simplify like below? I think
> at that point it's useless to name them anyway.

I think this version is better than the previous one, but I'd still
prefer a non-anonymous union.
