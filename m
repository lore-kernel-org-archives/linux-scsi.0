Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7E5C3DA78
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 01:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjANBiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 20:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjANBiR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 20:38:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1325C7F462
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 17:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673660250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VZy8c8fy0bsQa5T6EMyPtDGsQiznRhGW5hoUl+VQVKY=;
        b=aoE3aras4QEBwRor5GtbLdPac9jzFSoJDWQW/a99v+I6iUWab0hWDcIv4lqeK/Cei/e8bz
        kOsy9gd9Xj6U3e+4DJllY8u04aO7kDd5Y3hhr6eY0BGvN4WTpsJ94pKH0tVwV6YE0lfA8b
        yZOndSUhO9P1V9Fpx+9bUJuBGyk1tWs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-Za5gRPaTNA2eVyjlVZYSjA-1; Fri, 13 Jan 2023 20:37:28 -0500
X-MC-Unique: Za5gRPaTNA2eVyjlVZYSjA-1
Received: by mail-qv1-f71.google.com with SMTP id o95-20020a0c9068000000b005320eb4e959so12316770qvo.16
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 17:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VZy8c8fy0bsQa5T6EMyPtDGsQiznRhGW5hoUl+VQVKY=;
        b=JysMNSowK//Q2cxIOGpCdd44OslpwnzssSoToo/+0mn30zASAWToKXSdh0RVuRiBun
         ss+FavSnFvmE8v1v9AL2aIToz/foRe13wb9G3zsd6ClPQQaryHgFjwija37BVLDT4pI1
         GSqd+xdmPEFGHlxQsxd3CoZANX5C5q6qarlfqGmBXwlYyD1K3qVLle7pUzwg8hfWxBZ9
         G+VslvnOnsLBihFxY6ENxZVMwYTQB9f/E6KT1Kd39CxVQd/AAsqsvs0Db+Pp3wyOUszV
         7CwOSMRWZHTqWvCUf8zkNK3ajty98KubFYcVFiTGyazCGBSSFiH7kP7TG8T5pxjAKz9N
         SyKw==
X-Gm-Message-State: AFqh2kpnEuGMwBUGJqZ5xjzI5rXaNqbuw9b6GeDsO6Fez78Aq0onbqkS
        8TNX1BkL8SblHrW8FdSMlHAgZ4Vl/JJeuEW+8EfSpTIm9Xk/ABeobED7tsI/A+O4UEUxctSURTd
        9jsHddhaHrellQqpCq74nZg==
X-Received: by 2002:a05:622a:5a85:b0:3a8:28fb:b076 with SMTP id fz5-20020a05622a5a8500b003a828fbb076mr107846184qtb.31.1673660247672;
        Fri, 13 Jan 2023 17:37:27 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvb2Tb9KjAktZHd4kQ+lb1N0KtnEmqYLvasUGIsxQAbnMndD0u7XJmgxkam6UrQA6YDD+2hMw==
X-Received: by 2002:a05:622a:5a85:b0:3a8:28fb:b076 with SMTP id fz5-20020a05622a5a8500b003a828fbb076mr107846169qtb.31.1673660247477;
        Fri, 13 Jan 2023 17:37:27 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bp32-20020a05620a45a000b00705b4001fbasm10673981qkb.128.2023.01.13.17.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 17:37:27 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     njavali@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, qutran@marvell.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: qla2xxx: Change qla_trim_buf,__qla_adjust_buf functions to static
Date:   Fri, 13 Jan 2023 20:37:24 -0500
Message-Id: <20230114013724.3943580-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch reports
drivers/scsi/qla2xxx/qla_mid.c:1189:6: warning: symbol 'qla_trim_buf' was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_mid.c:1221:6: warning: symbol '__qla_adjust_buf' was not declared. Should it be static?

These functions are only used in qla_mid.c, so they should be static.

Fixes: 1f8f9c34127e ("scsi: qla2xxx: edif: Reduce memory usage during low I/O")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c6ca39b8e23d..bd6bc1a968b2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1186,7 +1186,7 @@ int qla_get_buf(struct scsi_qla_host *vha, struct qla_qpair *qp, struct qla_buf_
 	return 0;
 }
 
-void qla_trim_buf(struct qla_qpair *qp, u16 trim)
+static void qla_trim_buf(struct qla_qpair *qp, u16 trim)
 {
 	int i, j;
 	struct qla_hw_data *ha = qp->vha->hw;
@@ -1218,7 +1218,7 @@ void qla_trim_buf(struct qla_qpair *qp, u16 trim)
 	       qp->id, trim, qp->buf_pool.num_alloc);
 }
 
-void __qla_adjust_buf(struct qla_qpair *qp)
+static void __qla_adjust_buf(struct qla_qpair *qp)
 {
 	u32 trim;
 
-- 
2.27.0

