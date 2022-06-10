Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214CDC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 16:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349710AbiFJQww (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 12:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345414AbiFJQws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 12:52:48 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE8FFD7;
        Fri, 10 Jun 2022 09:52:47 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LKRj635jfz67v9b;
        Sat, 11 Jun 2022 00:47:54 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 18:52:45 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 17:52:43 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.de>, <damien.lemoal@opensource.wdc.com>,
        <Ajish.Koshy@microchip.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 1/4] scsi: pm8001: Rework shost initial values
Date:   Sat, 11 Jun 2022 00:46:39 +0800
Message-ID: <1654879602-33497-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1654879602-33497-1-git-send-email-john.garry@huawei.com>
References: <1654879602-33497-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some values in pm8001_prep_sas_ha_init() are set the same as they would be
set in scsi_host_alloc(), or could be in the sht (which would be better),
or later just overwritten, so rework the following:
- cmd_per_lun can be set in the sht
- max_lun and max_channel are as scsi_host_alloc() (so no need to set)
- can_queue is later overwritten (so don't set in
  pm8001_prep_sas_ha_init())

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9b04f1a6a67d..4288c6b8f041 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -109,6 +109,7 @@ static struct scsi_host_template pm8001_sht = {
 #endif
 	.shost_groups		= pm8001_host_groups,
 	.track_queue_depth	= 1,
+	.cmd_per_lun		= 32,
 };
 
 /*
@@ -605,12 +606,8 @@ static int pm8001_prep_sas_ha_init(struct Scsi_Host *shost,
 
 	shost->transportt = pm8001_stt;
 	shost->max_id = PM8001_MAX_DEVICES;
-	shost->max_lun = 8;
-	shost->max_channel = 0;
 	shost->unique_id = pm8001_id;
 	shost->max_cmd_len = 16;
-	shost->can_queue = PM8001_CAN_QUEUE;
-	shost->cmd_per_lun = 32;
 	return 0;
 exit_free1:
 	kfree(arr_port);
-- 
2.26.2

