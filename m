From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Mon, 06 Mar 2006 16:44:52 -0800
Message-ID: <1141692292.8649.75.camel@localhost.localdomain>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
	 <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
	 <20060306193555.GA2316@us.ibm.com>
	 <1141674628.3167.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:25068 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932541AbWCGApd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 19:45:33 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k270jWTi031249
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 19:45:32 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k270gqTY263562
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 17:42:52 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k270jWT0001175
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 17:45:32 -0700
In-Reply-To: <1141674628.3167.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

On Mon, 2006-03-06 at 13:50 -0600, James Bottomley wrote:
> On Mon, 2006-03-06 at 11:35 -0800, Mike Anderson wrote:
> > > 99% is good enough for me currently. 
> > 
> > Can you clarify this? Are you indicating that the 99% is only ok for debug
> > purposes or as a permanent solution. It would seem that if I want my system
> > to always boot that I would need to utilize an initramfs solution on top
> > of the driver solution.
> 
> It means I'll fix races in discovery, but the actual problem of the root
> device being discovered after port discovery completes because of some
> type of disk or cabling issue is beyond this type of fix.  

Well the problems I have seen when testing your tree, as well as the
original aic94xx/sas_class tree, is that the aic94xx driver enables phys
before the upper level sas layer has discover all phys and ports.
(again please see the boot dump I posted on Friday). 

> I also have
> to bet that expander configurations can get a bit random in who is
> discovered first, so likewise, the full fix for those will be udev
> updates.
> 
> > Alexis already created a patch that has some pieces in common with the
> > older adp driver to try and sync discovery, but we did not post as it was
> > failing on a x260 which has an expander configuration. Currently I believe
> > she is trying to port this to your patch series. Is this effort worth
> > continuing?
> 
> I can't say until I see the code.  However, if it's just fixing races,
> then yes.  If it's trying to make the driver reorder or wait for a
> preferred root disk, then probably not.

This patch does fix the problem with aic94xx enabling phys before the sas layer 
has discovered phys and ports, but it also causes the boot process to wait for 
device discovery.  And, sense I am not positive if this fix falls under the
category of "just fixing races" or "wait for a preferred root disk" I
thought I would post it and see what you think.

Thanks,

Alexis


Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
diff -uaNr BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_init.c BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_init.c	2006-03-06 11:37:01.000000000 -0800
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c	2006-03-06 12:55:19.000000000 -0800
@@ -218,6 +218,9 @@
 {
 	int err, i;
 
+	init_completion(&asd_ha->sas_ha.discover_phy);
+	asd_ha->sas_ha.discovering_device_flag=0;
+
 	err = pci_read_config_byte(asd_ha->pcidev, PCI_REVISION_ID,
 				   &asd_ha->revision_id);
 	if (err) {
@@ -631,6 +634,8 @@
 		asd_printk("coudln't enable phys, err:%d\n", err);
 		goto Err_en_phys;
 	}
+	wait_for_completion(&asd_ha->sas_ha.discover_phy);
+
 	ASD_DPRINTK("enabled phys\n");
 
 	return 0;
diff -uaNr BUILD-2.6.orig/drivers/scsi/sas/sas_discover.c BUILD-2.6/drivers/scsi/sas/sas_discover.c
--- BUILD-2.6.orig/drivers/scsi/sas/sas_discover.c	2006-03-06 11:37:01.000000000 -0800
+++ BUILD-2.6/drivers/scsi/sas/sas_discover.c	2006-03-06 13:07:20.000000000 -0800
@@ -648,8 +648,11 @@
 static void sas_discover_work_fn(void *_sas_port)
 {
 	struct sas_port *port = _sas_port;
+	struct sas_ha_struct *sas_ha = port->ha;
 	struct sas_discovery *disc = &port->disc;
 
+	sas_ha->discovering_device_flag=1;
+
 	spin_lock(&disc->disc_event_lock);
 	disc->disc_thread = 1;
 	while (!disc->disc_thread_quit && !list_empty(&disc->disc_event_list)){
@@ -678,6 +681,8 @@
 	disc->disc_thread = 0;
 	spin_unlock(&disc->disc_event_lock);
 	up(&disc->disc_sema);
+	mod_timer(&sas_ha->discover_timer, jiffies + 3*HZ);
+	sas_ha->discovering_device_flag=0;
 }
 
 int sas_discover_event(struct sas_port *port, enum discover_event ev)
diff -uaNr BUILD-2.6.orig/drivers/scsi/sas/sas_event.c BUILD-2.6/drivers/scsi/sas/sas_event.c
--- BUILD-2.6.orig/drivers/scsi/sas/sas_event.c	2006-03-06 11:37:01.000000000 -0800
+++ BUILD-2.6/drivers/scsi/sas/sas_event.c	2006-03-06 15:07:47.000000000 -0800
@@ -68,6 +68,20 @@
 #include "sas_dump.h"
 #include <scsi/sas/sas_discover.h>
 
+static void discover_timer_handler(struct sas_ha_struct *sas_ha)
+{
+	if (sas_ha->discover_timer_handler_flag==0 && \
+					sas_ha->discovering_device_flag==0) {
+		sas_ha->discover_timer_handler_flag = 1;
+		sas_ha->discovering_device_flag=1;
+		complete(&sas_ha->discover_phy);
+	}
+	else if (sas_ha->discover_timer_handler_flag==1)
+		printk("WARNING: Not all SAS Devices were discovered\n");
+	else
+		printk("Still waiting on a discovery\n");
+}
+
 static void sas_process_phy_event(struct asd_sas_phy *phy)
 {
 	unsigned long flags;
@@ -237,6 +251,13 @@
 	daemonize("sas_event_%d", sas_ha->core.shost->host_no);
 	current->flags |= PF_NOFREEZE;
 
+	sas_ha->discover_timer_handler_flag = 0;
+	init_timer(&sas_ha->discover_timer);
+	sas_ha->discover_timer.data=(struct sas_ha_struct *)sas_ha;
+	sas_ha->discover_timer.function=discover_timer_handler;
+	sas_ha->discover_timer.expires=jiffies+2*HZ;
+	add_timer(&sas_ha->discover_timer);
+
 	complete(&event_th_comp);
 
 	while (1) {
@@ -247,6 +268,7 @@
 	}
 
 	complete(&event_th_comp);
+	complete(&sas_ha->discover_phy);
 
 	return 0;
 }
diff -uaNr BUILD-2.6.orig/include/scsi/sas/sas_class.h BUILD-2.6/include/scsi/sas/sas_class.h
--- BUILD-2.6.orig/include/scsi/sas/sas_class.h	2006-03-06 11:37:01.000000000 -0800
+++ BUILD-2.6/include/scsi/sas/sas_class.h	2006-03-06 12:57:36.000000000 -0800
@@ -231,6 +231,11 @@
 	struct pci_dev *pcidev;	  /* should be set */
 	struct module *lldd_module; /* should be set */
 
+	struct completion       discover_phy;
+	int                     discovering_device_flag;
+	struct timer_list       discover_timer;
+	int                     discover_timer_handler_flag;
+
 	u8 *sas_addr;		  /* must be set */
 	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
 


