From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/8] pci: consolidate PCI config entry in drivers/pci
Date: Mon, 15 Oct 2018 10:57:37 +0200
Message-ID: <20181015085737.GC27159@lst.de>
References: <20181013151016.31674-1-hch@lst.de> <20181013151016.31674-5-hch@lst.de> <CAK7LNAQy_NTu5=8R6C3Xc2VLrJo7tKOz-u1=3JfGtBa3Z+ZD9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK7LNAQy_NTu5=8R6C3Xc2VLrJo7tKOz-u1=3JfGtBa3Z+ZD9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Christoph Hellwig <hch@lst.de>, mporter@kernel.crashing.org, alex.bou9@gmail.com, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2018 at 03:37:05PM +0900, Masahiro Yamada wrote:
> I think HAVE_ is a preferred prefix in this case according to this doc:
> https://github.com/masahir0y/linux/blob/v4.19-rc4/Documentation/kbuild/kconfig-language.txt#L448

Ok, I'll switch everything to HAVE_*

> If you do this for entire powerpc,
> the other 'select HAS_PCI' addtions to
> arch/powerpc/platforms/*/Kconfig look redundant.

I'll drop them.

> > -config PCI
> > -       bool "PCI support"
> > -       select PCI_MSI
> 
> 
> I think this 'select PCI_MSI' for riscv was lost.

Indeed, fixed.

> >  menu "Bus options (PCI etc.)"
> >
> > -config PCI
> > -       bool "PCI support"
> > -       default y
> 
> 
> The default is y for x86 (and xtensa as well).
> 
> With this patch, the default will be flipped.
> 
> I think most of people want to use PCI for x86,
> and this change will make people upset.
> 
> Will you update arch/{x86,xtensa}/configs/*_defconfig?

Yes.  Alternatively we could add a new ARCH_PCI_DEFAULT symbol,
that architectures could select if they want PCI by default.  Does
anyone thing this is a good idea?
