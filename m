Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D15C63697
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B9721D7E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3ZWZnXnQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="D71BIfsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390079AbgKZNai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56550 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390051AbgKZNah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:37 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrxBQ28uUTJB++jetuL6kEnNvt90PxZnzODz8Wc8oMw=;
        b=3ZWZnXnQNI3yd1oZIaL27a1gn7A8XnvQTxYuYhPvrpJW33zWzRH9N77J47ehQetaiaEIdR
        7iqdkmwqeBxiHBvk5M8cYxF5mpGZacDc9w3wSJtT1wL8x31J7Ymtpd1yNDCet6FBcr3CXz
        cwtACi+gUxS9539GjccM6j4rwBtuSgywJhMPl17xFoabLTvX3FM/BQ5Y/jqYX9jPxAAJcs
        VbZCaDdx3MAwKqJNYkNFcfgdra6yVEz95LMm+36m2uHuCOhzAmg6tBCKzzgXVIrwn/kCqc
        lzErsCSuRMxfFzMZfOelSuzACRdmAbBgCcdQN4TygPldnI6ELRcG1tAUSOwDZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrxBQ28uUTJB++jetuL6kEnNvt90PxZnzODz8Wc8oMw=;
        b=D71BIfsun8GR62UEPsc/jExgaHeHGcRLgvZgMexCqGGsOmK4D1X7sqv2s8jAv9BMrRhdbV
        NNq/xxA12ymnOzBA==
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
Subject: [PATCH 09/14] scsi: mpt3sas: Remove in_interrupt().
Date:   Thu, 26 Nov 2020 14:29:47 +0100
Message-Id: <20201126132952.2287996-10-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

_scsih_fw_event_cleanup_queue() waits for all outstanding firmware
events wokrqueue handlers to finish. If in_interrupt() is true, it
cancels itself and return early.

That in_interrupt() check is ill-defined and does not provide what the
name suggests: it does not cover all states in which it is safe to block
and call functions like cancel_work_sync().

That check is also not needed: _scsih_fw_event_cleanup_queue() is always
invoked from process context. Below is an analysis of its callers:

  - scsih_remove(), bound to PCI ->remove(), process context

  - scsih_shutdown(), bound to PCI ->shutdown(), process context

  - mpt3sas_scsih_clear_outstanding_scsi_tm_commands(), called by
      =3D> _base_clear_outstanding_commands(), called by
        =3D>_base_fault_reset_work(), workqueue
        =3D> mpt3sas_base_hard_reset_handler(), locks mutex

Remove the in_interrupt() check. Change _scsih_fw_event_cleanup_queue()
specification to a purely process-context function and mark it with
"Context: task, can sleep".

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: <MPT-FusionLinux.pdl@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mp=
t3sas_scsih.c
index f081adb85addc..d91f45abe6b86 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3673,6 +3673,8 @@ static struct fw_event_work *dequeue_next_fw_event(st=
ruct MPT3SAS_ADAPTER *ioc)
  *
  * Walk the firmware event queue, either killing timers, or waiting
  * for outstanding events to complete
+ *
+ * Context: task, can sleep
  */
 static void
 _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
@@ -3680,7 +3682,7 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER =
*ioc)
 	struct fw_event_work *fw_event;
=20
 	if ((list_empty(&ioc->fw_event_list) && !ioc->current_event) ||
-	     !ioc->firmware_event_thread || in_interrupt())
+	    !ioc->firmware_event_thread)
 		return;
=20
 	ioc->fw_events_cleanup =3D 1;
--=20
2.29.2

