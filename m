From: Burn Alting <burn@goldweb.com.au>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Tue, 24 Aug 2004 03:08:20 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093280900.3549.43.camel@swtf.comptex.com.au>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
	 <1093217548.1727.367.camel@mulgrave>
	 <1093218968.3553.17.camel@swtf.comptex.com.au>
	 <1093275122.1776.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from GOL139579-1.gw.connect.com.au ([203.63.118.157]:20382 "EHLO
	goldweb.com.au") by vger.kernel.org with ESMTP id S266069AbUHWRI1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 13:08:27 -0400
In-Reply-To: <1093275122.1776.52.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2004-08-24 at 01:31, James Bottomley wrote:
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

Good point. I'm just concerned that over time, devices are going to be
more specific about the errors they generate at "run-time" (as opposed
to boot/power-on stage) - the ASC/Q table in the scsi standard is
growing rapidly.

I don't think we can get around this and eventually complex error
recovery code (which is messy by nature) is going to be needed. Perhaps
we should get an early start by making the error recovery code as
generic as possible now.

> 
> James
> 

Burn

