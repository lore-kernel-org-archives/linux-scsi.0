From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptsas: use unnumbered port API and remove driver porttracking
Date: Thu, 6 Jul 2006 11:23:14 -0600
Message-ID: <20060706172314.GA10882@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40622 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030337AbWGFRfT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2006 13:35:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

James - This is what I have in mind. Pls reveiw.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-06-30 14:22:20.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-06 11:14:13.000000000 -0600
@@ -645,7 +645,6 @@ typedef struct _MPT_ADAPTER
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
-	u8		port_serial_number;
 } MPT_ADAPTER;
 
 /*
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-07-05 15:35:53.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-07-06 11:26:06.000000000 -0600
@@ -144,7 +144,6 @@ struct mptsas_devinfo {
  * Specific details on ports, wide/narrow
  */
 struct mptsas_portinfo_details{
-	u8	port_id; 	/* port number provided to transport */
 	u16	num_phys;	/* number of phys belong to this port */
 	u64	phy_bitmask; 	/* TODO, extend support for 255 phys */
 	struct sas_rphy *rphy;	/* transport layer rphy object */
@@ -350,10 +349,10 @@ mptsas_port_delete(struct mptsas_portinf
 	port_info = port_details->port_info;
 	phy_info = port_info->phy_info;
 
-	dsaswideprintk((KERN_DEBUG "%s: [%p]: port=%02d num_phys=%02d "
+	dsaswideprintk((KERN_DEBUG "%s: [%p]: num_phys=%02d "
 	    	"bitmask=0x%016llX\n",
-		__FUNCTION__, port_details, port_details->port_id,
-		port_details->num_phys, port_details->phy_bitmask));
+		__FUNCTION__, port_details, port_details->num_phys,
+		    port_details->phy_bitmask));
 
 	for (i = 0; i < port_info->num_phys; i++, phy_info++) {
 		if(phy_info->port_details != port_details)
@@ -462,9 +461,8 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		 * phy be removed by firmware events.
 		 */
 		dsaswideprintk((KERN_DEBUG
-			"%s: [%p]: port=%d deleting phy = %d\n",
-			__FUNCTION__, port_details,
-			port_details->port_id, i));
+			"%s: [%p]: deleting phy = %d\n",
+			__FUNCTION__, port_details, i));
 		port_details->num_phys--;
 		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
@@ -493,7 +491,6 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				goto out;
 			port_details->num_phys = 1;
 			port_details->port_info = port_info;
-			port_details->port_id = ioc->port_serial_number++;
 			if (phy_info->phy_id < 64 )
 				port_details->phy_bitmask |=
 				    (1 << phy_info->phy_id);
@@ -525,12 +522,8 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				    mptsas_get_port(phy_info_cmp);
 				port_details->starget =
 				    mptsas_get_starget(phy_info_cmp);
-				port_details->port_id =
-					phy_info_cmp->port_details->port_id;
 				port_details->num_phys =
 					phy_info_cmp->port_details->num_phys;
-//				port_info->port_serial_number--;
-				ioc->port_serial_number--;
 				if (!phy_info_cmp->port_details->num_phys)
 					kfree(phy_info_cmp->port_details);
 			} else
@@ -554,11 +547,11 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		if (!port_details)
 			continue;
 		dsaswideprintk((KERN_DEBUG
-			"%s: [%p]: phy_id=%02d port_id=%02d num_phys=%02d "
+			"%s: [%p]: phy_id=%02d num_phys=%02d "
 		    	"bitmask=0x%016llX\n",
 			__FUNCTION__,
-			port_details, i, port_details->port_id,
-			port_details->num_phys, port_details->phy_bitmask));
+			port_details, i, port_details->num_phys,
+			port_details->phy_bitmask));
 		dsaswideprintk((KERN_DEBUG"\t\tport = %p rphy=%p\n",
 			port_details->port, port_details->rphy));
 	}
@@ -1608,11 +1601,7 @@ static int mptsas_probe_one_phy(struct d
 	if (phy_info->sas_port_add_phy) {
 
 		if (!port) {
-			port = sas_port_alloc(dev,
-			    phy_info->port_details->port_id);
-			dsaswideprintk((KERN_DEBUG
-			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
-			    port, dev, phy_info->port_details->port_id));
+			port = sas_port_alloc(dev);
 			if (!port) {
 				error = -ENOMEM;
 				goto out;
@@ -1625,6 +1614,9 @@ static int mptsas_probe_one_phy(struct d
 				goto out;
 			}
 			mptsas_set_port(phy_info, port);
+			dsaswideprintk((KERN_DEBUG
+			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
+			    port, dev, port->port_identifier));
 		}
 		dsaswideprintk((KERN_DEBUG "sas_port_add_phy: phy_id=%d\n",
 		    phy_info->phy_id));
@@ -1939,7 +1931,8 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 					expander_sas_address)
 					continue;
 #ifdef MPT_DEBUG_SAS_WIDE
-				dev_printk(KERN_DEBUG, &port->dev, "delete\n");
+				dev_printk(KERN_DEBUG, &port->dev,
+				    "delete port (%d)\n", port->port_identifier);
 #endif
 				sas_port_delete(port);
 				mptsas_port_delete(phy_info->port_details);
@@ -2185,7 +2178,8 @@ mptsas_hotplug_work(void *arg)
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
 
 #ifdef MPT_DEBUG_SAS_WIDE
-		dev_printk(KERN_DEBUG, &port->dev, "delete\n");
+		dev_printk(KERN_DEBUG, &port->dev,
+		    "delete port (%d)\n", port->port_identifier);
 #endif
 		sas_port_delete(port);
 		mptsas_port_delete(phy_info->port_details);
