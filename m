Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A220C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 06:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A721611EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 06:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhHWGuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 02:50:21 -0400
Received: from verein.lst.de ([213.95.11.211]:46542 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231715AbhHWGuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 02:50:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 46DD467373; Mon, 23 Aug 2021 08:49:36 +0200 (CEST)
Date:   Mon, 23 Aug 2021 08:49:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        oliver.sang@intel.com
Subject: Re: [PATCH 18/24] scsi_ioctl: move the "block layer" SCSI ioctl
 handling to drivers/scsi
Message-ID: <20210823064936.GA21806@lst.de>
References: <20210724072033.1284840-1-hch@lst.de> <20210724072033.1284840-19-hch@lst.de> <20210823084316.4bb224e0.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823084316.4bb224e0.pasic@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 08:43:16AM +0200, Halil Pasic wrote:
> I believe there is a small problem with this patch. I think it is
> easiest to explain with the diff that fixes it. Please see the patch
> at the end of this email.
> 
> Otherwise your patch looks great!
> 
> This may or may not be related to the problem reported here:
> https://lkml.org/lkml/2021/7/29/157
> Adding Oliver, maybe he can test if this fixes his testcases as well.
> (It did fix ours.:)
> 
> If you like I can respin my fix with an extended patch description.

No this looks good, but to make sure Martin picks it up please send it
as a separate thread.  It would be great it this fixes Olives issue,
but at least on my Debian systems blkid don't even call into SG_IO.
But maybe he has a different one or it is a cascading effect on that
particular setup.

Reviewed-by: Christoph Hellwig <hch@lst.de>
