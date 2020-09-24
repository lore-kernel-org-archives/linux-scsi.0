Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75B5C4727D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 20:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0678221EB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 20:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600980819;
	bh=5VtJpDdYtCwZlRfMorsUAUPg+YDyujpIPaxXRnHMyk0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Wm/dijDQSPZX4If/Sk2botkYiT39dm3I0hFEbVtmZYn1b95XBuqiNL8BmxQndp8ZV
	 uaJGMGPPEyMZZjXe2qfxBO/KdntTuAuA5ipnACKJ4fzIVuJqlFLEV+sm1Y53Zu3U7i
	 0TpZELTdGxhxkkBf1RJPHcI/1Gj8PWd7xRrCkXY0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIXUxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUxf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Sep 2020 16:53:35 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063112399A;
        Thu, 24 Sep 2020 20:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600980815;
        bh=5VtJpDdYtCwZlRfMorsUAUPg+YDyujpIPaxXRnHMyk0=;
        h=From:To:Cc:Subject:Date:From;
        b=daxcQ/vGVx9MCUGijrm4hmX+iKBonjPY15FIt/uGOh1wm90jRQKKGJYiyFx3dyuMM
         4VooFuArvyGQFZm7MOndPrZi+x9DBAJlvd8EkcmIA/kDqzv+BUqLMt/D1ho9hJZlq3
         HkM3V3ooptvquX+48unEw3k1OuJtcy40JnTu8Io8=
From:   Keith Busch <kbusch@kernel.org>
To:     axboe@kernel.dk
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, hch@lst.de,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 0/3] zoned block device specific errors
Date:   Thu, 24 Sep 2020 13:53:27 -0700
Message-Id: <20200924205330.4043232-1-kbusch@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Zone block devices may have some limits that require special handling.
This series provides a way for drivers to notify of these conditions.

v3 -> v4:

Added reviews/acks/sobs

Dropped unintended patch

Damien Le Moal (1):
  scsi: handle zone resources errors

Keith Busch (2):
  block: add zone specific block statuses
  nvme: translate zone resource errors

 Documentation/block/queue-sysfs.rst |  8 ++++++++
 block/blk-core.c                    |  4 ++++
 drivers/nvme/host/core.c            |  4 ++++
 drivers/scsi/scsi_lib.c             |  9 +++++++++
 include/linux/blk_types.h           | 18 ++++++++++++++++++
 5 files changed, 43 insertions(+)

-- 
2.24.1

