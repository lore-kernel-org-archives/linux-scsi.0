From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Wed, 27 Jan 2016 17:04:06 +0000
Message-ID: <56A8F886.3010401@synopsys.com>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
 <20160107094437.GA11038@infradead.org>
 <CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
 <56969A3D.50701@synopsys.com>
 <CAC5umyjiTOzU9RCb4O-8aAHH35UWjMmE8fzWD4zUxQhwN9nUXg@mail.gmail.com>
 <5697715F.8060608@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:55116 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbcA0REQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2016 12:04:16 -0500
In-Reply-To: <5697715F.8060608@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com, Joao.Pinto@synopsys.com

Hi!
I am currently working in the implementation of DesignWare Quirks in the
existing UFS core and implementing a glue platform driver.
The project status is the following:

- Synopsys MPHY Test Chip is well configured
- Link is up in Host & Device (validated through the 0xd083 register)
- Additional connection setup are made successfully
- HBA is operational
- NOP_OUT is failing with OCS = 0x7

The OCS value is calculated in ufshcd_get_tr_ocs() in ufshcd.c.
I made a dump of the UTRD pointer where we can check the status = 7 ([2]).

UTRD at: 7007c3e0
@0000 [0]:21000000
@0004 [1]:93936a6a
@0008 [2]:00000007
@000c [3]:93936a6a
@0010 [4]:9f317400
@0014 [5]:00000000
@0018 [6]:00800080
@001c [7]:01006a6a

Did anyone have the same problem? Any hints to overcome this issue?

Thank you very much for your help!

Joao

On 1/14/2016 9:58 AM, Joao Pinto wrote:
> Hi,
> 
> On 1/14/2016 2:54 AM, Akinobu Mita wrote:
>> 2016-01-14 3:41 GMT+09:00 Joao Pinto <Joao.Pinto@synopsys.com>:
>>> I am planning to make some tests with the ufs kernel existing core driver in our
>>> setup, but I noticed that despite the scsi/ufs driver package contains a
>>> platform driver, this is not the typical platform driver (glue driver) which can
>>> be addressed from device tree. The only one available is the qcom's.
>>> Would I need to submit a designware platform glue driver also as done by QCom?
>>
>> Yes.  ufs-pltfrm.c only contains APIs for UFS platform driver since
>> commit 47555a5c8a11a423e6767f942941c745766c99a2 ("scsi: ufs: make the
>> UFS variant a platform device").  Just as you said, you need to add
>> ufs-abc.c as a real platform driver.
> 
> I am going to test the platform I already have and if everything is ok then I
> will submit the patch.
> 
>>
>>> We also need a pci glue driver, but you already have one. In your opinion the
>>> best approach is to add synopsys device id to the pci device list in the driver
>>> and add quirks or add a new designware pci glue driver?
>>
>> I think you can just add a new device id with vops like this
>>
>>         {
>>                 PCI_DEVICE(PCI_VENDOR_ID_SNPS, PCI_DEVICE_ID_SNPS_HAPS_UFS),
>>                 .driver_data = (void *)&ufs_hba_dwc_vops,
>>         },
>>
>> then bind to hba->vops in ufshcd_pci_probe().    If there is remaining
>> host controller specific initialization stuff, let vops->init() do that
>> by ufshcd_init().
>>
> 
> Ok, that's what I thought.
> 
> Thanks for the help!
> 
> Joao
> 

