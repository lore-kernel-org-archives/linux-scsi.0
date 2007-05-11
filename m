From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 11/28] Use unchecked_isa_dma in sd_revalidate_disk()
Date: Fri, 11 May 2007 09:27:20 -0500
Message-ID: <1178893640.3692.25.camel@mulgrave.il.steeleye.com>
References: <200705110600.l4B60sIQ008148@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49969 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754699AbXEKO1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 10:27:24 -0400
In-Reply-To: <200705110600.l4B60sIQ008148@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, bwalle@suse.de, jens.axboe@oracle.com

On Thu, 2007-05-10 at 23:00 -0700, akpm@linux-foundation.org wrote:
> From: Bernhard Walle <bwalle@suse.de>
> 
> In sd_revalidate_disk(), the SCSI Disk driver needs a few bytes DMA memory,
> allocated by kmalloc() and __GFP_DMA.  This patch uses __GFP_DMA only if
> the corresponding host structure has unchecked_isa_dma set.

OK, now we have the Mike Christie fix that actually bounces our
submission paths correctly, we can really eliminate all the GFP_DMA
buffer allocations in the ULDs ... so this isn't really the right fix.

James


