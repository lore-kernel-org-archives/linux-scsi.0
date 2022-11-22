Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12283C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 04:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiKVEzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 23:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiKVEzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 23:55:09 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F132A70E;
        Mon, 21 Nov 2022 20:55:08 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NGX3y0LWmzRpQd;
        Tue, 22 Nov 2022 12:54:38 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 12:55:06 +0800
Received: from build.huawei.com (10.175.101.6) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 12:55:05 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "Mike Christie" <michael.christie@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>, Wenchao Hao <haowenchao@huawei.com>
Subject: [PATCH] scsi:iscsi: rename iscsi_set_param to iscsi_if_set_param
Date:   Tue, 22 Nov 2022 18:11:05 +0000
Message-ID: <20221122181105.4123935-1-haowenchao@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are two iscsi_set_param() functions individually defined
in libiscsi.c and scsi_transport_iscsi.c which is confused.

So rename the one in scsi_transport_iscsi.c to iscsi_if_set_param().

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index cd3db9684e52..c3fe5ecfee59 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2988,7 +2988,7 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 }
 
 static int
-iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
@@ -3941,7 +3941,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		err = iscsi_set_param(transport, ev);
+		err = iscsi_if_set_param(transport, ev);
 		break;
 	case ISCSI_UEVENT_CREATE_CONN:
 	case ISCSI_UEVENT_DESTROY_CONN:
-- 
2.35.3

