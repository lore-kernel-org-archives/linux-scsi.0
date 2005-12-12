From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Mon, 12 Dec 2005 21:24:27 +0000
Message-ID: <20051212212427.GA9139@infradead.org>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751306AbVLLVYc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <439DE50B.90007@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 12, 2005 at 03:00:59PM -0600, Michael Reed wrote:
> (The subject of this email isn't quite accurate.  It's not
> a pci coherency problem, it's a pio write ordering problem.)
> 
> I've been asked to pass along the suggestion that "mmiowb"
> should be implemented for the platform.
> 
> Given that I've been unable to unearth the chipset documentation
> for the Vis WS, I can only hope that you've got some good ideas
> on how this might be accomplished.
> 
> I agree that replacing the pio read which flushed the preceeding
> pio write with mmiowb() is what has likely broken the driver.  If you
> restore them,  please make it either mmiowb or pio read, but not both.
> 
> Perhaps something like this?  It's not the most elegant solution....

Yeah, it's not that nice.  After all we don't use mmio at all on visw but
pio.  So why do we need the flushing at all?

> --- old/drivers/scsi/qla1280.c        2005-12-05 12:39:36.000000000 -0600
> +++ new/drivers/scsi/qla1280.c      2005-12-12 14:42:11.146215122 -0600
> @@ -401,6 +401,10 @@
>  #include "ql1280_fw.h"
>  #include "ql1040_fw.h"
> 
> +#ifdef CONFIG_X86_VISWS
> +  #undef mmiowb
> +  #define mmiowb() RD_REG_WORD(&ha->iobase->id_l)
> +#endif

Macros with implicit arguments are pretty horrible.  If we want to go down
that road we should add a macro that expands to either version depending
on the config flags.

While we're at it, does anyone know whyt the ioread* interface doesn't
provide the _relaxed version?  I'd really love to switch qla1280 over to it
given that it needs to support both mmio and pio.
