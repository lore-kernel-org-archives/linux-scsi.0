Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177D1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF0761039
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345858AbhIXXFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:05:05 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:33342
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232123AbhIXXFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Sep 2021 19:05:05 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 548F03F0AA;
        Fri, 24 Sep 2021 23:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632524610;
        bh=d5U2GkrHZIUhRCDfV/26YdMlC5mdNTj/avHWnIDd59w=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=mfTMOZMR5ACJF5cjnZ0qJpqdwpV1TBmYWrQBsT7j+U9xZJeaax4qJy//dZfzdnyT4
         hk7+e0CjJLzJBxkE1VjegeJJ/bJHBtGTHUe+F+/UawF+VHWm2ZILX7AiJiJykjz2tN
         UFejqzygovp4B82lU7E0xeJaY3QIGHO/y9kVqgD2/3QmxVik7NdnOAU/uuq3QfbLtd
         YaEnAzglhCSCd3Apd1i24epCMWey6nA5ICgWazZNlo1LxFcIPzp2SYR/A0+iROAZsD
         lfM34EXvsxvRQ7ryFaY45rBa6mZVKDxF1BSKxYj50iTrpxnmuHFCeQppaYjQdXJV7U
         3xj3QqaGZ+V0w==
From:   Colin King <colin.king@canonical.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Sat, 25 Sep 2021 00:03:30 +0100
Message-Id: <20210924230330.143785-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of spelling mistakes in pr_info and pr_err messages.
Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c25ce8f0e0af..07d0250f17c3 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -300,7 +300,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
 	}
 }
 
@@ -392,7 +392,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 		virtscsi_handle_param_change(vscsi, event);
 		break;
 	default:
-		pr_err("Unsupport virtio scsi event %x\n", event->event);
+		pr_err("Unsupported virtio scsi event %x\n", event->event);
 	}
 	virtscsi_kick_event(vscsi, event_node);
 }
-- 
2.32.0

