Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695E0C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F69660E74
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhGVScT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:32:19 -0400
Received: from verein.lst.de ([213.95.11.211]:35706 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGVScS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:32:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 85BEE67373; Thu, 22 Jul 2021 21:12:51 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:12:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 17/24] scsi_ioctl: simplify SCSI passthrough permission
 checking
Message-ID: <20210722191251.GA15065@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-18-hch@lst.de> <9f9683ff-10d8-26a2-95de-5084b477e6c0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f9683ff-10d8-26a2-95de-5084b477e6c0@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 10:47:35AM -0700, Bart Van Assche wrote:
> The first time I encountered this function it was not clear to me what the 
> purpose of this function is. I think this is a good time to add a comment 
> above this function that explains its purpose, namely to prevent that 
> unprivileged SG I/O users can modify storage device firmware.

Or generally do unexpected things, yes.  I'll add a patch at the end of
the series to avoid the pain of adding a comment first and then moving
the whole code around.
