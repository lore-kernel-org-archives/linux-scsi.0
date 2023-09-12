Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8FFCA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjILIxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjILIxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:53:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64622E79
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:53:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DD6C433C9;
        Tue, 12 Sep 2023 08:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694508823;
        bh=h9V/TxWvkCsPWm4aDXzjcBB9gkQayI8njTw8esu6BCk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nm1f4y1OZOKCQlge1/EOGyftBtt1HhSM+OJRClhw424c7iWCpOt9KOumsXmG7F8Ri
         zkh5c/muN4XyBwLIYk2HjGnVlJ3RGkyNALVFJJ15uDq67oTNwqSwBGzITyZV4u4/uL
         XgJL41U6Jy/6Xf5X+fEMPxbsZlkJdxIfNyeMJPMVSQgEi7Twav9LdbUx46SqeBDj6A
         X4HEKkuvgt/IOW2xN8iJ+h/52Eds5sxjUUYiVceSTxJbgT7CUZHFFQ1faxKKdqSgGm
         nXMEEwA1+TuXqRmpuM3qM/FMu8TJwTUA+SoJ4wbT5tPkk9yVgQYuvBhpvftAd6TE7r
         hbw0MB9VIqXSQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/3] scsi: libsas: Declare sas_discover_end_dev() static
Date:   Tue, 12 Sep 2023 17:53:38 +0900
Message-ID: <20230912085338.434381-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912085338.434381-1-dlemoal@kernel.org>
References: <20230912085338.434381-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_discover_end_dev() is defined and used used only in sas_discover.c.
Define this function as static.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
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

