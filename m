Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5A4C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286876112E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhKCSPw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhKCSPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 14:15:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81AFC061714;
        Wed,  3 Nov 2021 11:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hfvcTHZKSWjoPW0PNuYwn+asx66naeAEMFOrEFwKxfY=; b=DbzYr5VuaLhS5tLME+a++7VJ1y
        3qtVe1EGa0T5S6pH+S+O0yyFXuUY3rq9A//cMNqYlqrIK8TQNJzfTsRF0MBoA9it/5gg6VS/7laFY
        zm5V/76uelJblHJa8kAptQzCDOj4Xi4nuM0NJrkmr+iB2iWN7OlMUTyrcmQ4DQ/vgzaTMWFGRx/uY
        /Dow/OcYx+VSThoRBQrAsYYRZk4GzB1IdKns8Is2GWooRbcvmEh93SUX0EFHXwmCkcoJRXq0c3wM4
        dgJYFrf861GNhNhpRdsPoVJl8k+8pKPEpLdU6mYUHIhGUGCkdMevsJV+QhLlwNAYzq/ii0xPZZuB1
        kCxCQEag==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKkt-0068XM-Vf; Wed, 03 Nov 2021 18:12:59 +0000
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
Subject: [PATCH v4 3/4] floppy: address add_disk() error handling on probe
Date:   Wed,  3 Nov 2021 11:12:57 -0700
Message-Id: <20211103181258.1462704-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103181258.1462704-1-mcgrof@kernel.org>
References: <20211103181258.1462704-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to cleanup resources on the probe() callback registered
with __register_blkdev(), now that add_disk() error handling is
supported. Address this.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/floppy.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3873e789478e..255e88efb535 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4522,6 +4522,7 @@ static void floppy_probe(dev_t dev)
 {
 	unsigned int drive = (MINOR(dev) & 3) | ((MINOR(dev) & 0x80) >> 5);
 	unsigned int type = (MINOR(dev) >> 2) & 0x1f;
+	int err = 0;
 
 	if (drive >= N_DRIVE || !floppy_available(drive) ||
 	    type >= ARRAY_SIZE(floppy_type))
@@ -4529,10 +4530,20 @@ static void floppy_probe(dev_t dev)
 
 	mutex_lock(&floppy_probe_lock);
 	if (!disks[drive][type]) {
-		if (floppy_alloc_disk(drive, type) == 0)
-			add_disk(disks[drive][type]);
+		err = floppy_alloc_disk(drive, type);
+		if (err == 0) {
+			err = add_disk(disks[drive][type]);
+			if (err)
+				goto err_out;
+		}
 	}
 	mutex_unlock(&floppy_probe_lock);
+	return;
+
+err_out:
+	blk_cleanup_disk(disks[drive][type]);
+	disks[drive][type] = NULL;
+	mutex_unlock(&floppy_probe_lock);
 }
 
 static int __init do_floppy_init(void)
-- 
2.33.0

