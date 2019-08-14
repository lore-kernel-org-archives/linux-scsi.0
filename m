Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F531C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 20:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29979216F4
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 20:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EM5otbJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfHNUsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 16:48:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41505 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfHNUsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 16:48:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so179447pgg.8;
        Wed, 14 Aug 2019 13:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L6zn8/zWRH7MLvF6tsV0jrWUHrDLxpZxnankn/jHAsA=;
        b=EM5otbJNYi3giwwXYDymSy6RoYjIHiHQ6hHtw2ovaBxYdF3ll7/aIE/g8CVY8DwrFk
         +kI6dD9D8gTRlVWG2+Tu/MgxHs2iYUSzC3wAvV+cR7lYKGCdcfJgLPl55b+G/0KLLUB2
         jKUP7zHROGXc7BvX/AW7ENTuhxIm8RL8Q8UTRF9A5AQbp3xlvpQQbfKyGpd0W4PzCmxe
         KKqSEckTFg2NMJ40kKfzEJE5b5zBNfc2Q8nfSTm9h89krGTuMpl+VsW4+CjY5lXpaafh
         DQ3BYXIyW92VS7Py2lS6+KKZQOHZ9Xm3uK/zZQhtxUu3w+c+po3AlEEcicILVxPjYxXG
         F7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L6zn8/zWRH7MLvF6tsV0jrWUHrDLxpZxnankn/jHAsA=;
        b=kieyapSOEez63GNrruDlAmt/anu8SCvuKIMaK7UNE5P3VtW5cwlpKWcr1dT9Gk2mOV
         NoNlJXWH8o3JdgEObSQ9ihN24CcfQgu1b7BFCy983T6b7vdnHPe5XzhBeVKR40+wWsTi
         ZPZKVM/lMaZQBvkqOdfqlZJ80TL83X6vQ8c8tDF5BKhD7X+Etzs7vhvyUpFAZ8unWCzo
         wPVZPiAUp6cGJGRulDfPSvQ2VfCg0W0NtrV6FKc1ktEdO9nXo0vnpThVONtSSkA7P5il
         enNhNNvRSAGlb3XR7cqRF9iifOUYhGXZGcxUXdqoIq1ZuJfFfGENYF5abFIZJL0X4JKb
         7q3Q==
X-Gm-Message-State: APjAAAUwTIVjD+Hgm4NS7iyCCQTW0mup3dthwNpHWAVuMZjZyitQVFPz
        +MFCRuN3IdXBvvb8Gmo13rA=
X-Google-Smtp-Source: APXvYqyir3v3tA/xGjjloZiOxC1/jaqp2SmBfM8WCNk3zBq81e1rg0h8lg/e3sghxubfVd8hVS9maA==
X-Received: by 2002:a62:ab13:: with SMTP id p19mr1933410pff.20.1565815714651;
        Wed, 14 Aug 2019 13:48:34 -0700 (PDT)
Received: from localhost.localdomain (d206-116-172-62.bchsia.telus.net. [206.116.172.62])
        by smtp.gmail.com with ESMTPSA id r4sm812185pfl.127.2019.08.14.13.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 13:48:33 -0700 (PDT)
From:   Mark Balantzyan <mbalant3@gmail.com>
To:     sathya.prakash@broadcom.com
Cc:     suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Balantzyan <mbalant3@gmail.com>
Subject: [PATCH] lsilogic mpt fusion: mptctl: Fixed race condition around mptctl_id variable using mutexes
Date:   Wed, 14 Aug 2019 13:48:28 -0700
Message-Id: <20190814204828.13449-1-mbalant3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Certain functions in the driver, such as mptctl_do_fw_download() and
mptctl_do_mpt_command(), rely on the instance of mptctl_id, which does the
id-ing. There is race condition possible when these functions operate in
concurrency. Via, mutexes, the functions are mutually signalled to cooperate.

Signed-off-by: Mark Balantzyan <mbalant3@gmail.com>

---
 drivers/message/fusion/mptctl.c | 39 ++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 4470630d..f0b49a85 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -816,12 +816,15 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 
 		/*  Valid device. Get a message frame and construct the FW download message.
 	 	*/
+		mutex_lock(&mpctl_mutex);
 		if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
+			mutex_unlock(&mpctl_mutex);
 			return -EAGAIN;
 	}
-
+	mutex_lock(&mpctl_mutex);
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT
 	    "mptctl_do_fwdl called. mptctl_id = %xh.\n", iocp->name, mptctl_id));
+	mutex_unlock(&mpctl_mutex);
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.bufp  = %p\n",
 	    iocp->name, ufwbuf));
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.fwlen = %d\n",
@@ -943,7 +946,9 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	ReplyMsg = NULL;
 	SET_MGMT_MSG_CONTEXT(iocp->ioctl_cmds.msg_context, dlmsg->MsgContext);
 	INITIALIZE_MGMT_STATUS(iocp->ioctl_cmds.status)
+	mutex_lock(&mpctl_mutex);
 	mpt_put_msg_frame(mptctl_id, iocp, mf);
+	mutex_lock(&mpctl_mutex);
 
 	/* Now wait for the command to complete */
 retry_wait:
@@ -1889,7 +1894,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 	/* Get a free request frame and save the message context.
 	 */
+	mutex_lock(&mpctl_mutex);
         if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
+		mutex_unlock(&mpctl_mutex);
                 return -EAGAIN;
 
 	hdr = (MPIHeader_t *) mf;
@@ -2271,11 +2278,14 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
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
@@ -2287,8 +2297,11 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
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
@@ -2563,7 +2576,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	/* 
 	 * Gather ISTWI(Industry Standard Two Wire Interface) Data
 	 */
+	mutex_lock(&mpctl_mutex);
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
+		mutex_unlock(&mpctl_mutex);
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
 			"%s, no msg frames!!\n", ioc->name, __func__));
 		goto out;
@@ -2593,7 +2608,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context,
 				IstwiRWRequest->MsgContext);
 	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
+	mutex_lock(&mpctl_mutex);
 	mpt_put_msg_frame(mptctl_id, ioc, mf);
+	mutex_unlock(&mpctl_mutex);
 
 retry_wait:
 	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done,
@@ -3010,9 +3027,11 @@ static int __init mptctl_init(void)
 	 *  Install our handler
 	 */
 	++where;
+	mutex_lock(&mpctl_mutex);
 	mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
 	    "mptctl_reply");
 	if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
+		mutex_unlock(&mpctl_mutex);
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		misc_deregister(&mptctl_miscdev);
 		err = -EBUSY;
@@ -3022,13 +3041,14 @@ static int __init mptctl_init(void)
 	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER,
 	    "mptctl_taskmgmt_reply");
 	if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
+		mutex_unlock(&mpctl_mutex);
 		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
 		mpt_deregister(mptctl_id);
 		misc_deregister(&mptctl_miscdev);
 		err = -EBUSY;
 		goto out_fail;
 	}
-
+	mutex_unlock(&mpctl_mutex);
 	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
 	mpt_event_register(mptctl_id, mptctl_event_process);
 
@@ -3044,13 +3064,14 @@ out_fail:
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
 
@@ -3058,6 +3079,8 @@ static void mptctl_exit(void)
 	mpt_deregister(mptctl_taskmgmt_id);
 	mpt_deregister(mptctl_id);
 
+	mutex_unlock(&mpctl_mutex);
+
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 
 }
-- 
2.17.1

