From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 11 Sep 2003 16:19:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063311558.2017.5.camel@mulgrave>
References: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:36869 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261502AbTIKUUC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 16:20:02 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2003-09-11 at 16:05, Alan Stern wrote:
> What do people think of just having per-device flags that the host driver
> could set during the slave_configure() callback?  The point of these flags
> is not to prevent bad commands from being sent to the device --
> user-generated commands sent via sg should always be allowed.  Rather, the
> point is to prevent sd.c from generating these commands in the first
> place.  (Apparently the commands don't present a problem for sr.c.)

I'm not in principle opposed to this.  That's essentially what Andries
did for the mode sense 6 vs 10 problem.

> So for example, usb-storage could set the BFLAG to block MODE-SENSE page 8
> for any disk-type device.  This isn't a perfect solution; consider an
> iSCSI-attached device that is actually a usb-storage disk on some server.  
> Nevertheless, this might take care of the majority of the problems we see.  
> (I haven't seen any MODE-SENSE page 0x3f problems, but others have.)

They can't be BLIST flags, they have to be flags in the struct
scsi_device, but they're easy to add as long as we get a definitive list
of what's necessary.

James


