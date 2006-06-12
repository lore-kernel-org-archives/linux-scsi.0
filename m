From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Mon, 12 Jun 2006 09:18:22 -0500
Message-ID: <1150121902.3413.11.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70141ECB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:46734 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752002AbWFLOS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 10:18:26 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70141ECB@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 17:25 -0600, Moore, Eric wrote:
> I didn't have time today to add your new API into the driver.
> Still trying to stabilize things.   I will send you my latest source
> in private email.  I'm leaving for vacation now.  Perhaps while I'm
> gone,
> can you can the new API support into my source?

Actually, since the patch was over 100k and I've been running around a
bit, I didn't really have time to look at it.  What I have managed to do
is to wedge the port object into the existing mptsas driver.  This means
that it will still compile and run, and there's now more time for you to
sort out wide ports.

What I did discover is that the actual firmware has no concept of a port
below the adapter, so I actually had to rejig mptsas_probe_one_phy() to
recognise ports.  I also noticed that on an expander device, we allocate
and end device for the port that's connected to the HBA.  I didn't do
anything about this, since that was the behaviour of the old driver
(even if incorrect), so I assume the wide port update will fix this.

James

---

[SCSI] mptsas: introduce the port object

This is a hack just sufficient to get mptsas compiling and running
with the new port objects.  Eric Moore is working on more
comprehensive support.

Index: BUILD-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptsas.c	2006-06-11 22:16:01.000000000 -0500
+++ BUILD-2.6/drivers/message/fusion/mptsas.c	2006-06-11 22:52:53.000000000 -0500
@@ -140,6 +140,7 @@
 struct mptsas_phyinfo {
 	u8	phy_id; 		/* phy index */
 	u8	port_id; 		/* port number this phy is part of */
+	s8	port_num;		/* index of port for port pointer */
 	u8	negotiated_link_rate;	/* nego'd link rate for this phy */
 	u8	hw_link_rate; 		/* hardware max/min phys link rate */
 	u8	programmed_link_rate;	/* programmed max/min phy link rate */
@@ -147,6 +148,8 @@
 	struct mptsas_devinfo attached;	/* point to attached device info */
 	struct sas_phy *phy;
 	struct sas_rphy *rphy;
+	/* FIXME: hack: make the phyinfo also usable as the port info */
+	struct sas_port *port;
 	struct scsi_target *starget;
 };
 
@@ -811,6 +814,7 @@
 		    buffer->PhyData[i].Port;
 		port_info->phy_info[i].negotiated_link_rate =
 		    buffer->PhyData[i].NegotiatedLinkRate;
+		port_info->phy_info[i].port_num = -1;
 	}
 
  out_free_consistent:
@@ -1161,7 +1165,8 @@
 {
 	MPT_ADAPTER *ioc;
 	struct sas_phy *phy;
-	int error;
+	struct sas_port *port;
+	int error, i, port_index;
 
 	if (!dev)
 		return -ENODEV;
@@ -1173,7 +1178,6 @@
 	} else
 		phy = phy_info->phy;
 
-	phy->port_identifier = phy_info->port_id;
 	mptsas_parse_device_info(&phy->identify, &phy_info->identify);
 
 	/*
@@ -1270,8 +1274,43 @@
 		phy_info->phy = phy;
 	}
 
+	if (phy_info->attached.handle) {
+		port_index = -1;
+		for (i = 0; i < index; i++) {
+			struct mptsas_phyinfo *tmp = &phy_info[i - index];
+			if (!tmp->attached.handle)
+				continue;
+			if (phy_info->attached.handle == tmp->attached.handle) {
+				port_index = tmp->port_num;
+				phy_info->port_num = port_index;
+				break;
+			}
+		}
+		if (port_index == -1) {
+			for (i = 0; ; i++) {
+				struct mptsas_phyinfo *tmp = &phy_info[i - index];
+				if (!tmp->port) {
+					port_index = i;
+					phy_info->port_num = i;
+					break;
+				}
+			}
+		}
+
+		port = phy_info[port_index - index].port;
+
+		if (!port) {
+			port = phy_info[port_index - index].port =
+				sas_port_alloc(dev, port_index);
+			if (!port)
+				return -ENOMEM;
+			sas_port_add(port);
+		}
+		sas_port_add_phy(port, phy);
+	}
+
 	if ((phy_info->attached.handle) &&
-	    (!phy_info->rphy)) {
+	    (!phy_info->rphy) && port && !port->rphy) {
 
 		struct sas_rphy *rphy;
 		struct sas_identify identify;
@@ -1290,11 +1329,11 @@
 		mptsas_parse_device_info(&identify, &phy_info->attached);
 		switch (identify.device_type) {
 		case SAS_END_DEVICE:
-			rphy = sas_end_device_alloc(phy);
+			rphy = sas_end_device_alloc(port);
 			break;
 		case SAS_EDGE_EXPANDER_DEVICE:
 		case SAS_FANOUT_EXPANDER_DEVICE:
-			rphy = sas_expander_alloc(phy, identify.device_type);
+			rphy = sas_expander_alloc(port, identify.device_type);
 			break;
 		default:
 			rphy = NULL;
@@ -1371,8 +1410,7 @@
 		}
 
 		mptsas_probe_one_phy(&ioc->sh->shost_gendev,
-		    &port_info->phy_info[i], ioc->sas_index, 1);
-		ioc->sas_index++;
+		    &port_info->phy_info[i], i, 1);
 	}
 
 	return 0;
@@ -1423,6 +1461,8 @@
 			(MPI_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM <<
 			 MPI_SAS_EXPAND_PGAD_FORM_SHIFT), (i << 16) + *handle);
 
+		port_info->phy_info[i].port_num = -1;
+
 		if (port_info->phy_info[i].identify.handle) {
 			mptsas_sas_device_pg0(ioc,
 				&port_info->phy_info[i].identify,
@@ -1453,15 +1493,15 @@
 		list_for_each_entry(p, &ioc->sas_topology, list) {
 			for (j = 0; j < p->num_phys; j++) {
 				if (port_info->phy_info[i].identify.handle ==
-						p->phy_info[j].attached.handle)
+						p->phy_info[j].attached.handle
+				    && p->phy_info[j].rphy)
 					parent = &p->phy_info[j].rphy->dev;
 			}
 		}
 		mutex_unlock(&ioc->sas_topology_mutex);
 
 		mptsas_probe_one_phy(parent, &port_info->phy_info[i],
-		    ioc->sas_index, 0);
-		ioc->sas_index++;
+		    i, 0);
 	}
 
 	return 0;
@@ -1692,6 +1732,7 @@
 	MPT_ADAPTER *ioc = ev->ioc;
 	struct mptsas_phyinfo *phy_info;
 	struct sas_rphy *rphy;
+	struct sas_port *port;
 	struct scsi_device *sdev;
 	struct sas_identify identify;
 	char *ds = NULL;
@@ -1728,6 +1769,8 @@
 			}
 		}
 
+		port = phy_info[phy_info->port_id - phy_info->phy_id].port;
+
 		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SSP_TARGET)
 			ds = "ssp";
 		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_STP_TARGET)
@@ -1740,6 +1783,7 @@
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
 
 		sas_rphy_delete(phy_info->rphy);
+		sas_port_delete(port);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
 		phy_info->rphy = NULL;
 		phy_info->starget = NULL;
@@ -1822,14 +1866,16 @@
 		       "attaching %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
 
+		port = phy_info[phy_info->port_id - phy_info->phy_id].port;
+
 		mptsas_parse_device_info(&identify, &phy_info->attached);
 		switch (identify.device_type) {
 		case SAS_END_DEVICE:
-			rphy = sas_end_device_alloc(phy_info->phy);
+			rphy = sas_end_device_alloc(port);
 			break;
 		case SAS_EDGE_EXPANDER_DEVICE:
 		case SAS_FANOUT_EXPANDER_DEVICE:
-			rphy = sas_expander_alloc(phy_info->phy, identify.device_type);
+			rphy = sas_expander_alloc(port, identify.device_type);
 			break;
 		default:
 			rphy = NULL;


