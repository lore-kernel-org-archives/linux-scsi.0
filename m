Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B4FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 00:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0589F20715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 00:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oyp9/0e5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgGFAEz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 20:04:55 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:4167 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgGFAEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 20:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593993893; x=1625529893;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8ca8N+sBvNmUzTtJm7NHSpczkms9zjoJd+ZcEWFtgY4=;
  b=oyp9/0e5xrNXfl5PVP4+SC1+vpxMMh3lhWJw601Jbr4Zw0tNH/1JjWHe
   P3M7meIfdKq9c8JmIKqW59r3UGi1OggHy06YaTdBwnCm6dejVfSAg1LEz
   2Ot0zijEHR8C7nQ3P/Hxdlix4G267DwY1pC5AGUOGz4ZFo9EZ44vg3bcX
   SjQWBu0+ZGzmZAPEMVJpTYrAHcOqfWQ1ZqgpOlr7+aCa714nkEF7NtW1x
   mNn5fQtA+lqvJb7lSgbd+uaOJPqbYYjtl1edzUYJl/ykZI/EYBcP/bqZB
   kM8vmonK7wXs1ut3dGVOFDgZ44sdK1/QzK2KRe3dLVjetQ405+OR4+/OS
   w==;
IronPort-SDR: TYPnZIppdVPINrjzt+0ymfBd/4uQT160WFm5Df/QQxchovWfSJ1HJkNomdGyQnVwfl8Gdgwnu5
 1WLN6JZ8xKJW/QjgYcmZL9xuxupz/gJqQwWcinMXW65VVV67sN8urcULVnQSr9mkjovif7Akxq
 Goi2tMdKVU+ckPB7VUrG+ysYHKDZkU7XxjPex13z+9jHD35TK+723j1QJOi/U/rbcJ/ZdnVZs5
 SLEr2D9MdXVFStnxQVFWFtKPXQqLZoilaj45JrFxbM9w3AuCfS/WzTXyjPNq1TDx24vAoOjO1z
 /jA=
X-IronPort-AV: E=Sophos;i="5.75,317,1589212800"; 
   d="scan'208";a="250930113"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 08:04:53 +0800
IronPort-SDR: aVjMc8TjR5L1u1/QmYY+ljdP4vlLVRxMH6rAACCi2Hx9GTOEtYviYA23tS4kBVRQEx94833Vl0
 FVgPFZkNo6/Bd93OciBfmIvFO64xmmRBI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2020 16:53:35 -0700
IronPort-SDR: RazDHyldRPqhu7JeKJkt905GVocvsnswDDlNGzypggvgeSkSUYMpLmLRaswCBmkYPrcnm8ypPc
 GkXVQKsJkU7A==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Jul 2020 17:04:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: mpt3sas: Fix compilation warning
Date:   Mon,  6 Jul 2020 09:04:50 +0900
Message-Id: <20200706000450.358443-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit c7e4dd5d84fc ("scsi: mpt3sas: Fix error returns in
BRM_status_show") introduced a compilation warning:

>> drivers/scsi/mpt3sas/mpt3sas_ctl.c:3188:5: warning: Variable 'rc' is
reassigned a value before the old one has been used.
[redundantAssignment]
    rc = snprintf(buf, PAGE_SIZE, "%dn", (backup_rail_monitor_status & 1));
       ^
   drivers/scsi/mpt3sas/mpt3sas_ctl.c:3165:5: note: Variable 'rc' is
   reassigned a value before the old one has been used.
    rc = -EINVAL;
       ^
   drivers/scsi/mpt3sas/mpt3sas_ctl.c:3188:5: note: Variable 'rc' is
   reassigned a value before the old one has been used.
    rc = snprintf(buf, PAGE_SIZE, "%dn", (backup_rail_monitor_status & 1));
       ^

Remove this warning by moving -EINVAL rc assignement inside the error
condition paths.

Fixes: c7e4dd5d84fc ("scsi: mpt3sas: Fix error returns in BRM_status_show")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 70aedd15223c..983e568ff231 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3162,11 +3162,11 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 		goto out;
 	}
 
-	rc = -EINVAL;
 	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
 	    0) {
 		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
 			__func__);
+		rc = -EINVAL;
 		goto out;
 	}
 
@@ -3174,12 +3174,14 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 		ioc_err(ioc, "%s: iounit_pg3 failed with ioc_status(0x%04x)\n",
 			__func__, ioc_status);
+		rc = -EINVAL;
 		goto out;
 	}
 
 	if (io_unit_pg3->GPIOCount < 25) {
 		ioc_err(ioc, "%s: iounit_pg3->GPIOCount less than 25 entries, detected (%d) entries\n",
 			__func__, io_unit_pg3->GPIOCount);
+		rc = -EINVAL;
 		goto out;
 	}
 
-- 
2.26.2

