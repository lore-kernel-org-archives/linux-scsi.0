From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Sat, 22 Sep 2012 23:48:52 +0200
Message-ID: <201209222348.52273.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1209221615360.11873-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1209221615360.11873-100000@netrider.rowland.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Aaron Lu <aaron.lu@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Saturday, September 22, 2012, Alan Stern wrote:
> On Sat, 22 Sep 2012, Rafael J. Wysocki wrote:
> 
> > > > I see. So the sr's runtime suspend may be useful even without the power-off
> > > > feature, right?
> > > 
> > > Exactly.  Even though the drive itself may not be powered off, by 
> > > putting it into runtime suspend we gain the ability to suspend the 
> > > ancestor devices.
> > 
> > OK, so what about using a PM QoS-based approach as described (in general
> > terms) in this message in the "USB ports power off" thread:
> > 
> > http://marc.info/?l=linux-pm&m=134831537224566&w=4
> 
> I'm not entirely sure.  It may well work out better in this case than 
> in the USB ports case.
> 
> For the ZPODD stuff, the userspace control amounts to a single flag
> ("do not allow zero-power") which can easily be represented as a QoS
> constraint.
> 
> For the USB ports, the situation is more complicated.  The decision 
> about whether or not to power-off a port depends not just on the port 
> itself but also on the device plugged into the port, and there's no 
> direct relation between the two in the sysfs device tree.  (That could 
> be fixed perhaps by adding symbolic links between them.)

That doesn't seem to be a big obstacle as far as PM QoS is concerned, though.
The trick may be to add PM QoS constraints not for the device itself, but
directly for the port it is connected to (it always is possible to add a
constraint for the device too, but that simply may be unnecessary).  Then,
whoever decides whether or not to power off the port would only have to
look at the effective PM QoS requirement bits of the port.

> This should be discussed in the USB thread, though...

Sure.

Thanks,
Rafael
