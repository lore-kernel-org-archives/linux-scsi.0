From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH] scsi: Add helper functions to set target ID
Date: Thu, 20 Jul 2017 02:44:27 -0700
Message-ID: <150054386781.12890.7252889519285948439.stgit@rslab209.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0049.outbound.protection.outlook.com ([104.47.32.49]:48283
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932320AbdGSX1y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 19:27:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: Gana.Sridaran@microsemi.com, David.Carroll@mcirosemi.com

This patch adds 3 helper functions to set the initial target id, expander
id and port id numbers.

The ARC/HBA1000 product line  exposes RAID drives on bus number 0 and
sas transport HBA drives use bus 0 as well. We wanted to differentiate
between the RAID and HBA targets when the adapter in mixed mode (both RAID
and HBA are exposed). Since the number of RAID drives we support is
limited to 64 we wanted to block the first 64 targets and then add the
sas enabled HBA drives from target id 64.

Unfortunately the current sas transport implementation does not allow
changing of the next_target_id value (used by rphy to add drives), since
it is not exposed directly to the driver.

One way around this is to add helper functions to explicitly set the
next_target_id and others.

I still have to submit the sas transport aacraid support patches, but
I wanted to send this out to get comments and any other changes if
required.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 0 files changed

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 5006a656e16a..a6ef5520cb66 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -294,6 +294,31 @@ static void sas_bsg_remove(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	bsg_unregister_queue(q);
 }
 
+void sas_set_initial_target_id(struct Scsi_Host *shost, u32 target_id)
+{
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+
+	sas_host->next_target_id = target_id;
+}
+EXPORT_SYMBOL(sas_set_initial_target_id);
+
+void sas_set_initial_expander_id(struct Scsi_Host *shost, u32 expander_id)
+{
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+
+	sas_host->next_expander_id = expander_id;
+}
+EXPORT_SYMBOL(sas_set_initial_expander_id);
+
+void sas_set_initial_port_id(struct Scsi_Host *shost, u32 port_id)
+{
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+
+	sas_host->next_port_id = port_id;
+}
+EXPORT_SYMBOL(sas_set_initial_port_id);
+
+
 /*
  * SAS host attributes
  */
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 73d870918939..6917eee7bc24 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -179,6 +179,9 @@ struct sas_function_template {
 	int (*smp_handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 };
 
+void sas_set_initial_target_id(struct Scsi_Host *shost, u32 target_id);
+void sas_set_initial_expander_id(struct Scsi_Host *shost, u32 expander_id);
+void sas_set_initial_port_id(struct Scsi_Host *shost, u32 port_id);
 
 void sas_remove_children(struct device *);
 extern void sas_remove_host(struct Scsi_Host *);
