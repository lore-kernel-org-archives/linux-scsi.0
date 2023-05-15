Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF21C77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 07:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbjEOHCQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 03:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239262AbjEOHCP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 03:02:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCD5E60;
        Mon, 15 May 2023 00:02:13 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QKVYs0bBVz18LYW;
        Mon, 15 May 2023 14:57:53 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 15:02:09 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <louhongxiang@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH 0/2] Fix kernel panic in scsi_queue_rq()
Date:   Mon, 15 May 2023 15:01:54 +0800
Message-ID: <20230515070156.1790181-1-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'cfee29ffb45b ("scsi: core: Do not increase scsi_device's iorequest_cnt
if dispatch failed")' introduce bug which would cause kernel panic.

So revert the changes and fix the origin issue by decreasing the
iorequest_cnt if scsi_dispatch_cmd return failed.

Wenchao Hao (2):
  Revert "scsi: core: Do not increase scsi_device's iorequest_cnt if
    dispatch failed"
  scsi: core: decrease scsi_device's iorequest_cnt if dispatch failed

 drivers/scsi/scsi_lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.32.0

