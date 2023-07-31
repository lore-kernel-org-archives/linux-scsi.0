Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15108C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 08:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjGaIpN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 04:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjGaIod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 04:44:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774394696
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 01:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690792848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YgHQpEbLJguvAb28DMKBegK14yQyhVaGjEEtVU0RXL8=;
        b=gX+n2vIMxByPOz+Iru4gH/wF6seihStoCNTSDtKWeOBmXElh1thXL+htAioB0GilzC22Qp
        gp6B5K8higN9WuyyJMbgbcAVRPrF7+5R8B0H2smVyD8/I+o/e6TtCmvCU2QznGVTvFqJaL
        eWBUUhfittIs+OdTOGcBr0wAtPC4mD4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-Rt1tM8ssPnSEZoh2I2xJJg-1; Mon, 31 Jul 2023 04:40:44 -0400
X-MC-Unique: Rt1tM8ssPnSEZoh2I2xJJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2930A88D120;
        Mon, 31 Jul 2023 08:40:44 +0000 (UTC)
Received: from localhost (unknown [10.45.224.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAFC1401061;
        Mon, 31 Jul 2023 08:40:43 +0000 (UTC)
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Laight <David.Laight@ACULAB.COM>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jozef Bacik <jobacik@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Rob Evers <revers@redhat.com>
Subject: [PATCH v2 2/3] scsi: qedf: do not touch __user pointer in qedf_dbg_debug_cmd_read() directly
Date:   Mon, 31 Jul 2023 10:40:33 +0200
Message-ID: <20230731084034.37021-3-oleksandr@redhat.com>
In-Reply-To: <20230731084034.37021-1-oleksandr@redhat.com>
References: <20230731084034.37021-1-oleksandr@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The qedf_dbg_debug_cmd_read() function invokes sprintf()
directly on a __user pointer, which may crash the kernel.

Avoid doing that by using a small on-stack buffer for scnprintf()
and then calling simple_read_from_buffer() which does a proper
copy_to_user() call.

Fixes: 61d8658b4a ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Link: https://lore.kernel.org/lkml/20230724120241.40495-1-oleksandr@redhat.com/
Link: https://lore.kernel.org/linux-scsi/20230726101236.11922-1-skashyap@marvell.com/
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Rob Evers <revers@redhat.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Jozef Bacik <jobacik@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 drivers/scsi/qedf/qedf_debugfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index 3eb4334ac6a32..1c5716540e465 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -138,15 +138,14 @@ qedf_dbg_debug_cmd_read(struct file *filp, char __user *buffer, size_t count,
 			loff_t *ppos)
 {
 	int cnt;
+	char cbuf[32];
 	struct qedf_dbg_ctx *qedf_dbg =
 				(struct qedf_dbg_ctx *)filp->private_data;
 
 	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "debug mask=0x%x\n", qedf_debug);
-	cnt = sprintf(buffer, "debug mask = 0x%x\n", qedf_debug);
+	cnt = scnprintf(cbuf, sizeof(cbuf), "debug mask = 0x%x\n", qedf_debug);
 
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	return simple_read_from_buffer(buffer, count, ppos, cbuf, cnt);
 }
 
 static ssize_t
-- 
2.41.0

