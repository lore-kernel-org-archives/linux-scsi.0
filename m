From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Wed, 9 Jan 2008 18:31:57 +0100
Message-ID: <200801091831.58240.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801091216400.2880-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:46241 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYAIRb3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 12:31:29 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801091216400.2880-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Mittwoch, 9. Januar 2008 18:22:51 schrieb Alan Stern:
> On Wed, 9 Jan 2008, Oliver Neukum wrote:
> 
> > This has an interesting implication. As the storage driver can share
> > a device with in principle any other usb driver, we must audit all usb
> > drivers if we wish to adopt this patch.
> > All a device's interfaces must be resumed when the storage interface
> > is resumed. To resume a storage device no memory must be allocated
> > because that could deadlock.
> 
> Maybe people shouldn't enable autosuspend for their swap device...

Good advice, but not sufficient to avoid this problem. The vm may write
out normal dirty cached pages to scsi devices, which affects storage.

> What happens during normal system resume if a driver (not just USB!)  
> needs to allocate memory before the swap device has been resumed?

I have no idea. I guess these code paths have a sync in the suspend path,
so a lot of clean pages will be available.

	Regards
		Oliver

