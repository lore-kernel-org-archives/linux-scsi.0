Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B28CA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35F020640
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391898AbfJWMxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:53:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:49374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391880AbfJWMxQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 08:53:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CECD2B67E;
        Wed, 23 Oct 2019 12:53:14 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 8/8] scsi: sr: wait for the medium to become ready
Date:   Wed, 23 Oct 2019 14:52:47 +0200
Message-Id: <94dc98dc67b1d183d04c338c7978efa0556db6ac.1571834862.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1571834862.git.msuchanek@suse.de>
References: <cover.1571834862.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the autoclose IOCLT provided by cdrom driver to wait for drive to
close in open_finish, and attempt to open once more after the door
closes.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/scsi/sr.c | 54 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8090c5bdec09..34d9a818b9e0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -521,29 +521,58 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	return ret;
 }
 
-static int sr_block_open(struct block_device *bdev, fmode_t mode)
+static int __sr_block_open(struct block_device *bdev, fmode_t mode)
 {
-	struct scsi_cd *cd;
-	struct scsi_device *sdev;
-	int ret = -ENXIO;
-
-	cd = scsi_cd_get(bdev->bd_disk);
-	if (!cd)
-		goto out;
+	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
+	int ret;
 
-	sdev = cd->device;
-	scsi_autopm_get_device(sdev);
 	check_disk_change(bdev);
 
 	mutex_lock(&sr_mutex);
 	ret = cdrom_open(&cd->cdi, bdev, mode);
 	mutex_unlock(&sr_mutex);
 
+	return ret;
+}
+
+static int sr_block_open(struct block_device *bdev, fmode_t mode)
+{
+	struct scsi_cd *cd = scsi_cd_get(bdev->bd_disk);
+	struct scsi_device *sdev;
+	int ret;
+
+	if (!cd)
+		return -ENXIO;
+
+	sdev = cd->device;
+	scsi_autopm_get_device(sdev);
+	ret = __sr_block_open(bdev, mode);
 	scsi_autopm_put_device(sdev);
-	if (ret)
+
+	if (ret == -ERESTARTSYS)
 		scsi_cd_put(cd);
 
-out:
+	return ret;
+}
+
+static int sr_block_open_finish(struct block_device *bdev, fmode_t mode,
+				int ret)
+{
+	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
+
+	/* wait for drive to get ready */
+	if ((ret == -ENOMEDIUM) && !(mode & FMODE_NDELAY)) {
+		struct scsi_device *sdev = cd->device;
+		/*
+		 * Cannot use sr_block_ioctl because it locks sr_mutex blocking
+		 * out any processes trying to access the drive
+		 */
+		scsi_autopm_get_device(sdev);
+		cdrom_ioctl(&cd->cdi, bdev, mode, CDROM_AUTOCLOSE, 0);
+		ret = __sr_block_open(bdev, mode);
+		scsi_autopm_put_device(sdev);
+	}
+
 	return ret;
 }
 
@@ -639,6 +668,7 @@ static const struct block_device_operations sr_bdops =
 {
 	.owner		= THIS_MODULE,
 	.open		= sr_block_open,
+	.open_finish	= sr_block_open_finish,
 	.release	= sr_block_release,
 	.ioctl		= sr_block_ioctl,
 	.check_events	= sr_block_check_events,
-- 
2.23.0

