Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAB1C27C76
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 09:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjA1JRu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 04:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjA1JRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 04:17:48 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649BB30D0;
        Sat, 28 Jan 2023 01:17:46 -0800 (PST)
Received: from kwepemm600002.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4P3pkT5GC9zfZ8f;
        Sat, 28 Jan 2023 17:17:37 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemm600002.china.huawei.com (7.193.23.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 28 Jan 2023 17:17:42 +0800
From:   Zhong Jinghua <zhongjinghua@huawei.com>
To:     <gregkh@linuxfoundation.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>, <bvanassche@acm.org>,
        <emilne@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <zhongjinghua@huawei.com>, <yi.zhang@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH-next v2 0/2] scsi, driver core: fix iscsi rescan fails to create block device
Date:   Sat, 28 Jan 2023 17:41:44 +0800
Message-ID: <20230128094146.205858-1-zhongjinghua@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600002.china.huawei.com (7.193.23.29)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1->v2: add a new patch that introduces get_device_unless_zero() method.

Hello, This patchset introduces get_device_unless_zero() method, Avoid
dev's reference count from 0 to 1, as this will cause bugs in some parts
of the kernel. 

We used this method when we fixed an issue with iSCSI delete order.
Zhong Jinghua (2):
  driver core: introduce get_device_unless_zero()
  scsi: fix iscsi rescan fails to create block device

 drivers/base/core.c       | 8 ++++++++
 drivers/scsi/scsi_sysfs.c | 4 +---
 include/linux/device.h    | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.31.1

