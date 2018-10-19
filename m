From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 4/8] PCI: consolidate PCI config entry in drivers/pci
Date: Fri, 19 Oct 2018 14:07:04 +0900
Message-ID: <CAK7LNASJaRrut2neRa92CudohW4A-2=GHMzgEpOzT97VdGuhng@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-5-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-pci@vger.kernel.org
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 5:04 PM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no good reason to duplicate the PCI menu in every architecture.
> Instead provide a selectable HAS_PCI symbol that indicates availability

HAS_PCI -> HAVE_PCI


> of PCI support and the handle the rest in drivers/pci.
>
> Note that for powerpc we now select HAVE_PCI globally instead of the
> convoluted mess of conditional or or non-conditional support per board,
> similar to what we do e.g. on x86.  For alpha PCI is selected for the
> non-jensen configs as it was the default before, and a lot of code does
> not compile without PCI enabled.  On other architectures with limited
> PCI support that wasn't as complicated I've left the selection as-is.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>



Just in case, could you double-check these?
PCI_ENDPOINT
PCI_ENDPOINT_CONFIGFS
PCI_EPF_TEST


Previously, architecture without "source drivers/pci/Kconfig"
could not enable PCI_ENDPOINT.

Now, any architecture can enable it
regardless of its actual PCI availability
because PCI_ENDPOINT is only guarded by HAS_DMA.


We could add 'depends on HAVE_PCI' or something
to guard it to avoid changing the logic.


config PCI_ENDPOINT
        bool "PCI Endpoint Support"
        depends on HAVE_PCI     # Is this correct ??
        depends on HAS_DMA


or better to have 'depends on PCI' ?


PCI ML is also CC'ed, so comments are appreciated.



-- 
Best Regards
Masahiro Yamada
