From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: MPIO HS200 Gigabox weird behaviour again
Date: Fri, 11 Feb 2005 11:07:41 -0800
Message-ID: <20050211190741.GA8641@us.ibm.com>
References: <1108138682.5773.23.camel@mulgrave> <Pine.LNX.4.44L0.0502111326540.937-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e32.co.us.ibm.com ([32.97.110.130]:49814 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262312AbVBKTIz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 14:08:55 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1BJ8ouA071184
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2005 14:08:50 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1BJ8n2x274966
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2005 12:08:49 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1BJ8m3V017738
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2005 12:08:49 -0700
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502111326540.937-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 11, 2005 at 01:31:30PM -0500, Alan Stern wrote:
> On Fri, 11 Feb 2005, James Bottomley wrote:
> 
> > On Fri, 2005-02-11 at 11:00 -0500, Alan Stern wrote:
> > > SCSI developers: Is there any hope of this?
> > 
> > Well, IBM also has some old buggy piece of hardware that apparently
> > gives fatal errors but actually wants them retried:
> > 
> > http://marc.theaimsgroup.com/?t=110088696100005
> > 
> > After a bit of argument, they agreed to do it as a blacklist flag, so
> > you should be able to add the same flag to your gigabox.
> > 
> > I planned to put the patch in just as soon as they managed to send the
> > patch unmangled by a mailer, but they went very quiet.
> 
> Thanks, James.
> 
> Radovan: Below is an updated version of the patch James mentioned, with an
> entry included for your Gigabox drive.  It's meant to apply to
> 2.6.11-rc3-bk5, but it will probably go with older kernels too.  Try it
> out and let me know how it works.  If it solves your problem, I'll submit
> it for inclusion in the official kernel.

Do you have the asc/ascq for the USB device?

Longer term, it would be nice to have a black list modifiable via sysfs
(similiar to the scsi devinfo one) with a vendor + model + sense key + asc
+ ascq, for both this USB device and for the IBM one. AFAIUI, the IBM
ESS/2105 really wants certain hardware errors retried not all of them, I
don't know if the IBM ESS/storage developers were OK with Martin's patch
(I never see responses from them to anything posted on linux-scsi).

The sense black list could be used for quirks plus vendor specific
asc/ascq values. It could also be used by dm multipath, if error codes
(like Mike C's old patch) and not sense data were passed up.

James - would you be OK with such an approach?

It should be populated after loading scsi_mod, but before loading HBA
drivers (the same is true for devinfo); I think this means manually
loading scsi_mod, populate the tables, then allow hotplug loading of HBA
drivers.

We still need a nice way to display and modify a list or array in sysfs (for
both the devinfo or this asc/ascq table).

-- Patrick Mansfield
