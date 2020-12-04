Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB5BC1B0D8
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44DE822AAF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgLDQto (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387952AbgLDQto (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:49:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA66AC061A51;
        Fri,  4 Dec 2020 08:49:03 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607100542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpTRFsFRc9/tXI4gMGMyZKDuQbOkXJKaQdzwiNLDT4s=;
        b=B2ciP1NhXnAP2waJrjFFjcIJNjngJI2TpMagMN8GdkeNnK1sXK51i0yj1MC5V8skJKqmMn
        eirkdoY4S9b3nOqgQ5iHgjkcUJSwaMLYyUnx9i80FjVb5w5Fp3fDZNchVZPilhYcfTCNdb
        l0iXjWv953QSZtg5203RWoGpcg95FeZKyK0Nh9s9pfT+2RZaII/PRyoZCQd0JtSPlyl2Al
        Z22Fz7sBawLkXfbhR6tasTqrsosI53pgzR1j2fVuedKASFTIwh3mSjXoVcurNJslVjgoeJ
        7ewva/AIcRwspIPBqzu2xV4f3fSLlSs/8H0FNr/yawsSJnQihNG3EkaMORMZ5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607100542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpTRFsFRc9/tXI4gMGMyZKDuQbOkXJKaQdzwiNLDT4s=;
        b=kpO714HqfqwQQV8oJZbFASHdsbfVXcctd3YyQFFmAgzpyk8q247LzdIRp2XcipqjG3bcge
        kHFunfrSRej0InCw==
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/3] sr: Remove in_interrupt() usage in sr_init_command().
Date:   Fri,  4 Dec 2020 17:48:50 +0100
Message-Id: <20201204164850.2343359-3-bigeasy@linutronix.de>
In-Reply-To: <20201204164850.2343359-1-bigeasy@linutronix.de>
References: <20201204164803.ovwurzs3257em2rp@linutronix.de>
 <20201204164850.2343359-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The in_interrupt() check in sr_init_command() is a leftover from the
past, pre v2.3.16 era to be exact. Back then the ioctl() was served by
`sr' itself and sector size changes by CDROMREADMODE2 (as noted in the
comment) were accounted within sr's data structures which allowed a
"lazy" reset so it could be skipped on the next request and reset back
to the default value once the device node was closed or before a command
from the blockqueue was issued.

This does not work like that anymore. The CDROMREADMODE2 is served by
cdrom's mmc_ioctl() function which may change the sector size but the
`sr' driver does not learn about it and so its ->sector_size is not
updated.
The ioctl() resets the changed sector size back to 2048.
sr_read_sector() also resets the sector size back to the default once it
is done.

Remove the conditional sector size update from sr_init_command() and
sr_release() because it is not needed.

Link: https://lkml.kernel.org/r/20201204164803.ovwurzs3257em2rp@linutronix.=
de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
This change makes also ide-cd providing the last non-empty
cdrom_device_info::release callback.

 drivers/scsi/sr.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fd4b582110b29..e4633b84c556a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -416,19 +416,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *=
SCpnt)
 		goto out;
 	}
=20
-	/*
-	 * we do lazy blocksize switching (when reading XA sectors,
-	 * see CDROMREADMODE2 ioctl)=20
-	 */
 	s_size =3D cd->device->sector_size;
-	if (s_size > 2048) {
-		if (!in_interrupt())
-			sr_set_blocklength(cd, 2048);
-		else
-			scmd_printk(KERN_INFO, SCpnt,
-				    "can't switch blocksize: in interrupt\n");
-	}
-
 	if (s_size !=3D 512 && s_size !=3D 1024 && s_size !=3D 2048) {
 		scmd_printk(KERN_ERR, SCpnt, "bad sector size %d\n", s_size);
 		goto out;
@@ -701,11 +689,6 @@ static int sr_open(struct cdrom_device_info *cdi, int =
purpose)
=20
 static void sr_release(struct cdrom_device_info *cdi)
 {
-	struct scsi_cd *cd =3D cdi->handle;
-
-	if (cd->device->sector_size > 2048)
-		sr_set_blocklength(cd, 2048);
-
 }
=20
 static int sr_probe(struct device *dev)
--=20
2.29.2

