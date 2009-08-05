From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/7] mptsas : Change config request timeout value to 30 seconds.
Date: Wed, 5 Aug 2009 12:52:03 +0530
Message-ID: <20090805072151.GE14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:45326 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbZHEHnD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:43:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Change config request timeout value to 30 seconds.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 54fc73c..936e35a 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -72,6 +72,7 @@
  */
 #define MPTSAS_RAID_CHANNEL	1
 
+#define SAS_CONFIG_PAGE_TIMEOUT		30
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
@@ -661,7 +662,7 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 	cfg.pageAddr = starget->id;
 	cfg.cfghdr.hdr = &hdr;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	if (mpt_config(ioc, &cfg) != 0)
 		goto out;
@@ -1318,7 +1319,7 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 	cfg.pageAddr = form + form_specific;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
@@ -1926,7 +1927,7 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 	cfg.pageAddr = phy->identify.phy_identifier;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;    /* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
@@ -2278,7 +2279,7 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 	cfg.pageAddr = 0;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
@@ -2349,7 +2350,7 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 
 	cfg.cfghdr.ehdr = &hdr;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 	cfg.cfghdr.ehdr->PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
 	cfg.cfghdr.ehdr->ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_IO_UNIT;
 	cfg.cfghdr.ehdr->PageVersion = MPI_SASIOUNITPAGE1_PAGEVERSION;
@@ -2411,7 +2412,7 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 
 	cfg.cfghdr.ehdr = &hdr;
 	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	/* Get Phy Pg 0 for each Phy. */
 	cfg.physAddr = -1;
@@ -2479,7 +2480,7 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	cfg.physAddr = -1;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	memset(device_info, 0, sizeof(struct mptsas_devinfo));
 	error = mpt_config(ioc, &cfg);
@@ -2554,7 +2555,7 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 	cfg.pageAddr = form + form_specific;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	memset(port_info, 0, sizeof(struct mptsas_portinfo));
 	error = mpt_config(ioc, &cfg);
@@ -2635,7 +2636,7 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	cfg.pageAddr = form + form_specific;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
