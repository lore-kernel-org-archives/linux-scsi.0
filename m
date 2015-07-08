From: Christoph Hellwig <hch@infradead.org>
Subject: Re: blk-mq vs kmemleak
Date: Wed, 8 Jul 2015 01:17:40 -0700
Message-ID: <20150708081740.GA3374@infradead.org>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934296AbbGHIRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 04:17:47 -0400
Content-Disposition: inline
In-Reply-To: <559BDB49.70209@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jul 07, 2015 at 06:59:37AM -0700, Bart Van Assche wrote:
> Please note that my test was run with CONFIG_SLUB_DEBUG=y which causes a red
> zone to be allocated before and after each block of allocated memory. Could
> that explain the kmalloc-96 objects ?

96 is almost guaranteed to be the sense buffer allocated in
scsi_init_request and freed in scsi_exit_request.
