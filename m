Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135E2C4724C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 13:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE2C20870
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 13:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dy9fApb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEGNRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 09:17:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42471 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725948AbgEGNRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 09:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588857438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=geX7N42YtmADBy3liHNZ5oWXztK72qez5GHzumHYo4M=;
        b=dy9fApb/Ra7RUtwe6c3Yo0aHEAZH49/vRfoynpJ09oo/RNS75LHoxKyPgyNGBrcd94Ky51
        Ng1T8MT7eG39sA+lLHugQrCGm2DgXPIcs529kMHEk1Hl7lgLL9wuUmYeYNupQHIZO37of3
        vDmBStiSUolHnIZmYEH6B8QV+eAX788=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-ZBNz5C4GMDyqUQkXr9MtRA-1; Thu, 07 May 2020 09:17:14 -0400
X-MC-Unique: ZBNz5C4GMDyqUQkXr9MtRA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2CFD1B2C984;
        Thu,  7 May 2020 13:17:12 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-115-120.ams2.redhat.com [10.36.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04E5C5D9E5;
        Thu,  7 May 2020 13:17:09 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        =?UTF-8?q?Julian=20Gro=C3=9F?= <julian.g@posteo.de>
Subject: [PATCH] USB: uas: Add US_FL_NO_REPORT_OPCODES for LaCie 2Big Quadra USB3 external disk
Date:   Thu,  7 May 2020 15:17:08 +0200
Message-Id: <20200507131708.250871-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The LaCie 2Big Quadra USB3 external disk does not like the REPORT_OPCODES
request, causing probing it to take several minutes (and several resets).

Add US_FL_NO_REPORT_OPCODES flag for this model to fix the probing delay.

Reported-by: Julian Gro=C3=9F <julian.g@posteo.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unus=
ual_uas.h
index 1b23741036ee..37157ed9a881 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -28,6 +28,13 @@
  * and don't forget to CC: the USB development list <linux-usb@vger.kern=
el.org>
  */
=20
+/* Reported-by: Julian Gro=C3=9F <julian.g@posteo.de> */
+UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
+		"LaCie",
+		"2Big Quadra USB3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to =
SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there oth=
ers?
--=20
2.26.0

