From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: 29 Oct 2003 08:43:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067442207.13824.3.camel@patehci2>
References: <Pine.LNX.4.44L0.0310290947010.874-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:18172 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261850AbTJ2Pnm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:43:42 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310290947010.874-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

> >   There now in -test9 I think I see: ...
> > We guess writable if need be, but we prefer to settle for: ...
> > sdkp->write_prot = ((data.device_specific & 0x80) != 0); ...
> > after the first command that works in the sequence: ...
> > sd_do_mode_sense(..., 0x3F, ..., 4, ...);
> > sd_do_mode_sense(..., 0, buffer, 4, ...);
> > sd_do_mode_sense(..., 0x3F, buffer, 255, ...);
> > 
> > I mean to suggest, ... more closely ... Talk Like Windows ...
> > e.g.: ...
> > sd_do_mode_sense(..., 0x08, ..., 4, ...);
> 
> There's an excellent reason for _not_ doing this, at least as far as 
> usb-storage is concerned.  Namely, many USB Mass Storage devices die when 
> they receive MODE-SENSE(10) for page x08 but handle page x3F perfectly 
> well.  Ronald's device is a rather unusual exception.

Do these devices die for all lengths of op x5A MODE_SENSE_10 of page
x08, or only for the rude, header-only, 4 or 8 byte length that we get
by default if we patch drivers/scsi/ minimally?

That is, do these devices die only when assaulted by:

sd_do_mode_sense(..., 0x08, ..., 4, ...);

in place of the more Windows-like:

sd_do_mode_sense(..., 0x08, ..., 0x1C, ...); // if x5A MODE_SENSE_10
sd_do_mode_sense(..., 0x08, ..., 0x18, ...); // if x1A MODE_SENSE

?

Pat LaVarre


