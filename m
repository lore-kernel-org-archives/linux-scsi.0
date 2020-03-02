Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D345C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD4622B48
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCBDdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:33:38 -0500
Received: from smtp.infotech.no ([82.134.31.41]:60605 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgCBDdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Mar 2020 22:33:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0D677204269;
        Mon,  2 Mar 2020 04:33:35 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X7NiEKaAyelX; Mon,  2 Mar 2020 04:33:33 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id AD31720426D;
        Mon,  2 Mar 2020 04:33:27 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v8 31/38] sg: add sg_iosubmit_v3 and sg_ioreceive_v3 ioctls
Date:   Sun,  1 Mar 2020 22:32:42 -0500
Message-Id: <20200302033249.4515-32-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302033249.4515-1-dgilbert@interlog.com>
References: <20200302033249.4515-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
are meant to be (almost) drop-in replacements for the write()/read()
async version 3 interface. They only accept the version 3 interface.

See the webpage at: http://sg.danny.cz/sg/sg_v40.html
specifically the table in the section titled: "13 SG interface
support changes".

If sgv3 is a struct sg_io_hdr object, suitably configured, then
    res = write(sg_fd, &sgv3, sizeof(sgv3));
and
    res = ioctl(sg_fd, SG_IOSUBMIT_V3, &sgv3);
are equivalent. Dito for read() and ioctl(SG_IORECEIVE_V3).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 75 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/scsi/sg.h |  6 ++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a1442bb59231..a60e4aace07f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -834,6 +834,24 @@ sg_ctl_iosubmit(struct file *filp, struct sg_fd *sfp, void __user *p)
 	return -EPERM;
 }
 
+static int
+sg_ctl_iosubmit_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
+{
+	int res;
+	u8 hdr_store[SZ_SG_IO_V4];      /* max(v3interface, v4interface) */
+	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hdr_store;
+	struct sg_device *sdp = sfp->parentdp;
+
+	res = sg_allow_if_err_recovery(sdp, (filp->f_flags & O_NONBLOCK));
+	if (unlikely(res))
+		return res;
+	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
+		return -EFAULT;
+	if (h3p->interface_id == 'S')
+		return sg_v3_submit(filp, sfp, h3p, false, NULL);
+	return -EPERM;
+}
+
 #if IS_ENABLED(SG_LOG_ACTIVE)
 static void
 sg_rq_state_fail(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
@@ -1282,6 +1300,57 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 	return sg_receive_v4(sfp, srp, p, h4p);
 }
 
+/*
+ * Called when ioctl(SG_IORECEIVE_V3) received. Expects a v3 interface.
+ * Checks if O_NONBLOCK file flag given, if not checks given flags field
+ * to see if SGV4_FLAG_IMMED is set. Either of these implies non blocking.
+ * When non-blocking and there is no request waiting, yields EAGAIN;
+ * otherwise it waits.
+ */
+static int
+sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
+{
+	bool non_block = !!(filp->f_flags & O_NONBLOCK);
+	int res;
+	int pack_id = SG_PACK_ID_WILDCARD;
+	u8 v3_holder[SZ_SG_IO_HDR];
+	struct sg_io_hdr *h3p = (struct sg_io_hdr *)v3_holder;
+	struct sg_device *sdp = sfp->parentdp;
+	struct sg_request *srp;
+
+	res = sg_allow_if_err_recovery(sdp, non_block);
+	if (unlikely(res))
+		return res;
+	/* Get first three 32 bit integers: guard, proto+subproto */
+	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
+		return -EFAULT;
+	/* for v3: interface_id=='S' (in a 32 bit int) */
+	if (h3p->interface_id != 'S')
+		return -EPERM;
+	if (h3p->flags & SGV4_FLAG_IMMED)
+		non_block = true;	/* set by either this or O_NONBLOCK */
+	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
+
+	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
+		pack_id = h3p->pack_id;
+
+	srp = sg_find_srp_by_id(sfp, pack_id);
+	if (!srp) {     /* nothing available so wait on packet or */
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
+		if (non_block)
+			return -EAGAIN;
+		res = wait_event_interruptible
+				(sfp->read_wait,
+				 sg_get_ready_srp(sfp, &srp, pack_id));
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
+		if (unlikely(res))
+			return res;	/* signal --> -ERESTARTSYS */
+	}	/* now srp should be valid */
+	return sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
+}
+
 static int
 sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	     struct sg_request *srp)
@@ -1873,9 +1942,15 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_IOSUBMIT:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT\n", __func__);
 		return sg_ctl_iosubmit(filp, sfp, p);
+	case SG_IOSUBMIT_V3:
+		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT_V3\n", __func__);
+		return sg_ctl_iosubmit_v3(filp, sfp, p);
 	case SG_IORECEIVE:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE\n", __func__);
 		return sg_ctl_ioreceive(filp, sfp, p);
+	case SG_IORECEIVE_V3:
+		SG_LOG(3, sfp, "%s:    SG_IORECEIVE_V3\n", __func__);
+		return sg_ctl_ioreceive_v3(filp, sfp, p);
 	case SG_GET_SCSI_ID:
 		return sg_ctl_scsi_id(sdev, sfp, p);
 	case SG_SET_FORCE_PACK_ID:
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 182001023360..cbade2870355 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -357,6 +357,12 @@ struct sg_header {
 /* Gives some v4 identifying info to driver, receives associated response */
 #define SG_IORECEIVE _IOWR(SG_IOCTL_MAGIC_NUM, 0x42, struct sg_io_v4)
 
+/* Submits a v3 interface object to driver */
+#define SG_IOSUBMIT_V3 _IOWR(SG_IOCTL_MAGIC_NUM, 0x45, struct sg_io_hdr)
+
+/* Gives some v3 identifying info to driver, receives associated response */
+#define SG_IORECEIVE_V3 _IOWR(SG_IOCTL_MAGIC_NUM, 0x46, struct sg_io_hdr)
+
 /* command queuing is always on when the v3 or v4 interface is used */
 #define SG_DEF_COMMAND_Q 0
 
-- 
2.25.1

