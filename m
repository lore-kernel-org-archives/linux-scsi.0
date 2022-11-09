Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E132EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 02:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKICnv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKICnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 21:43:50 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196E5FD14;
        Tue,  8 Nov 2022 18:43:49 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N6Thl1zc8zpWDb;
        Wed,  9 Nov 2022 10:40:07 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 10:43:47 +0800
Received: from build.huawei.com (10.175.101.6) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 10:43:47 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wenchao Hao <haowenchao@huawei.com>
Subject: [RFC PATCH 0/5] scsi:scsi_debug:Add error injection for single lun
Date:   Wed, 9 Nov 2022 10:59:45 -0500
Message-ID: <20221109155950.3536976-1-haowenchao@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The original error injection mechanism was based on scsi_host which
could not inject fault for a single SCSI device.

This patchset provides the ability to inject errors for a single
SCSI device. Now we supports inject timeout errors, queuecommand
errors, and hostbyte, driverbyte, statusbyte, and sense data for
specific SCSI Command

The first patch add an sysfs interface to add and inquiry single
device's error injection info; the second patch defined how to remove
an injection which has been added. The following 3 patches use the
injection info and generate the related error type.

Wenchao Hao (5):
  scsi:scsi_debug: Add sysfs interface to manager single devices' error inject
  scsi:scsi_debug: Add interface to remove injection which has been added
  scsi:scsi_debug: make command timeout if timeout error is injected
  scsi:scsi_debug: Return failed value for specific command's queuecommand
  scsi:scsi_debug: fail specific scsi command with result and sense data

 drivers/scsi/scsi_debug.c | 295 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 295 insertions(+)

-- 
2.35.3

