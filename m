Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E32AC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 08:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342D4206F0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 08:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgHaIMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 04:12:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53982 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgHaIMF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 04:12:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 11DD98221A663C5D8A38;
        Mon, 31 Aug 2020 16:12:02 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 31 Aug 2020
 16:11:54 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 1/4] scsi: fnic: remove set but not used 'old_vlan'
Date:   Mon, 31 Aug 2020 16:11:23 +0800
Message-ID: <20200831081126.3251288-2-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831081126.3251288-1-yanaijie@huawei.com>
References: <20200831081126.3251288-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/fnic/fnic_main.c: In function ‘fnic_set_vlan’:
drivers/scsi/fnic/fnic_main.c:555:6: warning: variable ‘old_vlan’ set
but not used [-Wunused-but-set-variable]
  555 |  u16 old_vlan;
      |      ^~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/fnic_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 7910b573bacb..8258348857e2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -552,8 +552,7 @@ static u8 *fnic_get_mac(struct fc_lport *lport)
 
 static void fnic_set_vlan(struct fnic *fnic, u16 vlan_id)
 {
-	u16 old_vlan;
-	old_vlan = vnic_dev_set_default_vlan(fnic->vdev, vlan_id);
+	vnic_dev_set_default_vlan(fnic->vdev, vlan_id);
 }
 
 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-- 
2.25.4

