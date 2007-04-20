From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] cciss: Fix warnings during compilation under
 32bitenvironment
Date: Fri, 20 Apr 2007 14:36:45 +0100
Message-ID: <20070420143645.0e787f41@the-village.bc.nu>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
	<1176995934.31764.7.camel@mulgrave.il.steeleye.com>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
	<1176999730.31764.15.camel@mulgrave.il.steeleye.com>
	<558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
	<20070419222028.d33c7f86.akpm@linux-foundation.org>
	<1177074641.3718.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38715 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767105AbXDTNdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 09:33:42 -0400
In-Reply-To: <1177074641.3718.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Cameron, Steve" <Steve.Cameron@hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> > #if (BITS_PER_LONG > 32) || defined(CONFIG_LBD)
> > #define sector_upper_32(sector) ((sector) >> 32)
> > #else
> > #define sector_upper_32(sector) (0)
> > #endif

Gak

Just do

	sector_upper_32(sector)   (((sector) >> 31) >> 1)

and lose all the ifdefs,

Alan
