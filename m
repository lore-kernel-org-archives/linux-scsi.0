Return-Path: <SRS0=DCIq=3H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B683C33CB6
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jan 2020 18:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1614224697
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jan 2020 18:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q5tijWJ6";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q5tijWJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgARSeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 13:34:09 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51694 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726490AbgARSeJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jan 2020 13:34:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9671F8EE2AB;
        Sat, 18 Jan 2020 10:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1579372448;
        bh=L750pW0jXFMPlih59WLf5u6SjmIF4FbxRBF2zqyrBh0=;
        h=Subject:From:To:Cc:Date:From;
        b=q5tijWJ6JMA9carFlQccxvUV3iZfF120Ql+FG206Lb/CoA5+AiaP18+Z9FkSG/6ca
         XByrP50VFC0b2S+No3eK+9eMPd02TmVNz2zlq2S9LbrpgGUdAb6+L9v0N9S5wfe7Gu
         UD34Dm00KzkTn0mhi3TnFKwvUD69xJnUBCppqX3E=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 747-54qCavoF; Sat, 18 Jan 2020 10:34:08 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CF06C8EE17D;
        Sat, 18 Jan 2020 10:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1579372448;
        bh=L750pW0jXFMPlih59WLf5u6SjmIF4FbxRBF2zqyrBh0=;
        h=Subject:From:To:Cc:Date:From;
        b=q5tijWJ6JMA9carFlQccxvUV3iZfF120Ql+FG206Lb/CoA5+AiaP18+Z9FkSG/6ca
         XByrP50VFC0b2S+No3eK+9eMPd02TmVNz2zlq2S9LbrpgGUdAb6+L9v0N9S5wfe7Gu
         UD34Dm00KzkTn0mhi3TnFKwvUD69xJnUBCppqX3E=
Message-ID: <1579372445.3421.26.camel@HansenPartnership.com>
Subject: [GIT PULL] more SCSI fixes for 5.5-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 18 Jan 2020 10:34:05 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three fixes in drivers with no impact to core code. The mptfusion fix
is enormous because the driver API had to be rethreaded to pass down
the necessary iocp pointer, but once that's done a significant chunk of
code is deleted.  The other two patches are small.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: fnic: fix invalid stack access

Dan Carpenter (1):
      scsi: mptfusion: Fix double fetch bug in ioctl

Long Li (1):
      scsi: storvsc: Correctly set number of hardware queues for IDE disk

And the diffstat:

 drivers/message/fusion/mptctl.c | 213 ++++++++++------------------------------
 drivers/scsi/fnic/vnic_dev.c    |  20 ++--
 drivers/scsi/storvsc_drv.c      |   4 +-
 3 files changed, 63 insertions(+), 174 deletions(-)

With full diff below.

James

---

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index f9ac22413000..1074b882c57c 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -100,19 +100,19 @@ struct buflist {
  * Function prototypes. Called from OS entry point mptctl_ioctl.
  * arg contents specific to function.
  */
-static int mptctl_fw_download(unsigned long arg);
-static int mptctl_getiocinfo(unsigned long arg, unsigned int cmd);
-static int mptctl_gettargetinfo(unsigned long arg);
-static int mptctl_readtest(unsigned long arg);
-static int mptctl_mpt_command(unsigned long arg);
-static int mptctl_eventquery(unsigned long arg);
-static int mptctl_eventenable(unsigned long arg);
-static int mptctl_eventreport(unsigned long arg);
-static int mptctl_replace_fw(unsigned long arg);
-
-static int mptctl_do_reset(unsigned long arg);
-static int mptctl_hp_hostinfo(unsigned long arg, unsigned int cmd);
-static int mptctl_hp_targetinfo(unsigned long arg);
+static int mptctl_fw_download(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_getiocinfo(MPT_ADAPTER *iocp, unsigned long arg, unsigned int cmd);
+static int mptctl_gettargetinfo(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_readtest(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_mpt_command(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_eventquery(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_eventenable(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_eventreport(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_replace_fw(MPT_ADAPTER *iocp, unsigned long arg);
+
+static int mptctl_do_reset(MPT_ADAPTER *iocp, unsigned long arg);
+static int mptctl_hp_hostinfo(MPT_ADAPTER *iocp, unsigned long arg, unsigned int cmd);
+static int mptctl_hp_targetinfo(MPT_ADAPTER *iocp, unsigned long arg);
 
 static int  mptctl_probe(struct pci_dev *, const struct pci_device_id *);
 static void mptctl_remove(struct pci_dev *);
@@ -123,8 +123,8 @@ static long compat_mpctl_ioctl(struct file *f, unsigned cmd, unsigned long arg);
 /*
  * Private function calls.
  */
-static int mptctl_do_mpt_command(struct mpt_ioctl_command karg, void __user *mfPtr);
-static int mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen);
+static int mptctl_do_mpt_command(MPT_ADAPTER *iocp, struct mpt_ioctl_command karg, void __user *mfPtr);
+static int mptctl_do_fw_download(MPT_ADAPTER *iocp, char __user *ufwbuf, size_t fwlen);
 static MptSge_t *kbuf_alloc_2_sgl(int bytes, u32 dir, int sge_offset, int *frags,
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);
 static void kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma,
@@ -656,19 +656,19 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	 * by TM and FW reloads.
 	 */
 	if ((cmd & ~IOCSIZE_MASK) == (MPTIOCINFO & ~IOCSIZE_MASK)) {
-		return mptctl_getiocinfo(arg, _IOC_SIZE(cmd));
+		return mptctl_getiocinfo(iocp, arg, _IOC_SIZE(cmd));
 	} else if (cmd == MPTTARGETINFO) {
-		return mptctl_gettargetinfo(arg);
+		return mptctl_gettargetinfo(iocp, arg);
 	} else if (cmd == MPTTEST) {
-		return mptctl_readtest(arg);
+		return mptctl_readtest(iocp, arg);
 	} else if (cmd == MPTEVENTQUERY) {
-		return mptctl_eventquery(arg);
+		return mptctl_eventquery(iocp, arg);
 	} else if (cmd == MPTEVENTENABLE) {
-		return mptctl_eventenable(arg);
+		return mptctl_eventenable(iocp, arg);
 	} else if (cmd == MPTEVENTREPORT) {
-		return mptctl_eventreport(arg);
+		return mptctl_eventreport(iocp, arg);
 	} else if (cmd == MPTFWREPLACE) {
-		return mptctl_replace_fw(arg);
+		return mptctl_replace_fw(iocp, arg);
 	}
 
 	/* All of these commands require an interrupt or
@@ -678,15 +678,15 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return ret;
 
 	if (cmd == MPTFWDOWNLOAD)
-		ret = mptctl_fw_download(arg);
+		ret = mptctl_fw_download(iocp, arg);
 	else if (cmd == MPTCOMMAND)
-		ret = mptctl_mpt_command(arg);
+		ret = mptctl_mpt_command(iocp, arg);
 	else if (cmd == MPTHARDRESET)
-		ret = mptctl_do_reset(arg);
+		ret = mptctl_do_reset(iocp, arg);
 	else if ((cmd & ~IOCSIZE_MASK) == (HP_GETHOSTINFO & ~IOCSIZE_MASK))
-		ret = mptctl_hp_hostinfo(arg, _IOC_SIZE(cmd));
+		ret = mptctl_hp_hostinfo(iocp, arg, _IOC_SIZE(cmd));
 	else if (cmd == HP_GETTARGETINFO)
-		ret = mptctl_hp_targetinfo(arg);
+		ret = mptctl_hp_targetinfo(iocp, arg);
 	else
 		ret = -EINVAL;
 
@@ -705,11 +705,10 @@ mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static int mptctl_do_reset(unsigned long arg)
+static int mptctl_do_reset(MPT_ADAPTER *iocp, unsigned long arg)
 {
 	struct mpt_ioctl_diag_reset __user *urinfo = (void __user *) arg;
 	struct mpt_ioctl_diag_reset krinfo;
-	MPT_ADAPTER		*iocp;
 
 	if (copy_from_user(&krinfo, urinfo, sizeof(struct mpt_ioctl_diag_reset))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_reset - "
@@ -718,12 +717,6 @@ static int mptctl_do_reset(unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (mpt_verify_adapter(krinfo.hdr.iocnum, &iocp) < 0) {
-		printk(KERN_DEBUG MYNAM "%s@%d::mptctl_do_reset - ioc%d not found!\n",
-				__FILE__, __LINE__, krinfo.hdr.iocnum);
-		return -ENODEV; /* (-6) No such device or address */
-	}
-
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset called.\n",
 	    iocp->name));
 
@@ -754,7 +747,7 @@ static int mptctl_do_reset(unsigned long arg)
  *		-ENOMSG if FW upload returned bad status
  */
 static int
-mptctl_fw_download(unsigned long arg)
+mptctl_fw_download(MPT_ADAPTER *iocp, unsigned long arg)
 {
 	struct mpt_fw_xfer __user *ufwdl = (void __user *) arg;
 	struct mpt_fw_xfer	 kfwdl;
@@ -766,7 +759,7 @@ mptctl_fw_download(unsigned long arg)
 		return -EFAULT;
 	}
 
-	return mptctl_do_fw_download(kfwdl.iocnum, kfwdl.bufp, kfwdl.fwlen);
+	return mptctl_do_fw_download(iocp, kfwdl.bufp, kfwdl.fwlen);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -784,11 +777,10 @@ mptctl_fw_download(unsigned long arg)
  *		-ENOMSG if FW upload returned bad status
  */
 static int
-mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
+mptctl_do_fw_download(MPT_ADAPTER *iocp, char __user *ufwbuf, size_t fwlen)
 {
 	FWDownload_t		*dlmsg;
 	MPT_FRAME_HDR		*mf;
-	MPT_ADAPTER		*iocp;
 	FWDownloadTCSGE_t	*ptsge;
 	MptSge_t		*sgl, *sgIn;
 	char			*sgOut;
@@ -808,17 +800,10 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	pFWDownloadReply_t	 ReplyMsg = NULL;
 	unsigned long		 timeleft;
 
-	if (mpt_verify_adapter(ioc, &iocp) < 0) {
-		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n",
-				 ioc);
-		return -ENODEV; /* (-6) No such device or address */
-	} else {
-
-		/*  Valid device. Get a message frame and construct the FW download message.
-	 	*/
-		if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
-			return -EAGAIN;
-	}
+	/*  Valid device. Get a message frame and construct the FW download message.
+	*/
+	if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
+		return -EAGAIN;
 
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT
 	    "mptctl_do_fwdl called. mptctl_id = %xh.\n", iocp->name, mptctl_id));
@@ -826,8 +811,6 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	    iocp->name, ufwbuf));
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.fwlen = %d\n",
 	    iocp->name, (int)fwlen));
-	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.ioc   = %04xh\n",
-	    iocp->name, ioc));
 
 	dlmsg = (FWDownload_t*) mf;
 	ptsge = (FWDownloadTCSGE_t *) &dlmsg->SGL;
@@ -1238,13 +1221,11 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
+mptctl_getiocinfo (MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 {
 	struct mpt_ioctl_iocinfo __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_iocinfo *karg;
-	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
-	int			iocnum;
 	unsigned int		port;
 	int			cim_rev;
 	struct scsi_device 	*sdev;
@@ -1272,14 +1253,6 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 		return PTR_ERR(karg);
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_getiocinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		kfree(karg);
-		return -ENODEV;
-	}
-
 	/* Verify the data transfer size is correct. */
 	if (karg->hdr.maxDataSize != data_size) {
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_getiocinfo - "
@@ -1385,15 +1358,13 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_gettargetinfo (unsigned long arg)
+mptctl_gettargetinfo (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_targetinfo __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_targetinfo karg;
-	MPT_ADAPTER		*ioc;
 	VirtDevice		*vdevice;
 	char			*pmem;
 	int			*pdata;
-	int			iocnum;
 	int			numDevices = 0;
 	int			lun;
 	int			maxWordsLeft;
@@ -1408,13 +1379,6 @@ mptctl_gettargetinfo (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_gettargetinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_gettargetinfo called.\n",
 	    ioc->name));
 	/* Get the port number and set the maximum number of bytes
@@ -1510,12 +1474,10 @@ mptctl_gettargetinfo (unsigned long arg)
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_readtest (unsigned long arg)
+mptctl_readtest (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_test __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_test	 karg;
-	MPT_ADAPTER *ioc;
-	int iocnum;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_test))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_readtest - "
@@ -1524,13 +1486,6 @@ mptctl_readtest (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_readtest() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_readtest called.\n",
 	    ioc->name));
 	/* Fill in the data and return the structure to the calling
@@ -1571,12 +1526,10 @@ mptctl_readtest (unsigned long arg)
  *		-ENODEV  if no such device/adapter
  */
 static int
-mptctl_eventquery (unsigned long arg)
+mptctl_eventquery (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_eventquery __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_eventquery	 karg;
-	MPT_ADAPTER *ioc;
-	int iocnum;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventquery))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventquery - "
@@ -1585,13 +1538,6 @@ mptctl_eventquery (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_eventquery() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventquery called.\n",
 	    ioc->name));
 	karg.eventEntries = MPTCTL_EVENT_LOG_SIZE;
@@ -1610,12 +1556,10 @@ mptctl_eventquery (unsigned long arg)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-mptctl_eventenable (unsigned long arg)
+mptctl_eventenable (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_eventenable __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_eventenable	 karg;
-	MPT_ADAPTER *ioc;
-	int iocnum;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventenable))) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventenable - "
@@ -1624,13 +1568,6 @@ mptctl_eventenable (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_eventenable() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventenable called.\n",
 	    ioc->name));
 	if (ioc->events == NULL) {
@@ -1658,12 +1595,10 @@ mptctl_eventenable (unsigned long arg)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-mptctl_eventreport (unsigned long arg)
+mptctl_eventreport (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_eventreport __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_eventreport	 karg;
-	MPT_ADAPTER		 *ioc;
-	int			 iocnum;
 	int			 numBytes, maxEvents, max;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventreport))) {
@@ -1673,12 +1608,6 @@ mptctl_eventreport (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_eventreport() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_eventreport called.\n",
 	    ioc->name));
 
@@ -1712,12 +1641,10 @@ mptctl_eventreport (unsigned long arg)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-mptctl_replace_fw (unsigned long arg)
+mptctl_replace_fw (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_replace_fw __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_replace_fw	 karg;
-	MPT_ADAPTER		 *ioc;
-	int			 iocnum;
 	int			 newFwSize;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
@@ -1727,13 +1654,6 @@ mptctl_replace_fw (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_replace_fw() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_replace_fw called.\n",
 	    ioc->name));
 	/* If caching FW, Free the old FW image
@@ -1780,12 +1700,10 @@ mptctl_replace_fw (unsigned long arg)
  *		-ENOMEM if memory allocation error
  */
 static int
-mptctl_mpt_command (unsigned long arg)
+mptctl_mpt_command (MPT_ADAPTER *ioc, unsigned long arg)
 {
 	struct mpt_ioctl_command __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_command  karg;
-	MPT_ADAPTER	*ioc;
-	int		iocnum;
 	int		rc;
 
 
@@ -1796,14 +1714,7 @@ mptctl_mpt_command (unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_mpt_command() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
-	rc = mptctl_do_mpt_command (karg, &uarg->MF);
+	rc = mptctl_do_mpt_command (ioc, karg, &uarg->MF);
 
 	return rc;
 }
@@ -1821,9 +1732,8 @@ mptctl_mpt_command (unsigned long arg)
  *		-EPERM if SCSI I/O and target is untagged
  */
 static int
-mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
+mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __user *mfPtr)
 {
-	MPT_ADAPTER	*ioc;
 	MPT_FRAME_HDR	*mf = NULL;
 	MPIHeader_t	*hdr;
 	char		*psge;
@@ -1832,7 +1742,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	dma_addr_t	dma_addr_in;
 	dma_addr_t	dma_addr_out;
 	int		sgSize = 0;	/* Num SG elements */
-	int		iocnum, flagsLength;
+	int		flagsLength;
 	int		sz, rc = 0;
 	int		msgContext;
 	u16		req_idx;
@@ -1847,13 +1757,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	bufIn.kptr = bufOut.kptr = NULL;
 	bufIn.len = bufOut.len = 0;
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_do_mpt_command() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
-
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	if (ioc->ioc_reset_in_progress) {
 		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
@@ -2418,17 +2321,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
  *		-ENOMEM if memory allocation error
  */
 static int
-mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
+mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 {
 	hp_host_info_t	__user *uarg = (void __user *) arg;
-	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
 	char                    *pbuf=NULL;
 	dma_addr_t		buf_dma;
 	hp_host_info_t		karg;
 	CONFIGPARMS		cfg;
 	ConfigPageHeader_t	hdr;
-	int			iocnum;
 	int			rc, cim_rev;
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf = NULL;
@@ -2452,12 +2353,6 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-	    (ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_hp_hostinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": mptctl_hp_hostinfo called.\n",
 	    ioc->name));
 
@@ -2659,15 +2554,13 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
  *		-ENOMEM if memory allocation error
  */
 static int
-mptctl_hp_targetinfo(unsigned long arg)
+mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 {
 	hp_target_info_t __user *uarg = (void __user *) arg;
 	SCSIDevicePage0_t	*pg0_alloc;
 	SCSIDevicePage3_t	*pg3_alloc;
-	MPT_ADAPTER		*ioc;
 	MPT_SCSI_HOST 		*hd = NULL;
 	hp_target_info_t	karg;
-	int			iocnum;
 	int			data_sz;
 	dma_addr_t		page_dma;
 	CONFIGPARMS	 	cfg;
@@ -2681,12 +2574,6 @@ mptctl_hp_targetinfo(unsigned long arg)
 		return -EFAULT;
 	}
 
-	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
-		(ioc == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_hp_targetinfo() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnum);
-		return -ENODEV;
-	}
 	if (karg.hdr.id >= MPT_MAX_FC_DEVICES)
 		return -EINVAL;
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_hp_targetinfo called.\n",
@@ -2854,7 +2741,7 @@ compat_mptfwxfer_ioctl(struct file *filp, unsigned int cmd,
 	kfw.fwlen = kfw32.fwlen;
 	kfw.bufp = compat_ptr(kfw32.bufp);
 
-	ret = mptctl_do_fw_download(kfw.iocnum, kfw.bufp, kfw.fwlen);
+	ret = mptctl_do_fw_download(iocp, kfw.bufp, kfw.fwlen);
 
 	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
@@ -2908,7 +2795,7 @@ compat_mpt_command(struct file *filp, unsigned int cmd,
 
 	/* Pass new structure to do_mpt_command
 	 */
-	ret = mptctl_do_mpt_command (karg, &uarg->MF);
+	ret = mptctl_do_mpt_command (iocp, karg, &uarg->MF);
 
 	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 1f55b9e4e74a..1b88a3b53eee 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -688,26 +688,26 @@ int vnic_dev_soft_reset_done(struct vnic_dev *vdev, int *done)
 
 int vnic_dev_hang_notify(struct vnic_dev *vdev)
 {
-	u64 a0, a1;
+	u64 a0 = 0, a1 = 0;
 	int wait = 1000;
 	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, wait);
 }
 
 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
-	u64 a0, a1;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err, i;
 
 	for (i = 0; i < ETH_ALEN; i++)
 		mac_addr[i] = 0;
 
-	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a[0], &a[1], wait);
 	if (err)
 		return err;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		mac_addr[i] = ((u8 *)&a0)[i];
+		mac_addr[i] = ((u8 *)&a)[i];
 
 	return 0;
 }
@@ -732,30 +732,30 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, int multicast,
 
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 = 0, a1 = 0;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err;
 	int i;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] = addr[i];
+		((u8 *)&a)[i] = addr[i];
 
-	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a[0], &a[1], wait);
 	if (err)
 		pr_err("Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a0 = 0, a1 = 0;
+	u64 a[2] = {};
 	int wait = 1000;
 	int err;
 	int i;
 
 	for (i = 0; i < ETH_ALEN; i++)
-		((u8 *)&a0)[i] = addr[i];
+		((u8 *)&a)[i] = addr[i];
 
-	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a[0], &a[1], wait);
 	if (err)
 		pr_err("Can't del addr [%pM], %d\n", addr, err);
 }
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f8faf8b3d965..fb41636519ee 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1842,9 +1842,11 @@ static int storvsc_probe(struct hv_device *device,
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
 	/*
+	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
 	 */
-	host->nr_hw_queues = num_present_cpus();
+	if (!dev_is_ide)
+		host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.
