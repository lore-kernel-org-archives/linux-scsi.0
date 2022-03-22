Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34368C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 11:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbiCVLZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiCVLZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 07:25:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E051F623;
        Tue, 22 Mar 2022 04:23:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CE79568AFE; Tue, 22 Mar 2022 12:23:31 +0100 (CET)
Date:   Tue, 22 Mar 2022 12:23:31 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, ming.lei@redhat.com, hare@suse.de,
        chenxiang66@hisilicon.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Subject: Re: [PATCH 04/11] scsi: libsas: Send SMP commands through the
 block layer
Message-ID: <20220322112331.GD29270@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com> <1647945585-197349-5-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647945585-197349-5-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wouldn't it make more sense to have a new member in th Scsi_Host_template
that gets called for these request early from ->queue_rq instead of the
new request_queue and custome ops?

FYI, I think reusing the block layer for all these command is a good
idea but the way it is done here seems a bit ugly and not very
maintainable.
