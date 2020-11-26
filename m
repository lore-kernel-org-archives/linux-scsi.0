Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2545BC64E7D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC29E21D40
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UVx+cuii";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mpfunGzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbgKZNan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56576 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390124AbgKZNak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:40 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xOOBp6z3OInykv2pKK7i4G7TCjhXQtxisN5E2TisB+U=;
        b=UVx+cuiijhsjFzna9+6Zqbcckv8jr+L/hm8tSPZxe/bQJNiWItdNPTm4uLgd0T6p2PiU1u
        1Fj9u2FOn3UCQXAt0HC3Cz7eWVIldXES05AohHDsrP9G97NGioK8VESTGxHMOn+aDDIvOs
        SdyCLd7KoGxDk6eJU7MbbTCMqc1YIfxN3prsAP8tcFnTxi3YDqaBaKhY/TCO2fA+taJ/8K
        uYf6baBKGsUKh33aVbKJsMTEX4LpV71Fnjm7YJyiOxaTUkPGMw7Zw3fHAlJho3JOndCjJB
        7yUv1gpXkbeplah/1Er3WVqMLWz/X/TlymvPxv/UGDarmpijcSx6iBmEyWc/UQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xOOBp6z3OInykv2pKK7i4G7TCjhXQtxisN5E2TisB+U=;
        b=mpfunGzghZF4WsR3K6MnZfzrV/WdyF3J1uNBm0rLDM4bup9qGPN8JK7MbEdo+da6w+Mv/K
        VkmQ5T22WC26VCCw==
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
Subject: [PATCH 14/14] scsi: message: fusion: Remove in_interrupt() usage in mptsas_cleanup_fw_event_q().
Date:   Thu, 26 Nov 2020 14:29:52 +0100
Message-Id: <20201126132952.2287996-15-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mptsas_cleanup_fw_event_q() uses in_interrupt() to determine if it is
safe to cancel a worker item.

Aside of that in_interrupt() is deprecated as it does not provide what the
name suggests. It covers more than hard/soft interrupt servicing context
and is semantically ill defined.

Looking closer there are a few problems with the current construct:
- It could be invoked from an interrupt handler / non-blocking context
  because cancel_delayed_work() has no such restriction. Also,
  mptsas_free_fw_event() has no such restriction.

- The list is accessed unlocked. It may dequeue a valid work-item but at
  the time of invoking cancel_delayed_work() the memory may be released
  or reused because the worker has already run.

mptsas_cleanup_fw_event_q() is invoked via mptsas_shutdown() which is
always invoked from preemtible context on device shutdown.
It is also invoked via mptsas_ioc_reset(, MPT_IOC_POST_RESET) which is a
MptResetHandlers callback. The only caller here are
mpt_SoftResetHandler(), mpt_HardResetHandler() and
mpt_Soft_Hard_ResetHandler(). All these functions have a `sleepFlag'
argument and each caller uses caller uses `CAN_SLEEP' here and according
to current documentation:
|      @sleepFlag: Indicates if sleep or schedule must be called

So it is safe to sleep.

Add mptsas_hotplug_event::users member. Initialize it to one by default
so mptsas_free_fw_event() will free the memory.
mptsas_cleanup_fw_event_q() will increment its value for items it
dequeues and then it may keep a pointer after dropping the lock.
Invoke cancel_delayed_work_sync() to cancel the work item and wait if
the worker is currently busy. Free the memory afterwards since it owns
the last reference to it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
---
 drivers/message/fusion/mptsas.c | 45 +++++++++++++++++++++++++--------
 drivers/message/fusion/mptsas.h |  1 +
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsa=
s.c
index 18b91ea1a353f..5eb0b3361e4e0 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -289,6 +289,7 @@ mptsas_add_fw_event(MPT_ADAPTER *ioc, struct fw_event_w=
ork *fw_event,
=20
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
+	fw_event->users =3D 1;
 	INIT_DELAYED_WORK(&fw_event->work, mptsas_firmware_event_work);
 	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: add (fw_event=3D0x%p)"
 		"on cpuid %d\n", ioc->name, __func__,
@@ -314,6 +315,15 @@ mptsas_requeue_fw_event(MPT_ADAPTER *ioc, struct fw_ev=
ent_work *fw_event,
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
=20
+static void __mptsas_free_fw_event(MPT_ADAPTER *ioc,
+				   struct fw_event_work *fw_event)
+{
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: kfree (fw_event=3D0x%p)\n",
+	    ioc->name, __func__, fw_event));
+	list_del(&fw_event->list);
+	kfree(fw_event);
+}
+
 /* free memory associated to a sas firmware event */
 static void
 mptsas_free_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event)
@@ -321,10 +331,9 @@ mptsas_free_fw_event(MPT_ADAPTER *ioc, struct fw_event=
_work *fw_event)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: kfree (fw_event=3D0x%p)\n",
-	    ioc->name, __func__, fw_event));
-	list_del(&fw_event->list);
-	kfree(fw_event);
+	fw_event->users--;
+	if (!fw_event->users)
+		__mptsas_free_fw_event(ioc, fw_event);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
=20
@@ -333,9 +342,10 @@ mptsas_free_fw_event(MPT_ADAPTER *ioc, struct fw_event=
_work *fw_event)
 static void
 mptsas_cleanup_fw_event_q(MPT_ADAPTER *ioc)
 {
-	struct fw_event_work *fw_event, *next;
+	struct fw_event_work *fw_event;
 	struct mptsas_target_reset_event *target_reset_list, *n;
 	MPT_SCSI_HOST	*hd =3D shost_priv(ioc->sh);
+	unsigned long flags;
=20
 	/* flush the target_reset_list */
 	if (!list_empty(&hd->target_reset_list)) {
@@ -350,14 +360,29 @@ mptsas_cleanup_fw_event_q(MPT_ADAPTER *ioc)
 		}
 	}
=20
-	if (list_empty(&ioc->fw_event_list) ||
-	     !ioc->fw_event_q || in_interrupt())
+	if (list_empty(&ioc->fw_event_list) || !ioc->fw_event_q)
 		return;
=20
-	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
-		if (cancel_delayed_work(&fw_event->work))
-			mptsas_free_fw_event(ioc, fw_event);
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+
+	while (!list_empty(&ioc->fw_event_list)) {
+		bool canceled =3D false;
+
+		fw_event =3D list_first_entry(&ioc->fw_event_list,
+					    struct fw_event_work, list);
+		fw_event->users++;
+		spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+		if (cancel_delayed_work_sync(&fw_event->work))
+			canceled =3D true;
+
+		spin_lock_irqsave(&ioc->fw_event_lock, flags);
+		if (canceled)
+			fw_event->users--;
+		fw_event->users--;
+		WARN_ON_ONCE(fw_event->users);
+		__mptsas_free_fw_event(ioc, fw_event);
 	}
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
=20
=20
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsa=
s.h
index e35b13891fe42..71abf3477495e 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -107,6 +107,7 @@ struct mptsas_hotplug_event {
 struct fw_event_work {
 	struct list_head 	list;
 	struct delayed_work	 work;
+	int			users;
 	MPT_ADAPTER	*ioc;
 	u32			event;
 	u8			retries;
--=20
2.29.2

