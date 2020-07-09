Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67E8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858FB207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="lR+7/Yra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgGIPTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:19:06 -0400
Received: from m15113.mail.126.com ([220.181.15.113]:43809 "EHLO
        m15113.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgGIPSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 11:18:36 -0400
X-Greylist: delayed 1859 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2020 11:18:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=/LgYjZNguoFLQwNLPw
        QMJhRcOD+VgjClMKSQRTgSi+I=; b=lR+7/YraQf1f9P/fcok66ol6sfV/ch3EVt
        KakuqRIXOLPUhGybbNWYPo0hHsrk7T+ppQuO2axZt7o4IYBCW9TFvZVzbiTwpfhD
        gpbep0aluEdVkF5RqVMNXqS8j9yzEfpAroWLCQPG03j0/8Z42AIW5O0C8lZqX26N
        xckiSTy48=
Received: from 192.168.137.252 (unknown [112.10.74.133])
        by smtp3 (Coremail) with SMTP id DcmowAA3FATJLQdfCX7hHQ--.16361S3;
        Thu, 09 Jul 2020 22:46:35 +0800 (CST)
From:   Xianting Tian <xianting_tian@126.com>
To:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: virtio_scsi: remove unnecessary condition check
Date:   Thu,  9 Jul 2020 10:46:32 -0400
Message-Id: <1594305992-8458-1-git-send-email-xianting_tian@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DcmowAA3FATJLQdfCX7hHQ--.16361S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw47tryktw1xCw43ZF48Crg_yoW3Krc_XF
        4FqrsrGr15KFn2kry8GryfZrWY9anrZF40kr9YgFyfCr1Fqwn0gr1jqr1rZF4fWw4jk3W3
        Cw4vyr1S9r1xGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8Tv3UUUUUU==
X-Originating-IP: [112.10.74.133]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbi5gtcpFpD+5LX2gAAso
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

kmem_cache_destroy can correctly handle null pointer parameter,
so there is no need to check if the parameter is null before
calling kmem_cache_destroy.

Signed-off-by: Xianting Tian <xianting_tian@126.com>
---
 drivers/scsi/virtio_scsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bfec84a..5bc288f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -1007,10 +1007,8 @@ static int __init init(void)
 		mempool_destroy(virtscsi_cmd_pool);
 		virtscsi_cmd_pool = NULL;
 	}
-	if (virtscsi_cmd_cache) {
-		kmem_cache_destroy(virtscsi_cmd_cache);
-		virtscsi_cmd_cache = NULL;
-	}
+	kmem_cache_destroy(virtscsi_cmd_cache);
+	virtscsi_cmd_cache = NULL;
 	return ret;
 }
 
-- 
1.8.3.1

