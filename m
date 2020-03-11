Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78821C10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 14:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2ED520637
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 14:39:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TaMRLiyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgCKOjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:39:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729795AbgCKOjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 10:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583937574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=knoYa6Ul91pRyCLzoyCTBwuRxcecxBgIlJRY/JE6WzI=;
        b=TaMRLiyZN9pD9PQoPSvgI8hEe935TJJ7M5dWW2GS3DAeI4lP51AdSqiY5LafnCV1klT9X+
        3WT894knLhMdKMe1OHKRYdtgeoyJUEyv4rnVuMGFeZPJEW7YPiMNI4F6VQNMg1uO2FtL1D
        wDWiWmL8rjzdogrFx4G40/mb4Wih7mw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-qfldEiujOJaXWKMSMLX6Cg-1; Wed, 11 Mar 2020 10:39:32 -0400
X-MC-Unique: qfldEiujOJaXWKMSMLX6Cg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D816F107ACC7
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 14:39:31 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8369B8F37A
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 14:39:31 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: avoid repetitive logging of device offline messages
Date:   Wed, 11 Mar 2020 10:39:30 -0400
Message-Id: <20200311143930.20674-1-emilne@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Large queues of I/O to offline devices that are eventually
submitted when devices are unblocked result in a many repeated
"rejecting I/O to offline device" messages.  These messages
can fill up the dmesg buffer in crash dumps so no useful
prior messages remain.  In addition, if a serial console
is used, the flood of messages can cause a hard lockup in
the console code.

Introduce a flag indicating the message has already been logged
for the device, and reset the flag when scsi_device_set_state()
changes the device state.

v2:
	Changed flag type from bitfield to bool by request

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 8 ++++++--
 include/scsi/scsi_device.h | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41..a45e728 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device *sdev, st=
ruct request *req)
 		 * commands.  The device must be brought online
 		 * before trying any recovery commands.
 		 */
-		sdev_printk(KERN_ERR, sdev,
-			    "rejecting I/O to offline device\n");
+		if (!sdev->offline_already) {
+			sdev->offline_already =3D true;
+			sdev_printk(KERN_ERR, sdev,
+				    "rejecting I/O to offline device\n");
+		}
 		return BLK_STS_IOERR;
 	case SDEV_DEL:
 		/*
@@ -2340,6 +2343,7 @@ scsi_device_set_state(struct scsi_device *sdev, enu=
m scsi_device_state state)
 		break;
=20
 	}
+	sdev->offline_already =3D false;
 	sdev->sdev_state =3D state;
 	return 0;
=20
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3..cd9656f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -204,6 +204,9 @@ struct scsi_device {
 	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
+
+	bool offline_already;		/* Device offline message logged */
+
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
=20
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events=
 */
--=20
2.1.0

