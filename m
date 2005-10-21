From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 14:04:30 -0400
Message-ID: <43592DAE.8050506@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <4358497E.6070107@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:49536 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965054AbVJUSEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 14:04:42 -0400
In-Reply-To: <4358497E.6070107@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 21:50, Douglas Gilbert wrote:
>>Luben suggestion(correct me if I'm wrong) is this should be 
>>done thru user space, instead of exporting this in the 
>>/sys/class/sas_phy attributes.  Thus we need to export a 
>>SMP_PASSTHRU mechanism.  I believe there is discussion
>>by Christoph ( and I believe Luben backs this idea) of doing 
>>all this thru the /dev/sg interface.
> 
> 
> Folks,
> Just a suggestion if you want to bring /dev/sg into
> the picture for a SMP (and even a STP) passthrough.
> The host could define a lun (pick a number) and the
> LLDD could supply the target code for it (as scsi_debug
> does for example).

Doug, there is no reason to follow someone else's OS
broken path.

Your question above is SDI addressability. And the answer
is _right_ in the SDI spec: SDI is addressable as per
"controller".  That is each "controller" on the PCI/IO
bus provides an SDI portal.  This is overly evident
by at least looking at the SDI_GET_CNTLR_CONFIG function.

This allows for controllers who do not have SCSI LLDDs
but block or RAID LLDD to also be able to export an SDI
portal.

So in effect the SDI portal would have to be hooked to the
PCI device which claims a base class of 01h -- mass storage
controller.

So when the provider calls 
	sdi_register_provider(sdi_prov);

it fill out the pcidev member in

struct sdi_provider_struct {
	char           *name;
	struct pci_dev *pcidev;
	...
	struct sdi_functions_struct sdi_functions;
	...
};

from my example yesterday.  And the file drivers/scsi/sdi/sdi.c
creates a binary file attr (front end, could be another way)
in  /sys/devices/pciABCD:EF/.../sdi_portal.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
