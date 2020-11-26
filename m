Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2656C8300F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74ED121D46
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="h/4PIlQf";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SBNPN6jN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389545AbgKZNak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389743AbgKZNak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE0EC0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 05:30:39 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWZinuhF44IRroHb4hD7Q0Kvc+zAzhZUteuvx6ildkM=;
        b=h/4PIlQfU59ZsGvuAqvIllGc9APCWXyf6nPXVX432VkUv3Pcv3vf0iesdxs7zval9LLMHb
        ZUwValfpdwIpICCjzoO+6YqRJNbpGMluu50Qe0jRKkN3clblAtbQT9VVqu/2lvMMU6crFd
        6TddkQT+8aR8BhXZwrWpP1Rzie8tb0G8jOMzjyPZrd0QVyGoQoL6jpZKS3jo4U2SdsOkX9
        BbFXb9VBbtyRHZqjkzriHn7jveOqiQLj5pWngOTDUtcb9tAvOd4/qwOu/aywPQX/2g0tgt
        ooECZWYV8+JRZtJnwxX7r8ojh5PO31vKDU+dipjYFDqPdAs3mS5TW3IehOv8BQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWZinuhF44IRroHb4hD7Q0Kvc+zAzhZUteuvx6ildkM=;
        b=SBNPN6jNE6BlezRqouO9hWdUGNnuxmvSi03dldf8vsAw+9o57PGzMOYxb3nMhcJLdxLKIj
        DctZyn2fJad3aABw==
To:     linux-scsi@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 13/14] scsi: message: fusion: Remove in_interrupt() usage in mpt_config().
Date:   Thu, 26 Nov 2020 14:29:51 +0100
Message-Id: <20201126132952.2287996-14-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

in_interrupt() is referenced all over the place in these drivers. Most of
these references are comments which are outdated and wrong.

Aside of that in_interrupt() is deprecated as it does not provide what the
name suggests. It covers more than hard/soft interrupt servicing context
and is semantically ill defined.

From reading the mpt_config() code and the history this is clearly a
debug mechanism and should probably be replaced by might_sleep() or
completely removed because such checks are already in the subsequent
functions.

Remove the in_interrupt() references and replace the usage in
mpt_config() with might_sleep().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
---
 drivers/message/fusion/mptbase.c  | 14 ++------------
 drivers/message/fusion/mptfc.c    |  2 +-
 drivers/message/fusion/mptscsih.c |  2 +-
 drivers/message/fusion/mptspi.c   |  2 +-
 4 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptb=
ase.c
index 3078fac34e51f..549797d0301d8 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -57,7 +57,7 @@
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/interrupt.h>		/* needed for in_interrupt() proto */
+#include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/kthread.h>
 #include <scsi/scsi_host.h>
@@ -6335,7 +6335,6 @@ SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply=
_t *evnp)
  *		Page header is updated.
  *
  *	Returns 0 for success
- *	-EPERM if not allowed due to ISR context
  *	-EAGAIN if no msg frames currently available
  *	-EFAULT for non-successful reply or no reply (timeout)
  */
@@ -6353,19 +6352,10 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 	u8		 page_type =3D 0, extend_page;
 	unsigned long 	 timeleft;
 	unsigned long	 flags;
-	int		 in_isr;
 	u8		 issue_hard_reset =3D 0;
 	u8		 retry_count =3D 0;
=20
-	/*	Prevent calling wait_event() (below), if caller happens
-	 *	to be in ISR context, because that is fatal!
-	 */
-	in_isr =3D in_interrupt();
-	if (in_isr) {
-		dcprintk(ioc, printk(MYIOC_s_WARN_FMT "Config request not allowed in ISR=
 context!\n",
-				ioc->name));
-		return -EPERM;
-    }
+	might_sleep();
=20
 	/* don't send a config page during diag reset */
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index f92b0433f599f..0484e9c15c097 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -50,7 +50,7 @@
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>	/* for mdelay */
-#include <linux/interrupt.h>	/* needed for in_interrupt() proto */
+#include <linux/interrupt.h>
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/workqueue.h>
 #include <linux/sort.h>
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mpt=
scsih.c
index e7f0d4ae0f960..ce2e5b21978e2 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -52,7 +52,7 @@
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>	/* for mdelay */
-#include <linux/interrupt.h>	/* needed for in_interrupt() proto */
+#include <linux/interrupt.h>
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/workqueue.h>
=20
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptsp=
i.c
index eabc4de5816cb..af0ce5611e4ac 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -52,7 +52,7 @@
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>	/* for mdelay */
-#include <linux/interrupt.h>	/* needed for in_interrupt() proto */
+#include <linux/interrupt.h>
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/workqueue.h>
 #include <linux/raid_class.h>
--=20
2.29.2

