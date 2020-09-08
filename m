Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69175C2BC11
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E8D2080C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="HLH41+Tp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbgIHSgF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 14:36:05 -0400
Received: from mout.gmx.net ([212.227.15.18]:57571 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731043AbgIHQJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599581361;
        bh=7BNPl463okJLMgp5n/LV2nUSf308S0c4MPGl3nc4znE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HLH41+Tp2P3WoBA61SfRYfHNNqgXNa5kEM2q3LeieG/ywrHgzKsUffZaxqYE3AjKu
         qcaufv2cDt9sNesldK3YEp232Os2b/K/ln+VtMastWLHUYE8VbZraaOoj7nGuHBD/d
         qMSA3HbW0MKKeijd4AE7+rpg54z0OtiWp4ALtgfc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([84.179.245.142]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MmUHj-1kxRXf1UTh-00iUIx; Tue, 08
 Sep 2020 14:02:34 +0200
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Thomas Schmitt <scdbackup@gmx.net>
Subject: [PATCH 2/2] sr: fix automatic tray loading for data reading
Date:   Tue,  8 Sep 2020 14:02:07 +0200
Message-Id: <20200908120207.5014-3-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908120207.5014-1-scdbackup@gmx.net>
References: <20200908120207.5014-1-scdbackup@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DUrGlOOQJ0WDkC+hhzia2noiehs81VZ2RLQwIvPHP1p7zeqXJEO
 J84Z6cr1Ws8rInk2wb7ZVtCmnuF8dtBCCXI2TNFxo2TzFdjM04fuMKEkUV3e004E+u808if
 DkkTnD3CTzLNkpY8yk1IdVQuIvfM7RmW7GWTN4/c+PNlWgPpHncf9xkzn3bHRFOcqPHYjlK
 3upcnhRJSGat6b0bOQtgw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2N7cV38ZpDg=:J2wTam/oBpAuELyooOZhTD
 7uLsnckfkXfOHPovPcTU4VmX7OXatMAP2hRKVOfumkkQ1pm5e7yGo+tOewHfTmCTs2q1smlzs
 JIJNmV4Bwr/rSVipfafZwvLYW546FVUBOiPz8z8y1TeMaLOxpcV+EPYA2vTgYl/TJrfJ5qfPa
 ORoS4MxkNvur6qYtaUr6fTztN8DEtO6c0ORnU/qKZ2NIQgDn4djwV2z+9LzsOOxedpd3FcIgL
 GjulE3n9o5QrxAWNSSlRHjmLFlGocfaN6k9KUfxinIcl846Kq8o6CT2nJTJKL66LJ1csHOr/o
 h00DoZGC0IcjIi65n46IVupfFS++HJWw2weI4gShJ9pvk5JWEeE0Bf2ofK0iuAiwSOqCZtacM
 2RwThTMV/c2NZasafe+tIsrMCQXGjoCGXkjsn9+i+2PhGAx9Fsmm3awcs9/fp6FB0hU5YaNo9
 ssyzb6b5Kk4Scm9IK6UA3BFb9+FgLU07R/j174NLF9SzEv06dIfnTGKo8TLw20w22laXHmsYg
 v2j9+zOPSxdHRnWMjFsN8NW3gPpBScC6LGHlDEmO25RVFpUyOYYIYF6IlqLGT6OmNlUvgg4cG
 hG0kKSy+6A0IYnOakQS8EBiTQs1KG945kkXUNpNAUNGwFnD0k1+nDnKG2ZU7YMaOgIvIViphD
 0b1HLkZ7ArYeYKdp2YoIF01yIrbLyEUQxYZeHQli88wKCu3kKllw7CYXFJ7FdYYqpZifJPlaY
 0+YCDhAakxPGeueyN6R4KGxCiMV5KPgGygXN7VVvFa4Wghq8oZCEwaM3r5FQ3hWaEWpuMsdKu
 ne9Q0V++M64fCL52YCIbLBE1Jder4fx+wKP1He6gtDXDHg8c5LgB55WYe7Etq4Y7A2BVsXXDR
 jgap1q41hrfbzMHGsKHw62S25KSJBAdeo8gcKnP0c4wjzcmc9TYBqEf9SeSJRsW60BaXBkpc7
 TrvwAuGpxbse5+QbO61kbC0GwYmDqaulORL28zqWANOS4eG2br4iOQHSiAnrMWr/Z7SSz8rfe
 xsnvPBmhD4nkfA/j+SD5CAPdpSL0xrMBwD/MG3/wEdyofBZDmCoC8TUmvEJRfGQ8kf/8Xdhgd
 SC7qG9xbjoWAgAgmkSexhi4fKxfltwcaud4WvLZyqZA84ruC+mRpFy/VJcc5XMR/a2iqu8WdY
 S1+bD8x/gdnWbKj/783hlJLrc8qiiQnU51+qg9wDaQlyW8FF8nSxwZr37LmgQmKVxy/SOiitm
 X9OBdfZQ/yKBxfPoKx6VTN3Cp4iStdFQwjcOOTw==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If
  open("/dev/sr0", O_RDONLY);
pulls in the tray of an optical drive, it immediately returns -1 with
errno ENOMEDIUM or the first read(2) fails with EIO. Later, when the drive
has stopped blinking, another open() yields success and read() works.
This affects not only userland reading of the device file but also
mounting the device.
The reason is that medium assessment happens before automatic tray
loading.

Use the new function cdrom_handle_open_tray() for deciding and performing
tray loading before doing medium assessment.

Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
=2D--
 drivers/scsi/sr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 3b3a53c6a0de..cf06afffcb56 100644
=2D-- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -529,11 +529,16 @@ static int sr_block_open(struct block_device *bdev, =
fmode_t mode)

 	sdev =3D cd->device;
 	scsi_autopm_get_device(sdev);
-	check_disk_change(bdev);

 	mutex_lock(&cd->lock);
-	ret =3D cdrom_open(&cd->cdi, bdev, mode);
+	ret =3D cdrom_handle_open_tray(&cd->cdi, mode, 0);
 	mutex_unlock(&cd->lock);
+	if (!ret) {
+		check_disk_change(bdev);
+		mutex_lock(&cd->lock);
+		ret =3D cdrom_open(&cd->cdi, bdev, mode);
+		mutex_unlock(&cd->lock);
+	}

 	scsi_autopm_put_device(sdev);
 	if (ret)
=2D-
2.20.1

