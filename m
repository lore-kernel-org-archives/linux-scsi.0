From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: Wed, 29 Oct 2003 09:49:19 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310290947010.874-100000@ida.rowland.org>
References: <1067381663.11029.16.camel@patehci2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1540 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261569AbTJ2OtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 09:49:20 -0500
In-Reply-To: <1067381663.11029.16.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On 28 Oct 2003, Pat LaVarre wrote:

>   There now in -test9 I think I see:
> 
> We guess writable if need be, but we prefer to settle for:
> 
> sdkp->write_prot = ((data.device_specific & 0x80) != 0);
> 
> after the first command that works in the sequence:
> 
> sd_do_mode_sense(..., 0x3F, ..., 4, ...);
> sd_do_mode_sense(..., 0, buffer, 4, ...);
> sd_do_mode_sense(..., 0x3F, buffer, 255, ...);
> 
> I mean to suggest, ahead of these more creative (i.e. less friendly)
> alternatives, in order to fetch that bit of header, we try a command
> that more closely resembles the commands of the Talk Like Windows set,
> e.g.:
> 
> sd_do_mode_sense(..., 0x08, ..., 4, ...);

There's an excellent reason for _not_ doing this, at least as far as 
usb-storage is concerned.  Namely, many USB Mass Storage devices die when 
they receive MODE-SENSE(10) for page x08 but handle page x3F perfectly 
well.  Ronald's device is a rather unusual exception.

Alan Stern

