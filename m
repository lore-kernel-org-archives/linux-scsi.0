Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149B3CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 15:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F8120684
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 15:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jLvVxr0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409741AbfJXPqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:46:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409743AbfJXPqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 11:46:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571931954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=18a488PSJwMd7T57NULIJXU2mWIgp50hhEIjxQCIqZ4=;
        b=jLvVxr0nYenUvqbmFAFXCZjc8ai8cWwQhe4PF+cmBgNVY/rRsMdIhyoraH59U7rL93d95Y
        Wk6I1lO4djMqUWs/5p11h1RCgp+mAEBFmcX7PdK8iM6vDGV9gz4+O13lBif/zHDierVafC
        dYZrJewwCXgbSagAl6Qr0nVQf8AhR8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-s1jboasqN_SoxcxN2TFTgQ-1; Thu, 24 Oct 2019 11:45:35 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F12610055BF;
        Thu, 24 Oct 2019 15:28:37 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.43.2.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32BC0100164D;
        Thu, 24 Oct 2019 15:28:36 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: [PATCH 1/1] mpt3sas: change allocation option
Date:   Thu, 24 Oct 2019 17:28:35 +0200
Message-Id: <20191024152835.6177-1-thenzl@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: s1jboasqN_SoxcxN2TFTgQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From an interrupt handler path memory may be allocated using
GFP_KERNEL, replace it with GFP_ATOMIC.
_base_interrupt->_scsih_io_done->_scsih_smart_predicted_fault

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mp=
t3sas_scsih.c
index 3f0797e6f..a038be8a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5161,7 +5161,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *=
ioc, u16 handle)
 =09/* insert into event log */
 =09sz =3D offsetof(Mpi2EventNotificationReply_t, EventData) +
 =09     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
-=09event_reply =3D kzalloc(sz, GFP_KERNEL);
+=09event_reply =3D kzalloc(sz, GFP_ATOMIC);
 =09if (!event_reply) {
 =09=09ioc_err(ioc, "failure at %s:%d/%s()!\n",
 =09=09=09__FILE__, __LINE__, __func__);
--=20
2.20.1

