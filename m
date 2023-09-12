Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5869EEE3F39
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 23:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbjILXGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 19:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbjILXGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 19:06:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E0A10F4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 16:05:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A084C433CA;
        Tue, 12 Sep 2023 23:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694559957;
        bh=sm0gdVc1b17ynjL3gVmhqzM/RnQM3ORha2ZB0uH80Hs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Jez6CdA0L/ibIUYiSCi7nxZjP/Dsx/HOPh56LZGIOp5/POEmiDc7Q0WXuSwDtq3PM
         xJHJdepG+u+4HkMzfguxwimMUbk+KhIiVSZrRt7Om7oKm1ljikDepohVVPEN6cx5VJ
         6l4AehvacpVhleeo5eT/eF9CQG0+IJa9/acSnSXSODcre95+a6bGujQ6Z2nZhMp2Lq
         Iq/29WsWUjg/SU1HpcxusSis/YxG5MU/NOvmi5rd+38t5Qx00ka4xkeLLxG+BQs7OK
         BEJn4b3wYbxrC3NZFeMEUBye5kZlVTawkx39EI+wJI3qmlnFXjxr5YQ34WJ2R+Sk30
         nGsjiGL8gzePw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 3/3] scsi: libsas: Declare sas_discover_end_dev() static
Date:   Wed, 13 Sep 2023 08:05:51 +0900
Message-ID: <20230912230551.454357-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912230551.454357-1-dlemoal@kernel.org>
References: <20230912230551.454357-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_discover_end_dev() is defined and used only in sas_discover.c.
Define this function as static.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/libsas/sas_discover.c | 2 +-
 include/scsi/libsas.h              | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index ff7b63b10aeb..8fb7c41c0962 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -275,7 +275,7 @@ static void sas_resume_devices(struct work_struct *work)
  *
  * See comment in sas_discover_sata().
  */
-int sas_discover_end_dev(struct domain_device *dev)
+static int sas_discover_end_dev(struct domain_device *dev)
 {
 	return sas_notify_lldd_dev_found(dev);
 }
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index d3ace28ee41f..f5257103fdb6 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -696,8 +696,6 @@ extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
 extern struct device_attribute dev_attr_phy_event_threshold;
 
-int  sas_discover_end_dev(struct domain_device *);
-
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
-- 
2.41.0

