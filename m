Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E911C1B087
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A870229C9
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbgLDQtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:49:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48542 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731057AbgLDQtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:49:43 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607100541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVEfPPD9NE4f5E+YaRSwLsnYrJkOxX3+vwZtkdse0DI=;
        b=JU0l8O7vyRyZKX7y6MQY/xAfWPlmC+uQ+iEYXqBDcjbT20ERSvcaaNMb7T02B1TGWfc2In
        vl0pYoJEAEfV5B4wT8sXUd+bitffRWK4V6Qp1o+ZhyPnzqpwXbKicBPRcxqQD6d43x2phX
        Y7BwLMvfG8pRVVnaojx0BrxFqp3NUQZRAeFl2o576Nv6T9sMOJVS72YZTg3X61CfUeGrlI
        2qknB+gWh54xdxbZMxUGYpFWGURTcrkxtwkVckH+XgUzqaMXXxpfY75LDZK1yeLsOgV8lK
        mzTqFWBVXsfN8Htm53YuQ4MDPv6gTfLP+jphy0E3ldmBCq5THtWMk53ozSUr2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607100541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVEfPPD9NE4f5E+YaRSwLsnYrJkOxX3+vwZtkdse0DI=;
        b=ONHXERhPkRLPUfPSM7oeLR+/Sh5Zvi/X0sl348EPxAQa2NjgrkzrFfT8x8temtczhdShRT
        6r4Bkd+/qyXqyBDA==
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/3] sr: Switch the sector size back to 2048 if sr_read_sector() changed it.
Date:   Fri,  4 Dec 2020 17:48:49 +0100
Message-Id: <20201204164850.2343359-2-bigeasy@linutronix.de>
In-Reply-To: <20201204164850.2343359-1-bigeasy@linutronix.de>
References: <20201204164803.ovwurzs3257em2rp@linutronix.de>
 <20201204164850.2343359-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sr_read_sector() is hardly used since v2.3.16. Its only purpose is to
check if it is a XA medium via sr_is_xa(). This check is only enabled if
the module parameter `xa_test' is enabled.

Change the sector size back to 2048 if it was changed. With this change,
there is no lazy sector size changing left.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/sr_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ffcf902da3901..5703f8400b73c 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -549,6 +549,8 @@ static int sr_read_sector(Scsi_CD *cd, int lba, int blk=
size, unsigned char *dest
 	cgc.timeout =3D IOCTL_TIMEOUT;
 	rc =3D sr_do_ioctl(cd, &cgc);
=20
+	if (blksize !=3D CD_FRAMESIZE)
+		rc |=3D sr_set_blocklength(cd, CD_FRAMESIZE);
 	return rc;
 }
=20
--=20
2.29.2

