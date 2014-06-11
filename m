From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] [SCSI] NCR53c406a: don't call free_dma() by default
Date: Wed, 11 Jun 2014 05:17:55 -0700
Message-ID: <20140611121755.GE8389@infradead.org>
References: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
 <1402003789-1990031-5-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaFKMR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 08:17:57 -0400
Content-Disposition: inline
In-Reply-To: <1402003789-1990031-5-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Thu, Jun 05, 2014 at 11:29:49PM +0200, Arnd Bergmann wrote:
> The NCR53c406a scsi driver normally does not use DMA, unless
> the USE_PIO macro is disabled by modifying the source code.
> 
> The call to free_dma() for some reason uses #ifdef USE_DMA,
> which does not do the right thing, since USE_DMA is defined
> as a boolean that is either 0 or 1, but always present.
> 
> One case where it gets in the way is randconfig builds on ARM,
> which depending on the configuration does not provide a free_dma()
> function, causing this build error:

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
