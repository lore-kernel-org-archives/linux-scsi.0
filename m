From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Areca RAID driver remaining items?
Date: Thu, 23 Feb 2006 10:56:08 +0100
Message-ID: <1140688569.4672.24.camel@laptopd505.fenrus.org>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com>
	 <20060220182045.GA1634@infradead.org>
	 <001401c63779$12e49aa0$b100a8c0@erich2003>
	 <20060222145733.GC16269@infradead.org>
	 <00dc01c63842$381f9a30$b100a8c0@erich2003>
	 <1140683157.2972.6.camel@laptopd505.fenrus.org>
	 <001901c6385e$9aee7d40$b100a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41110 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751693AbWBWJ4P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 04:56:15 -0500
In-Reply-To: <001901c6385e$9aee7d40$b100a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: "\"Christoph Hellwig\"" <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org

On Thu, 2006-02-23 at 17:50 +0800, erich wrote:
> Dear Arjan van de Ven,
> 
> The following contex is coming from comment of Christoph Hellwig.
> 
> - msi should be a module options if at all, but defintitly not
>    a config options
> 
> #ifdef CONFIG_SCSI_ARCMSR_MSI
>  if (!pci_enable_msi(pci_device))
>   pACB->acb_flags |= ACB_F_HAVE_MSI;
> #endif
> 
> I make an option config for prevent some mainboards hang up if arcmsr enable 
> msi function.
> Areca RAID controller is bridged hardware.
> There were a lots of mainboards had wrong IRQ routing table issue with it.
> If somebody meet this issue and people can enable msi function to fix its 
> hardware bug.
> But unfortunately I found some mainboards will hang up if I always enable 
> this function in my lab.
> To avoid this issue, I do an option for this case.


yes the reason for making this optional is clear, and Christoph also
understands that.

However the idea that Christoph is proposing is to not make it a compile
time option, but a runtime option. Compile-time is not very flexible,
especially not for linux distributions. Making it a module option means
it becomes runtime behavior, and the user can load the module like

modprobe aerca msi=0

and msi gets turned off. No need to recompile anything! That has many
advantages over a more inflexible (from the user view) compiletime-only
option.


