From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 13:41:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C013BF@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32207 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266270AbUA2Sl4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 13:41:56 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Anderson' <andmike@us.ibm.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Philip R. Auld" <pauld@egenera.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

I view port as a part of the path. I may have been a little loose on my
terms. I am describing paths that enter different ports on the device - not
the paths through the same port that you describe. Could be 1 adapter to a
switch with 2 switch connections to 2 ports on the target; or 2 adapters,
each with an independent path to a different port on the device.

Relative to a single port on the device - I agree with you. Simple
reservations only allow one initiator access. With multiple ports on the
device, each which may be on different and independent "bus", simple
reservation isn't sufficient.  (yes - I'm using "bus" loosely - it may be an
independent Parallel SCSI bus, or a independent fabric/zone, etc).

-- James

> -----Original Message-----
> From: Mike Anderson [mailto:andmike@us.ibm.com]
> Sent: Thursday, January 29, 2004 1:31 PM
> To: Smart, James
> Cc: 'James Bottomley'; Philip R. Auld; 'Patrick Mansfield'; Simon
> Kelley; SCSI Mailing List; dm-devel@sistina.com
> Subject: Re: Is there a grand plan for FC failover?
> 
> 
> Smart, James [James.Smart@Emulex.com] wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> > > 
> > > On Thu, 2004-01-29 at 09:49, Philip R. Auld wrote:
> > > > It needs to be known to the pathing layer if you've got 
> > > load balancing. 
> > > > It has to know which path has the reservation and only 
> use that one.
> > > 
> > > Well, yes, but your multiple active path implementation 
> just collapsed
> > > back down to single path in the face of reservations, so it would
> > > probably be better simply to use failover in the face of 
> reservations
> > > and clustering.
> > 
> > Why do you imply that you're down to a single path ? With 
> multiple port
> > devices, and the T10 unclarity on multiport support, simple 
> reservations
> > didn't bring you down to the single port access you are 
> describing. Some
> > devices may have implemented it this way, but the standard 
> didn't say they
> > had to or even that they should.
> > 
> > And this picture changes significantly with the use of Persistent
> > Reservations and the use of keys.
> > 
> 
> It appears you are mixing port and path. If you have multiple 
> paths to a
> port created by multiple adapters connecting to this port 
> through a bus,
> fabric, etc. then simple reservations should restrict you to only one
> path to this port. Is there a device that implements simple 
> reservations
> and allows multiple initiators access?
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
