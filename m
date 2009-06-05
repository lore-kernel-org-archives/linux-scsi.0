From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 15:57:56 +0100
Message-ID: <200906051557.58809.arnd@arndb.de>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZFEO60 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 10:58:26 -0400
In-Reply-To: <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, torvalds@linux-foundation.org, mingo@elte.hu, lethal@linux-sh.org, just.for.lkml@googlemail.com, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Friday 05 June 2009, FUJITA Tomonori wrote:
> I think that the better fix can handle both cases per device:
> 
> - multiple identical dma addresses should not happen (with devices
>   behind hardware IOMMU)
> - multiple identical dma addresses could happen

I guess you could also have the case where for a given range
of addresses, you use a linear mapping and the dma addresses
can be identical, while for other physical addresses you would
rely on address translation.

For example on PowerPC/Cell with infiniband adapters, you can get
linear mapping behavior for DMA_ATTR_WEAK_ORDERING but IOMMU
translation without that flag, for the same device and same
physical address.

	Arnd <><
