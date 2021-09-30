Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA52C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 11:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5965F61425
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 11:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350681AbhI3L6j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 07:58:39 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3899 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350657AbhI3L6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 07:58:39 -0400
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HKs8S1QYmz67wpp;
        Thu, 30 Sep 2021 19:53:44 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 13:56:55 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 12:56:52 +0100
From:   John Garry <john.garry@huawei.com>
To:     <linux@armlinux.org.uk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <hare@suse.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: acornscsi: Remove scsi_cmd_to_tag() reference
Date:   Thu, 30 Sep 2021 19:51:57 +0800
Message-ID: <1633002717-79765-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 756fb6a895afb ("scsi: acornscsi: Remove tagged queuing vestiges")
mistakenly introduced a reference to function scsi_cmd_to_tag(). This
function does not exist as it was removed from an earlier series version
when I upstreamed the named commit - originally authored By Hannes - but
this reference still remained.

Fix by replacing the reference to scsi_cmd_to_tag() with
scsi_cmd_to_rq(scsi_scmd)->tag, which scsi_cmd_to_tag() was a wrapper for.

Fixes: 756fb6a895afb ("scsi: acornscsi: Remove tagged queuing vestiges")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index b4cb5fb19998..0cc62c1b0825 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1776,7 +1776,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
 	host->scsi.disconnectable = 0;
 	if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
 	    host->SCpnt->device->lun == host->scsi.reconnected.lun &&
-	    scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
+	    scsi_cmd_to_rq(host->SCpnt)->tag == host->scsi.reconnected.tag) {
 #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
 	    DBG(host->SCpnt, printk("scsi%d.%c: reconnected",
 		    host->host->host_no, acornscsi_target(host)));
-- 
2.26.2

