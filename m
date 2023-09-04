Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79C6C83F33
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Sep 2023 08:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352608AbjIDI46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Sep 2023 04:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbjIDI45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2023 04:56:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0020512E;
        Mon,  4 Sep 2023 01:56:53 -0700 (PDT)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RfMsQ25bLzrSRf;
        Mon,  4 Sep 2023 16:55:06 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 4 Sep 2023 16:56:51 +0800
From:   Xingui Yang <yangxingui@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.g.garry@oracle.com>, <damien.lemoal@opensource.wdc.com>
CC:     <andriy.shevchenko@linux.intel.com>, <akpm@linux-foundation.org>,
        <viro@zeniv.linux.org.uk>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <yangxingui@huawei.com>,
        <prime.zeng@hisilicon.com>, <kangfenglong@huawei.com>,
        <chenxiang66@hisilicon.com>
Subject: [PATCH v5 0/3] Add helper macro DEFINE_SHOW_STORE_ATTRIBUTE at seq_file.c
Date:   Mon, 4 Sep 2023 08:48:01 +0000
Message-ID: <20230904084804.39564-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.50.163.32]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
for read-only file, but we found many of drivers also want a helper macro
for read-write file too.

So we add this helper macro to reduce duplicate code.

Changes from v4:
- Reduce the scope to scsi subsystem based on Andy's suggestion.
- Remove unused macros in qla_dfs.c
- Adjust some descriptions in commit.

Changes from v3:
- Add AI Viro's comment to v1->v2's revision description.
- Fixed a spelling mistakes of "marco" to "macro".

Changes from v2:
- Fixed some spelling mistakes in commit.
- Revision description are added for easy tracing.

Changes from v1:
- Rename DEFINE_STORE_ATTRIBUTE() to DEFINE_SHOW_STORE_ATTRIBUTE().
- AI Viro points out that he doesn't like the definition of macros
  like DEFINE_SHOW_ATTRIBUTE.


Luo Jiaxing (3):
  seq_file: Add helper macro to define attribute for rw file
  scsi: hisi_sas: Use DEFINE_SHOW_STORE_ATTRIBUTE helper for debugfs
  scsi: qla2xxx: Use DEFINE_SHOW_STORE_ATTRIBUTE helper for debugfs

 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 137 ++-----------------------
 drivers/scsi/qla2xxx/qla_dfs.c         | 113 +-------------------
 include/linux/seq_file.h               |  15 +++
 3 files changed, 26 insertions(+), 239 deletions(-)

-- 
2.17.1

