Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3FEC388F2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 08:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42CE522248
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 08:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509412AbgJVIj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 04:39:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15763 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2509386AbgJVIj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 04:39:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D9271698A847086BC91;
        Thu, 22 Oct 2020 16:39:24 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 22 Oct 2020
 16:39:14 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v1 0/5] Introduce a new helper marco DEFINE_STORE_ATTRIBUTE at seq_file.c
Date:   Thu, 22 Oct 2020 16:39:52 +0800
Message-ID: <1603355997-32350-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
for read-only file, but we found many of drivers also want a helper marco for
read-write file too.

So we try to add this macro to help decrease code duplication.

Luo Jiaxing (5):
  seq_file: Introduce DEFINE_STORE_ATTRIBUTE() helper macro
  scsi: hisi_sas: Introduce DEFINE_STORE_ATTRIBUTE for debugfs
  scsi: qla2xxx: Introduce DEFINE_STORE_ATTRIBUTE for debugfs
  usb: dwc3: debugfs: Introduce DEFINE_STORE_ATTRIBUTE
  drm/i915/display: Introduce DEFINE_STORE_ATTRIBUTE for debugfs

 .../gpu/drm/i915/display/intel_display_debugfs.c   |  55 +--------
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 135 +++------------------
 drivers/scsi/qla2xxx/qla_dfs.c                     |  19 +--
 drivers/usb/dwc3/debugfs.c                         |  52 +-------
 include/linux/seq_file.h                           |  15 +++
 5 files changed, 41 insertions(+), 235 deletions(-)

-- 
2.7.4

