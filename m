Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FBDC433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3132C20767
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wWWW6aYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgICIBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgICIBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 04:01:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2A3C061244;
        Thu,  3 Sep 2020 01:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cU305cxFBo6tm5/dcumAYM77XH5iQN9l01UIc+MQ8ms=; b=wWWW6aYY0aagDmpZ1bPiSvTpQw
        hJm4tzGwj6/QUrIm6ZDBPRuSbs+oSQf3GZeEe/T3oMzvl2i2cvcS8HU0gIeJExqwloJMuvqD+tyUm
        /5CWj/mQRXnLWL5bbRHRR7Gi9/gFtwkcOHZ3GHFxXuEpkeqayyIaBuePt7xW9LIgNzgw5Nins47i/
        BsLowowCTOTKIIDe5AHHnQPXyuGTLG+TkeO/7krX6/GSvGxLHKw2GijdhXLkTHKMxfpZWQrLqDvzM
        osFtIVQYGnxEdZK6JbWvEPOOyuMeoSfkEwcWm+DIPXHs7xcLJi5qnAJIEjerenE5BSTQzTmGTqMiy
        bNvKvSow==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkBL-0006Zq-V2; Thu, 03 Sep 2020 08:01:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: simplify gendisk lookup and remove struct block_device aliases v3
Date:   Thu,  3 Sep 2020 10:01:00 +0200
Message-Id: <20200903080119.441674-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series removes the annoying struct block_device aliases, which can
happen for a bunch of old floppy drivers (and z2ram).  In that case
multiple struct block device instances for different dev_t's can point
to the same gendisk, without being partitions.  The cause for that
is the probe/get callback registered through blk_register_regions.

This series removes blk_register_region entirely, splitting it it into
a simple xarray lookup of registered gendisks, and a probe callback
stored in the major_names array that can be used for modprobe overrides
or creating devices on demands when no gendisk is found.  The old
remapping is gone entirely, and instead the 4 remaining drivers just
register a gendisk for each operating mode.  In case of the two drivers
that have lots of aliases that is done on-demand using the new probe
callback, while for the other two I simply register all at probe time
to keep things simple.

Note that the m68k drivers are compile tested only.

Changes since v2:
 - fix a wrong variable passed to ERR_PTR in the floppy driver
 - slightly adjust the del_gendisk cleanups to prepare for the next
   series touching this area

Changes since v1:
 - add back a missing kobject_put in the cdev code
 - improve the xarray delete loops

Diffstat:
 b/block/genhd.c           |  183 +++++++--------
 b/drivers/base/Makefile   |    2 
 b/drivers/block/amiflop.c |   98 ++++----
 b/drivers/block/ataflop.c |  135 +++++++----
 b/drivers/block/brd.c     |   39 ---
 b/drivers/block/floppy.c  |  154 ++++++++----
 b/drivers/block/loop.c    |   30 --
 b/drivers/block/swim.c    |   17 -
 b/drivers/block/z2ram.c   |  547 ++++++++++++++++++++++------------------------
 b/drivers/ide/ide-probe.c |   66 -----
 b/drivers/ide/ide-tape.c  |    2 
 b/drivers/md/md.c         |   21 -
 b/drivers/scsi/sd.c       |   19 -
 b/fs/char_dev.c           |   94 +++----
 b/fs/dcache.c             |    1 
 b/fs/internal.h           |    5 
 b/include/linux/genhd.h   |   12 -
 b/include/linux/ide.h     |    3 
 drivers/base/map.c        |  154 ------------
 include/linux/kobj_map.h  |   20 -
 20 files changed, 686 insertions(+), 916 deletions(-)
