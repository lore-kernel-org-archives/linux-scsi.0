Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC84DC64E7B
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 857F6221E2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="t2Cn8IF1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+pPpHOz6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390059AbgKZNaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56528 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389961AbgKZNae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:34 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnAEaaB4n7LL3RhdlN8tgP6NZ/XqOwpTxe9/6BlLv9M=;
        b=t2Cn8IF145fOAOGJ26MPtnFm6jW959s3O3r0ZKjmxMPlPysS1ZjQ/MMUxPsOzVsMc+Dqy+
        Sti70TSyTI5NfCwF8yK0W4XmHWRd1dTzXw2NmmCNxLenuGjaPcpjownmx104rLXypo/oAq
        lIoWAA8xNmMfj6MSJJd9pdW3FNfIQZdF5Tnj+D4UtZMnKUlrCVsLfBNlrFp7sO59utCGq1
        lajJDv6xwNct8HxHkD77z8qXrIujjy6yjY+NXUHoYGdvEsfAkWa4r7Lz3fKpqRiJKkNekQ
        1pVIzfZirKx1w+Y7HwFObj90dhb+bNI79NBZu0A/K0b13upPXSUcLjW0RivuYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnAEaaB4n7LL3RhdlN8tgP6NZ/XqOwpTxe9/6BlLv9M=;
        b=+pPpHOz6wVDlIkqXkPyAVkpe1UqzIB14wYo4zhrjFQZI5I0zE794GlZUyJkTuvHLht263p
        tL1kIolpZbl3tbCw==
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
Subject: [PATCH 05/14] scsi: qla2xxx: tcm_qla2xxx: Remove BUG_ON(in_interrupt()).
Date:   Thu, 26 Nov 2020 14:29:43 +0100
Message-Id: <20201126132952.2287996-6-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

tcm_qla2xxx_free_session() has a BUG_ON(in_interrupt()).

While in_interrupt() is ill-defined and does not provide what the name
suggests, it is not needed here: the function is always invoked from
workqueue context through "struct qla_tgt_func_tmpl" ->free_session()
hook it is bound to.

The function also calls wait_event_timeout() down the chain, which
already has a might_sleep().

Remove the in_interrupt() check.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: <GR-QLogic-Storage-Upstream@marvell.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_=
qla2xxx.c
index 784b43f181818..b55fc768a2a7a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1400,8 +1400,6 @@ static void tcm_qla2xxx_free_session(struct fc_port *=
sess)
 	struct se_session *se_sess;
 	struct tcm_qla2xxx_lport *lport;
=20
-	BUG_ON(in_interrupt());
-
 	se_sess =3D sess->se_sess;
 	if (!se_sess) {
 		pr_err("struct fc_port->se_sess is NULL\n");
--=20
2.29.2

