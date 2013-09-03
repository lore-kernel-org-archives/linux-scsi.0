From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/7] scsi/csiostor: use pcie_capability_xxx to simplify
 code
Date: Tue, 3 Sep 2013 17:43:28 -0600
Message-ID: <20130903234328.GC24733@google.com>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
 <1378193715-25328-2-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1378193715-25328-2-git-send-email-wangyijing@huawei.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Gavin Shan <shangw@linux.vnet.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Naresh Kumar Inna <naresh@chelsio.com>, Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 03, 2013 at 03:35:10PM +0800, Yijing Wang wrote:
> Pcie_capability_xxx() interfaces were introudced to

s/introudced/introduced/

> simplify code to access PCIe Cap config space. And
> because PCI core saves the PCIe Cap offset in
> set_pcie_port_type() when device is enumerated.
> So we can use pci_is_pcie() instead.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Jiang Liu <jiang.liu@huawei.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Naresh Kumar Inna <naresh@chelsio.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jesper Juhl <jj@chaosbits.net>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/scsi/csiostor/csio_hw.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
> index 0eb35b9..be9a6ef 100644
> --- a/drivers/scsi/csiostor/csio_hw.c
> +++ b/drivers/scsi/csiostor/csio_hw.c
> @@ -856,15 +856,12 @@ static void
>  csio_set_pcie_completion_timeout(struct csio_hw *hw, u8 range)
>  {
>  	uint16_t val;
> -	int pcie_cap;
>  
> -	if (!csio_pci_capability(hw->pdev, PCI_CAP_ID_EXP, &pcie_cap)) {
> -		pci_read_config_word(hw->pdev,
> -				     pcie_cap + PCI_EXP_DEVCTL2, &val);
> +	if (pci_is_pcie(hw->pdev)) {
> +		pcie_capability_read_word(hw->pdev, PCI_EXP_DEVCTL2, &val);
>  		val &= 0xfff0;
>  		val |= range ;
> -		pci_write_config_word(hw->pdev,
> -				      pcie_cap + PCI_EXP_DEVCTL2, val);
> +		pcie_capability_write_word(hw->pdev, PCI_EXP_DEVCTL2, val);

Please add a #define for the Completion Timeout Value field and use
pcie_capability_clear_and_set_word() instead of writing it out the
long way here.

>  	}
>  }
>  
> -- 
> 1.7.1
> 
> 
