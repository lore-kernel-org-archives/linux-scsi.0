From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 23:55:12 +0200
Message-ID: <468039C0.4070109@s5r6.in-berlin.de>
References: <877013.89456.qm@web31802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52397 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXFYVzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 17:55:41 -0400
In-Reply-To: <877013.89456.qm@web31802.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> --- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> I would also like to have the Target Port identifier in there.

("in there" = in sysfs)

> Well this is not correct because the TPI's format and representation
> is transport dependent

My thought was that SCSI core's role would only be to create the
respective sysfs attributes (thus enforcing uniform naming of the
attributes), but that the transport layer implementations are
responsible to feed string representations there; in one way or another.

> and because it is a property of the SCSI Target,
> not the SCSI device (struct scsi device).  And currently SCSI Core
> has no representation of SCSI Targets.

And because SCSI targets are not represented in sysfs, I'd lazily add
target-related information to the LU's sysfs representation.

Of course, if a representation of the target in sysfs is preferred, we
should add this before tainting the LU's sysfs representation with
attributes that belong to the target.

So, would people like targets reflected as sysfs devices ( = parent of
any LU devices)?  We should be able to add or remove parent devices into
sysfs device paths without breaking userspace, says Kay Sievers at the
end of http://lkml.org/lkml/2007/6/8/491 .

[...]
> Ideally SCSI Core is presented with an opaque token (void *, unsigned long (long),
> etc) which represents a target port, which it uses to send SPC commands
> to the target to find out how many if any LUs the target has, INQUIRY them,
> and then create struct scsi_dev for each LU.
> 
> When presented with this opaque token*, SCSI Core allocates and
> initializes a struct scsi_target, whose children are LUs, later
> to be discovered by SCSI Core.  SCSI Core then uses that opaque token
> to ask the transport protocol layer to send commands to the I_T_L
> nexus (WLUN or LUN if it knows it from previous discovery attempt).

Won't work with SBP-2/3.  There the LUs are discovered via IEEE 1212
mechanisms (configuration ROM) rather than SPC.  Plus there is SBP-2/3
login protocol.
-- 
Stefan Richter
-=====-=-=== -==- ==--=
http://arcgraph.de/sr/
