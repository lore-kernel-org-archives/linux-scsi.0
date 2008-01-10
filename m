From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Thu, 10 Jan 2008 10:26:59 +0100
Message-ID: <200801101027.00269.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801091530140.2856-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:46400 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYAJJ0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 04:26:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801091530140.2856-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Mittwoch, 9. Januar 2008 21:36:20 schrieb Alan Stern:
> On Wed, 9 Jan 2008, Oliver Neukum wrote:
> 
> > Am Mittwoch, 9. Januar 2008 18:22:51 schrieb Alan Stern:
> > > On Wed, 9 Jan 2008, Oliver Neukum wrote:
> > > 
> > > > This has an interesting implication. As the storage driver can share
> > > > a device with in principle any other usb driver, we must audit all usb
> > > > drivers if we wish to adopt this patch.
> > > > All a device's interfaces must be resumed when the storage interface
> > > > is resumed. To resume a storage device no memory must be allocated
> > > > because that could deadlock.
> > > 
> > > Maybe people shouldn't enable autosuspend for their swap device...
> > 
> > Good advice, but not sufficient to avoid this problem. The vm may write
> > out normal dirty cached pages to scsi devices, which affects storage.
> 
> For now, I think the best approach is "head-in-the-sand".  There aren't
> a lot of USB storage devices partnered with other functions at the
> moment.

Very well with exception of the hub driver.
 
> But it might be a good idea for all USB drivers to use GFP_NOIO in
> their resume pathways.

Yes, we should make this a requirement for every driver henceforth changed
to support autosuspend.

	Regards
		Oliver


