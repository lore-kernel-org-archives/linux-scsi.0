Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B99CC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 17:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DDA220709
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 17:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfKURNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:13:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:54128 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbfKURNk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 12:13:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FA82B1B9;
        Thu, 21 Nov 2019 17:13:37 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 03/10] cdrom: wait for the tray to close
Date:   Thu, 21 Nov 2019 18:13:10 +0100
Message-Id: <5e8f9d588560ebf117334d6919c3976a731db757.1574355709.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1574355709.git.msuchanek@suse.de>
References: <cover.1574355709.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi command to close the tray only starts the motor and does not
wait for the tray to close. Wait until the state chages from TRAY_OPEN
so users do not race with the tray closing.

This looks like inifinte wait but unless the drive is broken it either
closes the tray shortly or reports an error when it detects the tray is
blocked. At worst the wait can be interrupted by the user.

Also wait for the drive to become ready once the tray closes.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
v2:
 - check drive_status exists before using it
 - rename tray_close -> cdrom_tray_close
 - also wait for drive to become ready after tray closes
 - do not wait in cdrom_ioctl_closetray
v4: add a status change poll wrapper
---
 drivers/cdrom/cdrom.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index bb32decdadf1..b2bc0c8f9a69 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1045,6 +1045,28 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 	       tracks->cdi, tracks->xa);
 }
 
+static int cdrom_wait_for_status_change(struct cdrom_device_info *cdi,
+					int *status)
+{
+	int saved = *status;
+	const struct cdrom_device_ops *cdo = cdi->ops;
+
+	return poll_event_interruptible(saved !=
+			(*status = cdo->drive_status(cdi, CDSL_CURRENT)), 500);
+}
+
+static int cdrom_tray_close(struct cdrom_device_info *cdi)
+{
+	int ret;
+
+	ret = cdi->ops->tray_move(cdi, 0);
+	if (ret || !cdi->ops->drive_status)
+		return ret;
+
+	ret = CDS_TRAY_OPEN;
+	return cdrom_wait_for_status_change(cdi, &ret);
+}
+
 static int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
 {
 	int ret;
@@ -1062,14 +1084,14 @@ static int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
 				if (!(cdi->options & CDO_AUTO_CLOSE))
 					return -ENOMEDIUM;
 				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdrom_tray_close(cdi);
+				if (ret == -ERESTARTSYS)
+					return ret;
 				if (ret) {
 					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					return -ENOMEDIUM;
 				}
 				ret = cdo->drive_status(cdi, CDSL_CURRENT);
-				if (ret == CDS_TRAY_OPEN)
-					cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
 				if (ret == CDS_NO_DISC)
 					cd_dbg(CD_OPEN, "tray might not contain a medium\n");
 			} else {
@@ -1077,6 +1099,14 @@ static int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
 				return -ENOMEDIUM;
 			}
 		}
+		if (ret == CDS_DRIVE_NOT_READY) {
+			int poll_res;
+
+			cd_dbg(CD_OPEN, "waiting for drive to become ready...\n");
+			poll_res = cdrom_wait_for_status_change(cdi, &ret);
+			if (poll_res == -ERESTARTSYS)
+				return poll_res;
+		}
 		if (ret != CDS_DISC_OK)
 			return -ENOMEDIUM;
 	}
-- 
2.23.0

