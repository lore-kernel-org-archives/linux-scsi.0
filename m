From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Thu, 14 Jan 2016 11:54:37 +0900
Message-ID: <CAC5umyjiTOzU9RCb4O-8aAHH35UWjMmE8fzWD4zUxQhwN9nUXg@mail.gmail.com>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
	<20160107094437.GA11038@infradead.org>
	<CAC5umyg=vhQ_5Nz60u8gsZFEOFP45cmXnSGny-v4ddk4qNeMHA@mail.gmail.com>
	<56969A3D.50701@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33663 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbcANCyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 21:54:38 -0500
Received: by mail-vk0-f52.google.com with SMTP id i129so134613480vkb.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2016 18:54:38 -0800 (PST)
In-Reply-To: <56969A3D.50701@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com

2016-01-14 3:41 GMT+09:00 Joao Pinto <Joao.Pinto@synopsys.com>:
> I am planning to make some tests with the ufs kernel existing core driver in our
> setup, but I noticed that despite the scsi/ufs driver package contains a
> platform driver, this is not the typical platform driver (glue driver) which can
> be addressed from device tree. The only one available is the qcom's.
> Would I need to submit a designware platform glue driver also as done by QCom?

Yes.  ufs-pltfrm.c only contains APIs for UFS platform driver since
commit 47555a5c8a11a423e6767f942941c745766c99a2 ("scsi: ufs: make the
UFS variant a platform device").  Just as you said, you need to add
ufs-abc.c as a real platform driver.

> We also need a pci glue driver, but you already have one. In your opinion the
> best approach is to add synopsys device id to the pci device list in the driver
> and add quirks or add a new designware pci glue driver?

I think you can just add a new device id with vops like this

        {
                PCI_DEVICE(PCI_VENDOR_ID_SNPS, PCI_DEVICE_ID_SNPS_HAPS_UFS),
                .driver_data = (void *)&ufs_hba_dwc_vops,
        },

then bind to hba->vops in ufshcd_pci_probe().    If there is remaining
host controller specific initialization stuff, let vops->init() do that
by ufshcd_init().
