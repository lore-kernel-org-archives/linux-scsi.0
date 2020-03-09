Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B5CC10F27
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 18:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0334120578
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 18:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GyPl3dV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgCISOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 14:14:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727423AbgCISOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 14:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583777660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T957d8I4ZcqeCyMoJHbHmfdXJrfjNlZB+qb7t4iOja4=;
        b=GyPl3dV5p2gD1GAWlwrjQ5/6tC+E+rUGgHqSONE79Fo2RgX45eXpc9OooToOvxA7i58agH
        p0fsV4qsqDDzc7735z3WFmZU6SGVHN+z8t1r2jWqVN7cgMWFit5iTDs2RBZPzB34JjW65m
        cAGeJQHvfA1XsMouLBDUYSWFC0oQKd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-FE-_ALs0MouJ1I2flY-KTA-1; Mon, 09 Mar 2020 14:14:18 -0400
X-MC-Unique: FE-_ALs0MouJ1I2flY-KTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78FDD107ACC7
        for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2020 18:14:17 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3382D5C54A
        for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2020 18:14:17 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: avoid repetitive logging of device offline messages
Date:   Mon,  9 Mar 2020 14:14:16 -0400
Message-Id: <20200309181416.10665-1-emilne@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 8 ++++++--
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41..d3a6d97 100644
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
+			sdev->offline_already =3D 1;
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
+	sdev->offline_already =3D 0;
 	sdev->sdev_state =3D state;
 	return 0;
=20
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3..72987a0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -204,6 +204,8 @@ struct scsi_device {
 	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
+	unsigned offline_already:1;	/* Device offline message logged */
+
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
=20
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events=
 */
--=20
2.1.0

