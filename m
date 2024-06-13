Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A28614D;
	Thu, 13 Jun 2024 12:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281624; cv=none; b=lqKzcnstgPCFossL0tirT042CGxsZfQe7XDYZAOl2Dc1L1SnYECwfyvCHWduY3USRaHJCzaYds5t8N+dLgMOOz9iE+CRArva+im41C/qUafi5v9WdqBKfyS94Xb9dDtBVrjZnFzde0g/M4iNX41kpdndKgzt8pySk7N23dDumUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281624; c=relaxed/simple;
	bh=k40logFNctHXCPnugxk1gzt+GlipdYDeIqsYCbDatnc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r9GrisOvk0hNi78h0Aa4wT2R1+hzyWFlWBm0JucFV48CmEU7aEryvGB88xds0kuh0mPi90nPsW4Vk/hw8jlhqD5/fSC9R8hidcB6ZeMZHeN2WS5fUM28PN4Ea56T/aP7VF69INLM2lLLJeaW8dFNtSmuANO3mNBHaDfcsLDTqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4W0M5G71WxzPrN9;
	Thu, 13 Jun 2024 20:23:30 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C12314011F;
	Thu, 13 Jun 2024 20:26:57 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 13 Jun 2024 20:26:56 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
Subject: [PATCH v3] scsi: libsas: Fix exp-attached end device cannot be scanned in again after probe failed
Date: Thu, 13 Jun 2024 12:23:55 +0000
Message-ID: <20240613122355.7797-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemd100001.china.huawei.com (7.185.36.94)

We found that it is judged as broadcast flutter when the exp-attached end
device reconnects after probe failed, as follows:

[78779.654026] sas: broadcast received: 0
[78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
[78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
[78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
[78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
[78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
[78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
[78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
[78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
...
[78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
[78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
[78835.187487] sas: broadcast received: 0
[78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
[78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
[78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
[78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
[78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
[78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
[78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0

The cause of the problem is that the related ex_phy's attached_sas_addr was
not cleared after the end device probe failed. In order to solve the above
problem, a function sas_ex_unregister_end_dev() is defined to clear the
ex_phy information and unregister the end device after the exp-attached end
device probe failed.

As devices may probe failed after done REVALIDATING DOMAIN when call
sas_probe_devices(). Then after its port is added to the sas_port_del_list,
the port will not be deleted until the end of the next REVALIDATING DOMAIN
and sas_destruct_ports() is called. A warning about creating a duplicate
port will occur in the new REVALIDATING DOMAIN when the end device
reconnects. Therefore, the previous destroy_list and sas_port_del_list
should be handled after devices probe failed.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
Changes since v2:
- Add a helper for calling sas_destruct_devices() and sas_destruct_ports(),
  and put the new call at the end of sas_probe_devices() based on John's
  suggestion.

Changes since v1:
- Simplify the process of getting ex_phy id based on Jason's suggestion.
- Update commit information.
---
 drivers/scsi/libsas/sas_discover.c | 32 +++++++++++++++++++-----------
 drivers/scsi/libsas/sas_expander.c |  8 ++++++++
 drivers/scsi/libsas/sas_internal.h |  6 +++++-
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 8fb7c41c0962..8c517e47d2b9 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -17,6 +17,22 @@
 #include <scsi/sas_ata.h>
 #include "scsi_sas_internal.h"
 
+static void sas_destruct_ports(struct asd_sas_port *port)
+{
+	struct sas_port *sas_port, *p;
+
+	list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, del_list) {
+		list_del_init(&sas_port->del_list);
+		sas_port_delete(sas_port);
+	}
+}
+
+static void sas_destruct_devices_and_ports(struct asd_sas_port *port)
+{
+	sas_destruct_devices(port);
+	sas_destruct_ports(port);
+}
+
 /* ---------- Basic task processing for discovery purposes ---------- */
 
 void sas_init_dev(struct domain_device *dev)
@@ -226,6 +242,9 @@ static void sas_probe_devices(struct asd_sas_port *port)
 		else
 			list_del_init(&dev->disco_list_node);
 	}
+
+	/* destruct devices and ports after probe failed */
+	sas_destruct_devices_and_ports(port);
 }
 
 static void sas_suspend_devices(struct work_struct *work)
@@ -350,16 +369,6 @@ void sas_destruct_devices(struct asd_sas_port *port)
 	}
 }
 
-static void sas_destruct_ports(struct asd_sas_port *port)
-{
-	struct sas_port *sas_port, *p;
-
-	list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, del_list) {
-		list_del_init(&sas_port->del_list);
-		sas_port_delete(sas_port);
-	}
-}
-
 static bool sas_abort_cmd(struct request *req, void *data)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
@@ -538,8 +547,7 @@ static void sas_revalidate_domain(struct work_struct *work)
  out:
 	mutex_unlock(&ha->disco_mutex);
 
-	sas_destruct_devices(port);
-	sas_destruct_ports(port);
+	sas_destruct_devices_and_ports(port);
 	sas_probe_devices(port);
 }
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4e6bb3d0f163..09be69ea09a2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1878,6 +1878,14 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 	}
 }
 
+void sas_ex_unregister_end_dev(struct domain_device *dev)
+{
+	struct domain_device *parent = dev->parent;
+	struct sas_phy *phy = dev->phy;
+
+	sas_unregister_devs_sas_addr(parent, phy->number, true);
+}
+
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
 					  const int level)
 {
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 85948963fb97..caeda847c919 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -50,6 +50,7 @@ void sas_discover_event(struct asd_sas_port *port, enum discover_event ev);
 
 void sas_init_dev(struct domain_device *dev);
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev);
+void sas_ex_unregister_end_dev(struct domain_device *dev);
 
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
@@ -145,7 +146,10 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
-	sas_unregister_dev(dev->port, dev);
+	if (dev->parent && !dev_is_expander(dev->dev_type))
+		sas_ex_unregister_end_dev(dev);
+	else
+		sas_unregister_dev(dev->port, dev);
 }
 
 static inline void sas_fill_in_rphy(struct domain_device *dev,
-- 
2.17.1

