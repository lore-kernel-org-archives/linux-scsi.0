From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 13:56:36 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>
References: <20031030100501.A7250@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:17668 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262774AbTJ3S4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 13:56:38 -0500
In-Reply-To: <20031030100501.A7250@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On Thu, 30 Oct 2003, Patrick Mansfield wrote:

> Here's a patch, per Pat Lavarre's suggestion, this can't go in without
> others verifying and testing it, and without input or comment from others
> (at least James).

Why bother to test and shorten len in __scsi_mode_sense() if the callers 
have already taken care of that?  Right now the only users of 
__scsi_mode_sense() are the read-write-flag and cache-type routines in 
sd.c, and your patch makes them use the values you want for len.  If in 
the future other routines decide to call __scsi_mode_sense(), they might 
not appreciate having len changed out from under them.

> Again no USB testing here, tested on 2 sets of SPI attached disks, and 2
> sets of FCP attached disks. It really needs testing on removable media to
> actually hit the write protect check.

I am very doubtful that this will work, or rather that it will work with
all devices.  I've seen _lots_ of reports of USB devices that can't handle
page 8, with all sorts of combinations of values for len attempted.

Alan Stern

