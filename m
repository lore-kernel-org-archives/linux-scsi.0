From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Areca RAID driver remaining items?
Date: Thu, 23 Feb 2006 09:25:56 +0100
Message-ID: <1140683157.2972.6.camel@laptopd505.fenrus.org>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com>
	 <20060220182045.GA1634@infradead.org>
	 <001401c63779$12e49aa0$b100a8c0@erich2003>
	 <20060222145733.GC16269@infradead.org>
	 <00dc01c63842$381f9a30$b100a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56517 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751649AbWBWI0B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 03:26:01 -0500
In-Reply-To: <00dc01c63842$381f9a30$b100a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org

On Thu, 2006-02-23 at 14:27 +0800, erich wrote:
> Dear Christoph Hellwig,
> 
> I have figure out your comments about "remove internal queueing" and "remove 
> odd ioctl".
> But about "hardware datastructures", areca's firmware spec is need to get a 
> trunk of contingous memory space under 4G.
> In 64bit platform arcmsr need to make sure all ccbs have same of 
> ccb_phyaddr_hi32 physical address.
> If arcmsr use dma_pool_alloc do a separate dma mapping.
> Is there any method to avoid ccbs pool cross 4G segment?

the pci mapping layer prevents that already entirely; there is a LOT of
hardware that cannot deal with segments crossing 4G boundaries, so much
in fact that it's now generically disabled.


> In some mainboard if I always enable msi function, it will cause system hang 
> up.
> If it is not a config option, do you have any idea to avoid this issue?

how about a module option (module_param)?


