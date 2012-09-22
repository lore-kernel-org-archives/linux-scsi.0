From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Sat, 22 Sep 2012 11:38:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209221133410.7497-100000@netrider.rowland.org>
References: <201209221328.37967.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201209221328.37967.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Aaron Lu <aaron.lu@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 22 Sep 2012, Rafael J. Wysocki wrote:

> > There are sd devices with removable media.
> 
> OK.  Does the SCSI layer distinguish them from devices without removable media?

Yes, it does.  struct scsi_device has a .removable member, and the
Removable flag is part of the response data to the INQUIRY command
(which belongs to the primary command set common to all SCSI devices).

> > > User space has an interface to disable runtime PM of any device and it looks
> > > like that interface should be sufficient to disable the feature in question.
> > > Why do you think the new interface is needed?
> > 
> > Because this is not equivalent to doing no runtime PM at all. SCSI
> > now defines some powersaving states which do not involve powering
> > down and thus losing state.
> 
> I see. So the sr's runtime suspend may be useful even without the power-off
> feature, right?

Exactly.  Even though the drive itself may not be powered off, by 
putting it into runtime suspend we gain the ability to suspend the 
ancestor devices.

Alan Stern

