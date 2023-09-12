Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C72CA0ECE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbjILIxq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjILIxp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:53:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCCEAA
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:53:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE7DC433C7;
        Tue, 12 Sep 2023 08:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694508821;
        bh=92GrbNhMeOm0FkBMLNfGmmN07iLUeG1Qt8qOEXDMo9U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IQqINhNYVqQUlrzUoWhOfJJWQR91vpdDOgzyab0+5nW+07jyP19cnWuzeuFipBJpA
         qV0aXI/XgEm3MNWiPAAEaUxzhzLknPynELmomJwAh2JSMGz2Be8Bfe2nYtU0sA7l45
         mArEdSRwBh9EF3CxVvTHz5ENpZAXo16ay2pv4Kh/ihYPfJJOUxgYkD1bBIjff3gpTA
         iwnXF0Xo047fEjf4PMilgScPP1FHzZ7NdcpoLljXfhry1v3KZmGXD21rWdkM4PCdaC
         DLxj4uuVhLnayWPhQd3e69zcTf/BFEKPlxGrlELgJ44ZqLfGeAdXJ9VC33Ke46FWeN
         yAJ0ggffxsBJw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/3] scsi: libsas: Move local functions declarations to sas_internal.h
Date:   Tue, 12 Sep 2023 17:53:36 +0900
Message-ID: <20230912085338.434381-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912085338.434381-1-dlemoal@kernel.org>
References: <20230912085338.434381-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the declarations of functions used only within libsas from
include/scsi/libsas.h to drivers/scsi/libsas/sas_internal.h

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_internal.h | 12 ++++++++++++
 include/scsi/libsas.h              | 14 --------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index a6dc7dc07fce..cfc921e2765c 100644
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
+void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
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

