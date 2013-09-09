From: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [PATCH v2 1/6] scsi/bfa: use pcie_set/get_readrq to simplify
 code
Date: Mon, 9 Sep 2013 10:41:03 +0800
Message-ID: <522D353F.8090209@huawei.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com> <20130906221425.GA10152@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20130906221425.GA10152@google.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2013/9/7 6:14, Bjorn Helgaas wrote:
> On Thu, Sep 05, 2013 at 03:55:25PM +0800, Yijing Wang wrote:
>> v1->v2: use pcie_get/set_readrq to simplify code
>> a lot suggestd by Bjorn.
>>
>> Use pcie_get_readrq()/pcie_set_readrq() to simplify
>> code.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Cc: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Anil Gurumurthy <agurumur@brocade.com>
>> Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: linux-scsi@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/scsi/bfa/bfad.c |   48 +++++-----------------------------------------
>>  1 files changed, 6 insertions(+), 42 deletions(-)

Hi Bjorn,
   Thanks for your patience guidance! Now I know more about how to write
a patch or patchset. I will check my patch follow the advices below before
I send out every time. Make it easier for you and other maintainers to
review and apply.

> 
> I applied all these with some tweaks to my pci/yijing-pci_is_pcie-v2
> branch [1].  This will be rebased after v3.12-rc1, and may be amended
> if any patches are picked up by others.
> 
> Hints (not just for you; I hope other people pay attention, too,
> because I'm obsessive and I pay attention to these details):
> 
>   - Include a "[PATCH v2 0/6]" email.  That's a good place for you to
>     put an overall description of the series, and a good place for
>     responses like this one that apply to the whole series.
> 
>> -
>> -		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>> -		if (mask != 0xffff && pcie_cap_reg) {
>> -			pcie_cap_reg += 0x08;
>> -			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
>> -			if ((pcie_dev_ctl & 0x7000) != mask) {
>> -				printk(KERN_WARNING "BFA[%s]: "
>> +	if (pcie_max_read_reqsz > 0 && pci_is_pcie(pdev)) {
>> +		int max_rq = pcie_get_readrq(pdev);
>> +		if (max_rq > 128 && max_rq < 4096 && is_power_of_2(max_rq))
> 
> I think you meant to validate pcie_max_read_reqsz (the module parameter),
> not max_rq.  I made this change on my branch.

Yes, thanks for your fix.

Thanks!
Yijing.

> 
>> +			printk(KERN_WARNING "BFA[%s]: "
>>  				"pcie_max_read_request_size is %d, "
>> -				"reset to %d\n", bfad->pci_name,
>> -				(1 << ((pcie_dev_ctl & 0x7000) >> 12)) << 7,
>> +				"reset to %d\n", bfad->pci_name, max_rq,
>>  				pcie_max_read_reqsz);
>> -
>> -				pcie_dev_ctl &= ~0x7000;
>> -				pci_write_config_word(pdev, pcie_cap_reg,
>> -						pcie_dev_ctl | mask);
>> -			}
>> -		}
>> +		pcie_set_readrq(pdev, pcie_max_read_reqsz);
>>  	}
>>  
>>  	pci_save_state(pdev);
>> -- 
>> 1.7.1
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing
