From: Dave Jones <davej@redhat.com>
Subject: Re: [patch 1/1] Whitelist-Entry (FORCELUN) for SGS Thomson Microelectronics Cytronix 6in1 card reader in scsi_devinfo.c
Date: Wed, 9 Mar 2005 13:34:21 -0500
Message-ID: <20050309183420.GA12748@redhat.com>
References: <200503090903.j2993vjp022052@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mx1.redhat.com ([66.187.233.31]:52623 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262164AbVCISeg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 13:34:36 -0500
Content-Disposition: inline
In-Reply-To: <200503090903.j2993vjp022052@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, mail@hboeck.de

On Wed, Mar 09, 2005 at 01:03:32AM -0800, Andrew Morton wrote:
 > 
 > From: Hanno Boeck <mail@hboeck.de>
 > 
 > I have a usb-cardreader here that needs some FORCELUN-entries in
 > scsi_devinfo.c.
 > 
 > lsusb says about the device:
 > 
 > Bus 001 Device 003: ID 0483:1307 SGS Thomson Microelectronics Cytronix 6in1 card reader
 > 
 > Signed-off-by: Andrew Morton <akpm@osdl.org>

The problem with these devices is there are so many of them,
(The Fedora kernel had over a dozen additions to the whitelist at one point),
and there were still devices getting reported that weren't detected.
There's no way to stay on top of the amount of these things that are being produced.

There are only two sane solutions that I see
1) Have usb-storage tell the scsi layer "Its a card reader, scan all luns"
or
2) enable scanning of all luns, and blacklist any devices that misbehave.

I chose (2) in the Fedora kernel, and so far, only 1 device got picked up
that needed adding to the blacklist.

		Dave

