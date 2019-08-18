Return-Path: <SRS0=iy+L=WO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96BAC3A59E
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Aug 2019 22:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83D5B2186A
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Aug 2019 22:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZpt7/9D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfHRWyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Aug 2019 18:54:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33962 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfHRWye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Aug 2019 18:54:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so8457pgc.1;
        Sun, 18 Aug 2019 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GvtAa9lixzASNYEMlPTrzDBT/cBVP9MB8EpZD3U1M6Q=;
        b=CZpt7/9DoZopVPgiIy65QUP5U3rrCN3A5ywE7xdFPph07J4aG1Y2rRW32UK9ngX2Na
         d1AFC9+q9E7uMi9WYpuYioFLaGCkpg7z0HPZKitEKsnsxQB0dLeuLy7KCKLQBARkBEWT
         0NLHhUZ6jcsg+qUIQqE+hUaspbmJFs4z/f2k8SwQkoy66bKfihq3dw0jShxpAr72ucxo
         aUNCF0eAIM2rfHARGqJV/0F6uDf/Mz0FYNHJ3guptp7Diz1dUbZ5Zs0/Fains/C2+eau
         4U7dWc2cAZvrclW+3nxTT1zric+RKXabiNz4XRBhdvQpXVY4x46BKejkZ6ZfN32Ai1bP
         LhkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GvtAa9lixzASNYEMlPTrzDBT/cBVP9MB8EpZD3U1M6Q=;
        b=BozbNfLMrZoqg+veVRVeiULN9k7l7kjzCRe56zPXsXQH7nWjLYz5Jay9uE8qhFogNG
         Rc4t5TUtDZwl6shJwqEtmLyqifq8hbEMwmyLRtm8ItKiizmR8tF60EtPuLCrv/PqKN5h
         t4M7fFQkfXaCaTxcqJnLRxsiI/y66VwfLsIdj0Pfh4M7Twq/oxaeJ3nHr6UMR/kHYP+g
         nwCavXVbQprcALDZcx1PwnOYKpgT7VnAAqeSR9ZXQ9wqpq13W1kZBEmivjJgDk5nwlw3
         bwgVBZKSIGPYNzottyEiJeJ5ouP/1tUask8RvX3I9gcH6dna+lsdHQrNd08/HJNW6Uyq
         sq3w==
X-Gm-Message-State: APjAAAW5opJTzqKA0eBO1Ea+mu903NWgEE3buUp9igUJYd1lRGSJ8LDJ
        aHFj/qTITlgFu8oBJ3VWWOo=
X-Google-Smtp-Source: APXvYqz/RfzO5PSZSobu5ChjjmrbmjefV1a0Yqz9mVDSKRjYB91gJZJuv2iPZfpRyNd+cTRv9jjboA==
X-Received: by 2002:aa7:94a8:: with SMTP id a8mr21138617pfl.75.1566168873987;
        Sun, 18 Aug 2019 15:54:33 -0700 (PDT)
Received: from localhost.localdomain (d206-116-172-62.bchsia.telus.net. [206.116.172.62])
        by smtp.gmail.com with ESMTPSA id 185sm19379161pff.54.2019.08.18.15.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 15:54:33 -0700 (PDT)
From:   Mark Balantzyan <mbalant3@gmail.com>
To:     sathya.prakash@broadcom.com
Cc:     suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Balantzyan <mbalant3@gmail.com>
Subject: [PATCH v4] lsilogic mpt fusion: mptctl: Fixed race condition in mptctl.ko concerning mptctl_id variable among parallel functions variable among parallel functions
Date:   Sun, 18 Aug 2019 15:54:28 -0700
Message-Id: <20190818225428.25057-1-mbalant3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Certain functions in the driver, such as mptctl_do_fw_download() and
mptctl_do_mpt_command(), rely on the instance of mptctl_id, which does the
id-ing. There is race condition possible when these functions operate in
concurrency. Via, mutexes and global/local variable setting, the functions 
are mutually signalled to cooperate.

Signed-off-by: Mark Balantzyan <mbalant3@gmail.com>

---

Changelog v2

Lacked a version number but added properly terminated else condition at
(former) line 2300.

Changelog v3

Fixes "return -EAGAIN" lines which were erroneously tabbed as if to be guarded
by "if" conditions lying above them.

Changelog v4

Removes a pair of needless mutexes in init() function, allows for checking of NULL
condition outside of race-fixing mutexes in functions mptctl_do_mpt_command(), mptctl_do_fw_command, and mptctl_hp_hostinfo().

 drivers/message/fusion/mptctl.c | 59 ++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 4470630d..21af0ee8 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -816,12 +816,17 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 
 		/*  Valid device. Get a message frame and construct the FW download message.
 	 	*/
-		if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
+		mutex_lock(&mpctl_mutex);
+		mf = mpt_get_msg_frame(mptctl_id, iocp);
+		mutex_unlock(&mpctl_mutex);
+		if (mf == NULL) {
 			return -EAGAIN;
+		}
 	}
-
+	mutex_lock(&mpctl_mutex);
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT
 	    "mptctl_do_fwdl called. mptctl_id = %xh.\n", iocp->name, mptctl_id));
+	mutex_unlock(&mpctl_mutex);
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.bufp  = %p\n",
 	    iocp->name, ufwbuf));
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.fwlen = %d\n",
@@ -943,7 +948,9 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	ReplyMsg = NULL;
 	SET_MGMT_MSG_CONTEXT(iocp->ioctl_cmds.msg_context, dlmsg->MsgContext);
 	INITIALIZE_MGMT_STATUS(iocp->ioctl_cmds.status)
+	mutex_lock(&mpctl_mutex);
 	mpt_put_msg_frame(mptctl_id, iocp, mf);
+	mutex_lock(&mpctl_mutex);
 
 	/* Now wait for the command to complete */
 retry_wait:
@@ -1889,8 +1896,12 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 	/* Get a free request frame and save the message context.
 	 */
-        if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
-                return -EAGAIN;
+	mutex_lock(&mpctl_mutex);
+	mf = mpt_get_msg_frame(mptctl_id, ioc);
+	mutex_unlock(&mpctl_mutex);
+	if (mf == NULL) {
+		return -EAGAIN;
+	}
 
 	hdr = (MPIHeader_t *) mf;
 	msgContext = le32_to_cpu(hdr->MsgContext);
@@ -2271,11 +2282,14 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 		DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
 		if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
-		    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+		    (ioc->facts.MsgVersion >= MPI_VERSION_01_05)) {
+			mutex_lock(&mpctl_mutex);
 			mpt_put_msg_frame_hi_pri(mptctl_id, ioc, mf);
-		else {
-			rc =mpt_send_handshake_request(mptctl_id, ioc,
-				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
+			mutex_unlock(&mpctl_mutex);
+		} else {
+			mutex_lock(&mpctl_mutex);
+			rc = mpt_send_handshake_request(mptctl_id, ioc, sizeof(SCSITaskMgmt_t), (u32 *)mf, CAN_SLEEP);
+			mutex_unlock(&mpctl_mutex);
 			if (rc != 0) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				    "send_handshake FAILED! (ioc %p, mf %p)\n",
@@ -2287,8 +2301,11 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			}
 		}
 
-	} else
+	} else {
+		mutex_lock(&mpctl_mutex);
 		mpt_put_msg_frame(mptctl_id, ioc, mf);
+		mutex_unlock(&mpctl_mutex);
+	}
 
 	/* Now wait for the command to complete */
 	timeout = (karg.timeout > 0) ? karg.timeout : MPT_IOCTL_DEFAULT_TIMEOUT;
@@ -2563,7 +2580,10 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	/* 
 	 * Gather ISTWI(Industry Standard Two Wire Interface) Data
 	 */
-	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
+	mutex_lock(&mpctl_mutex);
+	mf = mpt_get_msg_frame(mptctl_id, ioc);
+	mutex_unlock(&mpctl_mutex);
+	if (mf == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
 			"%s, no msg frames!!\n", ioc->name, __func__));
 		goto out;
@@ -2593,7 +2613,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context,
 				IstwiRWRequest->MsgContext);
 	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
+	mutex_lock(&mpctl_mutex);
 	mpt_put_msg_frame(mptctl_id, ioc, mf);
+	mutex_unlock(&mpctl_mutex);
 
 retry_wait:
 	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done,
@@ -2991,6 +3013,7 @@ static int __init mptctl_init(void)
 {
 	int err;
 	int where = 1;
+	u8 m_id, m_taskmgmt_id;
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 
@@ -3010,25 +3033,26 @@ static int __init mptctl_init(void)
 	 *  Install our handler
 	 */
 	++where;
-	mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
+	m_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
 	    "mptctl_reply");
-	if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
+	if (!m_id || m_id >= MPT_MAX_PROTOCOL_DRIVERS) {
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		misc_deregister(&mptctl_miscdev);
 		err = -EBUSY;
 		goto out_fail;
 	}
+	mptctl_id = m_id; // registration with Fusion MPT base successful
 
-	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER,
+	m_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER,
 	    "mptctl_taskmgmt_reply");
-	if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
+	if (!m_taskmgmt_id || m_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		mpt_deregister(mptctl_id);
 		misc_deregister(&mptctl_miscdev);
 		err = -EBUSY;
 		goto out_fail;
 	}
-
+	mptctl_taskmgmt_id = m_taskmgmt_id; // registration with Fusion MPT base successful
 	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
 	mpt_event_register(mptctl_id, mptctl_event_process);
 
@@ -3044,13 +3068,14 @@ out_fail:
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static void mptctl_exit(void)
 {
+	mutex_lock(&mpctl_mutex);
 	misc_deregister(&mptctl_miscdev);
 	printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ (major,minor=%d,%d)\n",
 			 mptctl_miscdev.name, MISC_MAJOR, mptctl_miscdev.minor);
 
 	/* De-register event handler from base module */
 	mpt_event_deregister(mptctl_id);
-
+
 	/* De-register reset handler from base module */
 	mpt_reset_deregister(mptctl_id);
 
@@ -3058,6 +3083,8 @@ static void mptctl_exit(void)
 	mpt_deregister(mptctl_taskmgmt_id);
 	mpt_deregister(mptctl_id);
 
+	mutex_unlock(&mpctl_mutex);
+
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 
 }
-- 
2.17.1

