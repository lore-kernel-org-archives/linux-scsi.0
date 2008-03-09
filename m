From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
Date: Sun, 9 Mar 2008 21:29:16 +0900
Message-ID: <20080309212916T.tomof@acm.org>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54003 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbYCIM3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 08:29:34 -0400
In-Reply-To: <47D3C8A1.6040409@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mjt@tls.msk.ru
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 09 Mar 2008 14:23:13 +0300
Michael Tokarev <mjt@tls.msk.ru> wrote:

> Just got quite.. bad situation on a production server
> here.  The machine locked up hard several times in a
> row (required hard reboot).  So I finally enabled watchdog
> subsystem which helped.
> 
> Now I see the following (over netconsole):
> 
> DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!

Seems that you was out of swiommu space (and aic79xx can't handle it
though it should). This happened because:

a) you produced more I/Os than swiommu can handle.

b) swiommu space leaks due to bugs.

If you hit this problem due to a), the following boot option might
help:

swiotlb=65536

The same machine run well with old kernels? If so, probably, 2.6.24
has new bugs that lead to swiommu space leak.
