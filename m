From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.8.1-mm3
Date: 21 Aug 2004 15:24:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093116298.2092.388.camel@mulgrave>
References: <200408211838.i7LIcUdl025108@harpo.it.uu.se>
	<20040821191417.GA3402@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41614 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267685AbUHUTZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 15:25:27 -0400
In-Reply-To: <20040821191417.GA3402@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Mikael Pettersson <mikpe@csd.uu.se>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-08-21 at 15:14, Patrick Mansfield wrote:
> Looks like it will be hit for any scsi removable media, the removable
> media check in sd.c sd_media_changed() uses SCSI_IOCTL_TEST_UNIT_READY.

Yes, I'm in two minds about this one.

Either we could provide a helper routine to do it and convert all the
internal uses over, or we could define a new ioctl that is correctly
unique, something like

#define SCSI_TEST_UNIT_READY	_IOR('S', 8, int)
or perhaps just 0x5388

and convert the internal users over to it.

Opinions?

James


