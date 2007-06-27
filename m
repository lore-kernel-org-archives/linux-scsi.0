From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Wed, 27 Jun 2007 02:27:52 +0200
Message-ID: <4681AF08.5070802@s5r6.in-berlin.de>
References: <319583.29876.qm@web31809.mail.mud.yahoo.com>	 <4680EDFE.4050808@s5r6.in-berlin.de>	 <1182867615.3562.3.camel@localhost.localdomain>	 <4681351F.8000403@s5r6.in-berlin.de> <1182877289.3562.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36746 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXF0A2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 20:28:31 -0400
In-Reply-To: <1182877289.3562.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-06-26 at 17:47 +0200, Stefan Richter wrote:
>> To fill values into these attributes, transport layer
>> drivers/classes/whatever supply to SCSI core either strings or functions
>> which print strings into buffers.  ->  SCSI core controls that these
>> properties go into host*/target*:*:*/port_{name,id}.  Transports control
>> how the values of these attributes look.
> 
> Really, look at the fc code which already does it ...

Good, I did a kscope session now to get an idea of the "transport
classes" API and how the "XYZ Transport Attributes" drivers use it.

> to try to provide methods from the mid-layer would make this quite complex.

No, it's mostly trivial.  Mid-layer can add its own attributes to
starget->dev as well as to sdev->sdev_gendev.  As far as attribute
values are transport protocol dependent, the show functions of these
attributes can make use of sprintf-like functions to be supplied for
example by scsi_transport_template, as I mentioned earlier in the thread
in http://marc.info/?l=linux-scsi&m=118253907125635 .  I can explain
this by a demo patch, if I find time at the weekend.

[...]
>> 	err = device_create_file(target_gendev, &my_port_id_attr);
[...]
> Not really ... look at scsi_transport_fc.c line 911 ... the entire
> transport class is designed to set attributes like this and manage the
> lifetimes of the underlying objects.

OK, thanks for the pointer into the source.

Of course the mid-layer doesn't have to provide attributes like I
suggested them --- because the alternative is that all or at least the
majority of transport drivers provide them on their own but use
*uniform* attribute names for them.

This is what we have at the moment:

   - The scsi_tranport_fc.c transport driver supplies the Target Port
     Identifier and Name in attributes of the starget->dev.  The
     attributes are called "port_id" and "port_name".

   - The scsi_transport_sas.c transport driver supplies an
     "rphy_sas_address" of which the Target Port Identifier could
     presumably be obtained.  I am not sure in which sysfs devices this
     attribute is located and how these devices relate to starget->dev.

   - The scsi_transport_iscsi.c transport driver supplies the
     attributes "targetname" and "tpgt" of which the Target Port
     Identifier could be obtained.  I am not sure in which sysfs devices
     these attributes are located and how these devices relate to
     starget->dev.

   - I don't know if scsi_transport_spi.c's attributes are suitable to
     obtain object identifiers or object names.

   - Luben's SAS stack obviously supplies the Target Port Identifier in
     the grandparent of LUNS devices.  The attribute is called sas_addr.
     The Logical Unit Identifier is used as the sysfs name of LUNS
     devices, i.e. as sysfs directory names.

   - The sbp2.c transport driver supplies the concatenation of Target
     Port Identifier and Logical Unit Identifier in an attribute of the
     sdev->sdev_gendev.  The attribute is called "ieee1394_id".  sbp2.c
     needs to be told though by a recently added module parameter to
     use SAM-4 conforming formats for the identifiers.  It's partly
     SAM's fault because there is an editorial mistake in SAM regarding
     what an SBP-3 target port identifier is.

   - The fw-sbp2.c transport driver (candidate to eventually replace
     sbp2.c) supplies the concatenation of Target Port Identifier and
     Logical Unit Identifier in an attribute of the sdev->sdev_gendev.
     The attribute is called "ieee1394_id" and conforms to SAM-4 formats
     out of the box.

So, only the SBP-2 transport and the out-of-tree SAS transport expose
Logical Unit Identifiers and Target Port Identifiers.  (sbp2.c has been
doing so for years.)  Some of the other transports expose only Target
Port Identifiers.  Object identifiers are  exposed in non-uniform places
defined by the respective transport implementation.
-- 
Stefan Richter
-=====-=-=== -==- ==-==
http://arcgraph.de/sr/
