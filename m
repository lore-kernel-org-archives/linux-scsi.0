Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ADFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Dec 2021 14:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbhLUO3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Dec 2021 09:29:04 -0500
Received: from verein.lst.de ([213.95.11.211]:47017 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233837AbhLUO3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Dec 2021 09:29:03 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1656468AFE; Tue, 21 Dec 2021 15:29:00 +0100 (CET)
Date:   Tue, 21 Dec 2021 15:28:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, hch@lst.de, james.smart@broadcom.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH -next] scsi: efct: Use GFP_ATOMIC under spin lock
Message-ID: <20211221142859.GA30187@lst.de>
References: <20211221113706.329791-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221113706.329791-1-yangyingliang@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 21, 2021 at 07:37:06PM +0800, Yang Yingliang wrote:
> A spin lock is taken here so we should use GFP_ATOMIC.
> 
> Fixes: efac162a4e4d ("scsi: efct: Don't pass GFP_DMA to dma_alloc_coherent()")

No, it does not fix that commit.  The driver did sleeping allocations
even before the commit.

But wher is "here"?  Can we look into not holding that lock over an
allocation if it is preferable?  If not we should at least pass down
the gfp_flags so that only the caller(s) that can't sleep pass GFP_ATOMIC.
