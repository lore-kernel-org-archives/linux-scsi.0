Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420B5C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2542360E74
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhGVSf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:35:58 -0400
Received: from verein.lst.de ([213.95.11.211]:35721 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhGVSf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:35:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8473D67373; Thu, 22 Jul 2021 21:16:30 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:16:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 18/24] scsi_ioctl: move all "block layer" SCSI ioctl
 handling to drivers/scsi
Message-ID: <20210722191630.GB15065@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-19-hch@lst.de> <yq1im12w7ik.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1im12w7ik.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 02:06:40PM -0400, Martin K. Petersen wrote:
> > +static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
> > +			     struct sg_io_hdr *hdr, fmode_t mode)
> 
> [...]
> 
> > +static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
> > +				 struct bio *bio)
> > +{
> 
> Another couple of peculiar naming vestiges. These probably shouldn't
> have a "blk_" prefix now that they are under SCSI. Since they are
> internal to scsi_ioctl.c I propose you either drop the prefix completely
> or make it "scsi_".

Ok.  I'll keep __blk_send_generic and its callers for now as they'll
get removed later in the series.
