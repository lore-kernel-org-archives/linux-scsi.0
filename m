From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 14:37:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C013C0@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46038 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266326AbUA2TiR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 14:38:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: "Philip R. Auld" <pauld@egenera.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

I agree with what's here. Some of my concern did come from trying to support
older SCSI-2 devices, or some of those implementations before Persistent
Reserve finally settled to where it is now, and how you actually detect the
different rev/behaviors. 

IMO - After addressing the semantics of the reservations types and how to
identify what's what(which is all SCSI-based) - why isn't this in the scsi
layer ? Pushing this up a level to a transport agnostic layer seems to just
impose more behaviors on that layer, and create a bunch of new interfaces
for what SCSI could already know/do. Also, when considering the timing
constraints and ownership issues pushing this to user land doesn't seem
right either.

-- James S


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Thursday, January 29, 2004 1:31 PM
> To: Smart, James
> Cc: Philip R. Auld; 'Patrick Mansfield'; Simon Kelley; SCSI Mailing
> List; dm-devel@sistina.com
> Subject: RE: Is there a grand plan for FC failover?
> 
> 
> On Thu, 2004-01-29 at 12:35, Smart, James wrote:
> > Why do you imply that you're down to a single path ? With 
> multiple port
> > devices, and the T10 unclarity on multiport support, simple 
> reservations
> > didn't bring you down to the single port access you are 
> describing. Some
> > devices may have implemented it this way, but the standard 
> didn't say they
> > had to or even that they should.
> 
> T10 implies SCSI-2 reservations protect single paths.  Any multi-port
> SCSI-2 reservation implementations tend to be vendor 
> specific.  That's a
> nasty I don't think we want to get into.
> 
> > And this picture changes significantly with the use of Persistent
> > Reservations and the use of keys.
> 
> That's the point, it doesn't.  T10 clarified the persistent 
> reservation
> holder (5.6.2.6 in rev 16) so that it's a specific I_T nexus (which is
> effectively a specific path unless you have fabric redundancy) except
> for all registrant reservations (which aren't useful for clustering).
> 
> Obviously, this seems to require that the reservation be held against
> everyone when the port switches, which would preclude doing user level
> reservation handling, hence the need for a separate ownership API
> (assuming all vendors get on the same page about this).
> 
> James
> 
> 
