Return-Path: <SRS0=DDJn=CA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495CCC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 12:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CA3207CD
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 12:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=exactco.de header.i=@exactco.de header.b="bQ3QbnM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgHVMLL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Aug 2020 08:11:11 -0400
Received: from mx.exactcode.de ([144.76.154.42]:59216 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgHVMLI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Aug 2020 08:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=exactco.de; s=x;
        h=Content-Transfer-Encoding:Content-Type:Mime-Version:From:Subject:Cc:To:Message-Id:Date; bh=IOJaBKtfwNc0MXQHRUZW0wG6ZBvQeFH/lJGZsFnjIds=;
        b=bQ3QbnM4ngoXxjXa1br0MMfh9gmJ/JUOqWDS2OSyFtfBxe2mAUHBVK7XjYJV2YeGw3e+z78+MN+g85Y4dh+ggv03RiSZVg9nUyJKKXEtsN0gdtheXaZCZ+J9NvE1ISpobajKtwVx4kiejDjiNS/Ar4XfPolTU04LsJmVnqPENJ8=;
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.com>)
        id 1k9SMu-0003T7-Hn; Sat, 22 Aug 2020 12:11:32 +0000
Received: from [192.168.2.130] (helo=localhost)
        by exactco.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.86_2)
        (envelope-from <rene@exactcode.com>)
        id 1k9S4H-0002mM-Kc; Sat, 22 Aug 2020 11:52:20 +0000
Date:   Sat, 22 Aug 2020 13:59:41 +0200 (CEST)
Message-Id: <20200822.135941.315149880460809536.rene@exactcode.com>
To:     linux-scsi@vger.kernel.org
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH] fix qla2xxx regression on sparc64
From:   Rene Rebe <rene@exactcode.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 98aee70d19a7e3203649fa2078464e4f402a0ad8 in 2014 broke qla2xxx o=
n
sparc64, e.g. as in the Sun Blade 1000 / 2000. Unbreak by partial rever=
t to
fix endianess in nvram firmware default initialization.

Fixes: 98aee70d19a7e ("qla2xxx: Add endianizer to max_payload_size modi=
fier.")
Signed-off-by: Ren=E9 Rebe <rene@exactcode.de>

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla=
_init.c
index 57a2d76aa691..0916c33eb076 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4603,18 +4603,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
 			nv->add_firmware_options[0] =3D BIT_5;
 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
-			nv->frame_payload_size =3D 2048;
+			nv->frame_payload_size =3D __constant_cpu_to_le16(2048);
 			nv->special_options[1] =3D BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
 			nv->add_firmware_options[0] =3D BIT_5;
 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
-			nv->frame_payload_size =3D 1024;
+			nv->frame_payload_size =3D __constant_cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
 			nv->firmware_options[1] =3D BIT_5;
-			nv->frame_payload_size =3D 1024;
+			nv->frame_payload_size =3D __constant_cpu_to_le16(1024);
 		}
 =

 		nv->max_iocb_allocation =3D cpu_to_le16(256);


-- =

  Ren=E9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin
  https://exactcode.com | https://t2sde.org | https://rene.rebe.de
