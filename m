From: Dave Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi driver - sixth version
Date: Wed, 31 Mar 2004 17:51:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <opr5q28vkql6e53g@us.ibm.com>
References: <opr3u0ffo7l6e53g@us.ibm.com> <20040225134518.A4238@infradead.org>  <opr3xta6gbl6e53g@us.ibm.com> <1079027038.2820.57.camel@mulgrave> <opr5qwiyw4l6e53g@us.ibm.com> <406B3FDA.9010507@pobox.com>  <opr5q1enb6l6e53g@us.ibm.com> <1080776399.11299.63.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:56272 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261988AbUCaXwi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 18:52:38 -0500
In-Reply-To: <1080776399.11299.63.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On 31 Mar 2004 18:39:57 -0500, James Bottomley 
<James.Bottomley@SteelEye.com> wrote:
>> > 14) why are you faking a PCI bus?  The following is very, very wrong:
>> >
>> > +static struct pci_dev iseries_vscsi_dev = {
>> > +	.dev.bus = &pci_bus_type,
>> > +	.dev.bus_id = "vscsi",
>> > +	.dev.release = noop_release
>> >
>> > Did I mention "very" wrong?  :)
>> Because for iseries it is implemented in the pci code.  While it may
>> look wrong, it is actually correct.  Check out
>> arch/ppc64/kernel/iSeries_iommu.c and arch/ppc64/kernel/dma.c.
>> This device has to have dev->bus == &pci_bus_type otherwise the
>> dma_mapping_foo functions won't work correctly.
>
> Erm, something is very wrong in the iSeries code then.  This
> iseries_vio_device is a struct device.  As such, it should contain all
> the information it needs for the DMA API to act on it without performing
> silly pci device tricks.
>
> This looks like it's done because the iseries should be converted to the
> generic device infrastructure, but in fact it's not.  Since the generic
> API has been around for over a year and was designed to solve precisely
> these very problems it needs fixing rather than trying to work around it
> in a driver.
There will always be 1 (no more, no less) of these struct devices in the
system, so I'll move the definition of this into iSeries_iommu and then
just reference it from the driver.  I think that should abstract things
sufficiently.

Dave B
