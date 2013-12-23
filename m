From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] megaraid_sas: Quirk mmio hook for 1078 MR controller
Date: Mon, 23 Dec 2013 10:57:46 -0700
Message-ID: <CAErSpo7X4khuPOp5s4MdunOmwww0V4JZipJa3iEOA=Y5nnCwqA@mail.gmail.com>
References: <201312231512.rBNFC6mo008974@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <201312231512.rBNFC6mo008974@cosmhbs0.lsi.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "James E.J. Bottomley" <jbottomley@parallels.com>, sumit.saxena@lsi.com, Adam Radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 23, 2013 at 8:13 AM,  <Kashyap.Desai@lsi.com> wrote:
> This patch has fix for LSI Gen-1 MR controller issue which only pop-up on
> few systems and it is not generic.
>
> On few system, MR 1078 MR controller is not working if mmio decoding is off.
> This patch proposed early quirck entry for Device id 0x1000/0x0411 to enable mmio.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index f6c31fa..a20fe41 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -43,6 +43,10 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>                                 PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
> +/* LSI controller device id 0x0411 has some issues if mmio_always_on is not set.
> + * It pop-up only on few specific system, where decoding disable is not working.
> + */
> +DECLARE_PCI_FIXUP_EARLY(0x1000, 0x0411, quirk_mmio_always_on);

What is the actual problem that happens without this quirk?  Is there
some hardware defect in the MR 1078 that makes it fail when we disable
decoding?

Disabling decoding is important because it prevents conflicts with
other devices while sizing and updating BARs, so I don't want to use
this quirk unless it's really necessary.

Bjorn
