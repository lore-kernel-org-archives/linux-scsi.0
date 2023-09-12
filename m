Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F93EE49A4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 23:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbjILXF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 19:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjILXF7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 19:05:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762CD10CC
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 16:05:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B8BC433C9;
        Tue, 12 Sep 2023 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694559955;
        bh=/++H2vOxecYZw1i9MdzAT9+O8EKVSE1ONbyr1tKy7zI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gO0+ZsRt8yxqhJypUL16uzeurzdPMGoLjWCRIcXTWJH7MgIjobIDyKHa3gxyjPNw+
         5vLOEBonIL8MoLB2MHyhh7DgUYrpY14mtD+idcsTAGrqo2LOO34bqeguy0Io7aL9s5
         VaKo9vcAfWVVd+H6oSS+L4MAcu37ro/SUx4hCoOsqcMaE9A54UdxlFQO4ifpwl2ydb
         n9uyeKjEyJB4Y5QLmUZ9FtI01HKrrcFVmoLZP/g9H0Mx9ipNuNa3nvp13+fe4onDtt
         toeGAnZXxh1gQCR0okrpTiH1+4QkkjWh4diuRQwSxhULwXgFSLMHTXTXnA7jCeB+oz
         K9lNoRGt31oCw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 1/3] scsi: libsas: Move local functions declarations to sas_internal.h
Date:   Wed, 13 Sep 2023 08:05:49 +0900
Message-ID: <20230912230551.454357-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912230551.454357-1-dlemoal@kernel.org>
References: <20230912230551.454357-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the declarations of functions used only within libsas from
include/scsi/libsas.h to drivers/scsi/libsas/sas_internal.h

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/libsas/sas_internal.h | 12 ++++++++++++
 include/scsi/libsas.h              | 14 --------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index a6dc7dc07fce..3804aef165ad 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -39,6 +39,18 @@ struct sas_phy_data {
 	struct sas_work enable_work;
 };
 
+void sas_hash_addr(u8 *hashed, const u8 *sas_addr);
+
+int sas_discover_root_expander(struct domain_device *dev);
+
+int sas_ex_revalidate_domain(struct domain_device *dev);
+void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
+void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port);
+void sas_discover_event(struct asd_sas_port *port, enum discover_event ev);
+
+void sas_init_dev(struct domain_device *dev);
+void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev);
+
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8a43534eea5c..2e800690b127 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -404,8 +404,6 @@ cmd_to_domain_dev(struct scsi_cmnd *cmd)
 	return sdev_to_domain_dev(cmd->device);
 }
 
-void sas_hash_addr(u8 *hashed, const u8 *sas_addr);
-
 /* Before calling a notify event, LLDD should use this function
  * when the link is severed (possibly from its tasklet).
  * The idea is that the Class only reads those, while the LLDD,
@@ -699,20 +697,8 @@ extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
 extern struct device_attribute dev_attr_phy_event_threshold;
 
-int  sas_discover_root_expander(struct domain_device *);
-
-int  sas_ex_revalidate_domain(struct domain_device *);
-
-void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
-void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
-void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
-
 int  sas_discover_end_dev(struct domain_device *);
 
-void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
-
-void sas_init_dev(struct domain_device *);
-
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
-- 
2.41.0

