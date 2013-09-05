From: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [PATCH 1/7] scsi/bfa: use pcie_capability_xxx to simplify code
Date: Thu, 5 Sep 2013 15:21:46 +0800
Message-ID: <5228310A.20106@huawei.com>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com> <20130903233438.GB24733@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130903233438.GB24733@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Gavin Shan <shangw@linux.vnet.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> @@ -794,10 +793,8 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
>>  			break;
>>  		}
>>  
>> -		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>> -		if (mask != 0xffff && pcie_cap_reg) {
>> -			pcie_cap_reg += 0x08;
>> -			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
>> +		if (mask != 0xffff && pci_is_pcie(pdev)) {
> 
> Please move the pci_is_pcie() test up to the
> "if (pcie_mas_read_reqsz ..." statement.  There's no point in doing
> the switch statement if this isn't a PCIe device.

Right, will update.

> 
>> +			pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &pcie_dev_ctl);
>>  			if ((pcie_dev_ctl & 0x7000) != mask) {
>>  				printk(KERN_WARNING "BFA[%s]: "
>>  				"pcie_max_read_request_size is %d, "
>> @@ -806,7 +803,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
>>  				pcie_max_read_reqsz);
>>  
>>  				pcie_dev_ctl &= ~0x7000;
>> -				pci_write_config_word(pdev, pcie_cap_reg,
>> +				pcie_capability_write_word(pdev, PCI_EXP_DEVCTL,
>>  						pcie_dev_ctl | mask);
> 
> Please rework this to use pcie_set_readrq() instead of writing
> the capability directly.  If we write the capability directly, we
> risk writing a value that is incompatible with the MPS
> configuration done by the PCI core.

Ah, this code is Long-winded, use pcie_set_readrq()/pcie_get_readrq() can simplify
this code much.

Thanks!
Yijing.

> 
>>  			}
>>  		}
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
