From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] mpt fusion: mptsas - do not use ioc->handle to locate hba
 portinfo structure
Date: Thu, 20 Mar 2008 17:32:05 -0500
Message-ID: <47E2E5E5.4070905@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:59592 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757029AbYCTWcI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 18:32:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, Jeremy Higdon <jeremy@sgi.com>

While performing hardware raid reset testing via the raid's client, I noticed that
sometimes, following the reset, that there would be more raid targets in
the lsscsi output than there actually were raid targets.  I tracked this down
to the following issue.

Fusion cannot always find the mptsas_portinfo structure for the hba because it
uses the handle stored in ioc->handle to locate it.  The problem is that the
firmware can change the handle associated with the hba when h/w raid is reset
(via the raid client).  When this happens, the driver will allocate another
mptsas_portinfo structure and link it into the chain of said structures.
This ultimately causes confusion within the driver resulting in targets not
being removed when they should be.

Eric Moore pointed out that the hba's portinfo structure is always the
first structure on the sas_topology list.  This patch modifies mptsas.c
to access the hba's portinfo structure by taking the first structure
on said list.

Applies to 2.6.25-rc6-git5

Signed-off-by: Michael Reed <mdr@sgi.com>


--- lu/drivers/message/fusion/mptbase.h	2008-03-20 17:01:34.000000000 -0500
+++ l/drivers/message/fusion/mptbase.h	2008-03-20 17:15:35.517242637 -0500
@@ -693,7 +693,6 @@ typedef struct _MPT_ADAPTER
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
 	u8			 sas_discovery_ignore_events;
-	u16			 handle;
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
 	struct work_struct	 sas_persist_task;
--- lu/drivers/message/fusion/mptsas.c	2008-03-20 17:01:34.000000000 -0500
+++ l/drivers/message/fusion/mptsas.c	2008-03-20 17:29:33.071753167 -0500
@@ -230,6 +230,20 @@ static inline MPT_ADAPTER *rphy_to_ioc(s
 	return ((MPT_SCSI_HOST *)shost->hostdata)->ioc;
 }
 
+static struct mptsas_portinfo *
+mptsas_get_hba_portinfo(MPT_ADAPTER *ioc)
+{
+        struct list_head	*head = &ioc->sas_topology;
+	struct mptsas_portinfo	*pi=NULL;
+
+	/* always the first entry on sas_topology list */
+ 
+	if (!list_empty(head))
+		pi = list_entry(head->next, struct mptsas_portinfo, list);
+
+	return pi;
+}
+
 /*
  * mptsas_find_portinfo_by_handle
  *
@@ -1290,7 +1304,7 @@ static int mptsas_smp_handler(struct Scs
 		struct mptsas_portinfo *port_info;
 
 		mutex_lock(&ioc->sas_topology_mutex);
-		port_info = mptsas_find_portinfo_by_handle(ioc, ioc->handle);
+		port_info = mptsas_get_hba_portinfo(ioc);
 		if (port_info && port_info->phy_info)
 			sas_address =
 				port_info->phy_info[0].phy->identify.sas_address;
@@ -2028,8 +2042,7 @@ static int mptsas_probe_one_phy(struct d
 			int i;
 
 			mutex_lock(&ioc->sas_topology_mutex);
-			port_info = mptsas_find_portinfo_by_handle(ioc,
-								   ioc->handle);
+			port_info = mptsas_get_hba_portinfo(ioc);
 			mutex_unlock(&ioc->sas_topology_mutex);
 
 			for (i = 0; i < port_info->num_phys; i++)
@@ -2099,8 +2112,7 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 
 	mptsas_sas_io_unit_pg1(ioc);
 	mutex_lock(&ioc->sas_topology_mutex);
-	ioc->handle = hba->phy_info[0].handle;
-	port_info = mptsas_find_portinfo_by_handle(ioc, ioc->handle);
+	port_info = mptsas_get_hba_portinfo(ioc);
 	if (!port_info) {
 		port_info = hba;
 		list_add_tail(&port_info->list, &ioc->sas_topology);
