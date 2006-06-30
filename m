From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] mptsas: eliminate ghost devices
Date: Fri, 30 Jun 2006 12:54:02 -0500
Message-ID: <1151690042.8921.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56745 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932979AbWF3RyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 13:54:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

One of the current problems the mptsas driver has is that of "ghost"
devices (these are devices the firmware reports as existing, but what
they actually represent are the parents of a lower device), so for
example in my dual expander configuration, three expanders actually show
up, two for the real expanders but a third is created because the
firmware reports that the lower expander also has another expander
connected (which is simply the port going back to the upper expander).

The attached patch eliminates all these ghosts by not allocating any
devices for them if the SAS address is the SAS address of the parent.

James

Index: BUILD-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptsas.c
+++ BUILD-2.6/drivers/message/fusion/mptsas.c
@@ -1635,8 +1635,10 @@ static int mptsas_probe_one_phy(struct d
 	if (!mptsas_get_rphy(phy_info) && port && !port->rphy) {
 
 		struct sas_rphy *rphy;
+		struct device *parent;
 		struct sas_identify identify;
 
+		parent = dev->parent->parent;
 		/*
 		 * Let the hotplug_work thread handle processing
 		 * the adding/removing of devices that occur
@@ -1647,6 +1649,27 @@ static int mptsas_probe_one_phy(struct d
 				goto out;
 
 		mptsas_parse_device_info(&identify, &phy_info->attached);
+		if (scsi_is_host_device(parent)) {
+			struct mptsas_portinfo *port_info;
+			int i;
+
+			mutex_lock(&ioc->sas_topology_mutex);
+			port_info = mptsas_find_portinfo_by_handle(ioc,
+								   ioc->handle);
+			mutex_unlock(&ioc->sas_topology_mutex);
+
+			for (i = 0; i < port_info->num_phys; i++)
+				if (port_info->phy_info[i].identify.sas_address ==
+				    identify.sas_address)
+					goto out;
+
+		} else if (scsi_is_sas_rphy(parent)) {
+			struct sas_rphy *parent_rphy = dev_to_rphy(parent);
+			if (identify.sas_address ==
+			    parent_rphy->identify.sas_address)
+				goto out;
+		}
+
 		switch (identify.device_type) {
 		case SAS_END_DEVICE:
 			rphy = sas_end_device_alloc(port);
@@ -1698,6 +1721,7 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 		goto out_free_port_info;
 
 	mutex_lock(&ioc->sas_topology_mutex);
+	ioc->handle = hba->handle;
 	port_info = mptsas_find_portinfo_by_handle(ioc, hba->handle);
 	if (!port_info) {
 		port_info = hba;
Index: BUILD-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptbase.h
+++ BUILD-2.6/drivers/message/fusion/mptbase.h
@@ -632,6 +632,7 @@ typedef struct _MPT_ADAPTER
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
 	u8			 sas_discovery_ignore_events;
+	u16			 handle;
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
 	int			 num_ports;


