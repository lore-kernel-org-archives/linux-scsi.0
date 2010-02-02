From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 0/6] Work In Progress: FC sysfs
Date: Tue, 2 Feb 2010 14:06:14 +0100
Message-ID: <20100202130614.GA13224@schmichrtp.mainz.de.ibm.com>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
 <4B61B4DB.1020207@suse.de>
 <1264793466.11363.120.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:59534 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0BBNGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2010 08:06:17 -0500
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate5.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o12D6GRx032412
	for <linux-scsi@vger.kernel.org>; Tue, 2 Feb 2010 13:06:16 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o12D6GnQ1581290
	for <linux-scsi@vger.kernel.org>; Tue, 2 Feb 2010 13:06:16 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o12D6FhB009698
	for <linux-scsi@vger.kernel.org>; Tue, 2 Feb 2010 13:06:15 GMT
Content-Disposition: inline
In-Reply-To: <1264793466.11363.120.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.smart@emulex.com" <james.smart@emulex.com>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>

On Fri, Jan 29, 2010 at 11:31:06AM -0800, Robert Love wrote:
> On Thu, 2010-01-28 at 08:01 -0800, Hannes Reinecke wrote:
> > Robert Love wrote:
[...]
> > > # ls /sys/devices/virtual/net/eth3.101/fcport1/fcfport_2001000deca31e81/fcfabric_0/
> > > fabric_name  fcvport_0  fcvport_1  max_npiv_vports  npiv_vports_inuse  power  uevent  vport_create  vport_delete
> > > 
> > Consistent numbering. Either use '_' as a separator always or for none.
> > This mix-up doesn't make sense.
> > 
> > And, why doesn't the fcfport doesn't show up under the fabric?
> > One would assume that the fcfport is part of the fabric, too.
> > 
> > And what about the remote ports? Do they not participate in the fabric?
> > 
> > If the 'fcfabric' element is _not_ the actual fabric I would get rid of it altogether as it'll only serve to confuse
> > the users. Like just has been happened with me :-)
> > 
> Yeah, they should be under the fcfabric. This work is just incomplete in
> that area.

Besides the fabric, FC also has the arbitrated loop and point-to-point
support. If there is a fcfabric element, would the "point-to-point
remote port" be placed under the fcfabric? Or might this be another
point for not having the fcfabric element?

[...]
> > > 9) Is this change worth all of the changes that will need to happen?
> > > 
> > >    This is probably the most difficult question. I view this change as
> > >    positive overall, but it's very heavy lifting. Not only does the
> > >    FC transport need an overhaul, but it looks like the scsi transport
> > >    and AC code might need some additions. Every HBA will need to be
> > >    modified and every HBA's HBAAPI vendor library will need to change
> > >    too. (I hope this would be a catalyst to move to an OS library that
> > >    everyone shares)
> > > 
> > >    I'd like to hear other opinions about this because this really is
> > >    going to be something that all HBAs will need to be involved in.

The changes required for "all HBAs" also include the zfcp driver,
i am looking at this from zfcp's point of view. With zfcp, we only
support FCP/SCSI with point-to-point or fabric attached storage, so we
don't need as much flexibility as other HBAs.

I assume the LLD driver will report the available hardware resources
with fc_fcport_add, fc_fcpinit_add or whatever the entry points will
be called in the final version. Reporting the new FC elements instead
of FC host and SCSI host should be doable for zfcp.

--
Christof
