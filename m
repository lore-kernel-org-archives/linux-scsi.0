Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C0DCA0ECF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 07:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbjILHr3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjILHr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 03:47:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F8E79
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 00:47:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74437C433C7;
        Tue, 12 Sep 2023 07:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694504842;
        bh=7K3Te840Hth/WiXD63jli4PIbfxwQNxsR4MNc1WnHmo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=T6hODUsMqEtkeFD4l9vJaARLpeY7QFGG0O6Fuu7/bahNTlCVyOjOLmjfTqHSg5EVs
         aQ3+c6wz5D3+2+q3+U0lL7OnlGAZhwJde0Ff+9zjo7uU2YlfSN0L+xOpNdsmDjAqTd
         KwNzlkoW7xNR+lH985qKqy1KeKPgErpEGxMJDlK6YYRZDSvp/adFOj3Tc5pAJy+ccq
         PLH7z11zOrLki2utcjCV47L1cBQjPpc9LgqHfYyR3zIaRN+exc+8H9U0fiNi/EjyS6
         tH9QzsmHQi1kqMwLamLPkHTrD1pLklclwU+zwJwltOeAszZ7dYR7rzoFI8Ge+bgUzt
         SKxjH81fyMyeg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/3] scsi: libsas: Declare sas_discover_end_dev() static
Date:   Tue, 12 Sep 2023 16:47:15 +0900
Message-ID: <20230912074715.424062-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912074715.424062-1-dlemoal@kernel.org>
References: <20230912074715.424062-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_discover_end_dev() is defined and used used only in sas_discover.c.
Define this function as static.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
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
index 5ee86b225359..4ce4809aec42 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -696,8 +696,6 @@ extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
 extern struct device_attribute dev_attr_phy_event_threshold;
 
-int  sas_discover_end_dev(struct domain_device *);
-
 void sas_init_dev(struct domain_device *);
 
 void sas_task_abort(struct sas_task *);
-- 
2.41.0

