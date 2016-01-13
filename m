From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Wed, 13 Jan 2016 18:41:01 +0000
Message-ID: <56969A3D.50701@synopsys.com>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
 <20160107094437.GA11038@infradead.org>
 <CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:59841 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbcAMSlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 13:41:10 -0500
In-Reply-To: <CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Joao Pinto <Joao.Pinto@synopsys.com>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com

Hi,

On 1/8/2016 2:20 PM, Akinobu Mita wrote:
> 2016-01-07 18:44 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
>>> This driver patch includes a core driver and glue drivers for pci and platform
>>> for the DesignWare UFS Host IP.
>>
>> Why doesn't this use the existing ufs core?  The architecture looks
>> completely backwards to me.
> 
> I agree.  The existing ufs driver can have variant specific operations
> (hba->vops) and also can define quirks.  So if DesignWare UFS host
> controller requires vendor specific register settings or DME operations
> in initialization, or needs special workarounds for the specific versions,
> it can use those mechanisms and shares common parts between other host
> controllers.
> 

I am planning to make some tests with the ufs kernel existing core driver in our
setup, but I noticed that despite the scsi/ufs driver package contains a
platform driver, this is not the typical platform driver (glue driver) which can
be addressed from device tree. The only one available is the qcom's.
Would I need to submit a designware platform glue driver also as done by QCom?

We also need a pci glue driver, but you already have one. In your opinion the
best approach is to add synopsys device id to the pci device list in the driver
and add quirks or add a new designware pci glue driver?

Thanks,
Joao
