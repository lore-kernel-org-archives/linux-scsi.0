Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA153EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 11:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjF1LfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 07:35:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230188AbjF1LfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2023 07:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687952055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LwyMHP2ZqWQjcx8PKLBlNyd1xNugU2/yjb6G8zvsPZQ=;
        b=hMGfgfjX0m8PIGLIXFs57so1eluLJJQ7ct2M6a9+U0MK8slsls7xV3D5oyMfV8SjQfASsz
        yrSwVtbM3Bgy9LULoqKbArUxUgnUn2g2wVjTHsKU4WUs5HnOfx+WlblxvaxXihaqV5ndcq
        LsIRDRP12OHHUU2aNaXudP5Wu5aOeLI=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-JFR_OSH9PQ-ar1VgA-OOlA-1; Wed, 28 Jun 2023 07:34:14 -0400
X-MC-Unique: JFR_OSH9PQ-ar1VgA-OOlA-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-39e9c7227d9so5208692b6e.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 04:34:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687952053; x=1690544053;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwyMHP2ZqWQjcx8PKLBlNyd1xNugU2/yjb6G8zvsPZQ=;
        b=ltCjwBzAMOqojMowGq+21VW71tkl6lkdLkLkKwuUXreS6ML6O3L0V7VYr90AEMyp2e
         DIvghLHeLtmYRwKkscL4xOnceNiq9xQ8MJrZGoy3pEOwO2UuzRTdUtSDnubIO8A7xmKP
         z4OFfYgf3dw46ymCNhXDFuW0xpO+NlrR615M0NE5DDiUWyodW+/3oLgKR5n0+gPifTyn
         UpMXQirNFebEMuw6EGm6JZlDG55797xstqZeSkKC5RN0a4Nx8VJFabYwJm222gAjQRb/
         U1wbHaUJ8p8nyCeqn4ypQHYClCIObJB+Z192o9vCB4IFRUTlfYK/MN2KjEN7SWMyBCx2
         TGJQ==
X-Gm-Message-State: AC+VfDxQZV4Zbt/o8ywnQ9tbjDE01+nmsFuVrix0YXtNzAgfqCHwJoBI
        r2xRId24xs0p0gPinx5Ei7elwn+UY3SWV6JXaYs7hVINPs1n5TQol0ip+7dJv12KYK9I594N3Jz
        y4QTRgbuFtuI5fxHdPOAQ8jFiZKmQQAnHWRpadgSlMRle8416IsRPuX2b8jcIUzebnfm9HiVHWZ
        WFsetOag==
X-Received: by 2002:a05:6808:189a:b0:3a1:e13e:a89e with SMTP id bi26-20020a056808189a00b003a1e13ea89emr9937473oib.19.1687952053105;
        Wed, 28 Jun 2023 04:34:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4locL3SsfVrgVMyQn4HJU3Fl89zvyvMCojxJW9hE0cIeFjhYZtdcv1UKDlCBrd+zCWg6WnXA==
X-Received: by 2002:a05:6808:189a:b0:3a1:e13e:a89e with SMTP id bi26-20020a056808189a00b003a1e13ea89emr9937453oib.19.1687952052788;
        Wed, 28 Jun 2023 04:34:12 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id e4-20020ac84904000000b003f7f66d5a0esm5727786qtq.44.2023.06.28.04.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 04:34:12 -0700 (PDT)
Message-ID: <77f405a048b07e4451b7d7adaeba7ce4a00b7efb.camel@redhat.com>
Subject: [PATCH] scsi: qla2xxx avoid a panic due to BUG() if a WRITE_SAME
 command  is sent to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi@vger.kernel.org, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     djeffery@redhat.com, loberman@redhat.com, emilne@redhat.com,
        jpittman@redhat.com
Date:   Wed, 28 Jun 2023 07:34:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the current code, If a device does not have protection, qla2xx will
land up defaulting to a BUG() and will panic the system when
sg_write_same is sent.This is because SCSI_PROT_NORMAL is matched and
falls through to the BUG() call.
The write_same command to a device without protection is not handled
safely.

Fix this by making two changes:
Set the bundling variable also to 0 for SCSI_PROT_NORMAL
Modify the switch statement to match on SCSI_PROT_NORMAL and handle it
appropriately removing the call to BUG()

Supersedes prior suggested patch.
=20
Suggested-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
b/drivers/scsi/qla2xxx/qla_iocb.c
index b9b3e6f80ea9..82a5d195e401 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1381,7 +1381,8 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct
cmd_type_crc_2 *cmd_pkt,
 	if ((scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_READ_INSERT) ||
 	    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_WRITE_STRIP) ||
 	    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_READ_STRIP) ||
-	    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_WRITE_INSERT))
+	    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_WRITE_INSERT) ||
+	    (scsi_get_prot_op(cmd) =3D=3D SCSI_PROT_NORMAL))
 		bundling =3D 0;
=20
 	/* Allocate CRC context from global pool */
@@ -1443,6 +1444,9 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct
cmd_type_crc_2 *cmd_pkt,
 	dif_bytes =3D (data_bytes / blk_size) * 8;
=20
 	switch (scsi_get_prot_op(GET_CMD_SP(sp))) {
+	case SCSI_PROT_NORMAL:
+		total_bytes =3D data_bytes;
+		break;
 	case SCSI_PROT_READ_INSERT:
 	case SCSI_PROT_WRITE_STRIP:
 		total_bytes =3D data_bytes;
--=20
2.39.3

