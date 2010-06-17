From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/17] mpt2sas: staged device discovery. disable_discovery module parameter is added.
Date: Thu, 17 Jun 2010 13:31:17 +0530
Message-ID: <20100617080107.GD28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:41896 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab0FQIgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:36:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Added command line option called disable_discovery.  When enabled
on the command line, the driver will not send a port_enable when loaded
for the first time.   If port_enable is not called, then there is
no discovery of devices, as well as the sas topology.  Then later if one
desires to invoke discovery, then they will need to issue a diagnostic reset.
A diagnostic reset can be issued various ways. One of the way is throught
sysfs.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 62ea5a6..d978c8a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -95,6 +95,10 @@ int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
     "and halt firmware - (default=0)");
 
+static int disable_discovery = -1;
+module_param(disable_discovery, int, 0);
+MODULE_PARM_DESC(disable_discovery, " disable discovery ");
+
 /**
  * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
  *
@@ -3520,6 +3524,9 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	if (sleep_flag == CAN_SLEEP)
 		_base_static_config_pages(ioc);
 
+	if (ioc->wait_for_port_enable_to_complete && disable_discovery > 0)
+		return r;
+
 	r = _base_send_port_enable(ioc, sleep_flag);
 	if (r)
 		return r;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
