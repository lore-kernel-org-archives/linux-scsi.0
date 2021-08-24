Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C41C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A8B61178
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhHXDSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233885AbhHXDSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629775089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4FMgMmVU2uNnPaVr5geFa8doDQXcH7H2fPDk7t5xrWo=;
        b=RYbRc22PEKlNLxFs1wuU8XuiDFbYQDlydxe1mYhwtwH0OT8Li4fCAU0l5Bgrago3N3eS79
        krVygmMlf0K+mY/ruwMxuTRLq57hkS0p1ZArrHY8D2v9SKwsx597A8DDB6daJrmkVcOatE
        ruqrzoMwEyTKc6crPjYLHROcy8B9Y+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-uUaqnZAUPCuazUtVAcGI_g-1; Mon, 23 Aug 2021 23:18:08 -0400
X-MC-Unique: uUaqnZAUPCuazUtVAcGI_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C1C875049;
        Tue, 24 Aug 2021 03:18:07 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 459A25D6AD;
        Tue, 24 Aug 2021 03:18:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Omar Sandoval <osandov@fb.com>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] block/001: wait until device is added
Date:   Tue, 24 Aug 2021 11:17:53 +0800
Message-Id: <20210824031753.1397579-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Writing to the scan attribute of scsi host is usually one sync scan, but
devices in this sync scan may be delay added if there is concurrent
asnyc scan.

So wait until the device is added in block/001 for avoiding to fail
the test.

Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tests/block/001 | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/block/001 b/tests/block/001
index 51ec9d8..01356d0 100755
--- a/tests/block/001
+++ b/tests/block/001
@@ -21,15 +21,20 @@ stress_scsi_debug() {
 		return
 	fi
 
-	local host target
+	local host target target_path
 	for target in "${SCSI_DEBUG_TARGETS[@]}"; do
 		(
 		host="${target%%:*}"
 		scan="${target#*:}"
 		scan="${scan//:/ }"
+		target_path="/sys/class/scsi_device/${target}"
 		while [[ ! -e "$TMPDIR/stop" ]]; do
 			echo "${scan}" > "/sys/class/scsi_host/host${host}/scan"
-			echo 1 > "/sys/class/scsi_device/${target}/device/delete"
+			while [ ! -d ${target_path} ]; do
+				sleep 0.01;
+				[[ -e "$TMPDIR/stop" ]] && break
+			done
+			[ -d ${target_path} ] && echo 1 > ${target_path}/device/delete
 		done
 		) &
 	done
-- 
2.31.1

