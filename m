Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8272C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 11:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiCGLrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 06:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiCGLrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 06:47:10 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC1B66204;
        Mon,  7 Mar 2022 03:46:15 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KBxSg4X4PzBrd0;
        Mon,  7 Mar 2022 19:44:19 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 19:46:13 +0800
Received: from huawei.com (10.175.101.6) by dggpemm500017.china.huawei.com
 (7.185.36.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 7 Mar
 2022 19:46:12 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Wu Bo <wubo40@huawei.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Wenchao Hao <haowenchao@huawei.com>
Subject: [PATCH 0/2]scsi:libiscsi: Add iscsi_cls_conn device to sysfs correctly
Date:   Mon, 7 Mar 2022 19:56:52 -0500
Message-ID: <20220308005654.2281343-1-haowenchao@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

This patchset solve this issue by changing iscsi_conn_setup() and works 
well for iscsi_tcp.

Wenchao Hao (2):
  scsi: iscsi: Add helper functions to alloc and add iscsi_cls_conn
  scsi:libiscsi: Add iscsi_cls_conn to sysfs after been initialized

 drivers/scsi/libiscsi.c             | 13 ++++-
 drivers/scsi/scsi_transport_iscsi.c | 85 +++++++++++++++++++++++------
 include/scsi/scsi_transport_iscsi.h |  3 +
 3 files changed, 83 insertions(+), 18 deletions(-)

-- 
2.32.0

