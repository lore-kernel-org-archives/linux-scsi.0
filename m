From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Wed, 25 Aug 2004 19:54:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040826025453.GA125799@sgi.com>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org> <1093217548.1727.367.camel@mulgrave> <1093218968.3553.17.camel@swtf.comptex.com.au> <1093275122.1776.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:11718 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S266756AbUHZCz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 22:55:56 -0400
Content-Disposition: inline
In-Reply-To: <1093275122.1776.52.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Burn Alting <burn@goldweb.com.au>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 23, 2004 at 11:31:57AM -0400, James Bottomley wrote:
> On Sun, 2004-08-22 at 19:56, Burn Alting wrote:
> > How about when disk arrays are booting? Typically, a disk array will
> > quickly present target(s) to the host and then take some time to
> > initialise before being ready for medium access. I assume most disk
> > arrays will present the above sense condition (becoming ready) to all
> > medium access commands until it is ready for medium access.
> 
> If you power off a disc and power it on again, the same thing happens.
> 
> I'd like to distinguish between normal occurrences at start of day which
> we need to handle (like spinning up devices or waiting for them to
> become ready from power on).  And normal occurrences during device
> operation.  The former are handled in the ULD and the latter in the
> mid-layer error handler.
> 
> It's certainly possible to rejig the mid-layer to add an extra delay via
> schedule_delayed_work(), but I'd like to be sure its necessary first,
> since the addition looks to be slightly messy.
> 
> James


I believe that 02/04/01 should be treated like a Busy status.  The
semantics are slightly different, but the action taken by the
initiator is the same: wait a bit and then retry.

I have seen this key/asc/asq before and had to handle it that way.
I believe the device in question was a disk drive that had been
powered on recently.  Disks set to have a variable spinup delay
(based on ID, so that not all disks in a 16-drive box power up at
the same time and overstress a power supply) can return this code
up to a couple of minutes after power on.

jeremy
