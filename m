From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Thu, 05 Jan 2006 12:28:45 -0500
Message-ID: <43BD574D.8040009@emulex.com>
References: <OFE227A343.800436AC-ON412570ED.0055DD4F-412570ED.00560A75@de.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:10176 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751125AbWAER2w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 12:28:52 -0500
In-Reply-To: <OFE227A343.800436AC-ON412570ED.0055DD4F-412570ED.00560A75@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>


> Problem is that on the mainframe I don't have access to the primary
> port. Virtualization is done in adapter microcode. I just have
> access to the virtual port.

I was afraid you'd say this... that was the other caveat.

OK - given that the primary port doesn't exist what you have makes
a lot of sense. I guess we have the 2 options:
- add the 2 attributes per host
- create a host and set the attributes  (and this is major overkill)

I have some reservations about the data passing that allows the virtual
port to get the physical port data, but it's probably manageable.

With this direction - your patch is fine, with the caveat that I want
to explore the most meaningful names for the attributes. Does port_name
and physical_port_name become odd to a user ? Is some script writer bound
to assume they always wanted the physical name as they would only see a
difference if on a mainframe ? What if we change the names to be more
npiv-centric.  What about ppn (for physical_port_name) and ppn_id (for
physical_port_id) ?

> Seems that requirements for workstations and mainframes are quite
> contrary.

Not really - just there are several different implementation models, both at
the adapter and at the OS side.

-- james
