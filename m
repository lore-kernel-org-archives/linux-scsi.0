Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F67C43466
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 23:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3C7208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 23:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600384736;
	bh=77Kxgapl7no1WFV+APUmjan4i/QFUqqtiSGZHbU3iiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cVtCC/HTSRgk7Y5Ff1bu0jWoJMkk+wgNoZbAvcgExBA0FGhau95gHN72PIbfiVuMw
	 qSpxTqWsGkKlaUacKysi4XvVwRNSBZWsfqCd5S3wd9J1W7Ak6nMyqIrwwV3fssWXgW
	 Lr7o7oCk4Z5TvXjcQ1hx2u3GNw0GgIuNstq1P/c4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIQXSx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 19:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgIQXSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 19:18:50 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD7F2085B;
        Thu, 17 Sep 2020 23:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600384729;
        bh=77Kxgapl7no1WFV+APUmjan4i/QFUqqtiSGZHbU3iiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgARRf/p6wEOxHhwhBCLO0XlmncVbS/ukJgatHNihHqKcoibRDz0GhonhhBNAnHPk
         +JYnn89vlJrTp+rImd9ua3+oCQVVnYsjMeIOLbErV+rNqwr4E5A/ZJ7hLx2WENUGGf
         GQalqNEQGbSDwM3l6RJ5vfxE/YtjRtruu6UGq9I4=
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: [PATCHv3 1/4] block: add zone specific block statuses
Date:   Thu, 17 Sep 2020 16:18:38 -0700
Message-Id: <20200917231841.4029747-2-kbusch@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200917231841.4029747-1-kbusch@kernel.org>
References: <20200917231841.4029747-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A zoned device with limited resources to open or activate zones may
return an error when the host exceeds those limits. The same command may
be successful if retried later, but the host needs to wait for specific
zone states before it should retry. Have the block layer provide an
appropriate status for these conditions so applications can distinuguish
this error for special handling.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/block/queue-sysfs.rst |  8 ++++++++
 block/blk-core.c                    |  4 ++++
 include/linux/blk_types.h           | 18 ++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index f261a5c84170..2638d3446b79 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -124,6 +124,10 @@ For zoned block devices (zoned attribute indicating "host-managed" or
 EXPLICIT OPEN, IMPLICIT OPEN or CLOSED, is limited by this value.
 If this value is 0, there is no limit.
 
+If the host attempts to exceed this limit, the driver should report this error
+with BLK_STS_ZONE_ACTIVE_RESOURCE, which user space may see as the EOVERFLOW
+errno.
+
 max_open_zones (RO)
 -------------------
 For zoned block devices (zoned attribute indicating "host-managed" or
@@ -131,6 +135,10 @@ For zoned block devices (zoned attribute indicating "host-managed" or
 EXPLICIT OPEN or IMPLICIT OPEN, is limited by this value.
 If this value is 0, there is no limit.
 
+If the host attempts to exceed this limit, the driver should report this error
+with BLK_STS_ZONE_OPEN_RESOURCE, which user space may see as the ETOOMANYREFS
+errno.
+
 max_sectors_kb (RW)
 -------------------
 This is the maximum number of kilobytes that the block layer will allow
diff --git a/block/blk-core.c b/block/blk-core.c
index 10c08ac50697..8bffc7732e37 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -186,6 +186,10 @@ static const struct {
 	/* device mapper special case, should not leak out: */
 	[BLK_STS_DM_REQUEUE]	= { -EREMCHG, "dm internal retry" },
 
+	/* zone device specific errors */
+	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
+	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4ecf4fed171f..8603fc5f86a3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -103,6 +103,24 @@ typedef u8 __bitwise blk_status_t;
  */
 #define BLK_STS_ZONE_RESOURCE	((__force blk_status_t)14)
 
+/*
+ * BLK_STS_ZONE_OPEN_RESOURCE is returned from the driver in the completion
+ * path if the device returns a status indicating that too many zone resources
+ * are currently open. The same command should be successful if resubmitted
+ * after the number of open zones decreases below the device's limits, which is
+ * reported in the request_queue's max_open_zones.
+ */
+#define BLK_STS_ZONE_OPEN_RESOURCE	((__force blk_status_t)15)
+
+/*
+ * BLK_STS_ZONE_ACTIVE_RESOURCE is returned from the driver in the completion
+ * path if the device returns a status indicating that too many zone resources
+ * are currently active. The same command should be successful if resubmitted
+ * after the number of active zones decreases below the device's limits, which
+ * is reported in the request_queue's max_active_zones.
+ */
+#define BLK_STS_ZONE_ACTIVE_RESOURCE	((__force blk_status_t)16)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.24.1

