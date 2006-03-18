From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH] aic94xx: attaching to the sas transport class
Date: Fri, 17 Mar 2006 18:05:47 -0800
Message-ID: <1142647547.7462.39.camel@localhost.localdomain>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
	 <1142646304.7462.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:55489 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S932843AbWCRCFy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 21:05:54 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2I25shi015091
	for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2006 21:05:54 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2I22xAg257802
	for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2006 19:02:59 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2I25rRe020376
	for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2006 19:05:54 -0700
In-Reply-To: <1142646304.7462.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Fri, 2006-03-17 at 17:45 -0800, Alexis Bruemmer wrote:
> On Thu, 2006-03-02 at 16:38 -0600, James Bottomley wrote:
> > This fairly minimal patch correctly attaches the aic94xx driver to the
> > SAS transport class (The driver is available from
> > 
> > www.kernel.org/git/jgarzik/sas-2.6
> > 
> > ).  Unfortunately, the driver itself still has the following critical
> > issues
> > 
> > 1. Discovery order is non-deterministic (it starts one thread per port,
> > so the threads race for discovery)
> > 
> > 2. The minimal attachment to the sas transport class doesn't do
> > expanders.  This needs to be fixed up by patching better expander
> > support into the class.  The way to do this is probably to pull the
> > domain_device into the sas transport class.
> > 
> > 3. The object lifetimes are all basically infinite (this will probably
> > fixed by 2)
> 
> Here is a proposed solution for 3.  I have tested this patch on an x366
> and it seems to have fixed the wired refcnt problem as well as fixing
> the problems encountered when trying to load and unload the module. Also
> with this fix I was able to remove and add hard drives at will without
> the usual I/O buffer errors.
> 
> Please let me know what you think.
> 
> Regards,
> 
> Alexis
> 
> 
Sorry, the patch got truncated somehow on the first post-- must be
Friday :)


--Alexis


Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

diff -pNaur aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c	2006-03-14 08:51:51.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c	2006-03-17 17:09:43.000000000 -0800
@@ -586,9 +586,6 @@ static void sas_unregister_domain_device
 	struct domain_device *dev, *n;
 	struct sas_port *port = data;
 
-	sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
-			&port->disc.pending);
-
 	list_for_each_entry_reverse_safe(dev,n,&port->dev_list,dev_list_node)
 		sas_unregister_dev(dev);
 }
diff -pNaur aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_port.c aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_port.c
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_port.c	2006-03-12 14:40:39.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_port.c	2006-03-17 17:10:53.000000000 -0800
@@ -132,12 +132,6 @@ void sas_deform_port(struct asd_sas_phy 
 	if (port->port_dev)
 		port->port_dev->pathways--;
 
-	if (port->num_phys == 1) {
-		init_completion(&port->port_gone_completion);
-		sas_discover_event(port, DISCE_PORT_GONE);
-		wait_for_completion(&port->port_gone_completion);
-	}
-
 	if (sas_ha->lldd_port_deformed)
 		sas_ha->lldd_port_deformed(phy);
 
diff -pNaur aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_scsi_host.c aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_scsi_host.c	2006-03-12 14:40:39.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c	2006-03-17 16:48:10.000000000 -0800
@@ -693,6 +693,7 @@ out_err:
 
 void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha)
 {
+	sas_remove_host(sas_ha->core.shost);
 	scsi_remove_host(sas_ha->core.shost);
 	scsi_host_put(sas_ha->core.shost);
 	sas_ha->core.shost = NULL;
diff -pNaur aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h	2006-03-12 14:40:39.000000000 -0800
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h	2006-03-17 17:20:30.000000000 -0800
@@ -128,8 +128,6 @@ static inline int sas_notify_lldd_dev_fo
 	int res = 0;
 	struct sas_ha_struct *sas_ha = dev->port->ha;
 
-	if (!try_module_get(sas_ha->lldd_module))
-		return -ENOMEM;
 	if (sas_ha->lldd_dev_found) {
 		res = sas_ha->lldd_dev_found(dev);
 		if (res) {
@@ -146,7 +144,6 @@ static inline void sas_notify_lldd_dev_g
 {
 	if (dev->port->ha->lldd_dev_gone)
 		dev->port->ha->lldd_dev_gone(dev);
-	module_put(dev->port->ha->lldd_module);
 }
 
 static inline void sas_init_dev(struct domain_device *dev)


> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

