From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 15:51:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505155127.A11734@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <20030505093834.B7831@beaverton.ibm.com> <20030505174602.GA3433@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:42590 "EHLO laptop")
	by vger.kernel.org with ESMTP id S262073AbTEEWov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2003 18:44:51 -0400
Content-Disposition: inline
In-Reply-To: <20030505174602.GA3433@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, May 05, 2003 at 10:46:02AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

On Mon, May 05, 2003 at 10:46:02AM -0700, Mike Anderson wrote:
> Patrick Mansfield [patmans@us.ibm.com] wrote:

> > Right now, we could have an sgid that runs whenever an sg is found (sg
> > hotplug generated via device_register), and stores a sysfs path and the id
> > returned into a flat file.
> 
> I believe devlabel's scsi_unique_id.c file does some of this, though I
> have not looked at it closely.
> 
> -andmike

Yes, it looks very close, and has the underlying infrastructure (uses the
SCSI_IOCTL_SEND_COMMAND, not sg, so can be used for all upper level linux
scsi devices). It looks like we would need functionallity that is in the
devlabel script itself (to output just a  single ID), maybe just integrate
that into scsi_unique_id. (I did not look closely at devlabel, it has more
lines than the scsi_unique_id.c source.)

It looks like scsi_unique_id should also dump the code set, so it can pick
one code set (the same one) over anoother (if both were ever used by a
single LU).

It fails for character devices, but that is easily fixed by deletion of
the check (SCSI_IOCTL_SEND_COMMAND works for any scsi device: st, sd, sr
or sg). I deleted the check and it ran ok on a "processor" scsi device,
though the device does not support page 80 or page 83. 

scsi_unique_id should also have some sort of error checking/reporting, so
we can tell if a device is not functioning (versus does not support page
80 or 83).

I don't know how this would be integrated into the scsi device model tree,
given the current flux (class or bus for upper level devices, as well as
for the scsi_device itself).

-- Patrick Mansfield
