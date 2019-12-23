Return-Path: <SRS0=rNN+=2N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0954DC2D0D2
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Dec 2019 22:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C87EB2053B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Dec 2019 22:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPiGQ5oJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfLWW4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 17:56:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727031AbfLWW4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 17:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577141777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2/47G9XeaWMpZM1zDOYKyC4Wpdu3yTfLbrqo+TK1DM=;
        b=jPiGQ5oJSREDmvWHYdKSIY//btorumGEhSfY2clFEdRNTC2NH7RYHc0h/mLR/O/etVzPrc
        eiHf7/SDoSz4J0eLe+yiTBSDjPq/QuyE/8HhoWy/cxSh0/3PnXAoIK9auIQV70HOJfotjC
        SsAG82XFP9tYmwVTDsUuX0IvJf94gxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-pFJS9mGJPZ-zNFs_M12gbA-1; Mon, 23 Dec 2019 17:56:11 -0500
X-MC-Unique: pFJS9mGJPZ-zNFs_M12gbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAE26184B456;
        Mon, 23 Dec 2019 22:56:10 +0000 (UTC)
Received: from sulaco.redhat.com (ovpn-112-13.rdu2.redhat.com [10.10.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEC8560BE2;
        Mon, 23 Dec 2019 22:56:09 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC 8/9] ata_dev_printk: Add durable name to output
Date:   Mon, 23 Dec 2019 16:55:57 -0600
Message-Id: <20191223225558.19242-9-tasleson@redhat.com>
In-Reply-To: <20191223225558.19242-1-tasleson@redhat.com>
References: <20191223225558.19242-1-tasleson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have a durable name we will add to output, else
we will default to existing message output format.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/ata/libata-core.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 28c492be0a57..b57a74cfb529 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7249,6 +7249,9 @@ EXPORT_SYMBOL(ata_link_printk);
 void ata_dev_printk(const struct ata_device *dev, const char *level,
 		    const char *fmt, ...)
 {
+	char dict[128];
+	int dict_len =3D 0;
+
 	struct va_format vaf;
 	va_list args;
=20
@@ -7257,9 +7260,26 @@ void ata_dev_printk(const struct ata_device *dev, =
const char *level,
 	vaf.fmt =3D fmt;
 	vaf.va =3D &args;
=20
-	printk("%sata%u.%02u: %pV",
-	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
-	       &vaf);
+	if (dev->sdev) {
+		dict_len =3D dev_durable_name(
+			&dev->sdev->sdev_gendev,
+			dict,
+			sizeof(dict));
+	}
+
+	if (dict_len > 0) {
+		printk_emit(0, level[1] - '0', dict, dict_len,
+				"sata%u.%02u: %pV",
+				dev->link->ap->print_id,
+				dev->link->pmp + dev->devno,
+				&vaf);
+	} else {
+		printk("%sata%u.%02u: %pV",
+			level,
+			dev->link->ap->print_id,
+			dev->link->pmp + dev->devno,
+			&vaf);
+	}
=20
 	va_end(args);
 }
--=20
2.21.0

