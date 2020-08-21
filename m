Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED80C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 12:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E702078D
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 12:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=exactco.de header.i=@exactco.de header.b="vdzLXI94"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgHUMq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:46:57 -0400
Received: from mx.exactcode.de ([144.76.154.42]:58936 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgHUMq4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 08:46:56 -0400
X-Greylist: delayed 1105 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2020 08:46:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=exactco.de; s=x;
        h=Content-Transfer-Encoding:Content-Type:Mime-Version:From:Subject:To:Message-Id:Date; bh=6FArKxBsJBJDl4Eyny7XidOU9pbNnIfp1IODB4g8uEI=;
        b=vdzLXI94dVtsGTt9I3DDVNwnqzMzF8yNq5ncrAnlDGPDCq8LphH84bjMWAuUDLHIukrE+7GNtgO/gEEMg8U9hlblgWbDRhvglzc0BGp7FfNMgunM2ZB3rAUZFf/i+OGP7BGllE9BGKUWEGUIUo3uSvxCQ4XoQ9zeHJOhWTp/srE=;
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.com>)
        id 1k96A9-0002jt-Q4
        for linux-scsi@vger.kernel.org; Fri, 21 Aug 2020 12:28:53 +0000
Received: from [192.168.2.130] (helo=localhost)
        by exactco.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.86_2)
        (envelope-from <rene@exactcode.com>)
        id 1k95rV-00020w-3j
        for linux-scsi@vger.kernel.org; Fri, 21 Aug 2020 12:09:39 +0000
Date:   Fri, 21 Aug 2020 14:28:14 +0200 (CEST)
Message-Id: <20200821.142814.268140009249624430.rene@exactcode.com>
To:     linux-scsi@vger.kernel.org
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


Commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in 2014 broke
qla2xxx on sparc64, e.g. as in the Sun Blade 1000 / 2000.
Unbreak by fixing endianess in nvram firmware defaults
initialization.

Signed-off-by: Ren=E9 Rebe <rene@exactcode.de>

--- linux-5.8/drivers/scsi/qla2xxx/qla_init.c.vanilla	2020-08-21 09:55:=
18.600926737 +0200
+++ linux-5.8/drivers/scsi/qla2xxx/qla_init.c	2020-08-21 09:57:35.99292=
6885 +0200
@@ -4603,18 +4603,18 @@
 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
 			nv->add_firmware_options[0] =3D BIT_5;
 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
-			nv->frame_payload_size =3D 2048;
+			nv->frame_payload_size =3D cpu_to_le16(2048);
 			nv->special_options[1] =3D BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
 			nv->add_firmware_options[0] =3D BIT_5;
 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
-			nv->frame_payload_size =3D 1024;
+			nv->frame_payload_size =3D cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
 			nv->firmware_options[1] =3D BIT_5;
-			nv->frame_payload_size =3D 1024;
+			nv->frame_payload_size =3D cpu_to_le16(1024);
 		}
 =

 		nv->max_iocb_allocation =3D cpu_to_le16(256);

-- =

  Ren=E9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin
  https://exactcode.com | https://t2sde.org | https://rene.rebe.de
