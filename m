Return-Path: <SRS0=ECI8=3U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA113C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jan 2020 13:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 734F020707
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jan 2020 13:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5Z1WPj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgAaNX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jan 2020 08:23:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728514AbgAaNX6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2020 08:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580477037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sMaphhSEbDtcrddrpQyTgSv//2dXUFFEv7YDzezSwZc=;
        b=A5Z1WPj4ne6bQELoB+1LtQ/RO/2bVNH91MwoS5/ZCrVw/H8wjh0mf7cmk2Cl2yQelN7Ri9
        844p9WWD7dP61GEtR/pgwaqntVaoBFLhVqSa84ozEBfI4TPfFbClMToToAlx6bNO/q1H9H
        xZJ4MIXqoBSaS0616pt/vQF7V1meDRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-jXbA-LiSMMKz8pSbyFoyzA-1; Fri, 31 Jan 2020 08:23:53 -0500
X-MC-Unique: jXbA-LiSMMKz8pSbyFoyzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 176B9107ACC4;
        Fri, 31 Jan 2020 13:23:52 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.43.2.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FA637794C;
        Fri, 31 Jan 2020 13:23:51 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Subject: [PATCH] megaraid_sas: silence a warning
Date:   Fri, 31 Jan 2020 14:23:50 +0100
Message-Id: <20200131132350.31840-1-thenzl@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a flag to dma mem allocation to silence a warning.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/m=
egaraid/megaraid_sas_fusion.c
index 0f5399b3e..1fa2d1449 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -606,7 +606,8 @@ megasas_alloc_request_fusion(struct megasas_instance =
*instance)
=20
 	fusion->io_request_frames =3D
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				GFP_KERNEL, &fusion->io_request_frames_phys);
+				GFP_KERNEL | __GFP_NOWARN,
+				&fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
 		if (instance->max_fw_cmds >=3D (MEGASAS_REDUCE_QD_COUNT * 2)) {
 			instance->max_fw_cmds -=3D MEGASAS_REDUCE_QD_COUNT;
@@ -644,7 +645,7 @@ megasas_alloc_request_fusion(struct megasas_instance =
*instance)
=20
 		fusion->io_request_frames =3D
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				       GFP_KERNEL,
+				       GFP_KERNEL | __GFP_NOWARN,
 				       &fusion->io_request_frames_phys);
=20
 		if (!fusion->io_request_frames) {
--=20
2.21.1

