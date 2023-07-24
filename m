Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369E9C001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 12:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjGXMDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 08:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjGXMDe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 08:03:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C067E6D
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 05:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690200168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lSRQBULx+TvRi9w0R85wybLn1zR6qk9EVDsaRk1ameQ=;
        b=Gzqf5USKNErEseoPd2WK/leomC139OmqcezyGpkfRPd3T8fVRRcBY3vi6Hb2MKOhX+hRZ3
        jiG2I8gfiq3DoOrpte5tGEGolpOrbsyeQSUFSWyoI/67GD7h4+EQ8R3xAxJrCnRpdIX495
        MDcmPlHmDxzWuk0kf9pUIvlFeFv3hnI=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-LkaPnEg9PgulEKUeZ7-pKw-1; Mon, 24 Jul 2023 08:02:43 -0400
X-MC-Unique: LkaPnEg9PgulEKUeZ7-pKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FA3A3827907;
        Mon, 24 Jul 2023 12:02:43 +0000 (UTC)
Received: from localhost (dhcp-10-40-5-80.brq.redhat.com [10.40.5.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C64B6C2C856;
        Mon, 24 Jul 2023 12:02:42 +0000 (UTC)
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jozef Bacik <jobacik@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Rob Evers <revers@redhat.com>
Subject: [RFC PATCH 1/3] scsi: qedf: do not touch __user pointer in qedf_dbg_stop_io_on_error_cmd_read() directly
Date:   Mon, 24 Jul 2023 14:02:39 +0200
Message-ID: <20230724120241.40495-2-oleksandr@redhat.com>
In-Reply-To: <20230724120241.40495-1-oleksandr@redhat.com>
References: <20230724120241.40495-1-oleksandr@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The qedf_dbg_stop_io_on_error_cmd_read() function invokes sprintf()
directly on a __user pointer, which may crash the kernel.

Avoid doing that by using a small on-stack buffer for sprintf()
and then calling simple_read_from_buffer() which does a proper
copy_to_user() call.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 drivers/scsi/qedf/qedf_debugfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index a3ed681c8ce3f..4d1b99569d490 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -185,18 +185,17 @@ qedf_dbg_stop_io_on_error_cmd_read(struct file *filp, char __user *buffer,
 				   size_t count, loff_t *ppos)
 {
 	int cnt;
+	char cbuf[7];
 	struct qedf_dbg_ctx *qedf_dbg =
 				(struct qedf_dbg_ctx *)filp->private_data;
 	struct qedf_ctx *qedf = container_of(qedf_dbg,
 	    struct qedf_ctx, dbg_ctx);
 
 	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "entered\n");
-	cnt = sprintf(buffer, "%s\n",
+	cnt = sprintf(cbuf, "%s\n",
 	    qedf->stop_io_on_error ? "true" : "false");
 
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	return simple_read_from_buffer(buffer, count, ppos, cbuf, cnt);
 }
 
 static ssize_t
-- 
2.41.0

