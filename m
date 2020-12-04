Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA180C2BB40
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C76205CB
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgLDQtm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:49:42 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48530 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731021AbgLDQtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:49:41 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607100539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVmduwuXX/EtsNpL6GIUNu67EAHxRaD9Jr2TF6Y1iUI=;
        b=4PpF9phaFYkXNRjhGjolQ11N8z0op2VsWnINy5E+SDH8/1kg2275pS+r+gceqDCWQSI/Sy
        FKAWv3iouz6ndnQbeZew4Ty9ckiAtsUGo0EPwPTtRPi6ihTuaOmlqSOZUxW13hDuaP6y4w
        +x8PCz1W9xgRrVN/V4DIz7gQ/2foEsadVYX2TLs+Ku8uxx7yyR0R/hMDZj714//5+FGBGz
        Vl5Y7nL6vmd7788r0mhAfUYh0P4E1K1CGEvuk6kDzkTKloqgDDMTpAaciNprzw5LdqJrur
        7iNLUraY/FGXZcmQDwEX2b2USG0FSuBqBr71Cp3odOwC8qIAzuPp2UtZRg4ITw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607100539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVmduwuXX/EtsNpL6GIUNu67EAHxRaD9Jr2TF6Y1iUI=;
        b=ofh5NU+CKTUaCBB/NQB487eCfWL4VEphmdxik8LzRyunDLdSwglElK41h+mhRPKcUVdAwR
        Js6vEj+z4eJ71/Bw==
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/3] cdrom: Reset sector_size back it is not 2048.
Date:   Fri,  4 Dec 2020 17:48:48 +0100
Message-Id: <20201204164850.2343359-1-bigeasy@linutronix.de>
In-Reply-To: <20201204164803.ovwurzs3257em2rp@linutronix.de>
References: <20201204164803.ovwurzs3257em2rp@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In v2.4.0-test2pre2 mmc_ioctl_cdrom_read_data() was extended by issuing
a MODE_SELECT opcode to change the sector size and READ_10 to perform
the actual read if the READ_CD opcode is not support.
The sector size is never changed back to the previous value of 2048
bytes which is however denoted by the comment for version 3.09 of the
cdrom.c file.

Use cdrom_switch_blocksize() to change the sector size only if the
requested size deviates from 2048. Change it back to 2048 after the read
operation if a change was mode.

Link: https://lkml.kernel.org/r/20201204164803.ovwurzs3257em2rp@linutronix.=
de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/cdrom/cdrom.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 0c271b9e3c5b7..8f0e52a714938 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2996,13 +2996,15 @@ static noinline int mmc_ioctl_cdrom_read_data(struc=
t cdrom_device_info *cdi,
 		 * SCSI-II devices are not required to support
 		 * READ_CD, so let's try switching block size
 		 */
-		/* FIXME: switch back again... */
-		ret =3D cdrom_switch_blocksize(cdi, blocksize);
-		if (ret)
-			goto out;
+		if (blocksize !=3D CD_FRAMESIZE) {
+			ret =3D cdrom_switch_blocksize(cdi, blocksize);
+			if (ret)
+				goto out;
+		}
 		cgc->sshdr =3D NULL;
 		ret =3D cdrom_read_cd(cdi, cgc, lba, blocksize, 1);
-		ret |=3D cdrom_switch_blocksize(cdi, blocksize);
+		if (blocksize !=3D CD_FRAMESIZE)
+			ret |=3D cdrom_switch_blocksize(cdi, CD_FRAMESIZE);
 	}
 	if (!ret && copy_to_user(arg, cgc->buffer, blocksize))
 		ret =3D -EFAULT;
--=20
2.29.2

