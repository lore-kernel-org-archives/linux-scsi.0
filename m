Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ABEC55178
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4697E20725
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604076355;
	bh=+jA2F9SMD4SmqlEYokxQXsS4s9/IZa7HKNWZZqlIi2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iZ5PNflBfz5Tmg46sfZbQ69y0d7E45vIB/LT5D7/YfpssgRddHx5kc4KNOB5qJWsV
	 zpIhjsBBy5qPwCQbaCx2DVKHYTpiZlzHghNWzoyyKCed94b1b4+ciwv4JVbjSLvwAm
	 QvyEro5/r97Wy3QOqD9c1JTIACHUpqzkEyM0623Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgJ3Qpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 12:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJ3Qpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 12:45:52 -0400
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D67222C4;
        Fri, 30 Oct 2020 16:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076351;
        bh=+jA2F9SMD4SmqlEYokxQXsS4s9/IZa7HKNWZZqlIi2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYTHWlO3JBmZiI1FE3jXZkY+bXpIDujpCSreTR6tMg1ZANqwk5dQcoGO/nbRKYq8T
         Arjm21hegOFJph39VaM+JPy+Te5c9oFx3GCOxYuZLPZXinwSNrhkzrJUamyWSDRf2/
         Z8EOTZy8kkny1/htBZ+ZRffEajFNK80+6RgTromU=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
Date:   Fri, 30 Oct 2020 17:44:21 +0100
Message-Id: <20201030164450.1253641-3-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030164450.1253641-1-arnd@kernel.org>
References: <20201030164450.1253641-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There have been several attempts to fix serious problems
in the compat handling in megasas_mgmt_compat_ioctl_fw(),
and it also uses the compat_alloc_user_space() function.

Folding the compat handling into the regular ioctl
function with in_compat_syscall() simplifies it a lot and
avoids some of the remaining problems:

- missing handling of unaligned pointers
- overflowing the ioc->frame.raw array from
  invalid input
- compat_alloc_user_space()

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v3: address even more review comments from hch
v2: address review comments from hch
---
 drivers/scsi/megaraid/megaraid_sas.h      |   2 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 117 +++++++++-------------
 2 files changed, 45 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5e4137f10e0e..0f808d63580e 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2605,7 +2605,6 @@ struct megasas_aen {
 	u32 class_locale_word;
 } __attribute__ ((packed));
 
-#ifdef CONFIG_COMPAT
 struct compat_megasas_iocpacket {
 	u16 host_no;
 	u16 __pad1;
@@ -2621,7 +2620,6 @@ struct compat_megasas_iocpacket {
 } __attribute__ ((packed));
 
 #define MEGASAS_IOC_FIRMWARE32	_IOWR('M', 1, struct compat_megasas_iocpacket)
-#endif
 
 #define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
 #define MEGASAS_IOC_GET_AEN	_IOW('M', 3, struct megasas_aen)
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b1b9a8823c8c..88735dede051 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8318,16 +8318,19 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 * copy out the sense
 	 */
 	if (ioc->sense_len) {
+		void __user *uptr;
 		/*
 		 * sense_ptr points to the location that has the user
 		 * sense buffer address
 		 */
-		sense_ptr = (unsigned long *) ((unsigned long)ioc->frame.raw +
-				ioc->sense_off);
+		sense_ptr = (void *)ioc->frame.raw + ioc->sense_off;
+		if (in_compat_syscall())
+			uptr = compat_ptr(get_unaligned((compat_uptr_t *)
+							sense_ptr));
+		else
+			uptr = get_unaligned((void __user **)sense_ptr);
 
-		if (copy_to_user((void __user *)((unsigned long)
-				 get_unaligned((unsigned long *)sense_ptr)),
-				 sense, ioc->sense_len)) {
+		if (copy_to_user(uptr, sense, ioc->sense_len)) {
 			dev_err(&instance->pdev->dev, "Failed to copy out to user "
 					"sense data\n");
 			error = -EFAULT;
@@ -8370,6 +8373,37 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	return error;
 }
 
+static struct megasas_iocpacket *
+megasas_compat_iocpacket_get_user(void __user *arg)
+{
+	struct megasas_iocpacket *ioc;
+	struct compat_megasas_iocpacket __user *cioc = arg;
+	size_t size;
+	int err = -EFAULT;
+	int i;
+
+	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
+	if (!ioc)
+		return ERR_PTR(-ENOMEM);
+	size = offsetof(struct megasas_iocpacket, frame) + sizeof(ioc->frame);
+	if (copy_from_user(ioc, arg, size))
+		goto out;
+
+	for (i = 0; i < MAX_IOCTL_SGE; i++) {
+		compat_uptr_t iov_base;
+		if (get_user(iov_base, &cioc->sgl[i].iov_base) ||
+		    get_user(ioc->sgl[i].iov_len, &cioc->sgl[i].iov_len))
+			goto out;
+
+		ioc->sgl[i].iov_base = compat_ptr(iov_base);
+	}
+
+	return ioc;
+out:
+	kfree(ioc);
+	return ERR_PTR(err);
+}
+
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
@@ -8378,7 +8412,11 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	struct megasas_instance *instance;
 	int error;
 
-	ioc = memdup_user(user_ioc, sizeof(*ioc));
+	if (in_compat_syscall())
+		ioc = megasas_compat_iocpacket_get_user(user_ioc);
+	else
+		ioc = memdup_user(user_ioc, sizeof(struct megasas_iocpacket));
+
 	if (IS_ERR(ioc))
 		return PTR_ERR(ioc);
 
@@ -8483,78 +8521,13 @@ megasas_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
-{
-	struct compat_megasas_iocpacket __user *cioc =
-	    (struct compat_megasas_iocpacket __user *)arg;
-	struct megasas_iocpacket __user *ioc =
-	    compat_alloc_user_space(sizeof(struct megasas_iocpacket));
-	int i;
-	int error = 0;
-	compat_uptr_t ptr;
-	u32 local_sense_off;
-	u32 local_sense_len;
-	u32 user_sense_off;
-
-	if (clear_user(ioc, sizeof(*ioc)))
-		return -EFAULT;
-
-	if (copy_in_user(&ioc->host_no, &cioc->host_no, sizeof(u16)) ||
-	    copy_in_user(&ioc->sgl_off, &cioc->sgl_off, sizeof(u32)) ||
-	    copy_in_user(&ioc->sense_off, &cioc->sense_off, sizeof(u32)) ||
-	    copy_in_user(&ioc->sense_len, &cioc->sense_len, sizeof(u32)) ||
-	    copy_in_user(ioc->frame.raw, cioc->frame.raw, 128) ||
-	    copy_in_user(&ioc->sge_count, &cioc->sge_count, sizeof(u32)))
-		return -EFAULT;
-
-	/*
-	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
-	 * sense_len is not null, so prepare the 64bit value under
-	 * the same condition.
-	 */
-	if (get_user(local_sense_off, &ioc->sense_off) ||
-		get_user(local_sense_len, &ioc->sense_len) ||
-		get_user(user_sense_off, &cioc->sense_off))
-		return -EFAULT;
-
-	if (local_sense_off != user_sense_off)
-		return -EINVAL;
-
-	if (local_sense_len) {
-		void __user **sense_ioc_ptr =
-			(void __user **)((u8 *)((unsigned long)&ioc->frame.raw) + local_sense_off);
-		compat_uptr_t *sense_cioc_ptr =
-			(compat_uptr_t *)(((unsigned long)&cioc->frame.raw) + user_sense_off);
-		if (get_user(ptr, sense_cioc_ptr) ||
-		    put_user(compat_ptr(ptr), sense_ioc_ptr))
-			return -EFAULT;
-	}
-
-	for (i = 0; i < MAX_IOCTL_SGE; i++) {
-		if (get_user(ptr, &cioc->sgl[i].iov_base) ||
-		    put_user(compat_ptr(ptr), &ioc->sgl[i].iov_base) ||
-		    copy_in_user(&ioc->sgl[i].iov_len,
-				 &cioc->sgl[i].iov_len, sizeof(compat_size_t)))
-			return -EFAULT;
-	}
-
-	error = megasas_mgmt_ioctl_fw(file, (unsigned long)ioc);
-
-	if (copy_in_user(&cioc->frame.hdr.cmd_status,
-			 &ioc->frame.hdr.cmd_status, sizeof(u8))) {
-		printk(KERN_DEBUG "megasas: error copy_in_user cmd_status\n");
-		return -EFAULT;
-	}
-	return error;
-}
-
 static long
 megasas_mgmt_compat_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
 	switch (cmd) {
 	case MEGASAS_IOC_FIRMWARE32:
-		return megasas_mgmt_compat_ioctl_fw(file, arg);
+		return megasas_mgmt_ioctl_fw(file, arg);
 	case MEGASAS_IOC_GET_AEN:
 		return megasas_mgmt_ioctl_aen(file, arg);
 	}
-- 
2.27.0

