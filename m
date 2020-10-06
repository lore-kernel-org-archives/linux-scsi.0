Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB3AC47095
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 09:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661B2206B5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 09:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="RJNbDXt2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgJFJnJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:43:09 -0400
Received: from mout.gmx.net ([212.227.17.20]:51189 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgJFJnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Oct 2020 05:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601977381;
        bh=MRG/DidZTMAP3s/IKygvp2ugxJn5R6bJa+RqDMprr3A=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RJNbDXt2g4hh29Zl7x8j5rFscE1YFwWtvw53aiaHjw7P+lC/cmJu0Kc1/SMgBg5ie
         WLLlspcuHC6fTZhryPL1rpJuRZq+axnMm9qizK+6dW6boXvYV9rtvl/UjaOxXODjIY
         3d3lgrk5l9p8T0Ze5g5YGDuz7lZNru34hbUoHPIc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([91.8.173.95]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MbAci-1kwrOO3hzk-00bXEk; Tue, 06
 Oct 2020 11:43:00 +0200
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Thomas Schmitt <scdbackup@gmx.net>
Subject: [PATCH v2 2/2] sr: fix automatic tray loading for data reading
Date:   Tue,  6 Oct 2020 11:40:26 +0200
Message-Id: <20201006094026.1730-3-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201006094026.1730-1-scdbackup@gmx.net>
References: <20201006094026.1730-1-scdbackup@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:l6ieuFgGsYKG0hE/t+kPEvA27KMQa7HUegLkrn6XgsyAYX3WwjC
 DhexRajTu/N89hanWQRi0GRynj8P0alW0hVBwrdWS+AMITo8iAu7tj1gVvYHz/UyqN+uBTi
 sYUYJsakyq2l2yzOSZX3kBku7+CrTzrxHh0iElUNUJHzSshBIvTII6X6uyX5d+Me6i/90ww
 3m5qmAs6TmvMplmrGe8Mw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RYa96kB+0ww=:w/pmmUVibN6OGtyT+mpzkK
 uML4P15EonK3MCzgl5GcAgkiP98lMqCcchlxNSZVlOv5d0byxJqlLRTHoV5Ej0fMsPooNistW
 b1w9wCTQKAvD+lfzwz5ZbszjbVe+HRI2Ant1ao2EqsS0Lvjv4f1Y2Zzb8Rqbqsg9TSROWweDS
 gUGP4iMBuJ1rI3Y6CAVjtj+8cp5NgXC/L3ptNqtFOc8yz36gikT0roI0jLq8qnnyZ3cOi6mFx
 Y8k39ipnyLSiyyDsZny1BpMaOyKkL7GhiR2naU9qbWmZMPLjRcfApAA2GkHswNHkk7mN5IQ9G
 0ePgjx9mIUZA/GquUUvRABd4w9MvVHGBhg8IB9iblbu+vaEruOE2bOVcp5L8xsOYHuf+3hjxY
 2RkcOTjjE/4rKOYcC7xFj81n31gRo5O8DEkEa8iVxOXWfVJDr++pw/D/t2s3zQiH+LcPyc5S2
 99QoX/kDc7D7uyIJF8FmhgGaswDiix4UY8jSqoyiDZUU49VXalDWXnux4BcynYQ1cF4biNKFx
 Q68vffQ7aW/6i0gN5muXfMsUcDVDoAJ4J8PyBThZnzuPdRaoJiahF5g2i43OjMkI8IbHdhTP3
 N7+mRlv/1sJ2Tk4NOa9i6y1Ao2kdK/tHK+CYo/vtiHdjZI13K6BaB72JXT2b/r97IcExDS8oc
 Z8ajzlTaIbVspRwyKizK7mdGOzsP2FLYCkd33iLWWJljun7NKmLR09A18KVbGUDzT3QIR7HtN
 MMP1MjIpPwOyUzYF7dF6BCO8eXHaWOjmPWvHD4V5FJWGB9H0rHTDckI4BwOKn75oD24IkVx5h
 HdByxZH/1IRtIaZi7q2aMIY1uWCfWZp2/662YSJgW+3xE1yggtHqkmzUcZ1rjB59+y8eeKr48
 SuGS6mN1h9qsBf+p9rXDodUZo6G3VJMrUv0RddpAW74YW4HxVuaLBVfQBSKsDBt2mgZX/LKJ/
 vAx3sHz2Z9Mvg+YS+g0+HLj5Ap8DB02UjoajrkbeVvLruKMDedLGeLMdWIdq9bzRhlPQuUskQ
 uJyYXflWjuQ0jk5JNq88cSmdIcERD9ljOedQx8YOGh1sIUavmz0KoJMAsrFlwXYmEdgmlbvDI
 JNeeYQa+QEaDtISWUCIjr1zy0hcVfNvxcgVgrs/ojxQC+8B8CdXezFhwFTNMjjuZu65JbO0a7
 YOqhQIt5sTzSoVcmYKXQG1j9wHf6zs2CNPxspZyoQfxn7Ih6JuJjcDlX82fQs465HSxIhiqrt
 b9js8tcDChVQGh0d49H/H5oAgBhJeiz0Mp/mcvw==
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
 drivers/scsi/sr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 2b43c0f97442..1c3806f59865 100644
=2D-- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -540,12 +540,18 @@ static int sr_block_open(struct block_device *bdev, =
fmode_t mode)

 	sdev =3D cd->device;
 	scsi_autopm_get_device(sdev);
-	if (bdev_check_media_change(bdev))
-		sr_revalidate_disk(cd);

 	mutex_lock(&cd->lock);
-	ret =3D cdrom_open(&cd->cdi, bdev, mode);
+	ret =3D cdrom_handle_open_tray(&cd->cdi, mode, 0);
 	mutex_unlock(&cd->lock);
+	if (!ret) {
+		if (bdev_check_media_change(bdev))
+			sr_revalidate_disk(cd);
+
+		mutex_lock(&cd->lock);
+		ret =3D cdrom_open(&cd->cdi, bdev, mode);
+		mutex_unlock(&cd->lock);
+	}

 	scsi_autopm_put_device(sdev);
 	if (ret)
=2D-
2.20.1

