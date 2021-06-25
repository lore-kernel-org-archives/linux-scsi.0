Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3F1C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 22:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9456194C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 22:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFYWJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYWJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2021 18:09:13 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97589C061574;
        Fri, 25 Jun 2021 15:06:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 55CC21280D3A;
        Fri, 25 Jun 2021 15:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1624658812;
        bh=BnPQkEERp43ZgwOYOogE0QsNBC0J/ou2Eh0RJEdP93k=;
        h=Message-ID:Subject:From:To:Date:From;
        b=ZHXQHurICrVapp/kdW6trPdO4AjMJ80m7t0Q2KANtPR195ISaIn3ekCUa+Jp7QlYO
         5cduABdLdcB6+X7TrFBLxX1z5UTpiyIhZGtBXRI0l6lmUS6hM298ItMgzUpKn02ndL
         XD7D4hlBBwq9qWLYIj1STaF8zW2VbUlVt0mg8K1o=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9MyRSz2Ys3pj; Fri, 25 Jun 2021 15:06:52 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E56D91280D37;
        Fri, 25 Jun 2021 15:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1624658812;
        bh=BnPQkEERp43ZgwOYOogE0QsNBC0J/ou2Eh0RJEdP93k=;
        h=Message-ID:Subject:From:To:Date:From;
        b=ZHXQHurICrVapp/kdW6trPdO4AjMJ80m7t0Q2KANtPR195ISaIn3ekCUa+Jp7QlYO
         5cduABdLdcB6+X7TrFBLxX1z5UTpiyIhZGtBXRI0l6lmUS6hM298ItMgzUpKn02ndL
         XD7D4hlBBwq9qWLYIj1STaF8zW2VbUlVt0mg8K1o=
Message-ID: <85a6f026d0ed9dddcdddcc03a59968c46b09b94f.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.13-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 25 Jun 2021 15:06:51 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two small fixes, both in upper layer drivers (scsi disk and cdrom). 
The sd one is fixing a commit changing revalidation that came from the
block tree a while ago (5.10) and the sr one adds handling of a
condition we didn't previously handle for manually removed media.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi: sd: Call sd_revalidate_disk() for ioctl(BLKRRPART)

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

And the diffstat:

 drivers/scsi/sd.c | 22 ++++++++++++++++++----
 drivers/scsi/sr.c |  2 ++
 2 files changed, 20 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb3c37d1e009..a2c3d9ad9ee4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1387,6 +1387,22 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 	}
 }
 
+static bool sd_need_revalidate(struct block_device *bdev,
+		struct scsi_disk *sdkp)
+{
+	if (sdkp->device->removable || sdkp->write_prot) {
+		if (bdev_check_media_change(bdev))
+			return true;
+	}
+
+	/*
+	 * Force a full rescan after ioctl(BLKRRPART).  While the disk state has
+	 * nothing to do with partitions, BLKRRPART is used to force a full
+	 * revalidate after things like a format for historical reasons.
+	 */
+	return test_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@bdev: Block device of the scsi disk to open
@@ -1423,10 +1439,8 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	if (sdev->removable || sdkp->write_prot) {
-		if (bdev_check_media_change(bdev))
-			sd_revalidate_disk(bdev->bd_disk);
-	}
+	if (sd_need_revalidate(bdev, sdkp))
+		sd_revalidate_disk(bdev->bd_disk);
 
 	/*
 	 * If the drive is empty, just let the open fail.
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e4633b84c556..7815ed642d43 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -220,6 +220,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 

