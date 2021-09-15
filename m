Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AD2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 13:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6D161212
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 13:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhIONla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 09:41:30 -0400
Received: from verein.lst.de ([213.95.11.211]:36398 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhIONl3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 09:41:29 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 48BC967357; Wed, 15 Sep 2021 15:40:08 +0200 (CEST)
Date:   Wed, 15 Sep 2021 15:40:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <20210915134008.GA13933@lst.de>
References: <20210915092547.990285-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915092547.990285-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 05:25:47PM +0800, Ming Lei wrote:
> gendisk instance has to be released after request queue is cleaned up
> because bdi is referred from gendisk since commit edb0872f44ec ("block:
> move the bdi from the request_queue to the gendisk").
> 
> For sd and sr, gendisk can be removed in the release handler(sd_remove/
> sr_remove) of sdev->sdev_gendev, which is triggered in device_del(sdev->sdev_gendev)
> in __scsi_remove_device(), when the request queue isn't cleaned up yet.
> 
> So kernel oops could be triggered when referring bdi via gendisk.
> 
> Fix the issue by moving blk_cleanup_queue() into sd_remove() and
> sr_remove().

This looks like a bit of a bandaid to me.  I think the proper fix
is to move the parts of blk_cleanup_queue that need a disk or bdi
to del_gendisk.
