From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 1/4] zfcp: get rid of physical_wwpn and physical_s_id
Date: Sat, 11 Feb 2006 01:40:11 +0100
Message-ID: <20060211004011.GA17332@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:45807 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S932280AbWBKAkz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 19:40:55 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id k1B0esHm139146
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 00:40:54 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1B0etC3117462
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:40:55 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k1B0erB7017900
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 01:40:53 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Remove all remainders of obsolete zfcp adapter attributes physical_wwpn and
physical_s_id.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_def.h           |    2 --
 drivers/s390/scsi/zfcp_sysfs_adapter.c |    4 ----
 2 files changed, 0 insertions(+), 6 deletions(-)

15abdb9d073aa0288bd94b8f1a1c92957e254e3a
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index e260d19..7dac56c 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -915,8 +915,6 @@ struct zfcp_adapter {
 	wwn_t			peer_wwnn;	   /* P2P peer WWNN */
 	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
 	u32			peer_d_id;	   /* P2P peer D_ID */
-	wwn_t			physical_wwpn;     /* WWPN of physical port */
-	u32			physical_s_id;     /* local FC port ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u8			fc_service_class;
 	u32			hydra_version;	   /* Hydra version */
diff --git a/drivers/s390/scsi/zfcp_sysfs_adapter.c b/drivers/s390/scsi/zfcp_sysfs_adapter.c
index dfc0737..b29ac25 100644
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c
@@ -55,8 +55,6 @@ ZFCP_DEFINE_ADAPTER_ATTR(status, "0x%08x
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
-ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, "0x%016llx\n", adapter->physical_wwpn);
-ZFCP_DEFINE_ADAPTER_ATTR(physical_s_id, "0x%06x\n", adapter->physical_s_id);
 ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
 ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
 ZFCP_DEFINE_ADAPTER_ATTR(hardware_version, "0x%08x\n",
@@ -241,8 +239,6 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_peer_wwnn.attr,
 	&dev_attr_peer_wwpn.attr,
 	&dev_attr_peer_d_id.attr,
-	&dev_attr_physical_wwpn.attr,
-	&dev_attr_physical_s_id.attr,
 	&dev_attr_card_version.attr,
 	&dev_attr_lic_version.attr,
 	&dev_attr_status.attr,
-- 
0.99.9n-g5a22
