From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] scsi: wd7000: print sector number as 64-bit
Date: Tue, 21 Jun 2016 13:41:20 +0200
Message-ID: <5191137.P6HbgXDjAh@wuerfel>
References: <20160615204231.3784044-1-arnd@arndb.de> <4878482.cSGU6mK9NX@wuerfel> <yq1eg7r5oq5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:49304 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbcFULjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2016 07:39:31 -0400
In-Reply-To: <yq1eg7r5oq5.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday, June 20, 2016 9:12:50 PM CEST Martin K. Petersen wrote:
> >>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:
> 
> As sector_t can be 32-bit wide, this adds a cast to 'u64' and prints
> that with the correct format. The change to use no_printk()
> 
> [...]
> 
> +       dprintk("wd7000_biosparam: dev=%s, size=%lld, ",
> +               bdevname(bdev, b), (s64)capacity);
> 
> s64?
> 
> Why not unsigned long long like we usually do with sector_t?

The printk() was using %d as the format string, printing it
as a signed number, so I did not change it.

Using %llu makes sense though, I've resent it like that.

	Arnd

