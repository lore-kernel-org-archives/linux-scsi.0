Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90216C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 16:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiIZQF2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 12:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiIZQEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 12:04:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B28B24A4;
        Mon, 26 Sep 2022 07:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GgQCfShhg6c4Yw2GAHv1kM3Vj/4PRsYwZj4e6bUmfM4=; b=x+vi4WQB+4T6b3M6nhc/3hZmKg
        SkGgX4l4712JQMlgpEvnq3Qq4YjEtNVqoBYWX3LAmwjzVXTFoLk8/akmhkXMx1yPAgrfoKSDMUJ8I
        UGWYWXsnZ9RtY3PlyICfic+G5VFQCMLBsyckr+gT7CeCNmwqM+Uf7gTcwsJNBp6WE1AV5NAAKvP8l
        FHdR3DG3US8/lCeCVYDfio180P2wNUVZ/th8cGZ8tpVWGKbXh+b3ZF+x60i+jZTTxE2zic4sK95Pj
        tX6D+NIQUbX4+DOKnF97Qxhpgq33+20mfPg/Z2nLHOdvRlRP4C4HfRxdcbADl1flouxkbTzLVcZmH
        PM4P3mPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ocpTS-005Vm6-5p; Mon, 26 Sep 2022 14:52:46 +0000
Date:   Mon, 26 Sep 2022 07:52:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Message-ID: <YzG8vsR8j0VIt6Nx@infradead.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-5-axboe@kernel.dk>
 <Yy3O7wH16t6AhC3j@infradead.org>
 <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
 <YzG5/1zSdiMlMLnB@infradead.org>
 <69598e37-fb91-5b92-bb80-b68457a7b6f8@kernel.dk>
 <YzG6mZhtd/QysvdH@infradead.org>
 <25b9899f-0c60-39f2-179b-789b914e0f0a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25b9899f-0c60-39f2-179b-789b914e0f0a@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2022 at 08:50:41AM -0600, Jens Axboe wrote:
> Or just the union named so it's clear it's a union? That'd make it
> 
> pdu->u.meta
> 
> and so forth. I think that might be cleaner.

Ok, that's at least a bit of a warning sign.
