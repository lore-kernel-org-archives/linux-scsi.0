Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0652EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 11:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiCVLUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiCVLUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 07:20:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23AD26DB;
        Tue, 22 Mar 2022 04:18:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5189868AFE; Tue, 22 Mar 2022 12:18:48 +0100 (CET)
Date:   Tue, 22 Mar 2022 12:18:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, ming.lei@redhat.com, hare@suse.de,
        chenxiang66@hisilicon.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Subject: Re: [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
Message-ID: <20220322111848.GA29270@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com> <1647945585-197349-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647945585-197349-2-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2022 at 06:39:35PM +0800, John Garry wrote:
> Add an API to allocate a request queue which accepts a custom set of
> blk_mq_ops for that request queue.
> 
> The reason which we may want custom ops is for queuing requests which we
> don't want to go through the normal queuing path.

Eww.  I really do not think we should do separate ops per queue, as that
is going to get us into a deep mess eventually.
