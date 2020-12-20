Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87501C3526E
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 607CD23AAA
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 20:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgLTUiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 15:38:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35050 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgLTUiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 15:38:19 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608496612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ezRzP13O5uDREeae/5F86kNFRcMlGKxJeWNhoVQ62s=;
        b=EtGv773DOdTihRd6WkcqCPzsszra1PyVfHm+O8RZ/RYoNlMUCfjwlzmFL6e0omJyOjj10o
        jh9r6cQurFZ7HOZ+PW8hShQWM+ib2QRM8b6TSAqfbms1dABiBhSO7dMv+5zTDQUgB5iwCE
        j+sk1D9m+NkMvEmXj0/olm3WrA1gD88ZAvWN7vGsne80PqwKR5Hy6Nzzz9Enw1n99SxrpJ
        QPSbgX//jjK49QK24NgrJOKbD4U6tu4/uJPA9rhQFAY7t9UTprgj378jLm6YEYyGI6bsuL
        kMv3Dcw94lTxeYhkP0h5cLTF79iclE+3/dAIofHYx8WoyJBiDQiaKb0nE4fzRA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608496612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ezRzP13O5uDREeae/5F86kNFRcMlGKxJeWNhoVQ62s=;
        b=m4m/EVSikyK9R8cZSHyNcNyZ8d/YDn9JAcPUZEvnrxCiQikKkDM5VdxBolDWDatPlhGijz
        C41o+/28wLd4qWAw==
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6/6] scsi: target: Remove in_interrupt() check in transport_handle_cdb_direct()
Date:   Sun, 20 Dec 2020 21:36:38 +0100
Message-Id: <20201220203638.43615-7-bigeasy@linutronix.de>
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

transport_handle_cdb_direct() uses in_interrupt() to detect if it is
safe to sleep. It produces a stack trace and returns with an error which
is clearly for debugging.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

transport_handle_cdb_direct() has a comment saying that it may only be
invoked from process context. It invokes transport_generic_new_cmd()
which performs GFP_KERNEL memory allocations. in_interrupt() does not
detect all the contexts where it is invalid to sleep (for the blocking
GFP_KERNEL allocation) as it fails to detect sections with disabled
preemption.

Replace the in_interrupt() based check with a might_sleep() annotation.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/target_core_transport.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index b4fdc3f41e90a..d47bfd8b0f87c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1512,17 +1512,14 @@ int transport_handle_cdb_direct(
 {
 	sense_reason_t ret;
=20
+	might_sleep();
+
 	if (!cmd->se_lun) {
 		dump_stack();
 		pr_err("cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
-	if (in_interrupt()) {
-		dump_stack();
-		pr_err("transport_generic_handle_cdb cannot be called"
-				" from interrupt context\n");
-		return -EINVAL;
-	}
+
 	/*
 	 * Set TRANSPORT_NEW_CMD state and CMD_T_ACTIVE to ensure that
 	 * outstanding descriptors are handled correctly during shutdown via
--=20
2.29.2

