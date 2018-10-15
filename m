From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 4/8] pci: consolidate PCI config entry in drivers/pci
Date: Mon, 15 Oct 2018 18:17:13 +0900
Message-ID: <CAK7LNARbkmZ-Lq7W1R6r21dw0RTTyfGYNr5MLuufOVB2rqy2uQ@mail.gmail.com>
References: <20181013151016.31674-1-hch@lst.de> <20181013151016.31674-5-hch@lst.de>
 <CAK7LNAQy_NTu5=8R6C3Xc2VLrJo7tKOz-u1=3JfGtBa3Z+ZD9g@mail.gmail.com> <20181015085737.GC27159@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181015085737.GC27159@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2018 at 5:57 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Oct 15, 2018 at 03:37:05PM +0900, Masahiro Yamada wrote:
> > I think HAVE_ is a preferred prefix in this case according to this doc:
> > https://github.com/masahir0y/linux/blob/v4.19-rc4/Documentation/kbuild/kconfig-language.txt#L448
>
> Ok, I'll switch everything to HAVE_*
>
> > If you do this for entire powerpc,
> > the other 'select HAS_PCI' addtions to
> > arch/powerpc/platforms/*/Kconfig look redundant.
>
> I'll drop them.
>
> > > -config PCI
> > > -       bool "PCI support"
> > > -       select PCI_MSI
> >
> >
> > I think this 'select PCI_MSI' for riscv was lost.
>
> Indeed, fixed.
>
> > >  menu "Bus options (PCI etc.)"
> > >
> > > -config PCI
> > > -       bool "PCI support"
> > > -       default y
> >
> >
> > The default is y for x86 (and xtensa as well).
> >
> > With this patch, the default will be flipped.
> >
> > I think most of people want to use PCI for x86,
> > and this change will make people upset.
> >
> > Will you update arch/{x86,xtensa}/configs/*_defconfig?
>
> Yes.  Alternatively we could add a new ARCH_PCI_DEFAULT symbol,
> that architectures could select if they want PCI by default.  Does
> anyone thing this is a good idea?


No, I do not want to see such an ugly config option.

Instead, you can use 'imply' keyword to set the default y.

config X86
       ...
       imply    PCI



But, personally, I'd like the defconfig files updated.



-- 
Best Regards
Masahiro Yamada
