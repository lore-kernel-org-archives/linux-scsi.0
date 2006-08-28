From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: fix hotplug/unplug for expanderless systems
Date: Mon, 28 Aug 2006 15:22:51 -0700
Message-ID: <1156803771.7420.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:7910 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S964851AbWH1WWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 18:22:53 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7SMMrtZ025245
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 18:22:53 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7SMMrGw334348
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 16:22:53 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7SMMrx3021630
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 16:22:53 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7SMMqgL021612
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 16:22:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch fixes hotplug/unplug for expanderless systems by not queuing
an event just to do sas_unregister_domain_devices.

-Alexis



Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

---

diff -pNaur linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/libsas/sas_discover.c linux-2.6.18-rc5-aic94xx-new/drivers/scsi/libsas/sas_discover.c
--- linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/libsas/sas_discover.c	2006-08-28 14:29:30.000000000 -0700
+++ linux-2.6.18-rc5-aic94xx-new/drivers/scsi/libsas/sas_discover.c	2006-08-28 14:18:19.000000000 -0700
@@ -625,20 +625,15 @@ void sas_unregister_dev(struct domain_de
 	sas_unregister_common_dev(dev);
 }
 
-static void sas_unregister_domain_devices(void *data)
+void sas_unregister_domain_devices(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
-	struct asd_sas_port *port = data;
-
-	sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
-			&port->disc.pending);
 
 	list_for_each_entry_safe_reverse(dev,n,&port->dev_list,dev_list_node)
 		sas_unregister_dev(dev);
 
 	port->port->rphy = NULL;
 
-	complete(&port->port_gone_completion);
 }
 
 /* ---------- Discovery and Revalidation ---------- */
@@ -745,7 +740,6 @@ void sas_init_disc(struct sas_discovery 
 	static void (*sas_event_fns[DISC_NUM_EVENTS])(void *) = {
 		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
 		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
-		[DISCE_PORT_GONE] = sas_unregister_domain_devices,
 	};
 
 	spin_lock_init(&disc->disc_event_lock);
@@ -753,11 +747,3 @@ void sas_init_disc(struct sas_discovery 
 	for (i = 0; i < DISC_NUM_EVENTS; i++)
 		INIT_WORK(&disc->disc_work[i], sas_event_fns[i], port);
 }
-
-void sas_unregister_devices(struct sas_ha_struct *sas_ha)
-{
-	int i;
-
-	for (i = 0; i < sas_ha->num_phys; i++)
-		sas_unregister_domain_devices(sas_ha->sas_port[i]);
-}
diff -pNaur linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/libsas/sas_port.c linux-2.6.18-rc5-aic94xx-new/drivers/scsi/libsas/sas_port.c
--- linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/libsas/sas_port.c	2006-08-28 14:29:30.000000000 -0700
+++ linux-2.6.18-rc5-aic94xx-new/drivers/scsi/libsas/sas_port.c	2006-08-28 14:32:50.000000000 -0700
@@ -145,9 +145,7 @@ void sas_deform_port(struct asd_sas_phy 
 		port->port_dev->pathways--;
 
 	if (port->num_phys == 1) {
-		init_completion(&port->port_gone_completion);
-		sas_discover_event(port, DISCE_PORT_GONE);
-		wait_for_completion(&port->port_gone_completion);
+		sas_unregister_domain_devices(port);
 		sas_port_delete(port->port);
 		port->port = NULL;
 	} else
diff -pNaur linux-2.6.18-rc5-aic94xx-orig/include/scsi/libsas.h linux-2.6.18-rc5-aic94xx-new/include/scsi/libsas.h
--- linux-2.6.18-rc5-aic94xx-orig/include/scsi/libsas.h	2006-08-28 14:29:30.000000000 -0700
+++ linux-2.6.18-rc5-aic94xx-new/include/scsi/libsas.h	2006-08-28 14:18:20.000000000 -0700
@@ -613,7 +613,7 @@ void sas_init_ex_attr(void);
 
 int  sas_ex_revalidate_domain(struct domain_device *);
 
-
+void sas_unregister_domain_devices(struct asd_sas_port *port);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
 int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 
@@ -622,8 +622,6 @@ int  sas_discover_end_dev(struct domain_
 
 void sas_unregister_dev(struct domain_device *);
 
-void sas_unregister_devices(struct sas_ha_struct *);
-
 void sas_init_dev(struct domain_device *);
 
 #endif /* _SASLIB_H_ */


