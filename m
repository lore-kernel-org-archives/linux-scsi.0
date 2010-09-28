From: "Thomson, Patrick S" <patrick.s.thomson@intel.com>
Subject: RE: [RFC] libsas: modifying libsas port creation
Date: Tue, 28 Sep 2010 11:36:48 -0700
Message-ID: <86810401A1B22346A09CBA649BE561E9013408BE8B@azsmsx505.amr.corp.intel.com>
References: <86810401A1B22346A09CBA649BE561E90133F6445B@azsmsx505.amr.corp.intel.com>,<AANLkTinnh4=7sT+Jhx7px-mK37CZ17J-_bYEsSyKOoKC@mail.gmail.com>
 <SNT126-W423EB4A9F109822A4B728CCE660@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4598 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab0I1ShG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 14:37:06 -0400
In-Reply-To: <SNT126-W423EB4A9F109822A4B728CCE660@phx.gbl>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Marushak, Nathan" <nathan.marushak@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Jeppsen, Roger C" <roger.c.jeppsen@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>

Alrighty...

Based on Dan's feedback and some from Nate, here's another go
at the changes. I removed the spinlock and renamed the elements in
enum cfg. The default behavior remains the same however. I'm
still leery on changing existing behavior, unless of course people
think it's a good idea

thanks!
Pat

diff -Nau old/include/scsi/libsas.h new/include/scsi/libsas.h
--- old/include/scsi/libsas.h	2010-09-27 14:23:14.142380393 -0700
+++ new/include/scsi/libsas.h	2010-09-28 11:07:55.517702325 -0700
@@ -89,6 +89,11 @@
 	DISC_NUM_EVENTS 	= 3,
 };
 
+enum cfg_state {
+	CFGE_USE_LOCAL_AND_ATTACHED_SAS = 0U, 
+	CFGE_USE_ONLY_ATTACHED_SAS = 1,  
+};
+
 /* ---------- Expander Devices ---------- */
 
 #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
@@ -344,6 +349,8 @@
 
 	struct scsi_core core;
 
+	unsigned int      use_host_phy_addr; /* defaults to 0 */
+
 /* public: */
 	char *sas_ha_name;
 	struct device *dev;	  /* should be set */
@@ -366,6 +373,9 @@
 	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
 
+	/* LLDD calls to this notifies libsas of a characteristic change */
+	void (*notify_libsas_config)(struct sas_ha_struct *, enum cfg_state);
+
 	void *lldd_ha;		  /* not touched by sas class code */
 
 	struct list_head eh_done_q;
diff -Nau old/drivers/scsi/libsas/sas_port.c new/drivers/scsi/libsas/sas_port.c
--- old/drivers/scsi/libsas/sas_port.c	2010-09-27 15:28:37.465380355 -0700
+++ new/drivers/scsi/libsas/sas_port.c	2010-09-28 10:59:10.695757861 -0700
@@ -43,10 +43,13 @@
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
 	unsigned long flags;
+	unsigned int use_phy_addr = sas_ha->use_host_phy_addr;
 
 	if (port) {
-		if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
-			   SAS_ADDR_SIZE) != 0)
+		if ((memcmp(port->attached_sas_addr, phy->attached_sas_addr,
+			   SAS_ADDR_SIZE) != 0) ||
+		    ((use_phy_addr) && (memcmp(port->sas_addr, phy->sas_addr, 
+						  SAS_ADDR_SIZE) != 0)))
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
@@ -64,6 +67,8 @@
 		if (*(u64 *) port->sas_addr &&
 		    memcmp(port->attached_sas_addr,
 			   phy->attached_sas_addr, SAS_ADDR_SIZE) == 0 &&
+                    (!(use_phy_addr) || (memcmp(port->sas_addr, phy->sas_addr, 
+						SAS_ADDR_SIZE) == 0)) &&
 		    port->num_phys > 0) {
 			/* wide port */
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
diff -Nau old/drivers/scsi/libsas/sas_init.c new/drivers/scsi/libsas/sas_init.c
--- old/drivers/scsi/libsas/sas_init.c	2010-09-27 15:31:43.158567989 -0700
+++ new/drivers/scsi/libsas/sas_init.c	2010-09-28 11:08:48.224004758 -0700
@@ -39,6 +39,8 @@
 
 struct kmem_cache *sas_task_cache;
 
+void notify_libsas_config(struct sas_ha_struct *ha_struct, enum cfg_state cfg);
+
 /*------------ SAS addr hash -----------*/
 void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
 {
@@ -120,6 +122,12 @@
 
 	INIT_LIST_HEAD(&sas_ha->eh_done_q);
 
+	/* setup behavior mod interface */
+	sas_ha->notify_libsas_config = notify_libsas_config;
+
+	/* when creating ports, don't take host phy addr into account */
+	sas_ha->use_host_phy_addr = 0;
+
 	return 0;
 
 Undo_ports:
@@ -255,6 +263,20 @@
 	return ret;
 }
 
+void notify_libsas_config(struct sas_ha_struct *sas_ha, enum cfg_state cfg)
+{
+	unsigned long flags;
+
+	switch (cfg) {
+	case CFGE_USE_LOCAL_AND_ATTACHED_SAS:
+		sas_ha->use_host_phy_addr = 1;
+		break;
+	case CFGE_USE_ONLY_ATTACHED_SAS:
+		sas_ha->use_host_phy_addr = 0;
+		break;
+	}
+}
+
 static struct sas_function_template sft = {
 	.phy_enable = sas_phy_enable,
 	.phy_reset = sas_phy_reset,

> -----Original Message-----
> From: Sean Thomson [mailto:psthomso@hotmail.com] 
> Sent: Monday, September 27, 2010 5:47 PM
> To: Williams, Dan J; Thomson, Patrick S
> Cc: linux-scsi@vger.kernel.org; Ciechanowski, Ed; Marushak, Nathan; 
> Skirvin, Jeffrey D; Jeppsen, Roger C
> Subject: RE: [RFC] libsas: modifying libsas port creation
>
>
> > > I'm working on a SAS driver for Intel's Patsburg chipset and ran across 
> > > a problem (for me) when libsas creates a port. Specifically, it appears that
> > > libsas will use only use the attached sas address when creating a port, 
> > > instead of the sas address on each side of the link. What I'd like to 
> > > propose is to modify port creation such that, based on a flag stored 
> > > in struct sas_ha_struct, that the SAS address on the initiator side can 
> > > be taken into account. If the flag is not set, then the original behavior
> > > is in force.
> > >
> > > The main point is that the original behavior is the default, and if 
> > > anyone wants to use  the modified port creation, they call 
> > > sas_ha_struct.notify_libsas_config() right after  sas_ha_register during 
> > > module init.
> > >
> > 
> > Shouldn't this just be the default without a configuration option?
> > For cases where port->sas_addr != phy->sas_addr I assume you would
> > always want this new behavior regardless of the flag??
> > 

> Ideally, yes, because a port should take into account the sas address on each side 
> of the link, but, thats not how its been working. I'm expecting that somewhere, 
> someone knows the behavoir and coded around it (or took advantage of it). There 
> is an advantage to the current default, on a single level expander, you don't see 
> multipath if the port configurations on each side don't match. 
>
> Honestly, I haven't gone back to find out if the way it is, is intentional or a 
> misunderstanding.
>
> > > Thanks!
> > > Pat Thomson
> > >
> > > diff -Nau old/include/scsi/libsas.h new/include/scsi/libsas.h
> > > --- old/include/scsi/libsas.h 2010-09-27 14:23:14.142380393 -0700
> > > +++ new/include/scsi/libsas.h 2010-09-27 15:26:38.040818779 -0700
> > > @@ -89,6 +89,11 @@
> > > DISC_NUM_EVENTS = 3,
> > > };
> > >
> > > +enum cfg_state {
> > > + CFGE_USE_HOST_TARGET_SAS = 0U, /* struct sas_ha_struct.use_host_phy_addr */
> > > + CFGE_USE_ONLY_TARGET_SAS = 1, /* struct sas_ha_struct.use_host_phy_addr */
> > > +};
> > > +
> > > /* ---------- Expander Devices ---------- */
> > >
> > > #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
> > > @@ -344,6 +349,9 @@
> > >
> > > struct scsi_core core;
> > >
> > > + spinlock_t libsas_config_lock;
> > > + unsigned int use_host_phy_addr; /* defaults to 0 */
> > > +
> > 
> > Reading an int is assumed atomic so we wouldn't need a lock to set or
> > clear this flag. Something like this would be better done at init
> > time. Maybe if you needed it for ordering you could do something like
> > 
> > use_host_phy_addr=1
> > spin_lock();
> > spin_unlock();
> > 
> > ...but that does not appear to be the case here.
>  
> I don't need it for ordering, and I had forgotten about the atomicity. 
> I'd be just has happy to be rid of it.
>
> > 
> > --
> > Dan
> > --
	 	   		  
