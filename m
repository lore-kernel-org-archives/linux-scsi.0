Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B32C55194
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 09:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A55A20776
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 09:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDXJV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 05:21:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:39218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgDXJV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 05:21:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3DC11ACC3;
        Fri, 24 Apr 2020 09:21:25 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 229841E128C; Fri, 24 Apr 2020 11:21:25 +0200 (CEST)
Date:   Fri, 24 Apr 2020 11:21:25 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] isofs: stop using ioctl_by_bdev
Message-ID: <20200424092125.GA13069@quack2.suse.cz>
References: <20200423071224.500849-1-hch@lst.de>
 <20200423071224.500849-7-hch@lst.de>
 <20200423110347.GE3737@quack2.suse.cz>
 <20200424065253.GB23754@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424065253.GB23754@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri 24-04-20 08:52:53, Christoph Hellwig wrote:
> On Thu, Apr 23, 2020 at 01:03:47PM +0200, Jan Kara wrote:
> > There's no error handling in the caller and this function actually returns
> > unsigned int... So I believe you need to return 0 here to maintain previous
> > behavior (however suspicious it may be)?
> 
> Indeed, and I don't think it is suspicious at all - if we have no CDROM
> info we should assume session 0, which is the same as for non-CDROM
> devices.  Fixed for the next version.

Right, I've realized that once I've checked UDF version and thought about
it for a while...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
