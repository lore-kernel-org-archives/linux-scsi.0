From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 9/21] advansys: More PCI cleanups
Date: Thu, 26 Jul 2007 15:55:08 -0400
Message-ID: <46A8FC1C.6050206@garzik.org>
References: <11854705772242-git-send-email-matthew@wil.cx> <46A8F96B.9080002@garzik.org> <20070726195020.GO19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51059 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbXGZTzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:55:09 -0400
In-Reply-To: <20070726195020.GO19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 26, 2007 at 03:43:39PM -0400, Jeff Garzik wrote:
>>> +static void __devinit advansys_set_latency(struct pci_dev *pdev)
>>> +{
>>> +	if ((pdev->device == PCI_DEVICE_ID_ASP_1200A) ||
>>> +	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940)) {
>>> +		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0);
>>> +	} else {
>>> +		u8 latency;
>>> +		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
>>> +		if (latency < 0x20)
>>> +			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
>>> +	}
>> the latter branch is useless -- pci_set_master() ensures 
>> PCI_LATENCY_TIMER is adequate
> 
> i386 certainly has a workaround for broken BIOSes, but this looks to
> me like it's working around an issue the card has with a latency timer
> below 32.  Note that i386's implementation of pcibios_set_master()
> only ensures that the latency timer is 16 or higher.

Ah, indeed.

	Jeff



