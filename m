From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/3] scsi_transport_sas: add function to get SAS endpoint
 address
Date: Wed, 09 Dec 2015 11:13:35 -0800
Message-ID: <1449688415.2226.34.camel@HansenPartnership.com>
References: <1449688206.2226.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55112 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbbLITNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 14:13:37 -0500
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id E70868EE0CC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:13:36 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YTqR5aohUnre for <linux-scsi@vger.kernel.org>;
	Wed,  9 Dec 2015 11:13:36 -0800 (PST)
Received: from [153.66.254.242] (unknown [184.11.141.41])
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 978238EE04D
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:13:36 -0800 (PST)
In-Reply-To: <1449688206.2226.30.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For a device known to be SAS connected, this will return the endpoint
address.  This is useful for getting the SAS address of SATA devices.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_transport_sas.c |   14 ++++++++++++++
 include/scsi/scsi_transport_sas.h |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index b17f763..80520e2 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -383,6 +383,20 @@ void sas_remove_host(struct Scsi_Host *shost)
 EXPORT_SYMBOL(sas_remove_host);
 
 /**
+ * sas_get_address - return the SAS address of the device
+ * @sdev: scsi device
+ *
+ * Returns the SAS address of the scsi device
+ */
+u64 sas_get_address(struct scsi_device *sdev)
+{
+	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
+
+	return rdev->rphy.identify.sas_address;
+}
+EXPORT_SYMBOL(sas_get_address);
+
+/**
  * sas_tlr_supported - checking TLR bit in vpd 0x90
  * @sdev: scsi device struct
  *
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index a8fdd10..13c0b2b 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -189,6 +189,7 @@ extern int sas_phy_add(struct sas_phy *);
 extern void sas_phy_delete(struct sas_phy *);
 extern int scsi_is_sas_phy(const struct device *);
 
+u64 sas_get_address(struct scsi_device *);
 unsigned int sas_tlr_supported(struct scsi_device *);
 unsigned int sas_is_tlr_enabled(struct scsi_device *);
 void sas_disable_tlr(struct scsi_device *);
-- 
1.7.4.1



