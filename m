From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 12:35:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C013BE@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27079 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266279AbUA2Rge
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 12:36:34 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Philip R. Auld" <pauld@egenera.com>
Cc: 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Thursday, January 29, 2004 10:06 AM
> To: Philip R. Auld
> Cc: Smart, James; 'Patrick Mansfield'; Simon Kelley; SCSI 
> Mailing List;
> dm-devel@sistina.com
> Subject: Re: Is there a grand plan for FC failover?
> 
> 
> On Thu, 2004-01-29 at 09:49, Philip R. Auld wrote:
> > It needs to be known to the pathing layer if you've got 
> load balancing. 
> > It has to know which path has the reservation and only use that one.
> 
> Well, yes, but your multiple active path implementation just collapsed
> back down to single path in the face of reservations, so it would
> probably be better simply to use failover in the face of reservations
> and clustering.

Why do you imply that you're down to a single path ? With multiple port
devices, and the T10 unclarity on multiport support, simple reservations
didn't bring you down to the single port access you are describing. Some
devices may have implemented it this way, but the standard didn't say they
had to or even that they should.

And this picture changes significantly with the use of Persistent
Reservations and the use of keys.


> 
> For the single path case, something like the HP MSA/EVA arrays simply
> throw away reservations on path switch over. 

Depends on the reservation type. Simple Reservations, yes. Persistent
Reservations, no.

> This allows the user level
> watchdog code to reassert them in a cluster down the new 
> path.  However,
> there are array that will do a path switchover and then return
> reservation conflict to everyone (including the taking node).  These
> arrays will need some type of special handling.
> 
> James
> 

Although the management of the reservation/keys in user space is functional,
given that reservations are used as a last firewall for babbling adapters
under failure, you want to reinstate or move the firewall as quickly as
possible - which is sometimes at odds with going out to userland to do so.

-- James S
