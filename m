Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FF9C49EA2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 13:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D4261241
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 13:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhFPNwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 09:52:33 -0400
Received: from verein.lst.de ([213.95.11.211]:54470 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233642AbhFPNw1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Jun 2021 09:52:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 48AFE68BEB; Wed, 16 Jun 2021 15:50:16 +0200 (CEST)
Date:   Wed, 16 Jun 2021 15:50:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tim Waugh <tim@cyberelk.net>, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: remove ->revalidate_disk (resend)
Message-ID: <20210616135015.GA30671@lst.de>
References: <20210308074550.422714-1-hch@lst.de> <96011dbd-084f-8a07-3506-fc7717122866@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96011dbd-084f-8a07-3506-fc7717122866@hisilicon.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 16, 2021 at 05:41:54PM +0800, chenxiang (M) wrote:
> Hi,
>
> Before i reported a issue related to revalidate disk 
> (https://www.spinics.net/lists/linux-scsi/msg151610.html), and no one 
> replies, but the issue is still.
>
> And i plan to resend it, but i find that revalidate_disk interface is 
> completely removed in this patchset.
>
> Do you have any idea about the above issue?

bdev_disk_changed still calls into sd_revalidate_disk through sd_open.
How did bdev_disk_changed get called for you previously?  If it was
through the BLKRRPART ioctl please try latest mainline, which ensures
that ->open is called for that case.
