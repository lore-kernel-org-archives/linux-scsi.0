From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 1/6] scsi/bfa: use pcie_set/get_readrq to simplify code
Date: Fri, 6 Sep 2013 16:14:25 -0600
Message-ID: <20130906221425.GA10152@google.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 05, 2013 at 03:55:25PM +0800, Yijing Wang wrote:
> v1->v2: use pcie_get/set_readrq to simplify code
> a lot suggestd by Bjorn.
> 
> Use pcie_get_readrq()/pcie_set_readrq() to simplify
> code.
> 
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

I applied all these with some tweaks to my pci/yijing-pci_is_pcie-v2
branch [1].  This will be rebased after v3.12-rc1, and may be amended
if any patches are picked up by others.

Hints (not just for you; I hope other people pay attention, too,
because I'm obsessive and I pay attention to these details):

  - Include a "[PATCH v2 0/6]" email.  That's a good place for you to
    put an overall description of the series, and a good place for
    responses like this one that apply to the whole series.

  - Pay attention to the order of your patches.  Yours seemed random,
    and I reordered them so the core PCI ones are first and the arch
    and driver ones are later.  That way I can easily drop the later
    ones if they are picked up by other maintainers.

  - Don't put "v1->v2" comments in your changelogs.  Those are fine
    in the "[0/6]" email, but they're useless in the git changelog, and
    I strip them out when I see them.  Or you can put them after the
    "---" line, in which case they get stripped out automatically.

  - Run "git log --oneline" on the files you touch.  You should follow
    the existing convention, including spacing, brackets, capitalization,
    etc.  I changed most of your subject lines for this reason.

  - Write titles that are sentences, starting with a verb, as suggested
    by Ingo [2].  You did this already; I just made changes for
    consistency of capitalization and the like.

  - Use real function names, not things like "pcie_capability_xxx".
    That makes it easier to search logs.

  - Be consistent about writing function names.  Some of your logs
    included, e.g., both "pci_bus_set_ops" and "dev_info()".  I prefer
    to always include the parentheses when writing a function name,
    but at least be consistent.

  - Don't put "Cc: <mailing-list>" in your changelog.  That tag is
    useful to show that a *person* has had the opportunity to comment
    on a patch but declined to do so.  I don't think it's meaningful
    for mailing lists.  If it were, every single commit would have
    that tag, since every single commit should appear on the relevant
    list.  I suspect you probably do this so that something like
    "git send-email --signed-off-by-cc" will automatically send mail
    to the right lists.  But that's a one-time convenience at the
    cost of useless info in the changelog that's there forever.

  - Put Signed-off-by, Acked-by, etc., tags in this order as suggested
    by Ingo [2]:

      Reported-by:
      Tested-by:
      Signed-off-by:
      Acked-by:
      Reviewed-by:
      Cc: stable@vger.kernel.org  # v3.11+
      Cc: others

[1] http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/yijing-pci_is_pcie-v2

[2] http://lkml.kernel.org/r/20120711080446.GA17713@gmail.com

> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
> index f8ca7be..0a458db 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -766,50 +766,14 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
>  	bfad->pcidev = pdev;
>  
>  	/* Adjust PCIe Maximum Read Request Size */
> -	if (pcie_max_read_reqsz > 0) {
> -		int pcie_cap_reg;
> -		u16 pcie_dev_ctl;
> -		u16 mask = 0xffff;
> -
> -		switch (pcie_max_read_reqsz) {
> -		case 128:
> -			mask = 0x0;
> -			break;
> -		case 256:
> -			mask = 0x1000;
> -			break;
> -		case 512:
> -			mask = 0x2000;
> -			break;
> -		case 1024:
> -			mask = 0x3000;
> -			break;
> -		case 2048:
> -			mask = 0x4000;
> -			break;
> -		case 4096:
> -			mask = 0x5000;
> -			break;
> -		default:
> -			break;
> -		}
> -
> -		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
> -		if (mask != 0xffff && pcie_cap_reg) {
> -			pcie_cap_reg += 0x08;
> -			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
> -			if ((pcie_dev_ctl & 0x7000) != mask) {
> -				printk(KERN_WARNING "BFA[%s]: "
> +	if (pcie_max_read_reqsz > 0 && pci_is_pcie(pdev)) {
> +		int max_rq = pcie_get_readrq(pdev);
> +		if (max_rq > 128 && max_rq < 4096 && is_power_of_2(max_rq))

I think you meant to validate pcie_max_read_reqsz (the module parameter),
not max_rq.  I made this change on my branch.

> +			printk(KERN_WARNING "BFA[%s]: "
>  				"pcie_max_read_request_size is %d, "
> -				"reset to %d\n", bfad->pci_name,
> -				(1 << ((pcie_dev_ctl & 0x7000) >> 12)) << 7,
> +				"reset to %d\n", bfad->pci_name, max_rq,
>  				pcie_max_read_reqsz);
> -
> -				pcie_dev_ctl &= ~0x7000;
> -				pci_write_config_word(pdev, pcie_cap_reg,
> -						pcie_dev_ctl | mask);
> -			}
> -		}
> +		pcie_set_readrq(pdev, pcie_max_read_reqsz);
>  	}
>  
>  	pci_save_state(pdev);
> -- 
> 1.7.1
> 
> 
