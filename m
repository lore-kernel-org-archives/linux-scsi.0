From: Sean Thomson <psthomso@hotmail.com>
Subject: RE: [RFC] libsas: modifying libsas port creation
Date: Mon, 27 Sep 2010 17:47:09 -0700
Message-ID: <SNT126-W423EB4A9F109822A4B728CCE660@phx.gbl>
References: <86810401A1B22346A09CBA649BE561E90133F6445B@azsmsx505.amr.corp.intel.com>,<AANLkTinnh4=7sT+Jhx7px-mK37CZ17J-_bYEsSyKOoKC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from snt0-omc2-s37.snt0.hotmail.com ([65.55.90.112]:13996 "EHLO
	snt0-omc2-s37.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab0I1AxT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 20:53:19 -0400
In-Reply-To: <AANLkTinnh4=7sT+Jhx7px-mK37CZ17J-_bYEsSyKOoKC@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com, Pat Thomson <patrick.s.thomson@intel.com>
Cc: linux-scsi@vger.kernel.org, ed.ciechanowski@intel.com, nathan.marushak@intel.com, jeffrey.d.skirvin@intel.com, roger.c.jeppsen@intel.com


> > I'm working on a SAS driver for Intel's Patsburg chipset and ran across a problem (for me) when libsas creates a port. Specifically, it 
appears that libsas will use only use the attached sas address when creating a port, instead of the sas address on each side of the link. What I'd like to propose is to modify port creation such that, based on a flag stored in struct sas_ha_struct, that the SAS address on the initiator side can be taken into account. If the flag is not set, then the original behavior is in force.
> >
> > The main point is that the original behavior is the default, and if anyone wants to use the modified port creation, they call sas_ha_struct.notify_libsas_config() right after sas_ha_register during module init.
> >
> 
> Shouldn't this just be the default without a configuration option?
> For cases where port->sas_addr != phy->sas_addr I assume you would
> always want this new behavior regardless of the flag??
> 

Ideally, yes, because a port should take into account the sas address on each side of the link, but, thats not how its been working. I'm expecting that somewhere, someone knows the behavoir and coded around it (or took advantage of it). There is an advantage to the current default, on a single level expander, you don't see multipath if the port configurations on each side don't match. 

Honestly, I haven't gone back to find out if the way it is, is intentional or a misunderstanding.

> > Thanks!
> > Pat Thomson
> >
> > diff -Nau old/include/scsi/libsas.h new/include/scsi/libsas.h
> > --- old/include/scsi/libsas.h 2010-09-27 14:23:14.142380393 -0700
> > +++ new/include/scsi/libsas.h 2010-09-27 15:26:38.040818779 -0700
> > @@ -89,6 +89,11 @@
> > DISC_NUM_EVENTS = 3,
> > };
> >
> > +enum cfg_state {
> > + CFGE_USE_HOST_TARGET_SAS = 0U, /* struct sas_ha_struct.use_host_phy_addr */
> > + CFGE_USE_ONLY_TARGET_SAS = 1, /* struct sas_ha_struct.use_host_phy_addr */
> > +};
> > +
> > /* ---------- Expander Devices ---------- */
> >
> > #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
> > @@ -344,6 +349,9 @@
> >
> > struct scsi_core core;
> >
> > + spinlock_t libsas_config_lock;
> > + unsigned int use_host_phy_addr; /* defaults to 0 */
> > +
> 
> Reading an int is assumed atomic so we wouldn't need a lock to set or
> clear this flag. Something like this would be better done at init
> time. Maybe if you needed it for ordering you could do something like
> 
> use_host_phy_addr=1
> spin_lock();
> spin_unlock();
> 
> ...but that does not appear to be the case here.
 
I don't need it for ordering, and I had forgotten about the atomicity. I'd be just has happy to be rid of it.

> 
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 	   		  