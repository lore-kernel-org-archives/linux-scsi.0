Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9524DCA9ECB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 21:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC822086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 21:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="H3Nduxqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfJaVg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:36:27 -0400
Received: from mout.web.de ([212.227.17.12]:51695 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfJaVg1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 17:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572557767;
        bh=gE4GZ5fboi7hkq7Rs5Avb0Tqg2iycZAPpP9eGxWsFPM=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=H3NduxqoIoKxtYt5SXAdUunpyn42W7FuefTJBpE9yulWQDeOdGCloKfRmb5KuybOa
         W2bC+5YUex/Aa97AnH0mZAYDGTsDtsuszeIPmi3S+JGMHRt2oli8RDXC10sQJH+rvi
         YxuAXcpomsMZIeCFJQe9WtNQrKM54X6VIdnl2Iio=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.137.160]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lu4q2-1i0Xzt2Nlu-011O3A; Thu, 31
 Oct 2019 22:36:07 +0100
To:     linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] scsi: megaraid_sas: Use common error handling code in
 megasas_mgmt_ioctl_fw()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>
Message-ID: <d5c12f05-5a07-b698-ae60-2728330dd378@web.de>
Date:   Thu, 31 Oct 2019 22:35:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IgSe9gwX98TIaorhE4J0+ZrKsbuZQQkZ/JcDVFROQoKsQwgQNvF
 gaWpoLaLPn3SYpHWN3Bx15RtnbUWVnHINkv+GaYXNP9EqGSrcPb6Oq1Zl0qWxowQDFjd8W9
 zya+3aUw85VWGnvz6ri9xQl4pZrQHqtnHfnjs5BoCJWcsoLLIzrcfx84PiZgm8zyBtcZhP5
 qiJtLxc+0iuqQ2amIZpQA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8pVaFKJLwb8=:CnNAz1GHK6ydHxel71V97/
 YtNCoER5DHTS0cZlf8pPPd+R1Rw8yUtkQxESeocFyn/H+0Iy+0E+c/f7gWuHiO6f/1/A3nstZ
 b0Rg7EhyyHdgyN5fKEqrx/ZrMiWoIbdnR2vZsx/KLySvf3kptXZDy5CQJXZerGxSgOEKJBQvQ
 Xr5qiy2YcbJqGVSbMQCi9m1q9bZTn9TUC7X/54xDcOrGnH08c6BE7oUIiC5mVJWvE2SFzlak6
 VWrnjxgE6GOBofKDR558UrtdX7WGCS1yRcnyEx4r8uN+g/KxNtEl4sxq3VL616fc2cM5rBwsF
 6etiN+7WuqTdZNG8zRyyvwPuYTJzYGCLdcy9k2q6JhZusx5W7o2tbnEd1HUpiX5Uu4d5TUD3j
 HhwOA/JU7ktR5Lup9Dow+MZAKQ0Focs+afrQ7T1/kX6zhFre/NNl5wdlFJwaGZMgIm5l6CRuM
 oX7zp2JOUyYn+4JNvYLZ1Kq4nl2kwE84NVRaWPnFJAg73kYYVlYS8tggSuAvRAFjyu7v7EHwC
 tg/9B0yAZ28qp+a4G92VxUGAFsajnsJhhJHclQ26xhmO3EU7JO/phkHpv7tBboEQZhp29y2e5
 BsIqBY57DZrNjaQ4/Ix5ASb6Lmx/aHkTVYPuJD9iov1iFHZ66ewYruZWiMc5PeEZzmdevM5kz
 sy5a7mkI1q6C70JPnA6bttEA5g0aauPFsJ95OZFS/suwVgZ2cFIa24EvEUnzSDOYTVSrg6D6m
 JayD7e6RnaUY8kZ8Zl1xoKLKmxuGwhVEoxqFecLUA2bFc+LzSdzSBpRH4LXb1FujmSkzVi65t
 hZmcX/U55yM7C3uSfexe3UYvNJT1VIdzxvS5tXvKuzlfjtTArKAFiXqXcidhUa0I5CNiE1rl5
 gZKq91DHNjpfVwM4iH9QFucLl+tEpzy34VjLWBffuAviRUWvcaW/WDsP6lgOMi87y8hvufrxf
 SPigpWxXOqVjM3glMwpSLy3bfaWrj5EIrxTrmml5hkMXOD4IYzkEGfvxRqq8fUYTvoWuyjMQC
 /whdwtgr+pK/2tgCgAVirQxRK//BkcBkWybn78MQIrNiLNnaZ1dJsB/Oey86NKLSdif9Z9Uvx
 y1QcNHAqIjA9NpRYe8QR/gCItBwWlFUiaFJLt5fUz9LcYB5uQOFKs+Fx4/A/FF+79R9Lgj/H/
 l0HufGQOtSerzrnd0lh/ZqiSO0DJFFzBblqjA3SkxU1oWsyBwMGxaQ2KNlHKCC1txyDP8iY+2
 b3DIbRRm6HWwWJV+BBYLgWRl3NODIOWDgzT5nVbQ3hoGGkj2c2uRDRd0sf3o=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 31 Oct 2019 22:23:02 +0100

Move the same error code assignments so that such exception handling
can be better reused at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/scsi/megaraid/megaraid_sas_base.c | 25 ++++++++++-------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/mega=
raid/megaraid_sas_base.c
index c40fbea06cc5..f2f2a240e5af 100644
=2D-- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8272,27 +8272,20 @@ static int megasas_mgmt_ioctl_fw(struct file *file=
, unsigned long arg)
 		return PTR_ERR(ioc);

 	instance =3D megasas_lookup_instance(ioc->host_no);
-	if (!instance) {
-		error =3D -ENODEV;
-		goto out_kfree_ioc;
-	}
+	if (!instance)
+		goto e_nodev;

 	/* Block ioctls in VF mode */
-	if (instance->requestorId && !allow_vf_ioctls) {
-		error =3D -ENODEV;
-		goto out_kfree_ioc;
-	}
+	if (instance->requestorId && !allow_vf_ioctls)
+		goto e_nodev;

 	if (atomic_read(&instance->adprecovery) =3D=3D MEGASAS_HW_CRITICAL_ERROR=
) {
 		dev_err(&instance->pdev->dev, "Controller in crit error\n");
-		error =3D -ENODEV;
-		goto out_kfree_ioc;
+		goto e_nodev;
 	}

-	if (instance->unload =3D=3D 1) {
-		error =3D -ENODEV;
-		goto out_kfree_ioc;
-	}
+	if (instance->unload =3D=3D 1)
+		goto e_nodev;

 	if (down_interruptible(&instance->ioctl_sem)) {
 		error =3D -ERESTARTSYS;
@@ -8311,6 +8304,10 @@ static int megasas_mgmt_ioctl_fw(struct file *file,=
 unsigned long arg)
 out_kfree_ioc:
 	kfree(ioc);
 	return error;
+
+e_nodev:
+	error =3D -ENODEV;
+	goto out_kfree_ioc;
 }

 static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
=2D-
2.23.0

