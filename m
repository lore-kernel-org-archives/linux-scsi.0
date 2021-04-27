Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8587CC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6989D613C5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhD0WAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:37 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39063 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239471AbhD0WAE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A62BA2041CB;
        Tue, 27 Apr 2021 23:59:15 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 670patpvJPDn; Tue, 27 Apr 2021 23:59:14 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id D7145204190;
        Tue, 27 Apr 2021 23:59:12 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 64/83] sg: device timestamp
Date:   Tue, 27 Apr 2021 17:57:14 -0400
Message-Id: <20210427215733.417746-66-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add timestamp to each sg_device object that is written when the
object is created. The timestamp is the number nanoseconds since
the boot time of the machine.

The purpose is to allow the user to detect, via the extended
ioctl()s SG_SEIRV_DEV_TS_LOWER and SG_SEIRV_DEV_TS_UPPER, if
a given sg device object (e.g. /dev/sg3) may have possibly
changed. One worrisome scenario is when a device disappears
and a newly connected device takes the same sg device object
number (e.g. /dev/sg3) as the recently disappeared device.
Linux gives no guarantees that this type of behaviour will
_not_ happen. Recording the device creation timestamp is one
way an application can detect when this happens.

The uptime command in Linux shows, in humanly readable form,
how long a machine has been "up", that is the time that has
elapsed since the machine was started or "rebooted".

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 8 ++++++++
 include/uapi/scsi/sg.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c401047cae70..dc85592112e2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -308,6 +308,7 @@ struct sg_device { /* holds the state of each scsi generic device */
 	int max_sgat_elems;     /* adapter's max number of elements in sgat */
 	int max_sgat_sz;	/* max number of bytes in sgat list */
 	u32 index;		/* device index number */
+	u64 create_ns;		/* nanoseconds since bootup device created */
 	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
 	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
 	struct gendisk *disk;
@@ -4462,6 +4463,12 @@ sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
 	case SG_SEIRV_MAX_RSV_REQS:
 		seip->read_value = SG_MAX_RSV_REQS;
 		break;
+	case SG_SEIRV_DEV_TS_LOWER:	/* timestamp is 64 bits */
+		seip->read_value = sfp->parentdp->create_ns & U32_MAX;
+		break;
+	case SG_SEIRV_DEV_TS_UPPER:
+		seip->read_value = (sfp->parentdp->create_ns >> 32) & U32_MAX;
+		break;
 	default:
 		SG_LOG(6, sfp, "%s: can't decode %d --> read_value\n",
 		       __func__, seip->read_value);
@@ -5530,6 +5537,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	} else
 		pr_warn("%s: sg_sys Invalid\n", __func__);
 
+	sdp->create_ns = ktime_get_boottime_ns();
 	sg_calc_sgat_param(sdp);
 	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
 		    "type %d\n", sdp->index, scsidp->type);
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index a1f35fd34816..a3f3d244d2af 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -223,6 +223,8 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_SEIRV_SUBMITTED	0x5	/* number of mrqs submitted+unread */
 #define SG_SEIRV_DEV_SUBMITTED	0x6	/* sum(submitted) on all dev's fds */
 #define SG_SEIRV_MAX_RSV_REQS	0x7	/* maximum reserve requests */
+#define SG_SEIRV_DEV_TS_LOWER	0x8	/* device timestamp's lower 32 bits */
+#define SG_SEIRV_DEV_TS_UPPER	0x9	/* device timestamp's upper 32 bits */
 
 /*
  * A pointer to the following structure is passed as the third argument to
-- 
2.25.1

