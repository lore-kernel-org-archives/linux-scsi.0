Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A40C2D0C7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB973206A5
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLKUqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 15:46:06 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:40797 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLKUqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 15:46:04 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mzhf5-1hjio20Ph3-00vbw4; Wed, 11 Dec 2019 21:44:23 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-block@vger.kernel.org
Subject: [PATCH 02/24] compat: scsi: sg: fix v3 compat read/write interface
Date:   Wed, 11 Dec 2019 21:42:36 +0100
Message-Id: <20191211204306.1207817-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:DlM8/RSZOaYg5JzO7DSn/knKPUvnvQmVJDNmgl9LouBnU4D8Xp1
 /K/nZQCkejcMwqd34K2Q2OBGVdjrDhpVh8FPdUh0byRt9SW3BLbCX0oUB4xrMRk2xwLEfnB
 RlZHYWzNGZ9YtHMdiUUn1opDUpu7tCIjKc27WFY9HYeiSanGdlq9NRJjwNv7rVKJxk32BCY
 AE8eyDTr8OCkKgIhZDYog==
X-UI-Out-Filterresults: notjunk:1;V03:K0:57TTBnsP064=:xol5gk1SJmTe2qSSdWnL0w
 3a3nqIlxgWVtGDMKinfkP6M90bf9xUBEtxuQBD88/UGfqgJAYOiM7L3PPdvTmo9lkvzTpZQu0
 aUTZ4eiVwRshqensZ4GKhfWdBPld8QbYTSY9AVe0TMeyObvH+y9LetKeAUGCABADtnS5Qkw5G
 EcSoZvnK5Lh3Epls01CDs91roWqGa/ZaB1C5nZLdrpsVFCSavlzMrMmw9kK5LCanpNY/QQACE
 obCPL+eBF62x1XXEBpYGO8jj61UjgoLj5JcB1en4jh6StDSuF4kmBkDPiRKfFH/4Ny7uCuau9
 IBq38vB01H0aEfl268UwWIhsAkmlYXh5yab5jslBPHtuXVZSHql+g6klZ2QWwISYO+TIbWmIG
 5g9r0L3ulEJvK/xWDYygijvQo87e6JaMDPWEfVegNznVpasGpwDFZbpn6jq6BKlAee1nL/Aee
 F8iDOJ6oHpHeDJ+Eu+Z39lV64O9xRSJnuwiFTjIA0agfWveVlmVDoAE8X1t9EcG48N0TRFAqQ
 Gboa2XdlGNmU4keGeZkZmppSFyE43e/M2U4qftHy1xXmF8xIVVmLRIPp80G1F1A7JvaYLKCCq
 exaZWu1X5Bj8e8K5pTct5soi2v5F6KiJSu0rOxoIqd4Wvntn9bIrtn8sYFqtnYMphzH6FmHUB
 XY0X4+deX3vRvsf8L5WE89BH8edm6St/YYxJM2hqRjUIg4Y1x/H+vfQx01oxzSZSpRrExc8v4
 L3VXA8er+Zo+OFOvu4LSXOhlYxpXUf/nzl2mA8g6uFBRVQJIxz9vpVSXs9O7Csk/l762+jDUa
 JAewa1xpYzvxig7e+Gw4SqhYNWc2KYC3u7/Amh+SzvE+r0Zdg4ZchYXdUubg2vH0DZ5gAGXr6
 zbeTPLkZhfhYLYWMIQfQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the v5.4 merge window, a cleanup patch from Al Viro conflicted
with my rework of the compat handling for sg.c read(). Linus Torvalds
did a correct merge but pointed out that the resulting code is still
unsatisfactory.

I later noticed that the sg_new_read() function still gets the compat
mode wrong, when the 'count' argument is large enough to pass a
compat_sg_io_hdr object, but not a nativ sg_io_hdr.

To address both of these, move the definition of compat_sg_io_hdr
into a scsi/sg.h to make it visible to sg.c and rewrite the logic
for reading req_pack_id as well as the size check to a simpler
version that gets the expected results.

Fixes: c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t")
Fixes: 98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/scsi_ioctl.c |  29 +----------
 drivers/scsi/sg.c  | 125 +++++++++++++++++++++------------------------
 include/scsi/sg.h  |  30 +++++++++++
 3 files changed, 89 insertions(+), 95 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 650bade5ea5a..b61dbf4d8443 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -20,6 +20,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/sg.h>
 
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
@@ -550,34 +551,6 @@ static inline int blk_send_start_stop(struct request_queue *q,
 	return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);
 }
 
-#ifdef CONFIG_COMPAT
-struct compat_sg_io_hdr {
-	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
-	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
-	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
-	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
-	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
-	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
-	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
-						or scatter gather list */
-	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
-	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
-	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
-	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
-	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
-	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
-	unsigned char status;		/* [o] scsi status */
-	unsigned char masked_status;	/* [o] shifted, masked scsi status */
-	unsigned char msg_status;	/* [o] messaging level data (optional) */
-	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
-	unsigned short host_status;	/* [o] errors from host adapter */
-	unsigned short driver_status;	/* [o] errors from software driver */
-	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
-	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
-	compat_uint_t info;		/* [o] auxiliary information */
-};
-#endif
-
 int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
 {
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 160748ad9c0f..985546aac236 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -198,6 +198,7 @@ static void sg_device_destroy(struct kref *kref);
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
+#define SZ_COMPAT_SG_IO_HDR sizeof(struct compat_sg_io_hdr)
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
@@ -405,6 +406,36 @@ sg_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
+{
+	struct sg_header __user *old_hdr = buf;
+	int reply_len;
+
+	if (count < SZ_SG_HEADER)
+		goto unknown_id;
+
+	/* negative reply_len means v3 format, otherwise v1/v2 */
+	if (get_user(reply_len, &old_hdr->reply_len))
+		return -EFAULT;
+	if (reply_len >= 0)
+		return get_user(*pack_id, &old_hdr->pack_id);
+
+	if (in_compat_syscall() && count >= SZ_COMPAT_SG_IO_HDR) {
+		struct compat_sg_io_hdr __user *hp = buf;
+		return get_user(*pack_id, &hp->pack_id);
+	}
+
+	if (count >= SZ_SG_IO_HDR) {
+		struct sg_io_hdr __user *hp = buf;
+		return get_user(*pack_id, &hp->pack_id);
+	}
+
+unknown_id:
+	/* no valid header was passed, so ignore the pack_id */
+	*pack_id = -1;
+	return 0;
+}
+
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 {
@@ -413,8 +444,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	Sg_request *srp;
 	int req_pack_id = -1;
 	sg_io_hdr_t *hp;
-	struct sg_header *old_hdr = NULL;
-	int retval = 0;
+	struct sg_header *old_hdr;
+	int retval;
 
 	/*
 	 * This could cause a response to be stranded. Close the associated
@@ -429,79 +460,34 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_read: count=%d\n", (int) count));
 
-	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		old_hdr = memdup_user(buf, SZ_SG_HEADER);
-		if (IS_ERR(old_hdr))
-			return PTR_ERR(old_hdr);
-		if (old_hdr->reply_len < 0) {
-			if (count >= SZ_SG_IO_HDR) {
-				/*
-				 * This is stupid.
-				 *
-				 * We're copying the whole sg_io_hdr_t from user
-				 * space just to get the 'pack_id' field. But the
-				 * field is at different offsets for the compat
-				 * case, so we'll use "get_sg_io_hdr()" to copy
-				 * the whole thing and convert it.
-				 *
-				 * We could do something like just calculating the
-				 * offset based of 'in_compat_syscall()', but the
-				 * 'compat_sg_io_hdr' definition is in the wrong
-				 * place for that.
-				 */
-				sg_io_hdr_t *new_hdr;
-				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
-				if (!new_hdr) {
-					retval = -ENOMEM;
-					goto free_old_hdr;
-				}
-				retval = get_sg_io_hdr(new_hdr, buf);
-				req_pack_id = new_hdr->pack_id;
-				kfree(new_hdr);
-				if (retval) {
-					retval = -EFAULT;
-					goto free_old_hdr;
-				}
-			}
-		} else
-			req_pack_id = old_hdr->pack_id;
-	}
+	if (sfp->force_packid)
+		retval = get_sg_io_pack_id(&req_pack_id, buf, count);
+	if (retval)
+		return retval;
+
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (filp->f_flags & O_NONBLOCK) {
-			retval = -EAGAIN;
-			goto free_old_hdr;
-		}
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
 		retval = wait_event_interruptible(sfp->read_wait,
 			(atomic_read(&sdp->detaching) ||
 			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (retval) {
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		if (retval)
 			/* -ERESTARTSYS as signal hit process */
-			goto free_old_hdr;
-		}
-	}
-	if (srp->header.interface_id != '\0') {
-		retval = sg_new_read(sfp, buf, count, srp);
-		goto free_old_hdr;
+			return retval;
 	}
+	if (srp->header.interface_id != '\0')
+		return sg_new_read(sfp, buf, count, srp);
 
 	hp = &srp->header;
-	if (old_hdr == NULL) {
-		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
-		if (! old_hdr) {
-			retval = -ENOMEM;
-			goto free_old_hdr;
-		}
-	}
-	memset(old_hdr, 0, SZ_SG_HEADER);
+	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
+	if (!old_hdr)
+		return -ENOMEM;
+
 	old_hdr->reply_len = (int) hp->timeout;
 	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
 	old_hdr->pack_id = hp->pack_id;
@@ -575,7 +561,12 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 	int err = 0, err2;
 	int len;
 
-	if (count < SZ_SG_IO_HDR) {
+	if (in_compat_syscall()) {
+		if (count < SZ_COMPAT_SG_IO_HDR) {
+			err = -EINVAL;
+			goto err_out;
+		}
+	} else if (count < SZ_SG_IO_HDR) {
 		err = -EINVAL;
 		goto err_out;
 	}
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index f91bcca604e4..29c7ad04d2e2 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -68,6 +68,36 @@ typedef struct sg_io_hdr
     unsigned int info;          /* [o] auxiliary information */
 } sg_io_hdr_t;  /* 64 bytes long (on i386) */
 
+#if defined(__KERNEL__)
+#include <linux/compat.h>
+
+struct compat_sg_io_hdr {
+	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
+	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
+	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
+	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
+	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
+	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
+	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
+						or scatter gather list */
+	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
+	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
+	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
+	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
+	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
+	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
+	unsigned char status;		/* [o] scsi status */
+	unsigned char masked_status;	/* [o] shifted, masked scsi status */
+	unsigned char msg_status;	/* [o] messaging level data (optional) */
+	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
+	unsigned short host_status;	/* [o] errors from host adapter */
+	unsigned short driver_status;	/* [o] errors from software driver */
+	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
+	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
+	compat_uint_t info;		/* [o] auxiliary information */
+};
+#endif
+
 #define SG_INTERFACE_ID_ORIG 'S'
 
 /* Use negative values to flag difference from original sg_header structure */
-- 
2.20.0

