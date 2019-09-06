Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F6EC00306
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 00:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5AB82082C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 00:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbfIFAbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389986AbfIFAbq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Sep 2019 20:31:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85CE4307D8BE;
        Fri,  6 Sep 2019 00:31:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 799B75D6A5;
        Fri,  6 Sep 2019 00:31:35 +0000 (UTC)
Date:   Fri, 6 Sep 2019 08:31:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5 0/7] Elevator cleanups and improvements
Message-ID: <20190906003129.GA27116@ming.t460p>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 06 Sep 2019 00:31:46 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 05, 2019 at 06:51:28PM +0900, Damien Le Moal wrote:
> This patch series implements some cleanup of the elevator initialization
> code and introduces elevator features identification and device matching
> to enhance checks for elevator/device compatibility and fitness.
> 
> The first 2 patches of the series are simple cleanups which simplify 
> elevator initialization for newly allocated device queues.
> 
> Patch 3 introduce elevator features, allowing a clean and extensible
> definition of devices and features that an elevator supports and match
> these against features required by a block device. With this, the sysfs
> elevator list for a device always shows only elevators matching the
> features that a particular device requires, with the exception of the
> none elevator which has no features but is always available for use
> with any device.
> 
> The first feature defined is for zoned block device sequential write
> constraint support through zone write locking which prevents the use of
> any elevator that does not support this feature with zoned devices.
> 
> The last 4 patches of this series rework the default elevator selection
> and initialization to allow for the elevator/device features matching
> to work, doing so addressing cases not currently well supported, namely,
> multi-queue zoned block devices.
> 
> Changes from v4:
> * Fix patch 5 again to correctly handle request based DM devices and
>   avoid that default queue elevator of these devices end up always
>   being "none".
> 
> Changes from v3:
> * Fixed patch 5 to correctly handle DM devices which do not register a
>   request queue and so do not need elevator initialization.
> 
> Changes from v2:
> * Fixed patch 4
> * Call elevator_init_mq() earlier in device_add_disk() as suggested by
>   Christoph (patch 5)
> * Fixed title of patch 7
> 
> Changes from v1:
> * Addressed Johannes comments
> * Rebased on newest for-next branch to include Ming's sysfs lock changes
> 
> Damien Le Moal (7):
>   block: Cleanup elevator_init_mq() use
>   block: Change elevator_init_mq() to always succeed
>   block: Introduce elevator features
>   block: Improve default elevator selection
>   block: Delay default elevator initialization
>   block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
>   sd: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks
> 
>  block/blk-mq.c                |  20 +++--
>  block/blk-settings.c          |  16 ++++
>  block/blk.h                   |   2 +-
>  block/elevator.c              | 137 ++++++++++++++++++++++++++--------
>  block/genhd.c                 |   9 +++
>  block/mq-deadline.c           |   1 +
>  drivers/block/null_blk_main.c |   2 +
>  drivers/md/dm-rq.c            |   2 +-
>  drivers/scsi/sd_zbc.c         |   2 +
>  include/linux/blk-mq.h        |   3 +-
>  include/linux/blkdev.h        |   4 +
>  include/linux/elevator.h      |   8 ++
>  12 files changed, 161 insertions(+), 45 deletions(-)

Looks fine for the series:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming
