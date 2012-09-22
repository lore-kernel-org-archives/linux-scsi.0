From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Sat, 22 Sep 2012 21:46:11 +0200
Message-ID: <201209222146.11421.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1209221133410.7497-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([193.178.161.156]:39920 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab2IVTjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Sep 2012 15:39:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209221133410.7497-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Aaron Lu <aaron.lu@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Saturday, September 22, 2012, Alan Stern wrote:
> On Sat, 22 Sep 2012, Rafael J. Wysocki wrote:
> 
> > > There are sd devices with removable media.
> > 
> > OK.  Does the SCSI layer distinguish them from devices without removable media?
> 
> Yes, it does.  struct scsi_device has a .removable member, and the
> Removable flag is part of the response data to the INQUIRY command
> (which belongs to the primary command set common to all SCSI devices).
> 
> > > > User space has an interface to disable runtime PM of any device and it looks
> > > > like that interface should be sufficient to disable the feature in question.
> > > > Why do you think the new interface is needed?
> > > 
> > > Because this is not equivalent to doing no runtime PM at all. SCSI
> > > now defines some powersaving states which do not involve powering
> > > down and thus losing state.
> > 
> > I see. So the sr's runtime suspend may be useful even without the power-off
> > feature, right?
> 
> Exactly.  Even though the drive itself may not be powered off, by 
> putting it into runtime suspend we gain the ability to suspend the 
> ancestor devices.

OK, so what about using a PM QoS-based approach as described (in general
terms) in this message in the "USB ports power off" thread:

http://marc.info/?l=linux-pm&m=134831537224566&w=4

Rafael
