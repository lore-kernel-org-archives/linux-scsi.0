From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi disk: report size without overflow
Date: Fri, 21 Oct 2005 16:17:17 -0500
Message-ID: <1129929437.3440.60.camel@mulgrave>
References: <20051020205532.16b65fa7.rdunlap@xenotime.net>
	 <1129915249.3440.42.camel@mulgrave>
	 <Pine.LNX.4.58.0510211345080.32061@shark.he.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19594 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751150AbVJUVRU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 17:17:20 -0400
In-Reply-To: <Pine.LNX.4.58.0510211345080.32061@shark.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, Dale Blount <linux-kernel@dale.us>

On Fri, 2005-10-21 at 13:46 -0700, Randy.Dunlap wrote:
> On Fri, 21 Oct 2005, James Bottomley wrote:
> > what's wrong with the attached?  It looks like the code once allowed 256
> > byte sectors, but the if statement above now forbids them.
> 
> What if statement forbids 256-byte sectors?  I don't see it.
> 
> 	if (sector_size != 512 &&
> 	    sector_size != 1024 &&
> 	    sector_size != 2048 &&
> 	    sector_size != 4096 &&
> 	    sector_size != 256) {

Sorry, didn't read far enough down the if statement.

To support 256, we can still do it, but the assignment has to become

sector_t sz = (sdkp->capacity/2) * (hard_sector/256);

James


