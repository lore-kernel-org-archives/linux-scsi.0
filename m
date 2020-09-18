Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B81C43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 12:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0732E20870
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 12:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIRMQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 08:16:03 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:37225 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRMQD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 08:16:03 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MC0HF-1kBnB91zTx-00CUmb; Fri, 18 Sep 2020 14:15:46 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, anand.lodnoor@broadcom.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
Date:   Fri, 18 Sep 2020 14:15:43 +0200
Message-Id: <20200918121543.1466090-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918120955.1465510-1-arnd@arndb.de>
References: <20200918120955.1465510-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:z9AIGG+qS63xAkhNlR+tgy9b3xlu4k/PonUBJLNH95P0Poita0W
 fWz2zaCv8oJCc8irsoaaVWIZqh6Z461i52DpIZsRIBRmm2Matu8bljNwTZuEp6pAayFItl7
 MscbRKByL+0oLuwzRa9WN9NnJ3++ret0seWRJWKn1brE4BuXX/1jKinvZYv1k99Tkd1D9ua
 ncUevfikahluC74aHNQsw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:AERzY+NEGTU=:Dkbr3VlSvDqGNAeMasPAMr
 lK6edekI1h9ORqVKN2vq84L8Dat+Wpk0sT6UZBkAbyDcq/GisyUuYVQAHU5GAqtULUxdmWDlZ
 pDOID+4rJJLII9OSid3H2K8OTJ0/L0fwEJ8dOOqAp/jFmWWS/DpO0xumOcM1vAvHZgtStiY5v
 /6WVS5wWydkXEVotqWfoZBWzupLwRUfa1eSNgURal+1XlpUSU+la8iSaCh1ErXUU0i0dwQGjB
 wREHC0y62hjY0CpUrN8XusrdrQ0neU+k0fPiJAjyVIp05Vc3klTMiU3ppZ0eFz72Lb3KQMZSL
 uhLPkqaug1raIIcXQVOd99sv7JlmaRfZ19axnBGWcwVdOWPXXc6F1lzdhUqI3/Om24rgcg31U
 rq+zua5VhWMMGqEvamUl8PiHaq9jSyBprh4IA7Om3PnCqJSW+oq1N0c1td9P/NN+RuGvi/cqf
 fLG9v3/95mdTlzOV93YAIMoU83uxHufG/g35xLOZ/WE8j8YqOn0OwDC1BQHnnsJhtktiLs+fa
 6iBwMLCXxAwfLU2rHrnZzHrzD8u+lNUILwuLu3NaPsNrZJ67nJbpObkZdiBaqT9FOVNbFk4Iu
 QWTDa9JicFrikkowRz+PU1mpTQCoMzFbso7ehTlEL7uu/Wzcl77/AxvHDtl+LpZLuvy4ShCdl
 oC7epELAtUu3I8o65e6SOql6NaJEOHd5pSpvdF77U50flJh6lzibSzq9GdknUs1IGu86dzGEp
 c5mBuLaTsZLspUlvCr5SpcNaCUFOJQ1WLWFPjvWOM0Ox9+EQyLvUax2MaValN/nAISBagSoqR
 R6mYPfJ8/UjOSzqy+b89IBllvc4V/cQ8Smfbpx4KjcdIajgZZKMgdM2mrA7uZju409QTcMz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
---
v2: address review comments from hch
---
 drivers/scsi/megaraid/megaraid_sas.h      |   2 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 117 +++++++++-------------
 include/linux/compat.h                    |  10 +-
 3 files changed, 50 insertions(+), 79 deletions(-)

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
index c3de69f3bee8..d91951ee16ab 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8279,16 +8279,18 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
+			uptr = compat_ptr(get_unaligned((u32 *)sense_ptr));
+		else
+			uptr = get_unaligned((void __user **)sense_ptr);
 
-		if (copy_to_user((void __user *)((unsigned long)
-				 get_unaligned((unsigned long *)sense_ptr)),
-				 sense, ioc->sense_len)) {
+		if (copy_to_user(uptr, sense, ioc->sense_len)) {
 			dev_err(&instance->pdev->dev, "Failed to copy out to user "
 					"sense data\n");
 			error = -EFAULT;
@@ -8331,6 +8333,38 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
+		    get_user(ioc->sgl[i].iov_len, &cioc->sgl[i].iov_len)) {
+			goto out;
+		}
+		ioc->sgl[i].iov_base = compat_ptr(iov_base);
+	}
+
+	return ioc;
+out:
+	kfree(ioc);
+
+	return ERR_PTR(err);
+}
+
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
@@ -8339,7 +8373,11 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
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
 
@@ -8444,78 +8482,13 @@ megasas_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 1a530e1aa15a..a7a5a0ff59ef 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -91,6 +91,11 @@
 	static inline long __do_compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 #endif /* COMPAT_SYSCALL_DEFINEx */
 
+struct compat_iovec {
+	compat_uptr_t	iov_base;
+	compat_size_t	iov_len;
+};
+
 #ifdef CONFIG_COMPAT
 
 #ifndef compat_user_stack_pointer
@@ -248,11 +253,6 @@ typedef struct compat_siginfo {
 	} _sifields;
 } compat_siginfo_t;
 
-struct compat_iovec {
-	compat_uptr_t	iov_base;
-	compat_size_t	iov_len;
-};
-
 struct compat_rlimit {
 	compat_ulong_t	rlim_cur;
 	compat_ulong_t	rlim_max;
-- 
2.27.0

