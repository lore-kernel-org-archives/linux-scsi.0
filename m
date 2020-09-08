Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980F9C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 21:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6424F2080C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 21:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgIHViZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 17:38:25 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:48831 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgIHViY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 17:38:24 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MqqLB-1kstV21FIX-00mtWU; Tue, 08 Sep 2020 23:38:09 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     hch@infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
Date:   Tue,  8 Sep 2020 23:36:23 +0200
Message-Id: <20200908213715.3553098-3-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908213715.3553098-1-arnd@arndb.de>
References: <20200908213715.3553098-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ALhk5O7zdQzPn/jSuPH+SFbSayui4FFXnnw3ouKbjiE+KJxxXHJ
 xTxJi6sZWQIF4ClRlZEyqVEjbZQrQzE/7GtswSVjmEX5iezDeeLnkgAsigIUUoU84vaWzJ/
 XfqSldp+Aqx7jqXiwLuESijum4eObbxC2HXq5l8oMRagi7UsEIMRTpkDN96Lnbh5vxCe+Xm
 fAN3SeB+lK3H23/4YpSNA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gB8irALDMJw=:O/YhdWxQkADB+Kl5gwn9kK
 ULGoh+6wFVyrYrbCLUDAcR5M+1j5jvMV+30keUMGxoMjhBnuap8ump34sCJ1/F8lqsn6fBLOM
 HzTjjyPrdWXzkgfjZg6zV3X4JEvhWuy1PEp4r0Ihj2NXWU+NxSmlcxN0P4XfvxaLJZmgW7+Ew
 Cw7hDArxfg4AWPSpMI5i7zF1fpguUH+LBhcUNRmy54GWqeVyoAUAO4dLqESraIVy7lRxF8/kz
 bhMi0n4ynGT7WLNfrcuHE1S6lomqNxW1QO343qR8v+X4fYS5KwUFSeOOnBqvwE6U1ZqpOwnZv
 MPTWNnWmg9ARuNwoqzlY7zd5EUK4UgDCkcOLYif1mu8InCZ/3Pz6oIGDVGVPuzVMwPff+Cq+w
 LP+J147saJjDS/2DSoxBvUIv0l2pNrfMT0J7GpdKtCUZsBIBN1EwlknytXCaHkeHJUlK6X2eG
 6nv3ZHodzrI2gRluLXArKC/OjJ7infDW38Dd4MGv9t0xb1bL6bHyPtZGdA0ALXFp2RhowVE6h
 YwQn8U/B7YM1aOMe2Gl+femd5JuozUsp/UcCiqeewdA2MZGu5Ki2vvjuJ4CDjR1qFVzT8yExf
 2S4bUbzWQ5ywhF/qbf1QinxmCkUaAVGl2zVJguno14PDYRPi8Emk6WOY87AAObgbaWp1NUjpu
 Gr9wQh5VG/JdhdSD7nqdekyqaCfF2xvF7D3Ar22XnJzrlA2JIacKv+XCWtk2XyAItZ4E5O6EF
 XZ1cT9721+czN0iIjBhP/ht0gclQeDu5X5JYQUT8tudhx3dKRRGKYSHnWdLDQEVi/57wmz3Js
 Yk/BbXJ84rlufntVXgaTt7ZJyNhEnpxDRT9Jseg09i1rHfSVfNBIsEuV/KVd3iG7ZNf24cy
Sender: linux-scsi-owner@vger.kernel.org
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
 drivers/scsi/megaraid/megaraid_sas_base.c | 123 ++++++++++------------
 1 file changed, 56 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c3de69f3bee8..601dab468823 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8331,6 +8331,56 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	return error;
 }
 
+static struct megasas_iocpacket *megasas_compat_iocpacket_get_user(void __user *arg)
+{
+	int err = -EFAULT;
+#ifdef CONFIG_COMPAT
+	struct megasas_iocpacket *ioc;
+	struct compat_megasas_iocpacket __user *cioc = arg;
+	int i;
+
+	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
+	if (copy_from_user(ioc, arg,
+			   offsetof(struct megasas_iocpacket, frame) + 128))
+		goto out;
+
+	/*
+	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
+	 * sense_len is not null, so prepare the 64bit value under
+	 * the same condition.
+	 */
+	if (ioc->sense_len) {
+		compat_uptr_t *sense_ioc_ptr;
+		void __user *sense_cioc;
+
+		/* make sure the pointer is inside of frame.raw */
+		if (ioc->sense_off >
+		    (sizeof(ioc->frame.raw) - sizeof(void __user*))) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		sense_ioc_ptr = (compat_uptr_t *)&ioc->frame.raw[ioc->sense_off];
+		sense_cioc = compat_ptr(get_unaligned(sense_ioc_ptr));
+		put_unaligned((unsigned long)sense_cioc, (void **)sense_ioc_ptr);
+	}
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
+#endif
+	return ERR_PTR(err);
+}
+
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
@@ -8339,7 +8389,11 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
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
 
@@ -8444,78 +8498,13 @@ megasas_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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

