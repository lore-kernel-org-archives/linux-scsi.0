From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: [PATCH] scsi_transport_iscsi.c contexts
Date: Fri, 29 Apr 2005 12:45:19 -0700
Message-ID: <1114803919.16658.8.camel@haakon>
References: <1114646147.20844.37.camel@haakon> <42705449.1030706@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp812.mail.sc5.yahoo.com ([66.163.170.82]:42349 "HELO
	smtp812.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S262918AbVD2T42 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 15:56:28 -0400
In-Reply-To: <42705449.1030706@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>

On Wed, 2005-04-27 at 20:11 -0700, Mike Christie wrote:
> Nicholas A. Bellinger wrote:
> > This patch against 2.6.12-rc3 is the first step for scsi_transport_iscsi
> > getting iSCSI Keys defined in RFC 3720 Section 12 and other values not
> > defined in this section as keys, but need to be exported out via sysfs
> > into the correct connection/session contexts.
> > 
> > Currently, scsi_transport_iscsi.[c,h] assume that all values are on a
> > per session basis.  These changes have been tested with the upcoming
> > iSCSI transport class enabled release of iscsi-initiator-core
> > (1.6.2.0-rc2), and should hopefully be 'breakage-free' with sfnet.
> > 
> > Comments?
> > 
> > 
> > 
> > ------------------------------------------------------------------------
> > 
> > diff -urN linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c
> > --- linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 15:02:03.000000000 -0700
> > +++ linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 17:36:20.000000000 -0700
> > @@ -3,6 +3,8 @@
> >   *
> >   * Copyright (C) IBM Corporation, 2004
> >   * Copyright (C) Mike Christie, 2004
> > + * Copyright (C) PyX Technologies, 2005
> > + * Copyright (C) Nicholas A. Bellinger <nab@kernel.org>
> >   *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License as published by
> > @@ -25,7 +27,8 @@
> >  #include <scsi/scsi_transport.h>
> >  #include <scsi/scsi_transport_iscsi.h>
> >  
> > -#define ISCSI_SESSION_ATTRS 20
> > +#define ISCSI_CONNECTION_ATTRS 9
> > +#define ISCSI_SESSION_ATTRS 15
> >  #define ISCSI_HOST_ATTRS 2
> >  
> >  struct iscsi_internal {
> > @@ -34,6 +37,7 @@
> >  	/*
> >  	 * We do not have any private or other attrs.
> >  	 */
> > +	struct class_device_attribute *connection_attrs[ISCSI_CONNECTION_ATTRS + 1];
> 
> How are these attrs getting set up? By the LLD? Patch does not work for me;
> nothing shows up btw.
> 

Whoops, I forgot to mention that the includes of the local
scsi_transport_scsi.h in linux-iscsi-4.0.1.11 need to be changed from
"scsi_transport_iscsi.h" to <scsi/scsi_transport_iscsi.h>.  I assume
this was failing because of the changes to struct
iscsi_function_template in the patch.

> The reason all the settings are stuck on the session was becuase we couldn't
> come to an agreement on the layout. We wanted to do something like this:
> 
> /sys/class/iscsi_session/iscsi_connection
> 
> or even
> 
> /sys/class/iscsi_session
> /sys/class/iscsi_connection
> 

I am still thinking on this one.  First and foremost I think that we
need to get move towards a single class for iSCSI Initiators instead of
what is currently registered (/sys/class/iscsi_transport
and /sys/class/iscsi_host).  Let me keep working on this some more and I
will draft up a prosposal in the near future.  Any futher input is
welcomed. :-)

> with some symlinks to glue them together for the latter (I could probably do a better
> picture but you get the idea right). It depends on if people allowed us to stick kobjects
> in structs to make the dirs (could use a attribute group too I guess) or if they wanted
> seperate devices. It might make some sense to figure out the layout while seperating
> things out.
> 

The other thing I think we should considering is only registering
iscsi_session and iscsi_connection classes to the iscsi_host (or
whaterver the class is going to be called) when those entities actually
exist within the said iSCSI stack, and unregistering them once they go
away.  iscsi-initiator-core already does something along these lines in
iscsi_initiator_sysfs.c, and anchors everything released to a specific
Scsi Host to a 'iSCSI Channel'.

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

