Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5802EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 13:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbiCHN7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 08:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiCHN7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 08:59:36 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB621A81A;
        Tue,  8 Mar 2022 05:58:40 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KCcHf1mY6zbc1x;
        Tue,  8 Mar 2022 21:53:50 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 21:58:38 +0800
Received: from huawei.com (10.175.101.6) by dggpemm500017.china.huawei.com
 (7.185.36.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 8 Mar
 2022 21:58:37 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Wu Bo <wubo40@huawei.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>, Wenchao Hao <haowenchao@huawei.com>
Subject: [PATCH v2 0/3] scsi:iscsi: handle iscsi_cls_conn device with sysfs
Date:   Tue, 8 Mar 2022 22:09:13 -0500
Message-ID: <20220309030916.2932316-1-haowenchao@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We found a NULL pointer dereference in iscsi_sw_tcp_conn_get_param(),
the root reason is we did sysfs addition wrong.

iscsi_create_conn() expose iscsi_cls_conn to sysfs while the related
resources are not initialized. So we should delay the calling of
device_add() until these resources has been initialized.

This patchset solve this issue by correct the add and teardown flow
of iscsi_cls_conn.

-----------
V2:
  add two more iscsi_free_conn() and iscsi_remove_conn() than V1
  change the teardown flow of iscsi_cls_conn

Wenchao Hao (3):
  scsi: iscsi: Add helper functions to manage iscsi_cls_conn
  scsi:libiscsi: Add iscsi_cls_conn to sysfs after been initialized
  scsi:libiscsi: teardown iscsi_cls_conn gracefully

 drivers/scsi/libiscsi.c             | 21 ++++++---
 drivers/scsi/scsi_transport_iscsi.c | 72 +++++++++++++++++++++--------
 include/scsi/scsi_transport_iscsi.h |  5 +-
 3 files changed, 71 insertions(+), 27 deletions(-)

-- 
2.32.0

