Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EF0C2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 16:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02892223E
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 16:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393488AbgDPQ1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 12:27:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:34072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgDPQ1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 12:27:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E9CFAB3D;
        Thu, 16 Apr 2020 16:27:48 +0000 (UTC)
Date:   Thu, 16 Apr 2020 18:27:48 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v6 01/11] scsi: free sgtables in case command setup fails
Message-ID: <20200416162748.4kgklej2tokhcuqy@carbon>
References: <20200415090513.5133-1-johannes.thumshirn@wdc.com>
 <20200415090513.5133-2-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415090513.5133-2-johannes.thumshirn@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 06:05:03PM +0900, Johannes Thumshirn wrote:
> In case scsi_setup_fs_cmnd() fails we're not freeing the sgtables
> allocated by scsi_init_io(), thus we leak the allocated memory.
> 
> So free the sgtables allocated by scsi_init_io() in case
> scsi_setup_fs_cmnd() fails.
> 
> Technically scsi_setup_scsi_cmnd() does not suffer from this problem, as
> it can only fail if scsi_init_io() fails, so it does not have sgtables
> allocated. But to maintain symmetry and as a measure of defensive
> programming, free the sgtables on scsi_setup_scsi_cmnd() failure as well.
> scsi_mq_free_sgtables() has safeguards against double-freeing of memory so
> this is safe to do.
> 
> While we're at it, rename scsi_mq_free_sgtables() to scsi_free_sgtables().
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

I am not sure if the renaming should be part of this fix as it might
be something which should backported to stable.

Anyway, looks good to me.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
