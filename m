From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: megaraid sparse warnings
Date: Wed, 26 May 2010 22:39:47 +0100
Message-ID: <20100526213947.GW31073@ZenIV.linux.org.uk>
References: <4B7788B8.8090005@xenotime.net>
 <20100526142802.1c06d5c1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35551 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab0EZVjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2010 17:39:53 -0400
Content-Disposition: inline
In-Reply-To: <20100526142802.1c06d5c1.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, scsi <linux-scsi@vger.kernel.org>

On Wed, May 26, 2010 at 02:28:02PM -0700, Randy Dunlap wrote:
> ping??
> > 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
> > 			 adapter->product_info.fw_version[2],
> > 			 adapter->product_info.fw_version[1] >> 8,
> > 			 adapter->product_info.fw_version[1] & 0x0f,
> > 			 adapter->product_info.fw_version[0] >> 8,
> > 			 adapter->product_info.fw_version[0] & 0x0f);
> > 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
> > 			 adapter->product_info.bios_version[2],
> > 			 adapter->product_info.bios_version[1] >> 8,
> > 			 adapter->product_info.bios_version[1] & 0x0f,
> > 			 adapter->product_info.bios_version[0] >> 8,
> > 			 adapter->product_info.bios_version[0] & 0x0f);
> > 	} else {

> > Are the fw_version and bios_version fields more than 8 bits each for HP subsys VID
> > products?  Do HP VID products need a different struct so that they print this info
> > correctly?

Since both are claimed to be strings, I really suspect that this >> 8 is
misspelled >> 4 and they have a character followed by pair of two-digit
packed decimals in there...
