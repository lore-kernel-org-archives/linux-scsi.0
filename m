Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA1FC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32A5613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGIINV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhGIINV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztDTYYWkp+t+kb7GPKkSbcrbttoIILQY+N+mzBGgSjg=;
        b=IM4IELSSy2ztNXULy0Tb7/Ekdk+p/T4/SmdO9HhAqoY7/gmxvxWDwAUx/xdaG0PsL6QIOd
        0+2cKnJbyJH2rtKohPQdbtRT0Ti3Jc9XbYxK0Lae1j7K1jpwlLDpwsynOEnKTpDMLm+eEJ
        HIcP2i9jY5Sr7mfHo4aPqRvlptNdvdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-aYu-RRKjM52p_c725-P8Ew-1; Fri, 09 Jul 2021 04:10:36 -0400
X-MC-Unique: aYu-RRKjM52p_c725-P8Ew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9809192FDA0;
        Fri,  9 Jul 2021 08:10:34 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5B160C13;
        Fri,  9 Jul 2021 08:10:29 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 01/10] blk-mq: rename blk-mq-cpumap.c as blk-mq-map.c
Date:   Fri,  9 Jul 2021 16:09:56 +0800
Message-Id: <20210709081005.421340-2-ming.lei@redhat.com>
In-Reply-To: <20210709081005.421340-1-ming.lei@redhat.com>
References: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Firstly the name of cpumap isn't very useful because all kinds of map
helpers(pci, rdma, virtio) are for mapping cpu(s) to hw queue.

Secondly prepare for moving physical device related mapping into its
own subsystems, and we will put all map related functions/helpers into
this renamed source file.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/Makefile                          | 2 +-
 block/{blk-mq-cpumap.c => blk-mq-map.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename block/{blk-mq-cpumap.c => blk-mq-map.c} (100%)

diff --git a/block/Makefile b/block/Makefile
index bfbe4e13ca1e..0f31c7e8a475 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-flush.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-timeout.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
-			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
+			blk-mq-sysfs.o blk-mq-map.o blk-mq-sched.o ioctl.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
 			disk-events.o
 
diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-map.c
similarity index 100%
rename from block/blk-mq-cpumap.c
rename to block/blk-mq-map.c
-- 
2.31.1

