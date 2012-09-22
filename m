From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Sat, 22 Sep 2012 16:23:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209221615360.11873-100000@netrider.rowland.org>
References: <201209222146.11421.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:46897 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753001Ab2IVUXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2012 16:23:12 -0400
In-Reply-To: <201209222146.11421.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Aaron Lu <aaron.lu@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Sat, 22 Sep 2012, Rafael J. Wysocki wrote:

> > > I see. So the sr's runtime suspend may be useful even without the power-off
> > > feature, right?
> > 
> > Exactly.  Even though the drive itself may not be powered off, by 
> > putting it into runtime suspend we gain the ability to suspend the 
> > ancestor devices.
> 
> OK, so what about using a PM QoS-based approach as described (in general
> terms) in this message in the "USB ports power off" thread:
> 
> http://marc.info/?l=linux-pm&m=134831537224566&w=4

I'm not entirely sure.  It may well work out better in this case than 
in the USB ports case.

For the ZPODD stuff, the userspace control amounts to a single flag
("do not allow zero-power") which can easily be represented as a QoS
constraint.

For the USB ports, the situation is more complicated.  The decision 
about whether or not to power-off a port depends not just on the port 
itself but also on the device plugged into the port, and there's no 
direct relation between the two in the sysfs device tree.  (That could 
be fixed perhaps by adding symbolic links between them.)  This should 
be discussed in the USB thread, though...

Alan Stern

