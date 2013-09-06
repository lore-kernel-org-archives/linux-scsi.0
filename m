From: Jon Mason <jdmason@kudzu.us>
Subject: Re: [PATCH v2 1/6] scsi/bfa: use pcie_set/get_readrq to simplify code
Date: Fri, 6 Sep 2013 11:17:22 -0700
Message-ID: <CAPoiz9wqyb2xfLZ8yH9TLOivQqoOr-KG=HPM+qNK4+aZsD68vg@mail.gmail.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 5, 2013 at 12:55 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> v1->v2: use pcie_get/set_readrq to simplify code
> a lot suggestd by Bjorn.
>
> Use pcie_get_readrq()/pcie_set_readrq() to simplify
> code.

Very similar to a patch I sent out in 2011
http://www.spinics.net/lists/linux-scsi/msg52990.html

Hopefully this one gets pulled in.

> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Jiang Liu <jiang.liu@huawei.com>
> Cc: Anil Gurumurthy <agurumur@brocade.com>
> Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/scsi/bfa/bfad.c |   48 +++++-----------------------------------------
>  1 files changed, 6 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
> index f8ca7be..0a458db 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -766,50 +766,14 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
>         bfad->pcidev = pdev;
>
>         /* Adjust PCIe Maximum Read Request Size */
> -       if (pcie_max_read_reqsz > 0) {
> -               int pcie_cap_reg;
> -               u16 pcie_dev_ctl;
> -               u16 mask = 0xffff;
> -
> -               switch (pcie_max_read_reqsz) {
> -               case 128:
> -                       mask = 0x0;
> -                       break;
> -               case 256:
> -                       mask = 0x1000;
> -                       break;
> -               case 512:
> -                       mask = 0x2000;
> -                       break;
> -               case 1024:
> -                       mask = 0x3000;
> -                       break;
> -               case 2048:
> -                       mask = 0x4000;
> -                       break;
> -               case 4096:
> -                       mask = 0x5000;
> -                       break;
> -               default:
> -                       break;
> -               }
> -
> -               pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
> -               if (mask != 0xffff && pcie_cap_reg) {
> -                       pcie_cap_reg += 0x08;
> -                       pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
> -                       if ((pcie_dev_ctl & 0x7000) != mask) {
> -                               printk(KERN_WARNING "BFA[%s]: "
> +       if (pcie_max_read_reqsz > 0 && pci_is_pcie(pdev)) {
> +               int max_rq = pcie_get_readrq(pdev);
> +               if (max_rq > 128 && max_rq < 4096 && is_power_of_2(max_rq))
> +                       printk(KERN_WARNING "BFA[%s]: "
>                                 "pcie_max_read_request_size is %d, "
> -                               "reset to %d\n", bfad->pci_name,
> -                               (1 << ((pcie_dev_ctl & 0x7000) >> 12)) << 7,
> +                               "reset to %d\n", bfad->pci_name, max_rq,
>                                 pcie_max_read_reqsz);
> -
> -                               pcie_dev_ctl &= ~0x7000;
> -                               pci_write_config_word(pdev, pcie_cap_reg,
> -                                               pcie_dev_ctl | mask);
> -                       }
> -               }
> +               pcie_set_readrq(pdev, pcie_max_read_reqsz);
>         }
>
>         pci_save_state(pdev);
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
