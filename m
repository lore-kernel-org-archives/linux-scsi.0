Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B0DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5365C60EDF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhKCSPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhKCSPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 14:15:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A02C061203;
        Wed,  3 Nov 2021 11:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/VvXRoVO5D/RYmzfu2Viv3DDMIMX9DlAinlG2alJ+SM=; b=1/rCXzNN+PwirBOGOC8vCCcR8M
        kySObapW1OL41gTI+sELio+8ML6oU6Y3wEQwuuVfVQt4rpeXAfvwmDHZ4oztyVfVjgVxTy20bhdZi
        y9R4e5ZAn7bOCRVQNdOJ/KV1KwIdekM5esv+RTeRP7XBFuPIxN9RftKWAKlN2MvPqAFQQUzzQuqcB
        nDNra97HMYoEi8Br1AXOXrtjZ29T7OjalLZ6QTecRAVGsblz//PBXGwTjdgX2bLRu/OtDGBqUWTLN
        Nl2wziqcIgxTRTzki0SUxTy7VW7DQet8fvevSCWgnQblDSWc9AhVm9iBUxoJz7MUkvxR88+uPLjfI
        /U06Y0tg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKkt-0068XC-RD; Wed, 03 Nov 2021 18:12:59 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] block: update __register_blkdev() probe documentation
Date:   Wed,  3 Nov 2021 11:12:55 -0700
Message-Id: <20211103181258.1462704-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103181258.1462704-1-mcgrof@kernel.org>
References: <20211103181258.1462704-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__register_blkdev() is used to register a probe callback, and
that callback is typically used to call add_disk(). Now that
we are able to capture errors for add_disk(), we need to fix
those probe calls where add_disk() fails and clean up resources.

We don't extend the probe call to return the error given:

1) we'd have to always special-case the case where the disk
   was already present, as otherwise concurrent requests to
   open an existing block device would fail, and this would be
   a userspace visible change
2) the error from ilookup() on blkdev_get_no_open() is sufficient
3) The only thing the probe call is used for is to support
   pre-devtmpfs, pre-udev semantics that want to create disks when
   their pre-created device node is accessed, and so we don't care
   for failures on probe there.

Expand documentation for the probe callback to ensure users cleanup
resources if add_disk() is used and to clarify this interface may be
removed in the future.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/genhd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 4ed87f25276a..2f5b7e24e88a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -213,7 +213,10 @@ void blkdev_show(struct seq_file *seqf, off_t offset)
  * @major: the requested major device number [1..BLKDEV_MAJOR_MAX-1]. If
  *         @major = 0, try to allocate any unused major number.
  * @name: the name of the new block device as a zero terminated string
- * @probe: allback that is called on access to any minor number of @major
+ * @probe: pre-devtmpfs / pre-udev callback used to create disks when their
+ *	   pre-created device node is accessed. When a probe call uses
+ *	   add_disk() and it fails the driver must cleanup resources. This
+ *	   interface may soon be removed.
  *
  * The @name must be unique within the system.
  *
-- 
2.33.0

