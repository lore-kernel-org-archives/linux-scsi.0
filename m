From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness
	in	drivers/scsi/scsi_lib.c
Date: 27 Oct 2004 09:42:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098884542.1829.3.camel@mulgrave>
References: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>	<Pine.GSO.4.58.0
	410260947280.22299@boromir> <417E9163.8010904@us.ibm.com>
		<417E92AB.5020406@us.ibm.com> <1098842044.1762.688.camel@mulgrave>
	<417F2BD3.5010901@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63380 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262385AbUJ0NnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 09:43:12 -0400
In-Reply-To: <417F2BD3.5010901@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <mikenc@us.ibm.com>, Mateusz.Blaszczyk@nask.pl, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, 2004-10-27 at 01:02, Douglas Gilbert wrote:
> I have been seeing an oops (or badness) since about the lk 2.5
> series if I left my USB Sandisk CF (ImageMate) plug in with a
> mounted file system open when I halted the machine. As the logs
> had already been closed down there was nothing captured.

Yes, that's known and expected.  The devices have a complete state
transition model.  Some of the states (like deleted->cancel) are
explicitly forbidden (once a device is deleted, we actually don't allow
it to do anything other than die).  The attempts at bogus transitions
usually show up in error handling for a dead device.

The badness is simply a stack trace caused by a WARN_ON(1) in the code
that forbids the transition.  However, for the time being I'd like to
keep it in to help us debug problems which result in an oops later.

As long as you only get "badness" messages and no oops, everything is
actually fine.

James


