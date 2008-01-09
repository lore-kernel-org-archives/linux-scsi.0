From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Wed, 9 Jan 2008 15:36:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801091530140.2856-100000@iolanthe.rowland.org>
References: <200801091831.58240.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38511 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753055AbYAIUgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 15:36:21 -0500
In-Reply-To: <200801091831.58240.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Wed, 9 Jan 2008, Oliver Neukum wrote:

> Am Mittwoch, 9. Januar 2008 18:22:51 schrieb Alan Stern:
> > On Wed, 9 Jan 2008, Oliver Neukum wrote:
> > 
> > > This has an interesting implication. As the storage driver can share
> > > a device with in principle any other usb driver, we must audit all usb
> > > drivers if we wish to adopt this patch.
> > > All a device's interfaces must be resumed when the storage interface
> > > is resumed. To resume a storage device no memory must be allocated
> > > because that could deadlock.
> > 
> > Maybe people shouldn't enable autosuspend for their swap device...
> 
> Good advice, but not sufficient to avoid this problem. The vm may write
> out normal dirty cached pages to scsi devices, which affects storage.

For now, I think the best approach is "head-in-the-sand".  There aren't
a lot of USB storage devices partnered with other functions at the
moment.

But it might be a good idea for all USB drivers to use GFP_NOIO in
their resume pathways.

Alan Stern

