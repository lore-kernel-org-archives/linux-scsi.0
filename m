From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: init / exit cleanup
Date: Thu, 3 Jun 2004 22:23:45 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406032213080.4721-100000@poirot.grange>
References: <20040603133835.GA16378@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:55265 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S264238AbUFCU2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2004 16:28:18 -0400
In-Reply-To: <20040603133835.GA16378@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, 3 Jun 2004, Christoph Hellwig wrote:

> On Mon, May 31, 2004 at 11:13:51PM +0200, Guennadi Liakhovetski wrote:
> >
> > #ifdef CONFIG_HOTPLUG_PCI
> > #define __pcidevinit
> > #define __pcidevinitdata
> > #define __pcidevexit
> > #define __pcidevexitdata
> > #else
> > #define __pcidevinit __init
> > #define __pcidevinitdata __initdata
> > #define __pcidevexit __exit
> > #define __pcidevexitdata __exitdata
> > #endif
>
> This has been though out a bit but not considered worthwile. And to actually
> work it would have to be for all the kernel because you could get problems
> over the module boundary otherwise.

Sorry, do you have a reference or remember at least apporoximatly when and
where the discussion took place? I don't quite understand your arguments.
We do have __dev{init,exit,...} macros, do they have "problems over the
module boundary"? If yes - they want to be solved, right? If not - why
would equally defined __pcidev* have problems? You mean using __devinit in
a module has probles? The advantages of the above are obvious: there are
many more HOTPLUG-enabled systems, than PCI_HOTPLUG-enabled ones. And a
reasonable number of drivers, that serve devices only over PCI. How much
would it add to "Freeing init memory" in an "average" configuration?

Thanks
Guennadi
---
Guennadi Liakhovetski


