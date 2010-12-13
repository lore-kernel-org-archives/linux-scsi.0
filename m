From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [RFC] [PATCH 5/5] bnx2fc: Broadcom FCoE offload driver
 submission - part 3
Date: Mon, 13 Dec 2010 13:37:39 -0800
Message-ID: <7C88852EF6F99F4EB538472FCFEBE2220149E011B4@orsmsx509.amr.corp.intel.com>
References: <1291920835.5480.161.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
 <7C88852EF6F99F4EB538472FCFEBE22201499C3157@orsmsx509.amr.corp.intel.com>
 <1292023684.5480.198.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10844 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab0LMVhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2010 16:37:40 -0500
In-Reply-To: <1292023684.5480.198.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>

> On Fri, 2010-12-10 at 11:52 -0800, Zou, Yi wrote:
> > > This patch contains code that interfaces with libfc, libfcoe
> > > and cnic modules to create FCoE instances, send/receive
> > > non-offload FIP/FCoE packets, listen to link events, etc.
> > >
> > > Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> > > ---
> > >  drivers/scsi/Kconfig              |    1 +
> > >  drivers/scsi/Makefile             |    1 +
> > >  drivers/scsi/bnx2fc/Kconfig       |   11 +
> > >  drivers/scsi/bnx2fc/Makefile      |    3 +
> > >  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2320
> > > +++++++++++++++++++++++++++++++++++++
> > >  5 files changed, 2336 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/scsi/bnx2fc/Kconfig
> > >  create mode 100644 drivers/scsi/bnx2fc/Makefile
> > >  create mode 100644 drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> > >
> > > <-- snip -->
> > >
> > > +
> > > +unsigned long bnx2fc_debug_level;
> > > +module_param(bnx2fc_debug_level, long, 0644);
> > > +module_param_call(create, bnx2fc_create, NULL, (void
> *)FIP_MODE_FABRIC,
> > > +		  S_IWUSR);
> > > +__MODULE_PARM_TYPE(create, "string");
> > > +MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet
> > > interface");
> > > +module_param_call(destroy, bnx2fc_destroy, NULL, NULL, S_IWUSR);
> > > +__MODULE_PARM_TYPE(destroy, "string");
> > > +MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet
> > > interface");
> > > +
> >
> > //I sent this earlier to open-fcoe.org mailing list and realized it was
> > temporarily down, so resend this here, apologize if you get it multiple
> > times.
> >
> > I understand that fcoe.ko is not needed here, but the above also
> indicates
> > that the create/destroy will not be going through the existing fcoe-
> utils
> > which uses sysfs entries of the fcoe module. I think it will be nice
> for
> > everyone to use fcoe-utils as the open-fcoe user space tool.
> 
> Thanks for the comments, Yi.
> 
> You're right. fcoe.ko is not needed. However, we definitely want to
> integrate this driver with open-fcoe's fcoe-utils.
> 
> >
> > However, the existing fcoe.c does not offer that flexibility, where I
> think
> > we have to separate the fcoe.c to provide a fcoe transport layer so
> vendor
> > fcoe hba can plug in, where the existing fcoe.c is the sw fcoe
> transport and
> > plugged in by default. All fcoe transports are registered when they are
> loaded,
> > when fcoe_create() gets called from sysfs, it passes to the fcoe
> transport to
> > look up from the registered transports, whoever thinks the netdev is
> associated
> > with its hw will take over from there, fcoe_destroy() is similar. The
> default
> > transport is the sw fcoe hba in current fcoe.c will be called upon if
> no
> > registered fcoe transport can provide offload there.
> >
> > As the mod params are in fcoe.c, I think we can move create/destroy to
> libfcoe,
> > and, yeah, that does require change in fcoe-utils as well, but that
> would allow
> > fcoe.c be the pure sw fcoe transport. There will be functions in
> current fcoe.c
> > that can be exported so both sw or hw fcoe transport can use, reducing
> the code
> > size. The sw fcoe transport can plug in as vendor's transport in the
> same way
> > through fcoe transport registration, so fcoe.ko will not be required
> for any
> > vendors who has their fcoe transport implementation, e.g., bnx2fc_fcoe.
> >
> > I hope this makes sense, I do think this logic would work nicely for
> any
> > fcoe hba to provide the same user interface on top of given network
> interface
> > name via fcoe-util, which is already pretty well maintained and tested,
> with
> > full DCB support as well. I am hoping we can move towards this
> direction, if not
> > now.
> 
> This definitely is one approach that we can follow.
> 
> Approach we are following today is to modify /etc/fcoe/cfg-eth* to
> include "DRIVER_NAME", which fcoemon can use to identify the sysfs path
> to make appropriate calls to create/destroy.
> 
> Either way, changes in fcoe-utils are required.
> 
Hmm...this approach seems simpler I think. However, every driver will still
have to duplicate the same create/destroy sysfs interface, which is not 
very nice in my opinion. Yeah, as you said, either way, changes in fcoe-utils
are needed.

Thanks,
Yi

> Thanks,
> Bhanu
> >
> > Thanks,
> > yi
> >
> 
> 

