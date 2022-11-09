Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CB4C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 09:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiKIJZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKIJZq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 04:25:46 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12A8140F2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 01:25:45 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N6fhT4sWSz15MVR;
        Wed,  9 Nov 2022 17:25:29 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:25:41 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 9 Nov
 2022 17:25:41 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>
CC:     <lduncan@suse.com>, <cleech@redhat.com>,
        <michael.christie@oracle.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <yangyingliang@huawei.com>
Subject: [PATCH] scsi: iscsi: fix possible memory leak when transport_register_device() fails
Date:   Wed, 9 Nov 2022 17:24:21 +0800
Message-ID: <20221109092421.3111613-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If transport_register_device() fails, transport_destroy_device() should
be called to release the memory allocated in transport_setup_device().

Fixes: 0896b7523026 ("[SCSI] open-iscsi/linux-iscsi-5 Initiator: Transport class update for iSCSI")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index cd3db9684e52..88add31a56e3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2085,6 +2085,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	return 0;
 
 release_dev:
+	transport_destroy_device(&session->dev);
 	device_del(&session->dev);
 release_ida:
 	if (session->ida_used)
@@ -2462,6 +2463,7 @@ int iscsi_add_conn(struct iscsi_cls_conn *conn)
 	if (err) {
 		iscsi_cls_session_printk(KERN_ERR, session,
 					 "could not register transport's dev\n");
+		transport_destroy_device(&conn->dev);
 		device_del(&conn->dev);
 		return err;
 	}
-- 
2.25.1

