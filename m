Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACF3C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 06:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC93619BC
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 06:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhCaGxQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:53:16 -0400
Received: from verein.lst.de ([213.95.11.211]:34027 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233905AbhCaGxI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 02:53:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 84B1D68B02; Wed, 31 Mar 2021 08:53:04 +0200 (CEST)
Date:   Wed, 31 Mar 2021 08:53:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/15] md: remove the code to flush an old instance in
 md_open
Message-ID: <20210331065304.GA8001@lst.de>
References: <20210330161727.2297292-1-hch@lst.de> <20210330161727.2297292-2-hch@lst.de> <e74ca0f0-e9d5-1713-d714-4ac71a2f8ece@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74ca0f0-e9d5-1713-d714-4ac71a2f8ece@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 31, 2021 at 11:29:39AM +0800, heming.zhao@suse.com wrote:
> when userspace "mdadm -Ss" finish (the ioctl STOP_ARRAY returns),
> mddev->flags will be zero. and you can see my patch email (date: 2021-3-30).
> At this time, userspace will execute "mdadm --monitor" to scan the
> closing md device. the md_open will trigger very soon. at this time,
> bdev->bd_disk->private_data is only a skeleton, your shouldn't trust & use it.

Ermm, the block layer rules require the device to be fully set up
when add_disk is called.  So if that is not the case (and I'd like
to see hints how) we need to fix this properly instead of using a hack
in ->open.
