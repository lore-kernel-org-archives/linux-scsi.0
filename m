Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70045C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480242073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcDMl8M2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgGUKxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 06:53:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729349AbgGUKxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 06:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=a7FGaIHkD38JSVxPqaibb4DmZEBgCel4gb1OIq9hfcg=;
        b=HcDMl8M28Q2UocbN8b/QuXcF3AhaEwtt/3PFGX7RFHxYyIghX2F2+2tBS+xqN646Q6DUTj
        ZO4iICVPJMry+K0jN6Ii4KWIATTFaWZSrlOfIaHd+D8O0KVjA9wlOFjPqOI9rMVfXD7jmp
        YHA/kW7p9lzFyi/ayuRfDvJHEginceI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-ukSVL_ZBNG-8BMv4MWvP7A-1; Tue, 21 Jul 2020 06:53:12 -0400
X-MC-Unique: ukSVL_ZBNG-8BMv4MWvP7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26294100AA21;
        Tue, 21 Jul 2020 10:53:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCBC78730C;
        Tue, 21 Jul 2020 10:52:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-block@vger.kernel.org (open list:BLOCK LAYER),
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-scsi@vger.kernel.org (open list:SCSI CDROM DRIVER),
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        linux-mmc@vger.kernel.org (open list:SONY MEMORYSTICK SUBSYSTEM),
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        nbd@other.debian.org (open list:NETWORK BLOCK DEVICE (NBD)),
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 00/10] RFC: move logical block size checking to the block core
Date:   Tue, 21 Jul 2020 13:52:29 +0300
Message-Id: <20200721105239.8270-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series aims to move the logical block size checking to the=0D
block code.=0D
=0D
This was inspired by missing check for valid logical block size in=0D
virtio-blk which causes the kernel to crash in a weird way later on=0D
when it is invalid.=0D
=0D
I added blk_is_valid_logical_block_size which returns true iff the=0D
block size is one of supported sizes.=0D
=0D
I added this check to virtio-blk, and also converted  few block drivers=0D
that I am familiar with to use this interface instead of their=0D
own implementation.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (10):=0D
  block: introduce blk_is_valid_logical_block_size=0D
  block: virtio-blk: check logical block size=0D
  block: loop: use blk_is_valid_logical_block_size=0D
  block: nbd: use blk_is_valid_logical_block_size=0D
  block: null: use blk_is_valid_logical_block_size=0D
  block: ms_block: use blk_is_valid_logical_block_size=0D
  block: mspro_blk: use blk_is_valid_logical_block_size=0D
  block: nvme: use blk_is_valid_logical_block_size=0D
  block: scsi: sd: use blk_is_valid_logical_block_size=0D
  block: scsi: sr: use blk_is_valid_logical_block_size=0D
=0D
 block/blk-settings.c                | 18 +++++++++++++++++=0D
 drivers/block/loop.c                | 23 +++++----------------=0D
 drivers/block/nbd.c                 | 12 ++---------=0D
 drivers/block/null_blk_main.c       |  6 +++---=0D
 drivers/block/virtio_blk.c          | 15 ++++++++++++--=0D
 drivers/memstick/core/ms_block.c    |  2 +-=0D
 drivers/memstick/core/mspro_block.c |  6 ++++++=0D
 drivers/nvme/host/core.c            | 17 ++++++++--------=0D
 drivers/scsi/sd.c                   |  5 +----=0D
 drivers/scsi/sr.c                   | 31 ++++++++++++-----------------=0D
 include/linux/blkdev.h              |  1 +=0D
 11 files changed, 71 insertions(+), 65 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

