Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB84C6FA8B
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Sep 2022 10:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIQKc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Sep 2022 06:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQKc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2022 06:32:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04763122B;
        Sat, 17 Sep 2022 03:32:23 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MV6Zl399qzMmwc;
        Sat, 17 Sep 2022 18:27:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 18:32:21 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/7] scsi: libsas: sas address comparation refactor
Date:   Sat, 17 Sep 2022 18:43:04 +0800
Message-ID: <20220917104311.1878250-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sas address conversion and comparation is widely used in libsas and
drivers. However they are all opencoded and to avoid the line spill over
80 columns, are mostly split into multi-lines.

To make the code easier to read, introduce some helpers with clearer
semantics and replace the opencoded segments with them.

Jason Yan (7):
  scsi: libsas: introduce sas address conversion and comparation helpers
  scsi: libsas: use dev_and_phy_addr_same() instead of open coded
  scsi: libsas: use ex_phy_addr_same() instead of open coded
  scsi: libsas: use port_and_phy_addr_same() instead of open coded
  scsi: hisi_sas: use dev_and_phy_addr_same() instead of open coded
  scsi: pm8001: use dev_and_phy_addr_same() instead of open coded
  scsi: mvsas: use dev_and_phy_addr_same() instead of open coded

 drivers/scsi/hisi_sas/hisi_sas_main.c |  3 +--
 drivers/scsi/libsas/sas_expander.c    | 24 +++++++-------------
 drivers/scsi/mvsas/mv_sas.c           |  3 +--
 drivers/scsi/pm8001/pm8001_sas.c      |  3 +--
 include/scsi/libsas.h                 | 32 +++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 22 deletions(-)

-- 
2.31.1

