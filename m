Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2BDC32771
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiI0CTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiI0CTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:19:06 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F17A2AAB;
        Mon, 26 Sep 2022 19:19:05 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mc39P5BdZz1P6mn;
        Tue, 27 Sep 2022 10:14:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 10:19:03 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 0/8] scsi: libsas: sas address comparation refactor
Date:   Tue, 27 Sep 2022 10:29:33 +0800
Message-ID: <20220927022941.4029476-1-yanaijie@huawei.com>
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

v2->v3:
  Rename sas_phy_addr_same() to sas_phy_addr_match().
  Rearrange patches, move patch #6 to #1 and directly use the helper
  	sas_phy_match_dev_addr() in sas_find_attached_phy().
  Add some review tags from Jack Wang.

v1->v2:
  First factor out sas_find_attached_phy() and replace LLDDs's code
  	with it.
  Remove three too simple helpers.
  Rename the helpers with 'sas_' prefix.

Jason Yan (8):
  scsi: libsas: introduce sas address comparation helpers
  scsi: libsas: introduce sas_find_attached_phy() helper
  scsi: pm8001: use sas_find_attached_phy() instead of open coded
  scsi: mvsas: use sas_find_attached_phy() instead of open coded
  scsi: hisi_sas: use sas_find_attathed_phy() instead of open coded
  scsi: libsas: use sas_phy_match_dev_addr() instead of open coded
  scsi: libsas: use sas_phy_addr_match() instead of open coded
  scsi: libsas: use sas_phy_match_port_addr() instead of open coded

 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++------
 drivers/scsi/libsas/sas_expander.c    | 40 ++++++++++++++++-----------
 drivers/scsi/libsas/sas_internal.h    | 17 ++++++++++++
 drivers/scsi/mvsas/mv_sas.c           | 15 +++-------
 drivers/scsi/pm8001/pm8001_sas.c      | 16 ++++-------
 include/scsi/libsas.h                 |  2 ++
 6 files changed, 54 insertions(+), 48 deletions(-)

-- 
2.31.1

