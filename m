From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: init / exit cleanup
Date: Thu, 3 Jun 2004 14:38:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040603133835.GA16378@infradead.org>
References: <20040523103729.GA23804@infradead.org> <Pine.LNX.4.44.0405312248150.3168-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:7313 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263616AbUFCNii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2004 09:38:38 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405312248150.3168-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, May 31, 2004 at 11:13:51PM +0200, Guennadi Liakhovetski wrote:
> On Sun, 23 May 2004, Christoph Hellwig wrote:
> 
> > these leaks.  Maybe also  merge dc390_init and dc390_init_one?
> >
> > Similarly I think DC390_release should be merged into dc390_remove_one.
> 
> Attached. Also fixed some __init / __devinit and __exit / __devexit
> attributes. Although, would be good to have something like
> 
> #ifdef CONFIG_HOTPLUG_PCI
> #define __pcidevinit
> #define __pcidevinitdata
> #define __pcidevexit
> #define __pcidevexitdata
> #else
> #define __pcidevinit __init
> #define __pcidevinitdata __initdata
> #define __pcidevexit __exit
> #define __pcidevexitdata __exitdata
> #endif
> 
> I don't think there are any pcmcia / usb / ieee1394 / ... tmscsim adapters
> out there?

This has been though out a bit but not considered worthwile. And to actually
work it would have to be for all the kernel because you could get problems
over the module boundary otherwise.

